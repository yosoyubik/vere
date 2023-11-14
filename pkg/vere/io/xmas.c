/// @file

#include "vere.h"

#include "noun.h"
#include "ur.h"

#define XMAS_DEBUG     c3y
#define XMAS_VER       1
#define FINE_PAGE      4096             //  packets per page
#define FINE_FRAG      1024             //  bytes per fragment packet
#define FINE_PATH_MAX   384             //  longest allowed scry path
#define HEAD_SIZE         4             //  header size in bytes
#define PACT_SIZE      1472

/* _u3_xmas: next generation networking
 */
typedef struct _u3_xmas {
  u3_auto            car_u;
  u3_pier*           pir_u;
  union {
    uv_udp_t         wax_u;
    uv_handle_t      had_u;
  };
  c3_l               sev_l;
  ur_cue_test_t*     tes_u;             //  cue-test handle
  u3_cue_xeno*       sil_u;             //  cue handle
  u3p(u3h_root)      lax_p;
  u3p(u3h_root)      pen_p;
  c3_w               imp_w[256];
  time_t           imp_t[256];        //  imperial IP timestamps
  c3_o             imp_o[256];        //  imperial print status
  u3p(u3h_root)      req_p;
} u3_xmas;

typedef enum _u3_xmas_ptag {
  PACT_PEEK = 1,
  PACT_POKE = 2,
  PACT_PAGE = 3
} u3_xmas_ptag;

typedef enum _u3_xmas_rout_tag {
  ROUT_GALAXY = 0,
  ROUT_OTHER = 1
} u3_xmas_rout_tag;

typedef struct _u3_xmas_rout {
  u3_xmas_rout_tag  typ_y;  // type tag
  union {
    struct {
      c3_c*         dns_c;
      c3_y          her_y;
    } imp_u;
    u3_lane         lan_u;
  };
} u3_xmas_rout;

typedef struct _u3_xmas_head {
  c3_y             pro_y;  // protocol version
  u3_xmas_ptag     typ_y;  // packet type
  c3_y             ran_y;  // publisher rank
  c3_w             mug_w; // mug checksum
  c3_y             hop_y;  // hopcount
} u3_xmas_head;


typedef struct _u3_xmas_peek_pact {
  c3_d              pub_d[2];
  c3_s              pat_s;
  c3_c*             pat_c;
} u3_xmas_peek_pact;

typedef struct _u3_xmas_page_pact {
  c3_y              hop_y[6];
  c3_s              pat_s;
  c3_c*             pat_c;
  c3_w              tot_w;
  c3_y              aut_y[96]; // heap allocate??
  c3_y*             dat_y;
} u3_xmas_page_pact;

typedef struct _u3_xmas_poke_pact {
  u3_xmas_peek_pact*     pek_u;
  c3_w              tot_w;
  c3_y              aut_y[96]; // heap allocate??
  c3_y*             dat_y;
} u3_xmas_poke_pact;

typedef struct _u3_xmas_pact {
  u3_xmas_ptag      typ_y;
  uv_udp_send_t     snd_u;
  struct _u3_xmas*  sam_u;
  u3_xmas_rout      rut_u;
  union {
    u3_xmas_poke_pact  pok_u;
    u3_xmas_page_pact  pag_u;
    u3_xmas_peek_pact  pek_u;
  };
} u3_xmas_pact;


static void
_log_head(u3_xmas_head* hed_u)
{
  u3l_log("-- HEADER --");
  u3l_log("protocol: %u", hed_u->pro_y);
  u3l_log("packet type: %u", hed_u->typ_y);
  u3l_log("mug: 0x%05x", (hed_u->mug_w &0xfffff));
  u3l_log("hopcount: %u", hed_u->hop_y);
  u3l_log("");
}

static void
_log_buf(c3_y* buf_y, c3_w len_w)
{
  c3_w siz_w = 2*len_w + 1;
  c3_c* res_c = c3_calloc(siz_w);
  c3_w cur_w = 0;
  c3_c tmp_c[3];
  for(c3_w idx_w = 0; idx_w < len_w; idx_w++ ) {
    snprintf(res_c + (2*idx_w), siz_w - (2*idx_w), "%02x", buf_y[idx_w]); 
  }
  u3l_log("buffer: %s", res_c);
  free(res_c);
}

static void
_log_peek_pact(u3_xmas_peek_pact* pac_u)
{
  u3l_log("publisher: %s", u3r_string(u3dc("scot", c3__p, u3i_chubs(2, pac_u->pub_d))));
  u3l_log("path len: %u", pac_u->pat_s);
  u3l_log("path: %s", pac_u->pat_c);
}

