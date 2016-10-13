::                                                      ::  ::
::::  /hoon/womb/lib                                    ::  ::
  ::                                                    ::  ::
/?    310                                               ::  version
/+    talk, old-phon
::                                                      ::  ::
::::                                                    ::  ::
  ::                                                    ::  ::
:: |%
:: ++  foil                                                ::  ship allocation map
::   |*  mold                                              ::  entry mold
::   $:  min/@u                                            ::  minimum entry
::       ctr/@u                                            ::  next allocated
::       und/(set @u)                                      ::  free under counter
::       ove/(set @u)                                      ::  alloc over counter
::       max/@u                                            ::  maximum entry
::       box/(map @u +<)                                   ::  entries
::   ==                                                    ::
:: --                                                      ::
::                                                      ::
::::                                                    ::
  ::                                                    ::
|%                                                      ::
:: ++  managed                                             ::  managed plot
::   |*  mold                                              ::
::   %-  unit                                              ::  unsplit
::   %+  each  +<                                          ::  subdivided
::   mail                                                  ::  delivered
:: ::                                                      ::
:: ++  divided                                             ::  get division state
::   |*  (managed)                                         ::
::   ?-  +<                                                ::
::     $~      ~                                           ::  unsplit
::     {$~ $| *}  ~                                        ::  delivered
::     {$~ $& *}  (some p.u.+<)                            ::  subdivided
::   ==                                                    ::
:: ::                                                      ::
:: ++  moon  (managed _!!)                                 ::  undivided moon
:: ::
:: ++  planet                                              ::  subdivided planet
::   (managed (lone (foil moon)))                          ::
:: ::                                                      ::
:: ++  star                                                ::  subdivided star
::   (managed (pair (foil moon) (foil planet)))            ::
:: ::                                                      ::
:: ++  galaxy                                              ::  subdivided galaxy
::   (managed (trel (foil moon) (foil planet) (foil star)))::
:: ::                                                      ::
++  ticket  @G                                          ::  old 64-bit ticket
++  passcode  @uvH                                      ::  128-bit passcode
++  passhash  @uwH                                      ::  passocde hash
++  mail  @t                                            ::  email address
++  balance                                             ::  invitation balance
  $:  planets/@ud                                       ::  planet count
      stars/@ud                                         ::  star count
      owner/mail                                        ::  owner's email
      history/(list mail)                               ::  transfer history
  ==                                                    ::
:: ++  property                                            ::  subdivided plots
::   $:  galaxies/(map @p galaxy)                          ::  galaxy
::       planets/(map @p planet)                           ::  star
::       stars/(map @p star)                               ::  planet
::   ==                                                    ::
++  invite                                              ::
  $:  who/mail                                          ::  who to send to
      pla/@ud                                           ::  planets to send
      sta/@ud                                           ::  stars to send
      wel/welcome                                       ::  welcome message
  ==                                                    ::
++  welcome                                             ::  welcome message
  $:  intro/tape                                        ::  in invite email
      hello/tape                                        ::  as talk message
  ==                                                    ::
++  stat  (pair live dist)                              ::  external info
++  live  ?($cold $seen $live)                          ::  online status
++  dist                                                ::  allocation
  $%  {$free $~}                                        ::  unallocated
      {$owned p/mail}                                   ::  granted, status
      {$split p/(map ship stat)}                        ::  all given ships
  ==                                                    ::
