//
//  MyObject.h
//  MemoryManagement
//
//  Created by zhangdong on 16/5/25.
//  Copyright © 2016年 __Nature__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^blk_t)();
@interface MyObject : NSObject
{
    blk_t blk_;
    id obj_;
}
@property (nonatomic, strong) NSString *name;



@end