static void
_log_pact(u3_xmas_peek_pact* pac_u)
{
  u3l_log("-- REQUEST PACKET --");
  /*if( ROUT_GALAXY == pac_u->rut_u.typ_y ) {
    u3l_log("-- GALAXY ROUTE --");
    u3_noun her = u3dc("scot", c3__p, u3i_word(pac_u->rut_u.imp_u.her_y));
    c3_c* her_c = u3r_string(her);
    u3l_log("ship lane: %s", her_c);
    free(her_c);
    u3z(her);
  }
  else {
    u3l_log("-- OTHER ROUTE --");
    u3_noun pip = u3dc("scot", c3__if, u3i_word(pac_u->rut_u.lan_u.pip_w));
    c3_c* pip_c = u3r_string(pip);
    u3l_log("IP: (%s) port (%u)", pip_c, pac_u->rut_u.lan_u.por_s);
    free(pip_c);
    u3z(pip);
  }*/
  u3_noun pub = u3dc("scot", c3__p, u3i_chubs(2, pac_u->pub_d));
  c3_c* pub_c = u3r_string(pub);
  u3l_log("ship: %s", pub_c);
  free(pub_c);
  //u3z(pub);
  u3l_log("path: %s", pac_u->pat_c);
}


// cut and pasted from ames.c
//
static void
_ames_etch_short(c3_y buf_y[2], c3_s sot_s)
{
  buf_y[0] = sot_s         & 0xff;
  buf_y[1] = (sot_s >>  8) & 0xff;
}

static void
_ames_etch_word(c3_y buf_y[4], c3_w wod_w)
{
  buf_y[0] = wod_w         & 0xff;
  buf_y[1] = (wod_w >>  8) & 0xff;
  buf_y[2] = (wod_w >> 16) & 0xff;
  buf_y[3] = (wod_w >> 24) & 0xff;
}

/* _ames_czar_port(): udp port for galaxy.
*/
static c3_s
_ames_czar_port(c3_y imp_y)
{
  if ( c3n == u3_Host.ops_u.net ) {
    return 31337 + imp_y;
  }
  else {
    return 13337 + imp_y;
  }
}


/* _ames_alloc(): libuv buffer allocator.
*/
static void
_ames_alloc(uv_handle_t* had_u,
            size_t len_i,
            uv_buf_t* buf
            )
{
  //  we allocate 2K, which gives us plenty of space
  //  for a single ames packet (max size 1060 bytes)
  //
  void* ptr_v = c3_malloc(4096);
  *buf = uv_buf_init(ptr_v, 4096);
}

static inline c3_s
_ames_sift_short(c3_y buf_y[2])
{
  return (buf_y[1] << 8 | buf_y[0]);
}

static inline c3_w
_ames_sift_word(c3_y buf_y[4])
{
  return (buf_y[3] << 24 | buf_y[2] << 16 | buf_y[1] << 8 | buf_y[0]);
}

/* u3_xmas_decode_lane(): deserialize noun to lane; 0.0.0.0:0 if invalid
*/
static u3_lane
u3_xmas_decode_lane(u3_atom lan) {
  u3_lane lan_u;
  c3_d lan_d;

  if ( c3n == u3r_safe_chub(lan, &lan_d) || (lan_d >> 48) != 0 ) {
    return (u3_lane){0, 0};
  }

  //u3z(lan);

  lan_u.pip_w = (c3_w)lan_d;
  lan_u.por_s = (c3_s)(lan_d >> 32);
  //  convert incoming localhost to outgoing localhost
  //
  lan_u.pip_w = ( 0 == lan_u.pip_w ) ? 0x7f000001 : lan_u.pip_w;

  return lan_u;
}

/* _ames_chub_bytes(): c3_y[8] to c3_d
** XX factor out, deduplicate with other conversions
*/
static inline c3_d
_ames_chub_bytes(c3_y byt_y[8])
{
  return (c3_d)byt_y[0]
       | (c3_d)byt_y[1] << 8
       | (c3_d)byt_y[2] << 16
       | (c3_d)byt_y[3] << 24
       | (c3_d)byt_y[4] << 32
       | (c3_d)byt_y[5] << 40
       | (c3_d)byt_y[6] << 48
       | (c3_d)byt_y[7] << 56;
}

/* _ames_ship_to_chubs(): pack [len_y] bytes into c3_d[2]
*/
static inline void
_ames_ship_to_chubs(c3_d sip_d[2], c3_y len_y, c3_y* buf_y)
{
  c3_y sip_y[16] = {0};
  memcpy(sip_y, buf_y, c3_min(16, len_y));

  sip_d[0] = _ames_chub_bytes(sip_y);
  sip_d[1] = _ames_chub_bytes(sip_y + 8);
}

/* _ames_chub_bytes(): c3_d to c3_y[8]
** XX factor out, deduplicate with other conversions
*/
static inline void
_ames_bytes_chub(c3_y byt_y[8], c3_d num_d)
{
  byt_y[0] = num_d & 0xff;
  byt_y[1] = (num_d >>  8) & 0xff;
  byt_y[2] = (num_d >> 16) & 0xff;
  byt_y[3] = (num_d >> 24) & 0xff;
  byt_y[4] = (num_d >> 32) & 0xff;
  byt_y[5] = (num_d >> 40) & 0xff;
  byt_y[6] = (num_d >> 48) & 0xff;
  byt_y[7] = (num_d >> 56) & 0xff;
}

