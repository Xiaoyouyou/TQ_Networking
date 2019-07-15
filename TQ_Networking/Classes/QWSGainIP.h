//
//  QWSGainIP.h
//  demo
//
//  Created by Yibo Niu on 2016/11/12.
//  Copyright © 2016年 Yibo Niu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QWSGainIP : NSObject

/** 获取设备当前ip地址 */
+ (NSString *)getIPAddress:(BOOL)preferIP;

/** 获取所有相关ip信息 */
+ (NSDictionary * )getIPallAderss;

@end
