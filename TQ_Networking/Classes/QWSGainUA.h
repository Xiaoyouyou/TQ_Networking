//
//  QWSGainUA.h
//  demo
//
//  Created by Yibo Niu on 2016/11/12.
//  Copyright © 2016年 Yibo Niu. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface QWSGainUA : UIWebView

// 单例
+ (instancetype)sharedGainUA;

// 获取UA信息
- (NSString*)createHttpRequest;
@end