::                                                      ::
++  ames-tell                                           ::  .^ a+/=tell= type
  |^  {p/(list elem) q/(list elem)}                     ::
  ++  elem  $^  {p/elem q/elem}                         ::
            {term p/*}                                  ::  somewhat underspecified
  --                                                    ::
--                                                      ::
::                                                      ::  ::
::::                                                    ::  ::
  ::                                                    ::  ::
|%
++  part  {$womb $1 pith}                               ::  womb state
++  pith                                                ::  womb content
  $:  boss/(unit ship)                                  ::  outside master
::       bureau/(map passhash balance)                     ::  active invitations
::       office/property                                   ::  properties managed
      recycling/(map ship @)                            ::  old ticket keys
  ==                                                    ::
--                                                      ::
::                                                      ::  ::
::::                                                    ::  ::
  ::                                                    ::  ::
|%                                                      ::  arvo structures
++  invite-j  {who/mail pla/@ud sta/@ud}                ::  invite data
++  womb-task                                           ::  manage ship %fungi
  $%  {$claim aut/passcode her/@p tik/ticket}           ::  convert to %final
      {$bonus tid/passcode pla/@ud sta/@ud}             ::  supplement passcode
      {$invite tid/passcode inv/invite-j}               ::  alloc to passcode
      {$reinvite aut/passcode tid/passcode inv/invite-j}::  move to another
  ==
++  card                                                ::
  $%  {$flog wire flog}                                 ::
      {$info wire @p @tas nori}                         ::  fs write (backup)
      :: {$wait $~}                                        :: delay acknowledgment
      {$diff gilt}                                      :: subscription response
      {$poke wire dock pear}                            ::  app RPC
      {$next wire p/ring}                               ::  update private key
      {$tick wire p/@pG q/@p}                           ::  save ticket
      {$knew wire p/ship q/will}                        ::  learn will (old pki)
      {$jaelwomb wire womb-task}                        ::  manage rights
  ==                                                    ::
++  pear                                                ::
  $%  {$email mail tape wall}                           ::  send email
      {$womb-do-ticket ship}                            ::  request ticket
      {$womb-do-claim ship @p}                          ::  issue ship
      {$drum-put path @t}                               ::  log transaction
  ==                                                    ::
++  gilt                                                :: scry result
  $%  {$ships (list ship)}                              ::
      {$womb-balance balance}                           ::
      {$womb-balance-all (map passhash mail)}           ::
      {$womb-stat stat}                                 ::
::       {$womb-stat-all (map ship stat)}                  ::
      {$womb-ticket-info passcode ?($fail $good $used)} ::
  ==
++  move  (pair bone card)                              ::  user-level move
::
++  transaction                                         ::  logged poke
  $%  {$report her/@p wyl/will}
      {$claim aut/passcode her/@p}
      {$recycle who/mail him/knot tik/knot}
      {$bonus tid/cord pla/@ud sta/@ud}
      {$invite tid/cord inv/invite}
      {$reinvite aut/passcode inv/invite}
  ==
--
|%
++  ames-grab                                           :: XX better ames scry
  |=  {a/term b/ames-tell}  ^-  *
  =;  all  (~(got by all) a)
  %-  ~(gas by *(map term *))
  %-  zing
  %+  turn  (weld p.b q.b)
  |=  b/elem:ames-tell  ^-  (list {term *})
  ?@  -.b  [b]~
  (weld $(b p.b) $(b q.b))
::
++  murn-by
  |*  {a/(map) b/$-(* (unit))}
  ^-  ?~(a !! (map _p.n.a _(need (b q.n.a))))
  %-  malt
  %+  murn  (~(tap by a))
  ?~  a  $~
  |=  _c=n.a  ^-  (unit _[p.n.a (need (b q.n.a))])
  =+  d=(b q.c)
  ?~(d ~ (some [p.c u.d]))
::
++  neis  |=(a/ship ^-(@u (rsh (dec (xeb (dec (xeb a)))) 1 a)))  ::  postfix
::
--
::                                                    ::  ::
::::                                                  ::  ::
  !:                                                  ::  ::
=+  cfg=[can-claim=& can-recycle=&]                   ::  temporarily disabled
=+  [replay=| stat-no-email=|]                              ::  XX globals
|=  {bowl part}                                       ::  main womb work
|_  moz/(list move)
++  abet                                              ::  resolve
  ^-  (quip move *part)
  [(flop moz) +>+<+]
::
++  teba                                              ::  install resolved
  |=  a/(quip move *part)  ^+  +>
  +>(moz (flop -.a), +>+<+ +.a)
::
++  emit  |=(card %_(+> moz [[ost +<] moz]))          ::  return card
++  emil                                              ::  return cards
  |=  (list card)
  ^+  +>
  ?~(+< +> $(+< t.+<, +> (emit i.+<)))
::
++  ames-last-seen                                    ::  last succesful ping
  |=  a/ship  ~+  ^-  (unit time)
  ?:  =(a our)  (some now)
  %-  (hard (unit time))
  ~|  ames-look+/(scot %p our)/tell/(scot %da now)/(scot %p a)
  %+  ames-grab  %rue
  .^(ames-tell %a /(scot %p our)/tell/(scot %da now)/(scot %p a))
::
++  neighboured                                        ::  filter for connectivity
  |*  a/(list {ship *})  ^+  a
  %+  skim  a
  |=  {b/ship *}
  ?=(^ (ames-last-seen b))
::
::
:: ++  shop-galaxies  (available galaxies.office)        ::  unassigned %czar
:: ::
:: ::  Stars can be either whole or children of galaxies
:: ++  shop-stars                                        ::  unassigned %king
::   |=  nth/@u  ^-  cursor
::   =^  out  nth  %.(nth (available stars.office))
::   ?^  out  [out nth]
::   %+  shop-star   nth
::   (neighboured (issuing galaxies.office))
:: ::
:: ++  shop-star                                         ::  star from galaxies
::   |=  {nth/@u lax/(list {who/@p * * r/(foil star)})}  ^-  cursor
::   ?:  =(~ lax)  [~ nth]
::   =^  sel  nth  (in-list lax nth)
::   (prefix 3 who.sel (~(nth fo r.sel) nth))
:: ::
:: ++  shop-planets                                      ::  unassigned %duke
::   |=  nth/@u  ^-  cursor
::   =^  out  nth  %.(nth (available planets.office))
::   ?^  out  [out nth]
::   =^  out  nth
::     %+  shop-planet   nth
::     (neighboured (issuing stars.office))
::   ?^  out  [out nth]
::   (shop-planet-gal nth (issuing galaxies.office))
:: ::
:: ++  shop-planet                                       ::  planet from stars
::   |=  {nth/@u sta/(list {who/@p * q/(foil planet)})}  ^-  cursor
::   ?:  =(~ sta)  [~ nth]
::   =^  sel  nth  (in-list sta nth)
::   (prefix 4 who.sel (~(nth fo q.sel) nth))
:: ::
:: ++  shop-planet-gal                                   ::  planet from galaxies
::   |=  {nth/@u lax/(list {who/@p * * r/(foil star)})}  ^-  cursor
::   ?:  =(~ lax)  [~ nth]
::   =^  sel  nth  (in-list lax nth)
::   %+  shop-planet   nth
::   (neighboured (issuing-under 3 who.sel box.r.sel))
:: ::
++  peek-x-shop                                       ::  available ships
  |=  tyl/path  ^-  (unit (unit {$ships (list @p)}))
  =;  a   ~&  peek-x-shop+[tyl a]  a
  =;  res/(list ship)  (some (some [%ships res]))
  =+  [typ nth]=~|(bad-path+tyl (raid tyl typ=%tas nth=%ud ~))
  :: =.  nth  (mul 3 nth)
  !! :: XX scry jael /=shop=/[typ]/[nth]
::   ?+  typ  ~|(bad-type+typ !!)
::     $galaxies  (take-n [nth 3] shop-galaxies)
::     $planets   (take-n [nth 3] shop-planets)
::     $stars     (take-n [nth 3] shop-stars)
::   ==
::
:: ++  get-managed-galaxy  ~(got by galaxies.office)     ::  office read
:: ++  get-managed-star                                  ::  office read
::   |=  who/@p  ^-  star
::   =+  (~(get by stars.office) who)
::   ?^  -  u
::   =+  gal=(get-managed-galaxy (sein who))
::   ?.  ?=({$~ $& *} gal)  ~|(unavailable-star+(sein who) !!)
::   (fall (~(get by box.r.p.u.gal) (neis who)) ~)
:: ::
:: ++  get-managed-planet                                ::  office read
::   |=  who/@p  ^-  planet
::   =+  (~(get by planets.office) who)
::   ?^  -  u
::   ?:  (~(has by galaxies.office) (sein who))
::     =+  gal=(get-managed-galaxy (sein who))
::     ?.  ?=({$~ $& *} gal)  ~|(unavailable-galaxy+(sein who) !!)
::     (~(get fo q.p.u.gal) who)
::   =+  sta=(get-managed-star (sein who))
::   ?.  ?=({$~ $& *} sta)  ~|(unavailable-star+(sein who) !!)
::   (~(get fo q.p.u.sta) who)
:: ::
::
++  get-live                                          ::  last-heard time ++live
  |=  a/ship  ^-  live
  =+  rue=(ames-last-seen a)
  ?~  rue  %cold
  ?:((gth (sub now u.rue) ~m5) %seen %live)
::
:: ++  stat-any                                          ::  unsplit status
::   |=  {who/@p man/(managed _!!)}  ^-  stat
::   :-  (get-live who)
::   ?~  man  [%free ~]
::   ?:  stat-no-email  [%owned '']
::   [%owned p.u.man]
:: ::
:: ++  stat-planet                                       ::  stat of planet
::   |=  {who/@p man/planet}  ^-  stat
::   ?.  ?=({$~ $& ^} man)  (stat-any who man)
::   :-  (get-live who)
::   =+  pla=u:(divided man)
::   :-  %split
::   %-  malt
::   %+  turn  (~(tap by box.p.pla))
::   |=({a/@u b/moon} =+((rep 5 who a ~) [- (stat-any - b)]))
:: ::
:: ++  stat-star                                         ::  stat of star
::   |=  {who/@p man/star}  ^-  stat
::   ?.  ?=({$~ $& ^} man)  (stat-any who man)
::   :-  (get-live who)
::   =+  sta=u:(divided man)
::   :-  %split
::   %-  malt
::   %+  welp
::     %+  turn  (~(tap by box.p.sta))
::     |=({a/@u b/moon} =+((rep 5 who a ~) [- (stat-any - b)]))
::   %+  turn  (~(tap by box.q.sta))
::   |=({a/@u b/planet} =+((rep 4 who a ~) [- (stat-planet - b)]))
:: ::
:: ++  stat-galaxy                                       :: stat of galaxy
::   |=  {who/@p man/galaxy}  ^-  stat
::   ?.  ?=({$~ $& ^} man)  (stat-any who man)
::   =+  gal=u:(divided man)
::   :-  (get-live who)
::   :-  %split
::   %-  malt
::   ;:  welp
::     %+  turn  (~(tap by box.p.gal))
::     |=({a/@u b/moon} =+((rep 5 who a ~) [- (stat-any - b)]))
::   ::
::     %+  turn  (~(tap by box.q.gal))
::     |=({a/@u b/planet} =+((rep 4 who a ~) [- (stat-planet - b)]))
::   ::
::     %+  turn  (~(tap by box.r.gal))
::     |=({a/@u b/star} =+((rep 3 who a ~) [- (stat-star - b)]))
::   ==
::
++  stats-ship                                        ::  inspect ship
  |=  who/@p  ^-  stat
  :-  (get-live who)
  !!  :: XX scry jael /=stats=/[who]
::   ?-  (clan who)
::     $pawn  !!
::     $earl  !!
::     $duke  (stat-planet who (get-managed-planet who))
::     $king  (stat-star who (get-managed-star who))
::     $czar  (stat-galaxy who (get-managed-galaxy who))
::   ==
::
++  peek-x-stats                                      ::  inspect ship/system
  |=  tyl/path
  ?^  tyl
    ?>  |(=(our src) =([~ src] boss))                   ::  privileged info
    ``womb-stat+(stats-ship ~|(bad-path+tyl (raid tyl who=%p ~)))
  !!  ::  XX meaningful and/or useful in sein-jael model?
::   ^-  (unit (unit {$womb-stat-all (map ship stat)}))
::   =.  stat-no-email  &                      ::  censor adresses
::   :^  ~  ~  %womb-stat-all
::   %-  ~(uni by (~(urn by planets.office) stat-planet))
::   %-  ~(uni by (~(urn by stars.office) stat-star))
::   (~(urn by galaxies.office) stat-galaxy)
::
++  peek-x-balance                                     ::  inspect invitation
  |=  tyl/path
  !!  ::  XX scry jael /=balance=/[pas]
::   ^-  (unit (unit {$womb-balance balance}))
::   =+  pas=~|(bad-path+tyl (raid tyl pas=%uv ~))
::   %-  some
::   %+  bind  (~(get by bureau) (shaf %pass pas))
::   |=(bal/balance [%womb-balance bal])
::
++  parse-ticket
  |=  {a/knot b/knot}  ^-  {him/@ tik/@}
  [him=(rash a old-phon) tik=(rash b old-phon)]
::
++  check-old-ticket
  |=  {a/ship b/@pG}  ^-  (unit ?)
  %+  bind   (~(get by recycling) (sein a))
  |=  key/@  ^-  ?
  =(b `@p`(end 6 1 (shaf %tick (mix a (shax key)))))
::
::
++  peek-x-ticket
  |=  tyl/path
  ^-  (unit (unit {$womb-ticket-info passcode ?($fail $good $used)}))
  ?.  ?=({@ @ $~} tyl)  ~|(bad-path+tyl !!)
  =+  [him tik]=(parse-ticket i.tyl i.t.tyl)
  %+  bind  (check-old-ticket him tik)
  |=  gud/?
  :+  ~  %womb-ticket-info
  =+  pas=`passcode`(end 7 1 (sham %tick him tik))
  :-  pas
  ?.  gud  %fail
  !!  ::  XX scry jael /=balance=/(shaf %pass pas)
::   ?:  (~(has by bureau) (shaf %pass pas))  %used
::   %good
::
++  peer-scry-x                                        ::  subscription like .^
  |=  tyl/path
  =<  abet
  =+  gil=(peek-x tyl)
  ~|  tyl
  ?~  gil  ~|(%block-stub !!)
  ?~  u.gil  ~|(%bad-path !!)
  (emit %diff u.u.gil)
::
++  peek-x                                             ::  stateless read
  |=  tyl/path  ^-  (unit (unit gilt))
  ~|  peek+x+tyl
  ?~  tyl  ~
  ?+  -.tyl  ~
  ::  /shop/planets/@ud   (list @p)    up to 3 planets
  ::  /shop/stars/@ud     (list @p)    up to 3 stars
  ::  /shop/galaxies/@ud  (list @p)    up to 3 galaxies
    $shop  (peek-x-shop +.tyl)
  ::  /stats                          general stats dump
  ::  /stats/@p                       what we know about @p
    $stats  (peek-x-stats +.tyl)
  ::  /balance/passcode                invitation status
    $balance  (peek-x-balance +.tyl)
  ::  /ticket/ship/ticket              check ticket usability
    $ticket  (peek-x-ticket +.tyl)
  ==
::
++  poke-manage-old-key                               ::  add to recyclable tickets
  |=  {a/ship b/@}
  =<  abet
  ?>  |(=(our src) =([~ src] boss))                   ::  privileged
  .(recycling (~(put by recycling) a b))
::
++  email                                             ::  send email
  |=  {wir/wire adr/mail msg/tape}  ^+  +>
  ?:  replay  +>                      ::  dont's send email in replay mode
  ~&  do-email+[adr msg]
  ::~&([%email-stub adr msg] +>)
  (emit %poke womb+[%mail wir] [our %gmail] %email adr "Your Urbit Invitation" [msg]~)
::
++  log-transaction                                   ::  logged poke
  |=  a/transaction  ^+  +>
  ?:  replay  +>
  (emit %poke /womb/log [our %hood] %drum-put /womb-events/(scot %da now)/hoon (crip <eny a>))
::
++  poke-replay-log                                   ::  rerun transactions
  |=  a/(list {eny/@uvJ pok/transaction})
  ?~  a  abet
  ~&  womb-replay+-.pok.i.a
  =.  eny  eny.i.a
  =.  replay  &
  %_    $
      a  t.a
      +>
    ?-  -.pok.i.a
      $claim     (teba (poke-claim +.pok.i.a))
      $bonus    (teba (poke-bonus +.pok.i.a))
      $invite    (teba (poke-invite +.pok.i.a))
      $report    (teba (poke-report +.pok.i.a))
      $recycle   (teba (poke-recycle +.pok.i.a))
      $reinvite  (teba (poke-reinvite +.pok.i.a))
    ==
  ==
::
++  poke-bonus                                        ::  expand invitation
  |=  {tid/cord pla/@ud sta/@ud}
  =<  abet
  =.  log-transaction  (log-transaction %bonus +<)
  ?>  |(=(our src) =([~ src] boss))                   ::  priveledged
  =/  pas  ~|(bad-invite+tid `passcode`(slav %uv tid))
  (emit %jaelwomb / %bonus pas pla sta)
::
++  poke-invite                                       ::  create invitation
  |=  {tid/cord inv/invite}
  =<  abet
  =.  log-transaction  (log-transaction %invite +<)
  ?>  |(=(our src) =([~ src] boss))                   ::  priveledged
  =+  pas=~|(bad-invite+tid `passcode`(slav %uv tid))
  =.  emit  (emit %jaelwomb / %invite pas [who pla sta]:inv)
  (email /invite who.inv intro.wel.inv)
::
++  poke-reinvite                                     ::  split invitation
  |=  {aut/passcode inv/invite}                       ::  further invite
  =<  abet
  =.  log-transaction  (log-transaction %reinvite +<)
  ?>  =(src src)                                      ::  self-authenticated
  =/  pas/@uv  (end 7 1 (shaf %pass eny))
  =.  emit  (emit %jaelwomb / %reinvite aut pas [who pla sta]:inv)
  (email /invite who.inv intro.wel.inv)
::
++  poke-obey                                         ::  set/reset boss
  |=  who/(unit @p)
  =<  abet
  ?>  =(our src)                                      ::  me only
  .(boss who)
::
++  poke-save                                         ::  write backup
  |=  pax/path
  =<  abet
  ?>  =(our src)                                      ::  me only
  =+  pas=`@uw`(shas %back eny)
  ~&  [%backing-up pas=pas]
  =;  dif  (emit %info /backup [our dif])
  %+  foal  (welp pax /jam-crub)
  [%jam-crub !>((en:crub pas (jam `part`+:abet)))]
::
++  poke-rekey                                        ::  extend will
  |=  $~
  =<  abet
  ?>  |(=(our src) =([~ src] boss))                   ::  privileged
  ::  (emit /rekey %next sec:ex:(pit:nu:crub 512 (shaz (mix %next (shaz eny)))))
  ~&  %rekey-stub  .
::
++  poke-report                                       ::  report will
  |=  {her/@p wyl/will}                               ::
  =<  abet
  =.  log-transaction  (log-transaction %report +<)
  ?>  =(src src)                                      ::  self-authenticated
  (emit %knew /report her wyl)
::
++  poke-recycle                                      ::  save ticket as balance
  |=  {who/mail him-t/knot tik-t/knot}
  ?.  can-recycle.cfg  ~|(%ticket-recycling-offline !!)
  =<  abet
  =.  log-transaction  (log-transaction %recycle +<)
  ?>  =(src src)
  =+  [him tik]=(parse-ticket him-t tik-t)
  ?>  (need (check-old-ticket him tik))
  =+  pas=`passcode`(end 7 1 (sham %tick him tik))
::   ?^  (scry-womb-invite (shaf %pass pas))
::     ~|(already-recycled+[him-t tik-t] !!)
  =/  inv/{pla/@ud sta/@ud}
    ?+((clan him) !! $duke [0 1], $king [1 0])
  (emit %jaelwomb / %invite pas who inv)
::
::
:: ++  jael-claimed  'Move email here if an ack is necessary'
::
++  poke-claim                                        ::  claim plot, req ticket
  |=  {aut/passcode her/@p}
  ?.  can-claim.cfg  ~|(%ticketing-offline !!)
  =<  abet
  =.  log-transaction  (log-transaction %claim +<)
  ?>  =(src src)
  =/  tik/ticket  (end 6 1 (shas %tick eny))
  =.  emit  (emit %jaelwomb / %claim aut her tik)
  :: XX event crashes work properly yes?
  =/  adr/mail  !!  :: XX scry jael /=balance=/[aut]
  (email /ticket adr "Ticket for {<her>}: {<`@pG`tik>}")
::
--
