#ifndef U3_VERE_SERF_H
#define U3_VERE_SERF_H

  /** Data types.
  **/
    /* u3_serf_flag_e: process/system flags.
    */
      typedef enum {               //  execution flags
        u3_serf_mut_e = 1 <<  0,   //  state changed
        u3_serf_pac_e = 1 <<  1,   //  pack requested
        u3_serf_rec_e = 1 <<  2,   //  reclaim requested
        u3_serf_sav_e = 1 <<  3,   //  snapshot requested
        u3_serf_mel_e = 1 <<  4,   //  meld requested
        u3_serf_ram_e = 1 <<  5,   //  cram requested
        u3_serf_gab_e = 1 <<  6,   //  grab requested
        u3_serf_inn_e = 1 <<  7,   //  in an inner road
        u3_serf_xit_e = 1 <<  8    //  exit requested
      } u3_serf_flag_e;

    /* u3_serf: worker-process state
    */
      typedef struct _u3_serf {
        c3_d           key_d[4];   //  disk key
        c3_c*          dir_c;      //  execution directory (pier)
        c3_d           sen_d;      //  last event requested
        c3_d           dun_d;      //  last event processed
        u3_noun          roc;      //  arvo kernel at [dun_d]
        c3_l           mug_l;      //  hash of state
        u3_serf_flag_e fag_e;      //  flags
        c3_y           xit_y;      //  exit code
        void         (*xit_f)(void);  //  exit callback
      } u3_serf;

  /** Functions.
  **/
    /* u3_serf_init(): init or restore, producing status.
    */
      u3_noun
      u3_serf_init(u3_serf* sef_u);

    /* u3_serf_writ(): apply writ [wit], producing plea [*pel] on c3y.
    */
      c3_o
      u3_serf_writ(u3_serf* sef_u, u3_noun wit, u3_noun* pel);

    /* u3_serf_live(): apply %live command [com], producing *ret on c3y.
    */
      c3_o
      u3_serf_live(u3_serf* sef_u, u3_noun com, u3_noun* ret);

    /* u3_serf_peek(): read namespace.
    */
      u3_noun
      u3_serf_peek(u3_serf* sef_u, c3_w mil_w, u3_noun sam);

    /* u3_serf_play(): apply event list, producing status.
    */
      u3_noun
      u3_serf_play(u3_serf* sef_u, c3_d eve_d, u3_noun lit);

    /* u3_serf_work(): apply event, producing effects.
    */
      u3_noun
      u3_serf_work(u3_serf* sef_u, c3_w mil_w, u3_noun job);

    /* u3_serf_post(): update serf state post-writ.
    */
      void
      u3_serf_post(u3_serf* sef_u);

    /* u3_serf_grab(): garbage collect.
    */
      void
      u3_serf_grab(u3_serf* sef_u);

#endif /* ifndef U3_VERE_SERF_H */
