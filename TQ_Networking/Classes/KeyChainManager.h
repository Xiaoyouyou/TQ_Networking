//
//  KeyChainManager.h
//  TQSDK_v1.0
//
//  Created by valen on 2018/5/22.
//  Copyright © 2018年 广东天启互动娱乐. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyChainManager : NSObject
//https://blog.csdn.net/zhoushuangjian511/article/details/78583429
//https://www.jianshu.com/p/169e31cacf42  ----->>没账号不能共享。。
/*!
 保存数据
 
 @data  要存储的数据
 @identifier 存储数据的标示
 */
+(BOOL) keyChainSaveData:(id)data withIdentifier:(NSString*)identifier ;

/*!
 读取数据
 
 @identifier 存储数据的标示
 */
+(id) keyChainReadData:(NSString*)identifier ;


/*!
 更新数据
 
 @data  要更新的数据
 @identifier 数据存储时的标示
 */
+(BOOL)keyChainUpdata:(id)data withIdentifier:(NSString*)identifier ;

/*!
 删除数据
 
 @identifier 数据存储时的标示
 */
+(void) keyChainDelete:(NSString*)identifier ;

@end