static inline void
_ames_ship_of_chubs(c3_d sip_d[2], c3_y len_y, c3_y* buf_y)
{
  c3_y sip_y[16] = {0};

  _ames_bytes_chub(sip_y, sip_d[0]);
  _ames_bytes_chub(sip_y + 8, sip_d[1]);

  memcpy(buf_y, sip_y, c3_min(16, len_y));
}


/* u3_xmas_lane_to_chub(): serialize lane to double-word
*/
static c3_d
u3_xmas_lane_to_chub(u3_lane lan) {
  return ((c3_d)lan.por_s << 32) ^ (c3_d)lan.pip_w;
}

/* u3_xmas_encode_lane(): serialize lane to noun
*/
static u3_atom
u3_xmas_encode_lane(u3_lane lan) {
  // [%| p=@]
  // [%& p=@pC]
  return u3i_chub(u3_xmas_lane_to_chub(lan));
}



//  END plagariasm zone
//
//
//
//
//
//
//
static u3_noun _xmas_get_now() {
  struct timeval tim_u;
  gettimeofday(&tim_u, 0);
  return u3_time_in_tv(&tim_u);
}

static c3_o
_xmas_rout_pact(u3_xmas_pact* pac_u, u3_noun lan) {
  u3_noun tag, val;
  u3x_cell(lan, &tag, &val);

  u3_assert( (c3y == tag) || (c3n == tag) );
  c3_o suc_o = c3y;
  if ( c3y == tag ) {
    u3_assert( c3y == u3a_is_cat(val) );
    u3_assert( val < 256 );
    pac_u->rut_u.typ_y = ROUT_GALAXY;
    pac_u->rut_u.imp_u.her_y = val;
  } else {
    u3_lane lan_u = u3_xmas_decode_lane(u3k(val));
    //  if in local-only mode, don't send remote packets
    //
    if ( (c3n == u3_Host.ops_u.net) && (0x7f000001 != lan_u.pip_w) ) {
      suc_o = c3n;
    }
    //  if the lane is uninterpretable, silently drop the packet
    //
    else if ( 0 == lan_u.por_s ) {
      if ( u3C.wag_w & u3o_verbose ) {
        u3l_log("ames: inscrutable lane");
      }
      suc_o = c3n;
    } else {
      pac_u->rut_u.typ_y = ROUT_OTHER;
      pac_u->rut_u.lan_u = lan_u;
    }
  }
  // todo refcount
  //
  return suc_o;
}


static c3_y
_ship_meta(u3_noun her)
{
  c3_w met_w = u3r_met(3, her);
  switch ( met_w ) {
    case 0:
    case 1:
    case 2: {
      return 0;
    }
    case 3:
    case 4: {
      return 1;
    }
    case 5:
    case 6:
    case 7:
    case 8: {
      return 2;
    }
    default: {
      return 3;
    }
  }
}


static void _xmas_pact_free(u3_xmas_pact* pac_u) {
  // TODO: i'm lazy
}

static u3_xmas_head
_xmas_head_from_pact(u3_xmas_pact* pac_u, u3_noun her)
{
  u3_xmas_head hed_u;
  hed_u.pro_y = XMAS_VER;
  hed_u.typ_y = pac_u->typ_y;
  hed_u.ran_y = _ship_meta(her);
  hed_u.hop_y = 0;
  hed_u.mug_w = 0;

  return hed_u;
}

static void
_xmas_sift_head(c3_y buf_y[4], u3_xmas_head* hed_u) 
{
  c3_w hed_w = _ames_sift_word(buf_y);

  hed_u->pro_y = (hed_w >> 0)  & 0x7;
  hed_u->typ_y = (hed_w >> 3)  & 0x3;
  hed_u->mug_w = (hed_w >> 5)  & 0x3FFF;
  hed_u->hop_y = (hed_w >> 25) & 0x1F;

  if(c3o((hed_u->typ_y == PACT_PEEK), (hed_u->typ_y == PACT_POKE))) {
    hed_u->ran_y = (hed_w >> 30) & 0x3;
  }
}

static void
_xmas_etch_head(u3_xmas_head* hed_u, c3_y buf_y[4])
{
  if( c3y == XMAS_DEBUG ) {
    if( hed_u->pro_y > 7 ) {
      u3l_log("xmas: bad protocol version");
      return;
    }
  }
  c3_o req_o = c3o((hed_u->typ_y == PACT_PEEK), (hed_u->typ_y == PACT_POKE));
  c3_y siz_y = req_o ? 5 : 7;
  c3_w hed_w = (hed_u->pro_y  & 0x7 )
             ^ ((hed_u->typ_y & 0x3     ) << 3)
             ^ ((hed_u->mug_w & 0x3FFFF ) << 5)
             ^ ((hed_u->hop_y & 0x1F ) << 25);
             // XX: we don't expand hopcount if no request. Correct?
            
  if ( c3y == req_o ) {
    hed_w = hed_w ^ ((hed_u->ran_y & 0x3) << 30);
  }

  _ames_etch_word(buf_y, hed_w);
}

