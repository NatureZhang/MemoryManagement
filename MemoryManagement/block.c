//
//  block.c
//  MemoryManagement
//
//  Created by zhangdong on 16/5/26.
//  Copyright © 2016年 __Nature__. All rights reserved.
//

#include "block.h"
void (^blk)(void) = ^{printf("aaa");};
//int main() {
//    
//    __block int val = 10;
//    
//    void (^blk)(void) = ^{val = 1;};
//    
//    blk();
//    
//    return 0;
//}