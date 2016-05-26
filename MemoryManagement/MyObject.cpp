

// @property (nonatomic, strong) NSString *name;

// + (instancetype)myObject;

/* @end */


// @implementation MyObject


struct __MyObject__test_block_impl_0 {
  struct __block_impl impl;
  struct __MyObject__test_block_desc_0* Desc;
  __MyObject__test_block_impl_0(void *fp, struct __MyObject__test_block_desc_0 *desc, int flags=0) {
    impl.isa = &_NSConcreteStackBlock;
    impl.Flags = flags;
    impl.FuncPtr = fp;
    Desc = desc;
  }
};
static void __MyObject__test_block_func_0(struct __MyObject__test_block_impl_0 *__cself) {
printf("aaa");}

static struct __MyObject__test_block_desc_0 {
  size_t reserved;
  size_t Block_size;
} __MyObject__test_block_desc_0_DATA = { 0, sizeof(struct __MyObject__test_block_impl_0)};

static void _I_MyObject_test(MyObject * self, SEL _cmd) {

    void (*blk)(void) = ((void (*)())&__MyObject__test_block_impl_0((void *)__MyObject__test_block_func_0, &__MyObject__test_block_desc_0_DATA));

}


static NSString * _I_MyObject_name(MyObject * self, SEL _cmd) { return (*(NSString **)((char *)self + OBJC_IVAR_$_MyObject$_name)); }
static void _I_MyObject_setName_(MyObject * self, SEL _cmd, NSString *name) { (*(NSString **)((char *)self + OBJC_IVAR_$_MyObject$_name)) = name; }
// @end