static c3_w
_xmas_etch_page_pact(c3_y* buf_y, u3_xmas_page_pact* pac_u, u3_xmas_head* hed_u)
{
  c3_w cur_w = 0;
 
  // hops
  memcpy(buf_y, pac_u->hop_y, 6);
  cur_w += 6;

  // path length
  _ames_etch_short(buf_y + cur_w, pac_u->pat_s);
  cur_w += 2;

  // path
  memcpy(buf_y + cur_w, pac_u->pat_c, pac_u->pat_s + 1);
  cur_w += pac_u->pat_s + 1;

  //  total
  _ames_etch_word(buf_y + cur_w, pac_u->tot_w);
  cur_w += 4;

  // auth
  memcpy(buf_y + cur_w, &pac_u->aut_y, 96);
  cur_w += 96;

  // day
  memcpy(buf_y + cur_w, pac_u->dat_y, 1024);
  cur_w += 1024;

  return cur_w;
}

static c3_w
_xmas_etch_peek_pact(c3_y* buf_y, u3_xmas_peek_pact* pac_u, u3_xmas_head* hed_u, c3_o tag_o)
{
  c3_w cur_w = 0;
  c3_y pub_y = 2 << hed_u->ran_y;
  _ames_ship_of_chubs(pac_u->pub_d, pub_y, buf_y);
  cur_w += pub_y;

  if( tag_o == c3y ) {
    buf_y[cur_w] = 0; // Tag byte
    cur_w += 1;
  }

  _ames_etch_short(buf_y + cur_w, pac_u->pat_s);
  cur_w += 2;

  memcpy(buf_y + cur_w, pac_u->pat_c, pac_u->pat_s + 1);
  return cur_w + 328;
}

static c3_w
_xmas_etch_poke_pact(c3_y* buf_y, u3_xmas_poke_pact* pac_u, u3_xmas_head* hed_u)
{
  c3_w cur_w = 0;
  cur_w += _xmas_etch_peek_pact(buf_y, pac_u->pek_u, hed_u, c3n);

  //  total
  _ames_etch_word(buf_y + cur_w, pac_u->tot_w);
  cur_w += 4;

  // auth
  memcpy(buf_y + cur_w, &pac_u->aut_y, 96);
  cur_w += 96;

  // day
  memcpy(buf_y + cur_w, pac_u->dat_y, PACT_SIZE - cur_w);

  return PACT_SIZE;
}

static c3_w
_xmas_etch_pact(c3_y* buf_y, u3_xmas_pact* pac_u, u3_noun her)
{
  c3_w cur_w = 0;
  u3_xmas_head hed_u = _xmas_head_from_pact(pac_u, her);
  _xmas_etch_head(&hed_u, buf_y + cur_w);
  cur_w += 4;


  switch ( pac_u->typ_y ) {
    case PACT_POKE: {
      cur_w += _xmas_etch_poke_pact(buf_y + cur_w, &pac_u->pok_u, &hed_u);
    } break;
    case PACT_PEEK: {
      cur_w += _xmas_etch_peek_pact(buf_y + cur_w, &pac_u->pek_u, &hed_u, c3y);
    } break;
    case PACT_PAGE: {
      cur_w += _xmas_etch_page_pact(buf_y + cur_w, &pac_u->pag_u, &hed_u);
    } break;

    default: {
      u3l_log("bad pact type");//u3m_bail(c3__bail);
    }
  }
  return cur_w;
}

static void
_xmas_send_cb(uv_udp_send_t* req_u, c3_i sas_i)
{
  u3_xmas_pact* pac_u = (u3_xmas_pact*)req_u;
  u3_xmas* sam_u = pac_u->sam_u;

  if ( sas_i ) {
    u3l_log("xmas: send fail_async: %s", uv_strerror(sas_i));
    //sam_u->fig_u.net_o = c3n;
  }
  else {
    //sam_u->fig_u.net_o = c3y;
  }

  _xmas_pact_free(pac_u);
}

static void _xmas_send(u3_xmas_pact* pac_u)
{
  u3_xmas* sam_u = pac_u->sam_u;

  struct sockaddr_in add_u;

  memset(&add_u, 0, sizeof(add_u));
  add_u.sin_family = AF_INET;
  c3_s por_s;
  c3_w pip_w;
  if( pac_u->rut_u.typ_y == ROUT_GALAXY ) {
    por_s = _ames_czar_port(pac_u->rut_u.imp_u.her_y);
    pip_w = 0x7f000001;
  }
  else {
    pip_w = c3n == u3_Host.ops_u.net ? pac_u->rut_u.lan_u.pip_w : 0x7f000001;
    por_s = pac_u->rut_u.lan_u.por_s;
  }
  u3l_log("%x,%u", pip_w, por_s);


  add_u.sin_addr.s_addr = htonl(pip_w);
  add_u.sin_port = htons(por_s);

  //u3l_log("_ames_send %s %u", _str_typ(pac_u->typ_y),
  //                              pac_u->rut_u.lan_u.por_s);
    c3_y* buf_y = c3_calloc(PACT_SIZE);
    u3_noun who = 0;
    if( pac_u->typ_y == PACT_PEEK ) {
      who = u3i_chubs(2, pac_u->pek_u.pub_d);
    }
    
    c3_w siz_w = _xmas_etch_pact(buf_y, pac_u, u3k(who));

    uv_buf_t buf_u = uv_buf_init((c3_c*)buf_y, siz_w);

    c3_i     sas_i = uv_udp_send(&pac_u->snd_u,
                                 &sam_u->wax_u,
                                 &buf_u, 1,
                                 (const struct sockaddr*)&add_u,
                                 _xmas_send_cb);

    if ( sas_i ) {
      u3l_log("ames: send fail_sync: %s", uv_strerror(sas_i));
      /*if ( c3y == sam_u->fig_u.net_o ) {
        //sam_u->fig_u.net_o = c3n;
      }*/

      _xmas_pact_free(pac_u);
    }
}


