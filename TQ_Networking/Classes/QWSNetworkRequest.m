//
//  QWSNetworkRequest.m
//  demo
//
//  Created by Yibo Niu on 2016/11/11.
//  Copyright © 2016年 Yibo Niu. All rights reserved.
//

#import "QWSNetworkRequest.h"
#import "QWSGzip.h"
#import "QWSEncipher.h"



static QWSNetworkRequest *instan = nil;

@implementation QWSNetworkRequest

/** 实现单例*/
+ (instancetype)sharedNetworkRequest
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instan = [[super allocWithZone:NULL] init];
        
    });
    
    return instan;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [QWSNetworkRequest sharedNetworkRequest];
}

- (id)copyWithZone:(struct _NSZone *)zone
{
    return [QWSNetworkRequest sharedNetworkRequest];
}

// 向init接口发送请求
- (void)QWSRequest_Initinterface:(NSData*)requestData RequestURL:(NSString*)RequestURL successBlock:(successBlock)successBlock failBlock:(failBlock)failBlock{
    NSURL *url = [NSURL URLWithString:RequestURL];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    
    NSMutableData *commit = [[NSMutableData alloc]init];
    
    [request setHTTPMethod:@"POST"];
    
    [request setHTTPBody:commit];
    
    //   设置是否支持gzip     yes为支持  no反之
    //[request setAllowsCellularAccess:YES];
    
//    [request addValue:@"text/html" forHTTPHeaderField:@"content-type"];
    [request addValue:@"application/octet-stream" forHTTPHeaderField:@"content-type"];
    [request addValue:@"4cgame_sdk" forHTTPHeaderField:@"x-app"];
    [request addValue:@"1" forHTTPHeaderField:@"version"];
    [commit appendData:requestData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:
                                      ^(NSData *data, NSURLResponse *response, NSError *error) {
                                          
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              
                                              if(data != nil){
                                                  
                                                  QWSGzip *zip = [QWSGzip sharedGzip];
                                                  
                                                  NSData * gzipdata = [zip gzipDataExtract:data];
                                                  
                                                  NSString * requestss = [[NSString alloc] initWithData:gzipdata  encoding:NSUTF8StringEncoding];
                                                  
                                                  QWSEncipher *encipher = [[QWSEncipher alloc] init];
                                                  
                                                  NSString *srr = [encipher QWSDencryption:requestss];
                                                  
                                                  NSDictionary * dic = [self dictionaryWithJsonString:srr];
                                                  
                                                  NSInteger code = [[dic objectForKey:@"code"] integerValue];
                                                  if (code == 1) {
                                                      
                                                      NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                                      
                                                      [defaults setValue:@"1" forKey:@"INITIALIZATION"];
                                                      
                                                      [defaults synchronize];
                                                      successBlock(dic);
                                                  }else{
                                                      NSLog(@"请求失败=======%@",error);
                                                      
                                                      NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                                      
                                                      [defaults setValue:@"0" forKey:@"INITIALIZATION"];
                                                      
                                                      [defaults synchronize];
                                                      failBlock(error,[dic objectForKey:@"msg"]);
                                                  }
                                                  
                                              }else{
                                                  //如果获取失败
                                                  NSLog(@"请求失败=======%@",error);
                                                  
                                                  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                                  
                                                  [defaults setValue:@"0" forKey:@"INITIALIZATION"];
                                                  
                                                  [defaults synchronize];
                                                  
                                                  NSString *errormsg =[error.userInfo objectForKey:@"msg"];
                                                  
                                                  if ([self isBlankString:errormsg] == YES) {
                                                      errormsg = @"网络不稳定，请重启应用！";
                                                  }
                                                  
                                                  failBlock(error,errormsg);
                                              }
                                              
                                          });
                                          
                                      }];
    
    //获取cookie
    NSHTTPCookieStorage * cookiejar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    
    for (NSHTTPCookie * cookie in [cookiejar cookies]) {
        
    
        NSString * HUOSHUIDValue = [cookie value];
        
        if ([[cookie name] isEqualToString:@"HUOSHUID"]) {
            
            [user setValue:HUOSHUIDValue forKey:@"HUOSHUIDVALUE"];
            
        }
        
        [user synchronize];

        if (HUOSHUIDValue == nil)
        {
            [user setValue:@"0" forKey:@"INITIALIZATION"];
            
            [user synchronize];
            
        }
        else
        {
            [user setValue:@"1" forKey:@"INITIALIZATION"];
            
            [user synchronize];
        }
        
    }
    [dataTask resume];
}

