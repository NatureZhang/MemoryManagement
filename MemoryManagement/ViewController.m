//
//  ViewController.m
//  MemoryManagement
//
//  Created by zhangdong on 16/5/25.
//  Copyright © 2016年 __Nature__. All rights reserved.
//

#import "ViewController.h"
#import "MyObject.h"
/*
 内存管理的思考方式
 
 自己生成的对象，自己所持有
 alloc new copy mutableCopy
 使用以上名称开头的方法也意味着自己生成并持有对象
 
 非自己生成的对象，自己也能持有
 类方法等，retain
 
 不再需要自己持有的对象时释放
用alloc/new/copy/mutableCopy 方法生成并持有的对象，或者用retain方法持有的对象，一旦不再需要，务必要用release方法进行释放
 
 非自己持有的对象无法释放
 
 */

/*
 
 对象类型就是指向NSObject这样的Objective-C类的指针，id类型用于隐藏对象类型的类名部分，相当于C语言中常用的void
 */

/*
 所有权修饰符
 
 __strong 
 修饰符是id类型和对象类型默认的所有权修饰符，表示对象的强引用。__strong修饰符表示的变量在超出变量作用域时，即在该变量被废弃时，会释放其被赋予的对象
 
 __strong 、__weak、__autoreleasing 修饰符一起，可以保证将附有这些修饰符的自动变量初始化为nil
 
 */

/*
 __weak 修饰的变量持有对象的弱引用，为了不以自己持有的状态来保存自己生成并持有的对象，生成的对象会立即释放
 若对象被废弃，此弱引用自定失效并赋值nil
 
 与之对应 __unsafe_unretain 不会持有对象的引用，而且对象释放后不会被置为nil，所以说是不安全的
 
 */

/*
 
 __autoreleasing 
 将对象赋值给附加了__autoreleasing修饰符的变量等价于在mrc下调用对象的autorelease方法，即对象被注册到autoreleasepool。
 编译器会检查方法名是否以alloc/new/copy/mutableCopy开始，如果不是则自动将返回值的对象注册到autoreleasepool中
 
 */

/*
 
 ARC 下编码规则
 不能使用retain、release、retainCount、autorelease
 不能使用NSAllocateObject/NSDeallocateObject
 须遵守内存管理的命名规则
 不要显示调用dealloc
 不能使用区域（NSZone）
 对象型变量不能作为C语言结构体的成员
 显示转换“id”和“void *”
 
 */

/*
 
 以init开始的方法必须是实例方法，并且必须要返回对象，返回的对象应为id类型或该方法声明类的对象类型，抑或是该类的超类型或子类型，该返回对象并不注册到autoreleasepool上。基本只是对alloc方法返回值的对象进行初始化处理并返回该对象
 
 */

/*
 
 id obj --> id __strong obj
 id *obj --> id __autorelease obj
 
 */

/*
 
 {
    id __weak obj1 = obj;
 }
 
 源码
 id obj1;
 obj1 = 0;
 objc_storeWeak(&obj1, obj);
 objc_storeWeak(&obj1, 0);
 
 当对象被销毁时
 1  从weak表中获取废弃对象的地址为键值的记录
 2  将包含在记录中的所有附有__weak修饰符变量的地址，赋值为nil
 3  从weak表中删除该记录
 4  从引用计数表中删除废弃对象的地址为键值的记录
 
 id __weak obj = [[NSObject alloc] init] 对象会因为没有持有者而立即释放，并引起编译器警告
 
 */

/*
 
 使用 附有__weak修饰符的变量，即使使用注册到autoreleaspool中的对象
 {
    id __weak obj1 = obj;
    NSLog(@"%@", obj1);
 }
 
 源代码
 id obj1;
 objc_initWeak(&obj1, obj);
 id tmp = objc_loadWeakRetained(&obj1) // 取出附有__weak修饰符变量所引用的对象并retain
 objc_autorelease(tmp)                 // 注册到autoreleasepool中
 NSLog(@"%@", obj1);
 objc_destroyWeak(&obj1)
 
 使用几次就会注册几次，将附有__weak 修饰符的变量赋值给附有__strong修饰符的变量后再使用可以避免此类问题
 
 NSMatchPort类不支持__weak修饰符
 */