static void
_xmas_ef_peek(u3_xmas* sam_u, u3_noun her, u3_noun las, u3_noun pat) 
{
  if ( c3n == sam_u->car_u.liv_o ) {
    u3l_log("xmas: not yet live, dropping outbound\r");
    //u3z(her); u3z(las); u3z(pat);
    return;
  }

  u3_xmas_pact* pac_u = c3_calloc(sizeof(*pac_u));
  pac_u->typ_y = PACT_PEEK;
  pac_u->sam_u = sam_u;
  u3_noun pas = u3do("spat", pat);
  pac_u->pek_u.pat_s = u3r_short(0, u3dc("met", 3, u3k(pas)));
  pac_u->pek_u.pat_c = u3r_string(u3k(pas));

  if( 384 < strlen(pac_u->pek_u.pat_c) ) {
    u3l_log("xmas: path in peek too long");
    _xmas_pact_free(pac_u);
    //u3z(her); u3z(las); u3z(pat);
    return;
  }
  u3r_chubs(0, 2, pac_u->pek_u.pub_d, her);

  u3_noun lan, t = las;
  c3_o suc_o = c3n;

  while ( u3_nul != t ) {
    u3x_cell(t, &lan, &t);

    if( c3n == _xmas_rout_pact(pac_u, lan) ) {
      u3l_log("xmas: failed to set route");
      //_xmas_pact_req_free(pac_u);
    } else {
       u3l_log("xmas_send");
      _xmas_send(pac_u);
      suc_o = c3y;
    }
  }

  if( c3n == suc_o ) {
    _xmas_pact_free(pac_u);
  }

  //u3z(lan);
}


static c3_o _xmas_kick(u3_xmas* sam_u, u3_noun tag, u3_noun dat)
{
  c3_o ret_o;

  switch ( tag ) {
    default: {
      ret_o = c3n;
     } break;

     //
     case c3__peek: {
       u3_noun lan, her, pat;
       if ( c3n == u3r_trel(dat, &her, &lan, &pat) ) {
         ret_o = c3n;
       } else {
         _xmas_ef_peek(sam_u, u3k(her), u3k(lan), u3k(pat));
         ret_o = c3y;
       }
     } break;
  }

  //u3z(tag); u3z(dat);
  return ret_o; 
}

static c3_o _xmas_io_kick(u3_auto* car_u, u3_noun wir, u3_noun cad)
{
  u3_xmas* sam_u = (u3_xmas*)car_u;

  u3_noun tag, dat, i_wir;
  c3_o ret_o;

  if( c3n == u3r_cell(cad, &tag, &dat) )
  {
    ret_o = c3n;
  }

  ret_o = _xmas_kick(sam_u, u3k(tag), u3k(dat));

  //u3z(wir); u3z(cad);
  return ret_o;
}









static u3_noun
_xmas_io_info(u3_auto* car_u)
{

  return u3_nul;
}

static void
_xmas_io_slog(u3_auto* car_u) {
  u3l_log("xmas is online");
}

static void
_xmas_exit_cb(uv_handle_t* had_u)
{
  u3_xmas* sam_u = had_u->data;

  u3s_cue_xeno_done(sam_u->sil_u);
  ur_cue_test_done(sam_u->tes_u);
  u3h_free(sam_u->lax_p);
  u3h_free(sam_u->req_p);
  c3_free(sam_u);
}

static void 
_xmas_io_exit(u3_auto* car_u)
{
  u3_xmas* sam_u = (u3_xmas*)car_u;
  uv_close(&sam_u->had_u, _xmas_exit_cb);
}

static void
_xmas_sift_page_pact(u3_xmas_page_pact* pac_u, u3_xmas_head* hed_u, c3_y* buf_y, c3_w len_w)
{
  c3_w cur_w = 0;

  // next hop
  memcpy(pac_u->hop_y, buf_y, 6);
  cur_w += 6;

  // path length
  pac_u->pat_s = _ames_sift_short(buf_y + cur_w);
  cur_w += 2;

  // path contents
  pac_u->pat_c = c3_calloc(pac_u->pat_s + 1);
  memcpy(pac_u->pat_c, buf_y + cur_w, pac_u->pat_s);
  pac_u->pat_c[pac_u->pat_s] = '\0';
  cur_w += pac_u->pat_s + 1;

  // total fragments
  pac_u->tot_w = _ames_sift_word(buf_y + cur_w);
  cur_w += 4;

  // Authenticator
  memcpy(pac_u->aut_y, buf_y + cur_w, 96);
  cur_w += 96;

  memcpy(pac_u->dat_y, buf_y + cur_w, 1024);
  cur_w += 1024;
}