// 向其他接口发送请求
- (void)QWSRequest_Otherinterface:(NSData*)requestData RequestURL:(NSString*)RequestURL successBlock:(successBlock)successBlock failBlock:(failBlock)failBlock{
    NSURL *url = [NSURL URLWithString:RequestURL];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    
    NSMutableData *commit = [[NSMutableData alloc]init];
    
    [request setHTTPMethod:@"POST"];
    
    [request setHTTPBody:commit];
    
    [request setAllowsCellularAccess:YES];
    
//    [request addValue:@"text/html" forHTTPHeaderField:@"content-type"];
    [request addValue:@"application/octet-stream" forHTTPHeaderField:@"content-type"];
    [request addValue:@"4cgame_sdk" forHTTPHeaderField:@"x-app"];
    
    NSHTTPCookieStorage * cookiejar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    if ([cookiejar cookies] != nil) {
        
        NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
        
        [request setValue:[NSString stringWithFormat:@"%@%@",@"HUOSHUID=",[user valueForKey:@"HUOSHUIDVALUE"]] forHTTPHeaderField:@"cookie"];
        
    }
    
    [commit appendData:requestData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:
                                      ^(NSData *data, NSURLResponse *response, NSError *error) {
                                          
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              
                                              if(data != nil){
                                                  
                                                  NSLog(@"---***---%@",data);
                                                  
                                                  QWSGzip *zip = [QWSGzip sharedGzip];
                                                  
                                                  NSData * gzipdata = [zip gzipDataExtract:data];
                                                  
                                                  NSString * requestss = [[NSString alloc] initWithData:gzipdata  encoding:NSUTF8StringEncoding];
                                                  
                                                  QWSEncipher *encipher = [[QWSEncipher alloc] init];
                                                  
                                                  NSString * srr = [encipher QWSDencryption:requestss];
                                                  
                                                  NSDictionary *dic = [instan dictionaryWithJsonString:srr];
                                                  NSInteger code = [[dic objectForKey:@"code"] integerValue];
                                                  if (code == 1) {
                                                      successBlock(dic);
                                                  }else{
                                                      NSLog(@"请求失败=======%@",error);
                                                      failBlock(error,[dic objectForKey:@"msg"]);
                                                  }
                                                  
                                              }else{
                                                  //如果获取失败
                                                  NSLog(@"获取失败=======%@",error);
                                                  NSString *errormsg =[error.userInfo objectForKey:@"msg"];
                                                  
                                                  if ([self isBlankString:errormsg] == YES) {
                                                      errormsg = @"网络不稳定，请重启应用！";
                                                  }
                                                  
                                                  failBlock(error,errormsg);
                                              }
                                              
                                          });
                                          
                                      }];
    [dataTask resume];
}

- (BOOL)isBlankString:(NSString *)aStr {
    if (!aStr) {
        return YES;
    }
    if ([aStr isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if (!aStr.length) {
        return YES;
    }
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmedStr = [aStr stringByTrimmingCharactersInSet:set];
    if (!trimmedStr.length) {
        return YES;
    }
    return NO;
}


// 没有进行HTTP REQUESR HEADER
- (void)QWSRequest_Normalinterface:(NSData*)requestData RequestURL:(NSString*)RequestURL successBlock:(successBlock)successBlock failBlock:(failBlock)failBlock{
    NSURL *url = [NSURL URLWithString:RequestURL];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:100];
    
    NSMutableData *commit = [[NSMutableData alloc]init];
    
    [request setHTTPMethod:@"POST"];
    
    [request setHTTPBody:commit];
    
    [request setAllowsCellularAccess:YES];
    
//    [request addValue:@"text/html" forHTTPHeaderField:@"content-type"];
    [request addValue:@"application/octet-stream" forHTTPHeaderField:@"content-type"];
    [request addValue:@"4cgame_sdk" forHTTPHeaderField:@"x-app"];
    
    [commit appendData:requestData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:
                                      ^(NSData *data, NSURLResponse *response, NSError *error) {
                                          
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              if(data != nil){
                                                  
                                                  //NSData * gzipdata = [LFCGzipUtillity uncompressZippedData:data];
                                                  NSString * requestss = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
                                                  //NSData * srr = [QWSEncipher QWSDencryption:requestss];
                                                  NSDictionary * dic = [self dictionaryWithJsonString:requestss];
                                                  
                                                  NSInteger code = [[dic objectForKey:@"code"] integerValue];
                                                  
                                                  if (code == 1) {
                                                      successBlock(dic);
                                                  }else{
                                                      NSLog(@"请求失败=======%@",error);
                                                      failBlock(error,[dic objectForKey:@"msg"]);
                                                  }
                                                  
                                              }else{
                                                  //如果获取失败
                                                  NSLog(@"获取失败=======%@",error);
                                                  NSString *errormsg =[error.userInfo objectForKey:@"msg"];
                                                  
                                                  if ([self isBlankString:errormsg] == YES) {
                                                      errormsg = @"网络不稳定，请重启应用！";
                                                  }
                                                  
                                                  failBlock(error,errormsg);
                                              }
                                              
                                          });
                                          
                                      }];
    [dataTask resume];
    
    
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString{
    
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}


@end
