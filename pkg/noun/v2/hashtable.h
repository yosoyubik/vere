#ifndef U3_HASHTABLE_V2_H
#define U3_HASHTABLE_V2_H

#define VITS_W 1
#include "pkg/noun/hashtable.h"

#include "c3.h"
#include "types.h"

  /**  Data structures.
  **/

    /**  HAMT macros.
    ***
    ***  Coordinate with u3_noun definition!
    **/
      /* u3h_v2_slot_to_node(): slot to node pointer
      ** u3h_v2_node_to_slot(): node pointer to slot
      */
#     define  u3h_v2_slot_to_node(sot)  (u3a_into(((sot) & 0x3fffffff) << VITS_W))
#     define  u3h_v2_node_to_slot(ptr)  ((u3a_outa((ptr)) >> VITS_W) | 0x40000000)

    /**  Functions.
    ***
    ***  Needs: delete and merge functions; clock reclamation function.
    **/
      /* u3h_v2_free(): free hashtable.
      */
        void
        u3h_v2_free(u3p(u3h_root) har_p);

      /* u3h_v2_rewrite(): rewrite hashtable for compaction.
      */
        void
        u3h_v2_rewrite(u3p(u3h_root) har_p);

      /* u3h_v2_walk_with(): traverse hashtable with key, value fn and data
       *                  argument; RETAINS.
      */
        void
        u3h_v2_walk_with(u3p(u3h_root) har_p,
                      void (*fun_f)(u3_noun, void*),
                      void* wit);

      /* u3h_v2_walk(): u3h_v2_walk_with, but with no data argument
      */
        void
        u3h_v2_walk(u3p(u3h_root) har_p, void (*fun_f)(u3_noun));

#endif /* U3_HASHTABLE_V2_H */