static c3_w
_xmas_sift_peek_pact(u3_xmas_peek_pact* pac_u, u3_xmas_head* hed_u, c3_y* buf_y, c3_w len_w, c3_o tag_o)
{
  c3_y pub_y = 2 << hed_u->ran_y; // Publisher size
  c3_w cur_w = 0;
  _ames_ship_to_chubs(pac_u->pub_d, pub_y, buf_y);
  cur_w += pub_y;

  if ( c3y == tag_o ) {
    cur_w += 1; // tag byte
  }

  pac_u->pat_s = _ames_sift_short(buf_y + cur_w); // str len
  cur_w += 2;

  // if ( pac_u->pek_u.pat_s < 325 ) { TODO: check validity

  pac_u->pat_c = c3_calloc(pac_u->pat_s + 1);
  memcpy(pac_u->pat_c, buf_y + cur_w, pac_u->pat_s + 1);
  pac_u->pat_c[pac_u->pat_s] = '\0';
  cur_w += 328;
  return cur_w;
}

static void
_xmas_sift_poke_pact(u3_xmas_poke_pact* pac_u, u3_xmas_head* hed_u, c3_y* buf_y, c3_w len_w)
{
  c3_w cur_w = 0;
  // Peek portion
  pac_u->pek_u = c3_calloc(sizeof(pac_u->pek_u));
  cur_w += _xmas_sift_peek_pact(pac_u->pek_u, hed_u, buf_y, len_w, c3n);

  // Total fragments
  pac_u->tot_w = _ames_sift_word(buf_y + cur_w);
  cur_w += 4;

  // Authenticator
  memcpy(pac_u->aut_y, buf_y + cur_w, 96);
  cur_w += 96;

  // Datum
  memcpy(pac_u->dat_y, buf_y + cur_w, len_w - cur_w);
}




static void
_xmas_sift_pact(u3_xmas_pact* pac_u, u3_xmas_head* hed_u, c3_y* buf_y, c3_w len_w)
{
  pac_u->typ_y = hed_u->typ_y;
  switch ( hed_u->typ_y ) {
    case PACT_PEEK: {
      _xmas_sift_peek_pact(&pac_u->pek_u, hed_u, buf_y, len_w, c3y);
      _log_peek_pact(&pac_u->pek_u);
    } break;
    case PACT_PAGE: {
      _xmas_sift_page_pact(&pac_u->pag_u, hed_u, buf_y, len_w);
    } break;
    case PACT_POKE: {
      _xmas_sift_poke_pact(&pac_u->pok_u, hed_u, buf_y, len_w);
    } break;
  }
}

static u3_weak
_xmas_get_cache(u3_xmas* sam_u, u3_noun pax)
{
  return u3h_git(sam_u->pen_p, u3k(pax));
}

static void
_xmas_put_cache(u3_xmas* sam_u, u3_noun pax, u3_noun val)
{
  u3h_put(sam_u->pen_p, u3k(pax), val);
}


static void
_xmas_try_forward(u3_xmas_pact* pac_u, u3_noun fra, u3_noun hit)
{
  u3l_log("stubbed forwarding");
}

static void
_xmas_respond(u3_xmas_pact* req_u, u3_lane lan_u, u3_noun hit, u3_noun fra)
{
  u3_xmas_pact* res_u = c3_calloc(sizeof(*res_u));
  res_u->typ_y = PACT_PAGE;
  res_u->sam_u = req_u->sam_u;
  res_u->pag_u = (u3_xmas_page_pact) {
    .pat_s = req_u->pek_u.pat_s,
    .tot_w = u3r_word(0, u3h(hit)),
    .dat_y = c3_calloc(FINE_FRAG),
  };
  res_u->pag_u.pat_c = c3_calloc(req_u->pek_u.pat_s + 1);
  res_u->pag_u.pat_c[req_u->pek_u.pat_s] = '\0';
  memcpy(res_u->pag_u.pat_c, req_u->pek_u.pat_c, req_u->pek_u.pat_s);
  u3r_bytes(0, 1024, res_u->pag_u.dat_y, u3dc("snag", fra, u3t(hit)));
  res_u->rut_u.typ_y = ROUT_OTHER;
  res_u->rut_u.lan_u.por_s = lan_u.por_s;
  res_u->rut_u.lan_u.pip_w = lan_u.pip_w;
  _xmas_send(res_u);
}

static void
_xmas_serve_cache_hit(u3_xmas_pact* req_u, u3_lane lan_u, u3_noun fra, u3_noun hit) 
{
  c3_d her_d[2];
  memcpy(her_d, req_u->pek_u.pub_d, 2);
  c3_d our_d[2];
  memcpy(our_d, req_u->sam_u->pir_u->who_d, 2);
  if (  (her_d[0] != our_d[0])
    ||  (her_d[1] != our_d[1]) ) 
  {
    if (  (256 > our_d[0])
       && (0  == our_d[1]) )
    {
      // Forward only if requested datum is not ours, and we are a galaxy
      _xmas_try_forward(req_u, fra, hit);
    } else {
      u3l_log("no forward, we are not a galaxy");
    }
  } else {
  }
}


