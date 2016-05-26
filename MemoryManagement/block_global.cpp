
/*
 
 void (^blk)(void) = ^{printf("aaa");};
 int main() {
    return 0;
 }
 
 */

struct __blk_block_impl_0 {
  struct __block_impl impl;
  struct __blk_block_desc_0* Desc;
  __blk_block_impl_0(void *fp, struct __blk_block_desc_0 *desc, int flags=0) {
    impl.isa = &_NSConcreteGlobalBlock;
    impl.Flags = flags;
    impl.FuncPtr = fp;
    Desc = desc;
  }
};
static void __blk_block_func_0(struct __blk_block_impl_0 *__cself) {
printf("aaa");}

static struct __blk_block_desc_0 {
  size_t reserved;
  size_t Block_size;
} __blk_block_desc_0_DATA = { 0, sizeof(struct __blk_block_impl_0)};
static __blk_block_impl_0 __global_blk_block_impl_0((void *)__blk_block_func_0, &__blk_block_desc_0_DATA);
void (*blk)(void) = ((void (*)())&__global_blk_block_impl_0);
int main() {
}
