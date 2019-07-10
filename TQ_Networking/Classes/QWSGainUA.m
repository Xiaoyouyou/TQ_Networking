//
//  QWSGainUA.m
//  demo
//
//  Created by Yibo Niu on 2016/11/12.
//  Copyright © 2016年 Yibo Niu. All rights reserved.
//

#import "QWSGainUA.h"

static QWSGainUA * gainua = nil;

@interface QWSGainUA ()<UIWebViewDelegate>

@end

@implementation QWSGainUA

UIWebView *_webView;
NSString *userAgent;

+ (instancetype)sharedGainUA{

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gainua =[[super allocWithZone:NULL] init];
    });
    
    return gainua;
}

- (NSString *)createHttpRequest {
    _webView = [[UIWebView alloc] init];
    
    _webView.delegate = self;
    
    [_webView loadRequest:[NSURLRequest requestWithURL:
                           [NSURL URLWithString:@"http://www.eoe.cn"]]];
    
    return [self userAgentString];
}


-(NSString *)userAgentString
{
    while (userAgent == nil)
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return userAgent;
}


-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (webView == _webView) {
        userAgent = [request valueForHTTPHeaderField:@"User-Agent"];
        return NO;
    }
    return YES;
}




@end