/* 
 */
static void
_xmas_page_scry_cb(void* vod_p, u3_noun nun)
{
  u3_xmas_pact* pac_u = vod_p;
  u3_xmas* sam_u = pac_u->sam_u;
  //u3l_log("scry cb, at path: %s, %u", pac_u->pek_u.pat_c, strlen(pac_u->pek_u.pat_c));
  u3_noun pat = u3do("stab", u3i_string(pac_u->pek_u.pat_c));
  u3_noun fra = u3dc("slav", c3__ud, u3do("rear", u3k(pat)));
  u3_noun pax = u3do("snip", u3k(pat));
  u3_weak pas = u3r_at(7, nun);
  if( u3_none == pas ) {
    // TODO: mark as dead
    //u3z(nun);
    u3l_log("unbound");

    return;
  }
  u3_weak old = _xmas_get_cache(sam_u, u3k(pax));
  if ( old == u3_none ) {
    u3l_log("bad");
  } 
  u3_noun tag;
  u3_noun dat;
  u3x_cell(old, &tag, &dat);
  if ( c3y == u3r_sing(u3i_string("wait"), tag) ) {
    u3_noun i;
    u3_noun t = u3t(u3k(dat));
    while( u3_nul != t ) {
      u3x_cell(t, &i, &t);
      u3_lane lan_u = u3_xmas_decode_lane(u3k(i));
      
      _xmas_respond(pac_u, lan_u, u3k(pas), u3k(fra));

    }
  }
  _xmas_put_cache(sam_u, u3k(pax), u3nc(c3__item, u3k(pas)));
}



static void
_xmas_hear_peek(u3_xmas_pact* pac_u, u3_lane lan_u)
{

  u3_xmas* sam_u = pac_u->sam_u;
  u3_noun pat = u3i_string(pac_u->pek_u.pat_c);
  u3_noun pax = u3do("stab", u3k(pat));
  u3_noun key = u3do("snip", u3k(pax));
  u3_noun fra = u3do("rear", u3k(pax));
  u3_weak hit = _xmas_get_cache(sam_u, u3k(key));
  if ( u3_none != hit ) {
    u3_noun tag, dat;
    u3x_cell(hit, &tag, &dat);
    if ( c3y == u3r_sing(u3i_string("wait"), u3k(tag)) ) {
      u3_noun liv, las;
      u3x_cell(dat, &liv, &las);
      u3_noun val = u3nc(
          _xmas_get_now(), 
          u3nc(u3_xmas_encode_lane(lan_u), u3k(las))
          //  TODO: a set instead of list?
      );
      _xmas_put_cache(sam_u, u3k(key), u3nc(u3i_string("wait"), u3k(val)));
    }
    else if ( c3y == u3r_sing(u3i_string("item"), u3k(tag)) ) {
      _xmas_serve_cache_hit(pac_u, lan_u, u3k(pax), u3k(dat));
    } else {
      u3l_log("xmas: weird case in cache, dropping");
    }
  } else {
    u3_noun sky = u3nc(c3__page, u3k(key));
    u3_pier_peek_last(sam_u->car_u.pir_u, u3_nul, c3__xx, u3_nul, sky, pac_u, _xmas_page_scry_cb);
    u3_noun val = u3nc(
      _xmas_get_now(), 
      u3nc(u3_xmas_encode_lane(lan_u), u3_nul)
          //  TODO: a set instead of list?
    );

    _xmas_put_cache(sam_u, u3k(key), u3nc(u3i_string("wait"), val));
    // TODO: retrieve from namespace
  }
}

static void
_xmas_hear(u3_xmas* sam_u,
           u3_lane* lan_u,
           c3_w     len_w,
           c3_y*    hun_y)
{
  u3l_log("xmas_hear");

  u3_xmas_pact* pac_u;
  c3_w pre_w;
  c3_y* cur_y = hun_y;
  if ( HEAD_SIZE > len_w ) {
    c3_free(hun_y);
    return;
  }

  pac_u = c3_calloc(sizeof(*pac_u));
  pac_u->sam_u = sam_u;
  u3_xmas_head hed_u;
  _xmas_sift_head(cur_y, &hed_u);
  _xmas_sift_pact(pac_u, &hed_u, hun_y + 4, (len_w - 4));

  switch ( pac_u->typ_y ) {
    case PACT_PEEK: {
      _xmas_hear_peek(pac_u, *lan_u);
    } break;
    default: {
      u3l_log("xmas: unimplemented packet type %u", pac_u->typ_y);
    } break;
  }
}