/*
 NSGlobalBlock
 1  记述全局变量的地方有Block语法时
 2  Block语法的表达式中不使用截获的自动变量时
 在以上情况下，Block 为 GlobalBlock。除此之外的Block语法生成的Block为StackBlock类对象，且设置在栈上。
 
 
 NSStackBlock
 1  block 作为函数参数时
 
 ARC有效时，编译器会恰当的进行判断，自动生成将Block从栈上复制到堆上的代码
 复制的过程
 
 将通过Block语法生成的Block，即配置在栈上的Block用结构体实例，赋值给相当于Block类型的变量tmp中，
 _Block_copy 函数，将栈上的Block复制到堆上，复制后，将堆上的地址作为指针赋值给变量tmp
 tmp = _Block_copy(tmp);
 
 将堆上的Block作为OC对象，注册到autoreleasepool中，然后返回该对象
 reture objc_autoreleaseReturnValue(tmp)
 
 当block作为函数参数时，编译器不会进行自动复制
 
 */

/*
 
 存储域                复制效果
 栈                从栈上复制到堆
 程序数据区域        什么也不做
 堆                引用计数增加
 
 */

/*
 
 Block 从栈复制到堆上时，对__block 变量的影响
 __block变量的配置存储域        Block从栈复制到堆上时的影响
    栈                          从栈复制到堆并被Block持有
    堆                          被Block持有
 */

/*
 
 在多个Block中使用__block 变量时，因为最先会将所有的Block配置在栈上，所以__block变量也会配置在栈上。在任何一个Block从栈复制到堆时，__block变量也会一并从栈上复制到堆上，并被该block持有。当剩下的Block从栈复制到堆时，被复制的Block持有__block 变量，并增加__block 变量的引用计数
 
 */

/*
 
 什么时候栈上的Block会复制到堆上呢
 
 1  调用Block的copy实例方法时
 2  Block作为函数返回值返回时
 3  将Block赋值给附有__strong修饰符id类型的类或Block类型成员变量时
 4  在方法名中含有usingBlock 的cocoa框架方法或GCD的API中传递Block时
 
 */

/*
 
 若果在Block中使用附有__strong 修饰符的对象类型自动变量，那么当Block从栈复制到堆时，该对象为Block持有。
 
 */

/*
 
 ARC 无效时，__block 说明符被用来避免Block中的循环引用。这是由于当Block从栈复制到堆时，若Block是用的变量为附有__block 说明符的id类型或对象类型的自动变量，不会被retain；如果Block使用的变量为没有__block 说明符的id类型或对象类型的自动变量，则会被retain
 
 */



typedef void(^Block)(id obj);

@interface ViewController ()

@property (nonatomic, copy) Block aBlock;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
//    __block int val = 10;
//    void (^blk)(void) = ^{val = 1;};
//    
//    NSLog(@"%@", ^{val = 1;});
    
//    typedef void(^blk_t)(id obj);
//    
//    blk_t blk;
//    {
//        id array = [[NSMutableArray alloc] init];
//        id __weak array2 = array;
//        blk = ^(id obj) {
//            [array2 addObject:obj];
//            NSLog(@"array count = %ld", [array2 count]);
//        };
//    }
//    
//    blk([[NSObject alloc] init]);
//    blk([[NSObject alloc] init]);
//    blk([[NSObject alloc] init]);
    
    [[MyObject alloc] init];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)testBlock:(Block)block {
    
    _aBlock = block;
    NSLog(@"%@", _aBlock);
}

- (NSArray *)getBlockArray {
    
    int val = 10;
    
    return [[NSArray alloc] initWithObjects:^{NSLog(@"blk0:%d", val);}, ^{NSLog(@"blk1:%d", val);}, nil];
}
@end
