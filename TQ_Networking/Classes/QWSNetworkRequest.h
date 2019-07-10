//
//  QWSNetworkRequest.h
//  demo
//
//  Created by Yibo Niu on 2016/11/11.
//  Copyright © 2016年 Yibo Niu. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^successBlock)(NSDictionary *success);
typedef void(^failBlock)(NSError *error,NSString *errorMsg);

@interface QWSNetworkRequest : NSObject

//单例
+ (instancetype)sharedNetworkRequest;


// 向init接口发送请求
- (void)QWSRequest_Initinterface:(NSData*)requestData RequestURL:(NSString*)RequestURL successBlock:(successBlock)successBlock failBlock:(failBlock)failBlock;

// 向其他接口发送请求
- (void)QWSRequest_Otherinterface:(NSData*)requestData RequestURL:(NSString*)RequestURL successBlock:(successBlock)successBlock failBlock:(failBlock)failBlock;

// 没有进行HTTP REQUESR HEADER
- (void)QWSRequest_Normalinterface:(NSData*)requestData RequestURL:(NSString*)RequestURL successBlock:(successBlock)successBlock failBlock:(failBlock)failBlock;


@end