static void
_xmas_recv_cb(uv_udp_t*        wax_u,
              ssize_t          nrd_i,
              const uv_buf_t * buf_u,
              const struct sockaddr* adr_u,
              unsigned         flg_i)
{
  if ( 0 > nrd_i ) {
    if ( u3C.wag_w & u3o_verbose ) {
      u3l_log("xmas: recv: fail: %s", uv_strerror(nrd_i));
    }
    c3_free(buf_u->base);
  }
  else if ( 0 == nrd_i ) {
    c3_free(buf_u->base);
  }
  else if ( flg_i & UV_UDP_PARTIAL ) {
    if ( u3C.wag_w & u3o_verbose ) {
      u3l_log("xmas: recv: fail: message truncated");
    }
    c3_free(buf_u->base);
  }
  else {
    u3_xmas*            sam_u = wax_u->data;
    struct sockaddr_in* add_u = (struct sockaddr_in*)adr_u;
    u3_lane             lan_u;

    lan_u.por_s = ntohs(add_u->sin_port);
    lan_u.pip_w = ntohl(add_u->sin_addr.s_addr);

    //  NB: [nrd_i] will never exceed max length from _ames_alloc()
    //
    _xmas_hear(sam_u, &lan_u, (c3_w)nrd_i, (c3_y*)buf_u->base);
  }
}



static void
_xmas_io_talk(u3_auto* car_u)
{
  u3_xmas* sam_u = (u3_xmas*)car_u;
  //_xmas_io_start(sam_u);
  u3_noun    who = u3i_chubs(2, sam_u->pir_u->who_d);
  u3_noun    rac = u3do("clan:title", u3k(who));
  c3_s     por_s = sam_u->pir_u->por_s;
  c3_i     ret_i;
  if ( c3__czar == rac ) {
    c3_y num_y = (c3_y)sam_u->pir_u->who_d[0];
    c3_s zar_s = _ames_czar_port(num_y);

    if ( 0 == por_s ) {
      por_s = zar_s;
    }
    else if ( por_s != zar_s ) {
      u3l_log("ames: czar: overriding port %d with -p %d", zar_s, por_s);
      u3l_log("ames: czar: WARNING: %d required for discoverability", zar_s);
    }
  }


  //  Bind and stuff.
  {
    struct sockaddr_in add_u;
    c3_i               add_i = sizeof(add_u);

    memset(&add_u, 0, sizeof(add_u));
    add_u.sin_family = AF_INET;
    add_u.sin_addr.s_addr = _(u3_Host.ops_u.net) ?
                              htonl(INADDR_ANY) :
                              htonl(INADDR_LOOPBACK);
    add_u.sin_port = htons(por_s);

    if ( (ret_i = uv_udp_bind(&sam_u->wax_u,
                              (const struct sockaddr*)&add_u, 0)) != 0 )
    {
      u3l_log("xmas: bind: %s", uv_strerror(ret_i));

      /*if ( (c3__czar == rac) &&
           (UV_EADDRINUSE == ret_i) )
      {
        u3l_log("    ...perhaps you've got two copies of vere running?");
      }*/

      //  XX revise
      //
      u3_pier_bail(u3_king_stub());
    }

    uv_udp_getsockname(&sam_u->wax_u, (struct sockaddr *)&add_u, &add_i);
    u3_assert(add_u.sin_port);

    sam_u->pir_u->por_s = ntohs(add_u.sin_port);
  }
  if ( c3y == u3_Host.ops_u.net ) {
    u3l_log("xmas: live on %d", sam_u->pir_u->por_s);
  }
  else {
    u3l_log("xmas: live on %d (localhost only)", sam_u->pir_u->por_s);
  }

  uv_udp_recv_start(&sam_u->wax_u, _ames_alloc, _xmas_recv_cb);

  sam_u->car_u.liv_o = c3y;
  //u3z(rac); u3z(who);
}

/* _xmas_io_init(): initialize ames I/O.
*/
u3_auto*
u3_xmas_io_init(u3_pier* pir_u)
{
  u3_xmas* sam_u  = c3_calloc(sizeof(*sam_u));
  sam_u->pir_u    = pir_u;

  sam_u->lax_p = u3h_new_cache(100000);
  sam_u->req_p = u3h_new_cache(100000);

  u3_assert( !uv_udp_init(u3L, &sam_u->wax_u) );
  sam_u->wax_u.data = sam_u;

  sam_u->sil_u = u3s_cue_xeno_init();
  sam_u->tes_u = ur_cue_test_init();

  //  Disable networking for fake ships
  //
  if ( c3y == sam_u->pir_u->fak_o ) {
    u3_Host.ops_u.net = c3n;
  }

  u3_auto* car_u = &sam_u->car_u;
  car_u->nam_m = c3__xmas;
  car_u->liv_o = c3y;
  car_u->io.talk_f = _xmas_io_talk;
  car_u->io.info_f = _xmas_io_info;
  car_u->io.slog_f = _xmas_io_slog;
  car_u->io.kick_f = _xmas_io_kick;
  car_u->io.exit_f = _xmas_io_exit;


  /*{
    u3_noun now;
    struct timeval tim_u;
    gettimeofday(&tim_u, 0);

    now = u3_time_in_tv(&tim_u);
    //sam_u->sev_l = u3r_mug(now);
    u3z(now);
  }*/

  return car_u;
}




