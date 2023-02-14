#include "pma.h"

#include <assert.h>

int64_t
addr_to_page_idx_(uintptr_t addr, const pma_t *pma);

static void
test_addr_to_page_idx_(void)
{
    void               *base_ = (void *)0x200000000;
    static const size_t kLen  = 1 << 20;
    pma_t              *pma_  = pma_init(base_, kLen, NULL, NULL);
    assert(pma_);

    {
        uintptr_t addr_ = (uintptr_t)base_;
        int64_t   idx_  = addr_to_page_idx_(addr_, pma_);
        assert(idx_ == 1);
    }

    {
        static const int64_t kOffset = 2;
        uintptr_t            addr_   = (uintptr_t)base_ + kOffset * kPageSz;
        int64_t              idx_    = addr_to_page_idx_(addr_, pma_);
        assert(idx_ == kOffset + 1);
    }

    // TODO: test negative indexes.

    pma_deinit(pma_);
}

static void
test_pma_init_()
{
    {
        void  *base_ = (void *)0x200000000;
        size_t len_  = 1 << 20;
        pma_t *pma_  = pma_init(base_, len_, NULL, NULL);
        assert(pma_);
        assert(pma_->heap_start == base_);
        assert(pma_->stack_start == (char *)base_ + len_);
        assert(pma_->heap_len == kPageSz);
        assert(pma_->stack_len == kPageSz);
        assert(pma_->heap_fd == -1);
        assert(pma_->stack_fd == -1);
        assert(pma_->max_sz == 0);
        // Ensure we can write to the heap.
        *(char *)base_ = 'h';
        // Ensure we can write to the stack.
        *((char *)base_ + len_ - 1) = 'i';
        pma_deinit(pma_);
    }
}

int
main(int argc, char *argv[])
{
    test_pma_init_();
    test_addr_to_page_idx_();
    return 0;
}
