/// @file

#include "pkg/noun/v2/allocate.h"

#include "pkg/noun/v2/hashtable.h"
#include "log.h"
#include "pkg/noun/v2/manage.h"
#include "options.h"
#include "retrieve.h"
#include "trace.h"
#include "vortex.h"

/* u3a_v2_reclaim(): clear ad-hoc persistent caches to reclaim memory.
*/
void
u3a_v2_reclaim(void)
{
  //  clear the memoization cache
  //
  u3h_free(u3R->cax.har_p);
  u3R->cax.har_p = u3h_new();
}

/* u3a_v2_rewrite_compact(): rewrite pointers in ad-hoc persistent road structures.
 *                        XX need to version
*/
void
// u3a_v2_v1_rewrite_compact(u3a_v2_v1_road *rod_u)
u3a_v2_rewrite_compact(void)
{
  u3a_v2_rewrite_noun(u3R->ski.gul);
  u3a_v2_rewrite_noun(u3R->bug.tax);
  u3a_v2_rewrite_noun(u3R->bug.mer);
  u3a_v2_rewrite_noun(u3R->pro.don);
  u3a_v2_rewrite_noun(u3R->pro.day);
  u3a_v2_rewrite_noun(u3R->pro.trace);
  u3h_rewrite(u3R->cax.har_p);

  u3R->ski.gul = u3a_v2_rewritten_noun(u3R->ski.gul);
  u3R->bug.tax = u3a_v2_rewritten_noun(u3R->bug.tax);
  u3R->bug.mer = u3a_v2_rewritten_noun(u3R->bug.mer);
  u3R->pro.don = u3a_v2_rewritten_noun(u3R->pro.don);
  u3R->pro.day = u3a_v2_rewritten_noun(u3R->pro.day);
  u3R->pro.trace = u3a_v2_rewritten_noun(u3R->pro.trace);
  u3R->cax.har_p = u3a_v2_rewritten(u3R->cax.har_p);
}

void
u3a_v2_rewrite_noun(u3_noun som)
{
  if ( c3n == u3a_v2_is_cell(som) ) {
    return;
  }

  if ( c3n == u3a_v2_rewrite_ptr(u3a_v2_to_ptr((som))) ) return;

  u3a_cell* cel = u3a_v2_to_ptr(som);

  u3a_v2_rewrite_noun(cel->hed);
  u3a_v2_rewrite_noun(cel->tel);

  cel->hed = u3a_v2_rewritten_noun(cel->hed);
  cel->tel = u3a_v2_rewritten_noun(cel->tel);
}