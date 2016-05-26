//
//  MyObject.m
//  MemoryManagement
//
//  Created by zhangdong on 16/5/25.
//  Copyright © 2016年 __Nature__. All rights reserved.
//

#import "MyObject.h"

@implementation MyObject

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        id obj = obj_;
        
        blk_ = ^{NSLog(@"obj_ = %@", obj);};
        
    }
    return self;
}
@end
