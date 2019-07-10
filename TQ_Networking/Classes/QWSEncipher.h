//
//  QWSEncipher.h
//  demo
//
//  Created by Yibo Niu on 2016/11/11.
//  Copyright © 2016年 Yibo Niu. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QWSEncipher : NSObject

/** 单例 */
+ (instancetype)sharerEncipher;

// 加密
- (id)QWSEncryption:(NSString*)Encryption;

// 解密
- (id)QWSDencryption:(NSString *)Dencryption;


@end
