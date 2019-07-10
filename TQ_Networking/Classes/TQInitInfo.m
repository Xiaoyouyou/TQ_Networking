//
//  TQInitInfo.m
//  TQSDK_v1.0
//
//  Created by valen on 2018/4/1.
//  Copyright © 2018年 广东天启互动娱乐. All rights reserved.
//

#import "TQInitInfo.h"
@interface TQInitInfo()
@end

@implementation TQInitInfo

+ (instancetype)singleInitInfo
{
    return [[self alloc] init];
}


static TQInitInfo *_instance;
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    
    // 由于alloc方法内部会调用allocWithZone: 所以我们只需要保证在该方法只创建一个对象即可
    dispatch_once(&onceToken,^{
        
        // 只执行1次的代码(这里面默认是线程安全的)
        _instance = [super allocWithZone:zone];
        
    });
    
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _instance;
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    return _instance;
}

//-----

@end
