//
//  TQPay.m
//  TQSDK_v1.0
//
//  Created by valen on 2018/3/31.
//  Copyright © 2018年 广东天启互动娱乐. All rights reserved.
//

#import "TQPay.h"
#import "QWSNetworkRequest.h"
#import "RequestHeader.h"
#import "DYDeviceInfo.h"
#import "QWSGainUA.h"
#import <TQ_MD5Encryption/QWSMD5Encryption.h>
#import "TQStaticLoginInfo.h"
#import "QWSEncipher.h"
#import "QWSGzip.h"
#import "TQInitInfo.h"
#import "AFNetworking.h"

//#import "QWSMD5Encryption.h"
#import "KeyChainManager.h"
#define  SDK_GAME_KEYCHAIN_CHANNEL  @"SDK_4CC_PROMOTEID"//SDK渠道号
#define  APP_GAME_KEYCHAIN_CHANNEL  @"APP_4CC_APPKEY"//APP渠道号
@interface TQPay()
@end
@implementation TQPay

+ (instancetype)singleTQPay
{
    
    return [[self alloc] init];
}


static TQPay *_instance;
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

- (void)initWithMoney:(NSString*)money  successBlock:(successBlock)successBlock failBlock:(failBlock)failBlock{
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    QWSNetworkRequest *network = [QWSNetworkRequest sharedNetworkRequest];
    TQStaticLoginInfo  *logininfo = [TQStaticLoginInfo singleStaticLoginInfo];
    QWSMD5Encryption *md5Encryption = [QWSMD5Encryption sharedMD5Encryption];
    TQInitInfo   *initinfo =  [TQInitInfo singleInitInfo];
    //拼接参数
    
    NSString *a =  initinfo.appID;
    NSString *c = [KeyChainManager keyChainReadData:@"4CSDKUUID"];
    NSString *d = @"3";
//    NSStringEncoding enc;
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"gameChannel" ofType:nil];
//    NSString *str = [NSString stringWithContentsOfFile:path usedEncoding:&enc error:nil];
//    NSString *estr;
//    if (str == nil) {
//        estr = @"default";
//    }else{
//        estr = str;
//    }
//    NSString *e = str;
    NSString *e = [KeyChainManager keyChainReadData:SDK_GAME_KEYCHAIN_CHANNEL];
    NSString *f = [NSString stringWithFormat:@"%@||%@||%@||%@",[[UIDevice currentDevice] name],[[UIDevice currentDevice] model],[[UIDevice currentDevice] systemName],[[UIDevice currentDevice] systemVersion]];  //设备信息;
    QWSGainUA *gainUA = [QWSGainUA sharedGainUA];
    NSString *g = [gainUA createHttpRequest];
    NSString *o = money;//金额
    NSString *v = logininfo.mem_id;
    NSString *j = @"alipay";
    
    NSString *z = logininfo.user_token ;
    NSString *w = @"0";
    NSString *x = initinfo.clientID;
    
    NSDate *currentDate = [NSDate date];
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    
    [dateFormatter setDateFormat:@"Y-MM-dd"];
    
    NSString * dateString = [dateFormatter stringFromDate:currentDate];
    
    NSString * strs = @"payPtb";
    
    NSString * add = [NSString stringWithFormat:@"%@%@%d%@",strs,dateString,0,initinfo.clientKEY];
    
    
    NSString * api_token = [md5Encryption md5:add];   //y
    
    NSString *param_token_az = [NSString stringWithFormat:@"a=%@&c=%@&d=%@&e=%@&f=%@&g=%@&o=%@&v=%@&j=%@&z=%@&w=%@&x=%@&y=%@",a,c,d,e,f,g,o,v,j,z,w,x,api_token];
    
    NSString * param_token_az_Str = [md5Encryption md5:[NSString stringWithFormat:@"%@%@",[md5Encryption md5:param_token_az],initinfo.clientKEY]];//az
    
    NSDictionary *behaviordic = @{@"a":a,@"c":c,@"d":d,@"e":e,@"f":f,@"g":g,@"o":o,@"v":v,@"j":j,@"z":z,@"w":w,@"x":x,@"y":api_token,@"az":param_token_az_Str};
    
//    NSLog(@"----支付宝初始化的入参---%@",behaviordic);
    //JSON化
    NSError * parseError_be = nil;
    
    NSData * jsonData_be = [NSJSONSerialization dataWithJSONObject:behaviordic
                                                           options:NSJSONWritingPrettyPrinted error:&parseError_be];
    
    NSString * action = [[NSString alloc]initWithData:jsonData_be encoding:NSUTF8StringEncoding];
    
    QWSEncipher *encipher = [[QWSEncipher alloc] init];
    
    NSString * restr1 =[encipher QWSEncryption:action];
    
    QWSGzip *zip = [QWSGzip sharedGzip];
    
    NSData *data1 = [zip gZipDataPressure:[restr1 dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    //网络请求
    
    [network QWSRequest_Otherinterface:data1 RequestURL:[NSString stringWithFormat:@"%@payPtb.php",HTTPHead] successBlock:^(NSDictionary *success) {
       
        
        successBlock(success);
        
    } failBlock:^(NSError *error, NSString *errorMsg) {
        
        failBlock(error,errorMsg);
    }];
    
}

- (void)initWithSXYPayToken:(NSString*)paytoken  andmoney:(NSString*)money successBlock:(successBlock)successBlock failBlock:(failBlock)failBlock{
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    TQStaticLoginInfo  *logininfo = [TQStaticLoginInfo singleStaticLoginInfo];
    QWSMD5Encryption *md5Encryption = [QWSMD5Encryption sharedMD5Encryption];
    QWSNetworkRequest *network = [QWSNetworkRequest sharedNetworkRequest];
    TQInitInfo   *initinfo =  [TQInitInfo singleInitInfo];
    //拼接参数
    
    NSString *a =  initinfo.appID;
    NSString *o = money;//金额
    NSString *zj = money;//跟金额一样
    NSString *v = logininfo.mem_id;
    NSString *z = logininfo.user_token;
    NSString *w = @"0";
    NSString *d = @"3";
    NSString *x = initinfo.clientID;
    
    NSDate *currentDate = [NSDate date];
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    
    [dateFormatter setDateFormat:@"Y-MM-dd"];
    
    NSString * dateString = [dateFormatter stringFromDate:currentDate];
    
    NSString * strs = @"alipay_ptb";
    
    NSString * add = [NSString stringWithFormat:@"%@%@%d%@",strs,dateString,0,initinfo.clientKEY];
    
    
    NSString * api_token = [md5Encryption md5:add];//y
    
    NSString *ai = paytoken;
    
    NSDictionary *behaviordic = @{@"a":a,@"o":o,@"zj":zj,@"v":v,@"z":z,@"w":w,@"d":d,@"x":x,@"y":api_token,@"ai":ai};
    
    
    //JSON化
    NSError * parseError_be = nil;
    
    NSData * jsonData_be = [NSJSONSerialization dataWithJSONObject:behaviordic
                                                           options:NSJSONWritingPrettyPrinted error:&parseError_be];
    
    NSString * action = [[NSString alloc]initWithData:jsonData_be encoding:NSUTF8StringEncoding];
    
    QWSEncipher *encipher = [[QWSEncipher alloc] init];
    
    NSString * restr1 =[encipher QWSEncryption:action];
    
    QWSGzip *zip = [QWSGzip sharedGzip];
    
    NSData *data1 = [zip gZipDataPressure:[restr1 dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    //网络请求
    
    [network QWSRequest_Otherinterface:data1 RequestURL:[NSString stringWithFormat:@"%@alipay/alipay_ptb.php",HTTPHead] successBlock:^(NSDictionary *success) {
        
        
        successBlock(success);
        
    } failBlock:^(NSError *error, NSString *errorMsg) {
        
        failBlock(error,errorMsg);
    }];
}

- (void)initWithPayToken:(NSString*)paytoken  andmoney:(NSString*)money successBlock:(successBlock)successBlock failBlock:(failBlock)failBlock{
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    TQStaticLoginInfo  *logininfo = [TQStaticLoginInfo singleStaticLoginInfo];
     QWSMD5Encryption *md5Encryption = [QWSMD5Encryption sharedMD5Encryption];
    QWSNetworkRequest *network = [QWSNetworkRequest sharedNetworkRequest];
    TQInitInfo   *initinfo =  [TQInitInfo singleInitInfo];
    //拼接参数
    
    NSString *a =  initinfo.appID;
    NSString *o = money;//金额
    NSString *zj = money;//跟金额一样
    NSString *v = logininfo.mem_id;
    NSString *z = logininfo.user_token;
    NSString *w = @"0";
    NSString *d = @"3";
    NSString *x = initinfo.clientID;
    
    NSDate *currentDate = [NSDate date];
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    
    [dateFormatter setDateFormat:@"Y-MM-dd"];
    
    NSString * dateString = [dateFormatter stringFromDate:currentDate];
    
    NSString * strs = @"alipay_ptb";
    
    NSString * add = [NSString stringWithFormat:@"%@%@%d%@",strs,dateString,0,initinfo.clientKEY];
    
    
    NSString * api_token = [md5Encryption md5:add];//y
    
    NSString *ai = paytoken;
    
    NSDictionary *behaviordic = @{@"a":a,@"o":o,@"zj":zj,@"v":v,@"z":z,@"w":w,@"d":d,@"x":x,@"y":api_token,@"ai":ai};
    
    
    //JSON化
    NSError * parseError_be = nil;
    
    NSData * jsonData_be = [NSJSONSerialization dataWithJSONObject:behaviordic
                                                           options:NSJSONWritingPrettyPrinted error:&parseError_be];
    
    NSString * action = [[NSString alloc]initWithData:jsonData_be encoding:NSUTF8StringEncoding];
    
    QWSEncipher *encipher = [[QWSEncipher alloc] init];
    
    NSString * restr1 =[encipher QWSEncryption:action];
    
    QWSGzip *zip = [QWSGzip sharedGzip];
    
    NSData *data1 = [zip gZipDataPressure:[restr1 dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    //网络请求
    
    [network QWSRequest_Otherinterface:data1 RequestURL:[NSString stringWithFormat:@"%@alipay/alipay_ptb.php",HTTPHead] successBlock:^(NSDictionary *success) {
        
        
        successBlock(success);
        
    } failBlock:^(NSError *error, NSString *errorMsg) {
        
        failBlock(error,errorMsg);
    }];
}


//- (void)initWithPaymoney:(NSString*)money successBlock:(successBlock)successBlock failBlock:(failBlock)failBlock{
//     TQInitInfo   *initinfo =  [TQInitInfo singleInitInfo];
//    TQStaticLoginInfo  *logininfo = [TQStaticLoginInfo singleStaticLoginInfo];
//    QWSMD5Encryption *md5Encryption = [QWSMD5Encryption sharedMD5Encryption];
//    QWSNetworkRequest *network = [QWSNetworkRequest sharedNetworkRequest];
//    //拼接参数
//
//    NSString *a =  initinfo.appID;
//    NSString *o = money;//金额
//    NSString *zj = money;//跟金额一样
//    NSString *v = logininfo.mem_id;
//    NSString *z = logininfo.user_token;
////    NSStringEncoding enc;
////    NSString *path = [[NSBundle mainBundle] pathForResource:@"gameChannel" ofType:nil];
////    NSString *str = [NSString stringWithContentsOfFile:path usedEncoding:&enc error:nil];
////    NSString *estr;
////    if (str == nil) {
////        estr = @"default";
////    }else{
////        estr = str;
////    }
////    NSString *e = str;
//    NSString *e = [KeyChainManager keyChainReadData:SDK_GAME_KEYCHAIN_CHANNEL];
////    NSString *e = @"jailbreak";
//    NSString *d = @"3";
//    NSString *j = @"syfpay";
//    NSString *x = initinfo.clientID;
//    NSString *w = @"0";
//    NSString * user_ip =  initinfo.ipstr;
////     NSString *schemestr = [NSString stringWithFormat:@"%@-tq%@",[self getBundleID],@"123456"];
//     NSString * packagename =  [self getBundleID];
//
//    NSDate *currentDate = [NSDate date];
//
//    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
//
//    [dateFormatter setDateFormat:@"Y-MM-dd"];
//
//    NSString * dateString = [dateFormatter stringFromDate:currentDate];
//
//    NSString * strs = @"syfpay_ptb";
//
//    NSString * add = [NSString stringWithFormat:@"%@%@%d%@",strs,dateString,0,initinfo.clientKEY];
//
//
//    NSString * api_token = [md5Encryption md5:add];//y
//
//
//    NSDictionary *behaviordic = @{@"a":a,@"o":o,@"zj":zj,@"v":v,@"z":z,@"e":e,@"d":d,@"j":j,@"x":x,@"w":w,@"user_ip":user_ip,@"packagename":packagename,@"y":api_token};
//
////    NSLog(@"----数娱付入参------%@",behaviordic);
//    //JSON化
//    NSError * parseError_be = nil;
//
//    NSData * jsonData_be = [NSJSONSerialization dataWithJSONObject:behaviordic
//                                                           options:NSJSONWritingPrettyPrinted error:&parseError_be];
//
//    NSString * action = [[NSString alloc]initWithData:jsonData_be encoding:NSUTF8StringEncoding];
//
//    QWSEncipher *encipher = [[QWSEncipher alloc] init];
//
//    NSString * restr1 =[encipher QWSEncryption:action];
//
//    QWSGzip *zip = [QWSGzip sharedGzip];
//
//    NSData *data1 = [zip gZipDataPressure:[restr1 dataUsingEncoding:NSUTF8StringEncoding]];
//
//
//    //网络请求
//
//    [network QWSRequest_Otherinterface:data1 RequestURL:[NSString stringWithFormat:@"%@syfpay/syfpay_ptb.php",HTTPHead] successBlock:^(NSDictionary *success) {
//
//
//        successBlock(success);
//
//    } failBlock:^(NSError *error, NSString *errorMsg) {
//
//        failBlock(error,errorMsg);
//    }];
//}

- (void)initWithPaymoney:(NSString*)money withPayWay:(NSString*)payWay successBlock:(successBlock)successBlock failBlock:(failBlock)failBlock{
    TQInitInfo   *initinfo =  [TQInitInfo singleInitInfo];
    TQStaticLoginInfo  *logininfo = [TQStaticLoginInfo singleStaticLoginInfo];
    QWSMD5Encryption *md5Encryption = [QWSMD5Encryption sharedMD5Encryption];
    QWSNetworkRequest *network = [QWSNetworkRequest sharedNetworkRequest];
    //拼接参数
//    NSArray *payArr = initinfo.payWayArray;
    NSString *a =  initinfo.appID;
    NSString *o = money;//金额
    NSString *zj = money;//跟金额一样
    NSString *v = logininfo.mem_id;
    NSString *z = logininfo.user_token;
    //    NSStringEncoding enc;
    //    NSString *path = [[NSBundle mainBundle] pathForResource:@"gameChannel" ofType:nil];
    //    NSString *str = [NSString stringWithContentsOfFile:path usedEncoding:&enc error:nil];
    //    NSString *estr;
    //    if (str == nil) {
    //        estr = @"default";
    //    }else{
    //        estr = str;
    //    }
    //    NSString *e = str;
    NSString *e = [KeyChainManager keyChainReadData:SDK_GAME_KEYCHAIN_CHANNEL];
    //    NSString *e = @"jailbreak";
    NSString *d = @"3";
    NSString *j = payWay;
    NSString *x = initinfo.clientID;
    NSString *w = @"0";
    NSString * user_ip =  initinfo.ipstr;
    //     NSString *schemestr = [NSString stringWithFormat:@"%@-tq%@",[self getBundleID],@"123456"];
    NSString * packagename =  [self getBundleID];
    
    NSDate *currentDate = [NSDate date];
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    
    [dateFormatter setDateFormat:@"Y-MM-dd"];
    
    NSString * dateString = [dateFormatter stringFromDate:currentDate];
    
    NSString * strs = @"syfpay_ptb";
    
    NSString * add = [NSString stringWithFormat:@"%@%@%d%@",strs,dateString,0,initinfo.clientKEY];
    NSString *mycardDiscount = @"1";
    
    NSString * api_token = [md5Encryption md5:add];//y
    NSDictionary *behaviordic;
    if ([payWay isEqualToString:@"mycard"]) {
        behaviordic = @{@"a":a,@"o":o,@"zj":zj,@"v":v,@"z":z,@"e":e,@"d":d,@"j":j,@"x":x,@"w":w,@"user_ip":user_ip,@"packagename":packagename,@"y":api_token,@"mycard_discount":mycardDiscount};
    }else{
        behaviordic = @{@"a":a,@"o":o,@"zj":zj,@"v":v,@"z":z,@"e":e,@"d":d,@"j":j,@"x":x,@"w":w,@"user_ip":user_ip,@"packagename":packagename,@"y":api_token};
    }
    
    
    
    //    NSLog(@"----数娱付入参------%@",behaviordic);
    //JSON化
    NSError * parseError_be = nil;
    
    NSData * jsonData_be = [NSJSONSerialization dataWithJSONObject:behaviordic
                                                           options:NSJSONWritingPrettyPrinted error:&parseError_be];
    
    NSString * action = [[NSString alloc]initWithData:jsonData_be encoding:NSUTF8StringEncoding];
    
    QWSEncipher *encipher = [[QWSEncipher alloc] init];
    
    NSString * restr1 =[encipher QWSEncryption:action];
    
    QWSGzip *zip = [QWSGzip sharedGzip];
    
    NSData *data1 = [zip gZipDataPressure:[restr1 dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    //网络请求
    
    [network QWSRequest_Otherinterface:data1 RequestURL:[NSString stringWithFormat:@"%@ysfpay/ysfpay_ptb.php",HTTPHead] successBlock:^(NSDictionary *success) {
        
        
        successBlock(success);
        
    } failBlock:^(NSError *error, NSString *errorMsg) {
        
        failBlock(error,errorMsg);
    }];
}

- (void)initWithPaymoney:(NSString*)money successBlock:(successBlock)successBlock failBlock:(failBlock)failBlock{
    
    TQInitInfo   *initinfo =  [TQInitInfo singleInitInfo];
    TQStaticLoginInfo  *logininfo = [TQStaticLoginInfo singleStaticLoginInfo];
    QWSMD5Encryption *md5Encryption = [QWSMD5Encryption sharedMD5Encryption];
    QWSNetworkRequest *network = [QWSNetworkRequest sharedNetworkRequest];
    //拼接参数
    NSArray *payArr = logininfo.loginPayArr;
    NSString *a =  initinfo.appID;
    NSString *o = money;//金额
    NSString *zj = money;//跟金额一样
    NSString *v = logininfo.mem_id;
    NSString *z = logininfo.user_token;
    //    NSStringEncoding enc;
    //    NSString *path = [[NSBundle mainBundle] pathForResource:@"gameChannel" ofType:nil];
    //    NSString *str = [NSString stringWithContentsOfFile:path usedEncoding:&enc error:nil];
    //    NSString *estr;
    //    if (str == nil) {
    //        estr = @"default";
    //    }else{
    //        estr = str;
    //    }
    //    NSString *e = str;
    NSString *e = [KeyChainManager keyChainReadData:SDK_GAME_KEYCHAIN_CHANNEL];
    //    NSString *e = @"jailbreak";
    NSString *d = @"3";
    NSString *j;
    for (int i = 0; i<payArr.count ; i++) {
        if ([payArr[i][@"b"] rangeOfString:@"微信"].location != NSNotFound) {
             j = payArr[i][@"a"];
        }
    }
    NSString *x = initinfo.clientID;
    NSString *w = @"0";
    NSString * user_ip =  initinfo.ipstr;
    //     NSString *schemestr = [NSString stringWithFormat:@"%@-tq%@",[self getBundleID],@"123456"];
    NSString * packagename =  [self getBundleID];
    
    NSDate *currentDate = [NSDate date];
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    
    [dateFormatter setDateFormat:@"Y-MM-dd"];
    
    NSString * dateString = [dateFormatter stringFromDate:currentDate];
    
    NSString * strs = @"syfpay_ptb";
    
    NSString * add = [NSString stringWithFormat:@"%@%@%d%@",strs,dateString,0,initinfo.clientKEY];
    
    
    NSString * api_token = [md5Encryption md5:add];//y
    
    
    NSDictionary *behaviordic = @{@"a":a,@"o":o,@"zj":zj,@"v":v,@"z":z,@"e":e,@"d":d,@"j":j,@"x":x,@"w":w,@"user_ip":user_ip,@"packagename":packagename,@"y":api_token};
    
    //    NSLog(@"----数娱付入参------%@",behaviordic);
    //JSON化
    NSError * parseError_be = nil;
    
    NSData * jsonData_be = [NSJSONSerialization dataWithJSONObject:behaviordic
                                                           options:NSJSONWritingPrettyPrinted error:&parseError_be];
    
    NSString * action = [[NSString alloc]initWithData:jsonData_be encoding:NSUTF8StringEncoding];
    
    QWSEncipher *encipher = [[QWSEncipher alloc] init];
    
    NSString * restr1 =[encipher QWSEncryption:action];
    
    QWSGzip *zip = [QWSGzip sharedGzip];
    
    NSData *data1 = [zip gZipDataPressure:[restr1 dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    //网络请求
    
    [network QWSRequest_Otherinterface:data1 RequestURL:[NSString stringWithFormat:@"%@ysfpay/ysfpay_ptb.php",HTTPHead] successBlock:^(NSDictionary *success) {
        
        
        successBlock(success);
        
    } failBlock:^(NSError *error, NSString *errorMsg) {
        
        failBlock(error,errorMsg);
    }];
}

//二维码微信支付
- (void)initQRCodeWithPaymoney:(NSString*)money successBlock:(successBlock)successBlock failBlock:(failBlock)failBlock{
    
    TQInitInfo   *initinfo =  [TQInitInfo singleInitInfo];
    TQStaticLoginInfo  *logininfo = [TQStaticLoginInfo singleStaticLoginInfo];
    QWSMD5Encryption *md5Encryption = [QWSMD5Encryption sharedMD5Encryption];
    QWSNetworkRequest *network = [QWSNetworkRequest sharedNetworkRequest];
    //拼接参数
    NSArray *payArr = logininfo.loginPayArr;
    NSString *a =  initinfo.appID;
    NSString *o = money;//金额
    NSString *zj = money;//跟金额一样
    NSString *v = logininfo.mem_id;
    NSString *z = logininfo.user_token;
    //    NSStringEncoding enc;
    //    NSString *path = [[NSBundle mainBundle] pathForResource:@"gameChannel" ofType:nil];
    //    NSString *str = [NSString stringWithContentsOfFile:path usedEncoding:&enc error:nil];
    //    NSString *estr;
    //    if (str == nil) {
    //        estr = @"default";
    //    }else{
    //        estr = str;
    //    }
    //    NSString *e = str;
    NSString *e = [KeyChainManager keyChainReadData:SDK_GAME_KEYCHAIN_CHANNEL];
    //    NSString *e = @"jailbreak";
    NSString *d = @"3";
    NSString *j;
    NSString * is_qcode = @"1";
    for (int i = 0; i<payArr.count ; i++) {
        if ([payArr[i][@"b"] rangeOfString:@"微信"].location != NSNotFound) {
            j = payArr[i][@"a"];
        }
    }
    NSString *x = initinfo.clientID;
    NSString *w = @"0";
    NSString * user_ip =  initinfo.ipstr;
    //     NSString *schemestr = [NSString stringWithFormat:@"%@-tq%@",[self getBundleID],@"123456"];
    NSString * packagename =  [self getBundleID];
    
    NSDate *currentDate = [NSDate date];
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    
    [dateFormatter setDateFormat:@"Y-MM-dd"];
    
    NSString * dateString = [dateFormatter stringFromDate:currentDate];
    
    NSString * strs = @"syfpay_ptb";
    
    NSString * add = [NSString stringWithFormat:@"%@%@%d%@",strs,dateString,0,initinfo.clientKEY];
    
    
    NSString * api_token = [md5Encryption md5:add];//y
    
    
    NSDictionary *behaviordic = @{@"a":a,@"o":o,@"zj":zj,@"v":v,@"z":z,@"e":e,@"d":d,@"j":j,@"x":x,@"w":w,@"user_ip":user_ip,@"packagename":packagename,@"y":api_token,@"is_qcode":is_qcode};
    
    //    NSLog(@"----数娱付入参------%@",behaviordic);
    //JSON化
    NSError * parseError_be = nil;
    
    NSData * jsonData_be = [NSJSONSerialization dataWithJSONObject:behaviordic
                                                           options:NSJSONWritingPrettyPrinted error:&parseError_be];
    
    NSString * action = [[NSString alloc]initWithData:jsonData_be encoding:NSUTF8StringEncoding];
    
    QWSEncipher *encipher = [[QWSEncipher alloc] init];
    
    NSString * restr1 =[encipher QWSEncryption:action];
    
    QWSGzip *zip = [QWSGzip sharedGzip];
    
    NSData *data1 = [zip gZipDataPressure:[restr1 dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    //网络请求
    
    [network QWSRequest_Otherinterface:data1 RequestURL:[NSString stringWithFormat:@"%@ysfpay/ysfpay_ptb.php",HTTPHead] successBlock:^(NSDictionary *success) {
        
        
        successBlock(success);
        
    } failBlock:^(NSError *error, NSString *errorMsg) {
        
        failBlock(error,errorMsg);
    }];
}


- (void)initQRCodeWithAlipayPaymoney:(NSString*)money successBlock:(successBlock)successBlock failBlock:(failBlock)failBlock{
    
    TQInitInfo   *initinfo =  [TQInitInfo singleInitInfo];
    TQStaticLoginInfo  *logininfo = [TQStaticLoginInfo singleStaticLoginInfo];
    QWSMD5Encryption *md5Encryption = [QWSMD5Encryption sharedMD5Encryption];
    QWSNetworkRequest *network = [QWSNetworkRequest sharedNetworkRequest];
    //拼接参数
    NSArray *payArr = logininfo.loginPayArr;
    NSString *a =  initinfo.appID;
    NSString *o = money;//金额
    NSString *zj = money;//跟金额一样
    NSString *v = logininfo.mem_id;
    NSString *z = logininfo.user_token;
    //    NSStringEncoding enc;
    //    NSString *path = [[NSBundle mainBundle] pathForResource:@"gameChannel" ofType:nil];
    //    NSString *str = [NSString stringWithContentsOfFile:path usedEncoding:&enc error:nil];
    //    NSString *estr;
    //    if (str == nil) {
    //        estr = @"default";
    //    }else{
    //        estr = str;
    //    }
    //    NSString *e = str;
    NSString *e = [KeyChainManager keyChainReadData:SDK_GAME_KEYCHAIN_CHANNEL];
    //    NSString *e = @"jailbreak";
    NSString *d = @"3";
    NSString *j;
    NSString * is_qcode = @"2";
    for (int i = 0; i<payArr.count ; i++) {
        if ([payArr[i][@"b"] rangeOfString:@"支付宝"].location != NSNotFound) {
            j = payArr[i][@"a"];
        }
    }
    NSString *x = initinfo.clientID;
    NSString *w = @"0";
    NSString * user_ip =  initinfo.ipstr;
    //     NSString *schemestr = [NSString stringWithFormat:@"%@-tq%@",[self getBundleID],@"123456"];
    NSString * packagename =  [self getBundleID];
    
    NSDate *currentDate = [NSDate date];
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    
    [dateFormatter setDateFormat:@"Y-MM-dd"];
    
    NSString * dateString = [dateFormatter stringFromDate:currentDate];
    
    NSString * strs = @"syfpay_ptb";
    
    NSString * add = [NSString stringWithFormat:@"%@%@%d%@",strs,dateString,0,initinfo.clientKEY];
    
    
    NSString * api_token = [md5Encryption md5:add];//y
    
    
    NSDictionary *behaviordic = @{@"a":a,@"o":o,@"zj":zj,@"v":v,@"z":z,@"e":e,@"d":d,@"j":j,@"x":x,@"w":w,@"user_ip":user_ip,@"packagename":packagename,@"y":api_token,@"is_qcode":is_qcode};
    
    //    NSLog(@"----数娱付入参------%@",behaviordic);
    //JSON化
    NSError * parseError_be = nil;
    
    NSData * jsonData_be = [NSJSONSerialization dataWithJSONObject:behaviordic
                                                           options:NSJSONWritingPrettyPrinted error:&parseError_be];
    
    NSString * action = [[NSString alloc]initWithData:jsonData_be encoding:NSUTF8StringEncoding];
    
    QWSEncipher *encipher = [[QWSEncipher alloc] init];
    
    NSString * restr1 =[encipher QWSEncryption:action];
    
    QWSGzip *zip = [QWSGzip sharedGzip];
    
    NSData *data1 = [zip gZipDataPressure:[restr1 dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    //网络请求
    
    [network QWSRequest_Otherinterface:data1 RequestURL:[NSString stringWithFormat:@"%@ysfpay/ysfpay_ptb.php",HTTPHead] successBlock:^(NSDictionary *success) {
        
        
        successBlock(success);
        
    } failBlock:^(NSError *error, NSString *errorMsg) {
        
        failBlock(error,errorMsg);
    }];
}

- (void)initAlipaySXYWithPaymoney:(NSString*)money successBlock:(successBlock)successBlock failBlock:(failBlock)failBlock{
    
    TQInitInfo   *initinfo =  [TQInitInfo singleInitInfo];
    TQStaticLoginInfo  *logininfo = [TQStaticLoginInfo singleStaticLoginInfo];
    QWSMD5Encryption *md5Encryption = [QWSMD5Encryption sharedMD5Encryption];
    QWSNetworkRequest *network = [QWSNetworkRequest sharedNetworkRequest];
    //拼接参数
    NSArray *payArr = logininfo.loginPayArr;
    NSString *a =  initinfo.appID;
    NSString *o = money;//金额
    NSString *zj = money;//跟金额一样
    NSString *v = logininfo.mem_id;
    NSString *z = logininfo.user_token;
    //    NSStringEncoding enc;
    //    NSString *path = [[NSBundle mainBundle] pathForResource:@"gameChannel" ofType:nil];
    //    NSString *str = [NSString stringWithContentsOfFile:path usedEncoding:&enc error:nil];
    //    NSString *estr;
    //    if (str == nil) {
    //        estr = @"default";
    //    }else{
    //        estr = str;
    //    }
    //    NSString *e = str;
    NSString *e = [KeyChainManager keyChainReadData:SDK_GAME_KEYCHAIN_CHANNEL];
    //    NSString *e = @"jailbreak";
    NSString *d = @"3";
    NSString *j;
//    NSString * is_qcode = @"1";
    
    
    
    for (int i = 0; i<payArr.count ; i++) {
        if ([payArr[i][@"b"] rangeOfString:@"支付宝"].location != NSNotFound) {
            j = payArr[i][@"a"];
        }
    }
    NSString *x = initinfo.clientID;
    NSString *w = @"0";
    NSString * user_ip =  initinfo.ipstr;
    //     NSString *schemestr = [NSString stringWithFormat:@"%@-tq%@",[self getBundleID],@"123456"];
    NSString * packagename =  [self getBundleID];
    
    NSDate *currentDate = [NSDate date];
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    
    [dateFormatter setDateFormat:@"Y-MM-dd"];
    
    NSString * dateString = [dateFormatter stringFromDate:currentDate];
    
    NSString * strs = @"syfpay_ptb";
    
    NSString * add = [NSString stringWithFormat:@"%@%@%d%@",strs,dateString,0,initinfo.clientKEY];
    
    
    NSString * api_token = [md5Encryption md5:add];//y
    
    
    NSDictionary *behaviordic = @{@"a":a,@"o":o,@"zj":zj,@"v":v,@"z":z,@"e":e,@"d":d,@"j":j,@"x":x,@"w":w,@"user_ip":user_ip,@"packagename":packagename,@"y":api_token};
    
    //    NSLog(@"----数娱付入参------%@",behaviordic);
    //JSON化
    NSError * parseError_be = nil;
    
    NSData * jsonData_be = [NSJSONSerialization dataWithJSONObject:behaviordic
                                                           options:NSJSONWritingPrettyPrinted error:&parseError_be];
    
    NSString * action = [[NSString alloc]initWithData:jsonData_be encoding:NSUTF8StringEncoding];
    
    QWSEncipher *encipher = [[QWSEncipher alloc] init];
    
    NSString * restr1 =[encipher QWSEncryption:action];
    
    QWSGzip *zip = [QWSGzip sharedGzip];
    
    NSData *data1 = [zip gZipDataPressure:[restr1 dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    //网络请求
    
    [network QWSRequest_Otherinterface:data1 RequestURL:[NSString stringWithFormat:@"%@ysfpay/ysfpay_ptb.php",HTTPHead] successBlock:^(NSDictionary *success) {
        
        
        successBlock(success);
        
    } failBlock:^(NSError *error, NSString *errorMsg) {
        
        failBlock(error,errorMsg);
    }];
}




- (void)initWithPayMerchatAccountId:(NSString*)Merchat  andMoney:(NSString*)money successBlock:(successBlock)successBlock failBlock:(failBlock)failBlock{
     TQInitInfo   *initinfo =  [TQInitInfo singleInitInfo];
    TQStaticLoginInfo  *logininfo = [TQStaticLoginInfo singleStaticLoginInfo];
    QWSMD5Encryption *md5Encryption = [QWSMD5Encryption sharedMD5Encryption];
    QWSNetworkRequest *network = [QWSNetworkRequest sharedNetworkRequest];
    //拼接参数
     NSString *a =  initinfo.appID;
    NSString *c = [KeyChainManager keyChainReadData:@"4CSDKUUID"];
    NSString *d = @"3";
//    NSStringEncoding enc;
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"gameChannel" ofType:nil];
//    NSString *str = [NSString stringWithContentsOfFile:path usedEncoding:&enc error:nil];
//    NSString *estr;
//    if (str == nil) {
//        estr = @"default";
//    }else{
//        estr = str;
//    }
//    NSString *e = str;
    NSString *e = [KeyChainManager keyChainReadData:SDK_GAME_KEYCHAIN_CHANNEL];
//    NSString *e = @"jailbreak";
//    NSLog(@"渠道号---：%@",estr);
    NSString *f = [NSString stringWithFormat:@"%@||%@||%@||%@",[[UIDevice currentDevice] name],[[UIDevice currentDevice] model],[[UIDevice currentDevice] systemName],[[UIDevice currentDevice] systemVersion]];  //设备信息;
    QWSGainUA *gainUA = [QWSGainUA sharedGainUA];
    NSString *g = [gainUA createHttpRequest];
    NSString *merchatAccountId = Merchat;//货币种类
    NSString *z = logininfo.user_token;
    NSString *o = money;//金额
     NSString *x = initinfo.clientID;
    NSString *j = @"paypal";
    NSString *v = logininfo.mem_id;
    NSString *w = @"0";
    NSString * user_ip =  initinfo.ipstr;
    NSString * packagename =  [self getBundleID];
    
    NSDate *currentDate = [NSDate date];
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    
    [dateFormatter setDateFormat:@"Y-MM-dd"];
    
    NSString * dateString = [dateFormatter stringFromDate:currentDate];
    
    NSString * strs = @"paypal";
    
    NSString * add = [NSString stringWithFormat:@"%@%@%d%@",strs,dateString,0,initinfo.clientKEY];
    
    
    NSString * api_token = [md5Encryption md5:add];//y
    
    NSDictionary *behaviordic = @{@"a":a,@"c":c,@"d":d,@"e":e,@"f":f,@"g":g,@"merchatAccountId":merchatAccountId,@"z":z,@"o":o,@"x":x,@"j":j,@"v":v,@"w":w,@"user_ip":user_ip,@"packagename":packagename,@"y":api_token};
//    NSLog(@"----PayPal=----入参---%@",behaviordic);
    
    
    //JSON化
    NSError * parseError_be = nil;
    
    NSData * jsonData_be = [NSJSONSerialization dataWithJSONObject:behaviordic
                                                           options:NSJSONWritingPrettyPrinted error:&parseError_be];
    
    NSString * action = [[NSString alloc]initWithData:jsonData_be encoding:NSUTF8StringEncoding];
    
    QWSEncipher *encipher = [[QWSEncipher alloc] init];
    
    NSString * restr1 =[encipher QWSEncryption:action];
    
    QWSGzip *zip = [QWSGzip sharedGzip];
    
    NSData *data1 = [zip gZipDataPressure:[restr1 dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    //网络请求
    
    [network QWSRequest_Otherinterface:data1 RequestURL:[NSString stringWithFormat:@"%@paypal/paypal.php",HTTPHead] successBlock:^(NSDictionary *success) {
        
        
        successBlock(success);
        
    } failBlock:^(NSError *error, NSString *errorMsg) {
        
        failBlock(error,errorMsg);
    }];
}

- (void)initWithPayGameCurrencyServerId:(NSString*)serverId andProductname:(NSString*)productname andProductdesc:(NSString*)productdesc andAttach:(NSString*)attach andAmount:(NSString*)amount andRoleId:(NSString*)roleId andServerName:(NSString*)serverName andRoleName:(NSString*)roleName andStyle:(NSString*)style successBlock:(successBlock)successBlock failBlock:(failBlock)failBlock{
     TQInitInfo   *initinfo =  [TQInitInfo singleInitInfo];
     QWSNetworkRequest *network = [QWSNetworkRequest sharedNetworkRequest];
     TQStaticLoginInfo  *logininfo = [TQStaticLoginInfo singleStaticLoginInfo];
    QWSMD5Encryption *md5Encryption = [QWSMD5Encryption sharedMD5Encryption];
    //入参
    NSString *a =  initinfo.appID;
    NSString *c = [KeyChainManager keyChainReadData:@"4CSDKUUID"];
    NSString *d = @"3";
//    NSStringEncoding enc;
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"gameChannel" ofType:nil];
//    NSString *str = [NSString stringWithContentsOfFile:path usedEncoding:&enc error:nil];
//    NSString *estr;
//    if (str == nil) {
//        estr = @"default";
//    }else{
//        estr = str;
//    }
//    NSString *e = str;
    NSString *e = [KeyChainManager keyChainReadData:SDK_GAME_KEYCHAIN_CHANNEL];
//    NSString *e = @"jailbreak";
    NSString *f = [NSString stringWithFormat:@"%@||%@||%@||%@",[[UIDevice currentDevice] name],[[UIDevice currentDevice] model],[[UIDevice currentDevice] systemName],[[UIDevice currentDevice] systemVersion]];  //设备信息;
    QWSGainUA *gainUA = [QWSGainUA sharedGainUA];
    NSString *g = [gainUA createHttpRequest];
    NSString *i = serverName;
    NSString *j = style;
    NSString *l = productdesc;
    NSString *m = attach;
    NSString *o = amount;
    NSString *p = roleName;
    NSString *v = logininfo.mem_id;
    NSString *z = logininfo.user_token;
    NSString *w = @"0";
    NSString * user_ip =  initinfo.ipstr;
    NSString *x = initinfo.clientID;
    NSString * packagename =  [self getBundleID];
    
    NSDate *currentDate = [NSDate date];
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    
    [dateFormatter setDateFormat:@"Y-MM-dd"];
    
    NSString * dateString = [dateFormatter stringFromDate:currentDate];
    
    NSString * strs = @"pay";
    
    NSString * add = [NSString stringWithFormat:@"%@%@%d%@",strs,dateString,0,initinfo.clientKEY];
    
    
    NSString * api_token = [md5Encryption md5:add];//y
    
    NSString *ac = initinfo.cityID;
    NSLog(@"ac%@",ac);
    NSString *param_token_az = [NSString stringWithFormat:@"a=%@&c=%@&d=%@&e=%@&f=%@&g=%@&i=%@&j=%@&l=%@&m=%@&o=%@&p=%@&v=%@&z=%@&w=%@&user_ip=%@&x=%@&packagename=%@&y=%@&ac=%@",a,c,d,e,f,g,i,j,l,m,o,p,v,z,w,user_ip,x,packagename,api_token,ac];
    
    NSString * param_token_az_Str = [md5Encryption md5:[NSString stringWithFormat:@"%@%@",[md5Encryption md5:param_token_az],initinfo.clientKEY]];//az
    
    NSString *ao = serverId;
    NSString *ap = roleId;
    
    NSString *tmpac;//淘宝API有时候会崩，崩了直接判断一下，传空就行
    if (ac == nil) {
        tmpac = @"";
    }else{
        tmpac =ac;
    }
    NSDictionary *behaviordic = @{@"a":a,@"c":c,@"d":d,@"e":e,@"f":f,@"g":g,@"i":i,@"j":j,@"l":l,@"m":m,@"o":o,@"p":p,@"v":v,@"z":z,@"w":w,@"user_ip":user_ip,@"x":x,@"packagename":packagename,@"y":api_token,@"ac":tmpac,@"az":param_token_az_Str,@"ao":ao,@"ap":ap};
//    NSLog(@"----初始化-购买道具=----入参---%@",behaviordic);
    
    
    //JSON化
    NSError * parseError_be = nil;
    
    NSData * jsonData_be = [NSJSONSerialization dataWithJSONObject:behaviordic
                                                           options:NSJSONWritingPrettyPrinted error:&parseError_be];
    
    NSString * action = [[NSString alloc]initWithData:jsonData_be encoding:NSUTF8StringEncoding];
    
    QWSEncipher *encipher = [[QWSEncipher alloc] init];
    
    NSString * restr1 =[encipher QWSEncryption:action];
    
    QWSGzip *zip = [QWSGzip sharedGzip];
    
    NSData *data1 = [zip gZipDataPressure:[restr1 dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    //网络请求
    
    [network QWSRequest_Otherinterface:data1 RequestURL:[NSString stringWithFormat:@"%@pay.php",HTTPHead] successBlock:^(NSDictionary *success) {
        
        
        successBlock(success);
        
    } failBlock:^(NSError *error, NSString *errorMsg) {
        
        failBlock(error,errorMsg);
    }];
}


- (void)initWithPaymoney:(NSString*)money andyxbnum:(NSString*)yxbnum andPayToken:(NSString*)payToken choosePay:(NSString *)ptbID successBlock:(successBlock)successBlock failBlock:(failBlock)failBlock{
    TQInitInfo   *initinfo =  [TQInitInfo singleInitInfo];
    QWSNetworkRequest *network = [QWSNetworkRequest sharedNetworkRequest];
    TQStaticLoginInfo  *logininfo = [TQStaticLoginInfo singleStaticLoginInfo];
    QWSMD5Encryption *md5Encryption = [QWSMD5Encryption sharedMD5Encryption];
    //入参
    NSString *a =  initinfo.appID;
    NSString *o = money;
    NSString *n = yxbnum;
    NSString *v = logininfo.mem_id;
    NSString *z = logininfo.user_token;
    NSString *d = @"3";
    NSString *w = @"0";
    NSString *x = initinfo.clientID;
    
    NSDate *currentDate = [NSDate date];
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    
    [dateFormatter setDateFormat:@"Y-MM-dd"];
    
    NSString * dateString = [dateFormatter stringFromDate:currentDate];
    
    NSString * strs = @"ptbpay";
    
    NSString * add = [NSString stringWithFormat:@"%@%@%d%@",strs,dateString,0,initinfo.clientKEY];
    NSString * ptb = ptbID;
    
    NSString * api_token = [md5Encryption md5:add];//y
    NSString *ai = payToken;
    
    NSString *param_token_az = [NSString stringWithFormat:@"a=%@&o=%@&n=%@&v=%@&z=%@&d=%@&w=%@&x=%@&y=%@&ai=%@",a,o,n,v,z,d,w,x,api_token,ai];
    
    NSString * param_token_az_Str = [md5Encryption md5:[NSString stringWithFormat:@"%@%@",[md5Encryption md5:param_token_az],initinfo.clientKEY]];//az
    
    
    NSDictionary *behaviordic = @{@"a":a,@"o":o,@"n":n,@"v":v,@"z":z,@"d":d,@"w":w,@"x":x,@"y":api_token,@"ai":ai,@"az":param_token_az_Str,@"ptb":ptb};
//    NSLog(@"----平台币-购买道具=----入参---%@",behaviordic);
    
    
    //JSON化
    NSError * parseError_be = nil;
    
    NSData * jsonData_be = [NSJSONSerialization dataWithJSONObject:behaviordic
                                                           options:NSJSONWritingPrettyPrinted error:&parseError_be];
    
    NSString * action = [[NSString alloc]initWithData:jsonData_be encoding:NSUTF8StringEncoding];
    
    QWSEncipher *encipher = [[QWSEncipher alloc] init];
    
    NSString * restr1 =[encipher QWSEncryption:action];
    
    QWSGzip *zip = [QWSGzip sharedGzip];
    
    NSData *data1 = [zip gZipDataPressure:[restr1 dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    //网络请求
    
    [network QWSRequest_Otherinterface:data1 RequestURL:[NSString stringWithFormat:@"%@ptbpay/ptballpay.php",HTTPHead] successBlock:^(NSDictionary *success) {
         successBlock(success);

    } failBlock:^(NSError *error, NSString *errorMsg) {
        
        failBlock(error,errorMsg);
    }];
}

- (void)initWithPayPropsToken:(NSString*)paytoken  andmoney:(NSString*)money successBlock:(successBlock)successBlock failBlock:(failBlock)failBlock{
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    TQStaticLoginInfo  *logininfo = [TQStaticLoginInfo singleStaticLoginInfo];
    QWSMD5Encryption *md5Encryption = [QWSMD5Encryption sharedMD5Encryption];
    QWSNetworkRequest *network = [QWSNetworkRequest sharedNetworkRequest];
    TQInitInfo   *initinfo =  [TQInitInfo singleInitInfo];
    //拼接参数
    
    NSString *a =  initinfo.appID;
    NSString *o = money;//金额
    NSString *zj = money;//跟金额一样
    NSString *v = logininfo.mem_id;
    NSString *z = logininfo.user_token;
    NSString *w = @"0";
    NSString *d = @"3";
    NSString *x = initinfo.clientID;
    
    NSDate *currentDate = [NSDate date];
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    
    [dateFormatter setDateFormat:@"Y-MM-dd"];
    
    NSString * dateString = [dateFormatter stringFromDate:currentDate];
    
    NSString * strs = @"alipay";
    
    NSString * add = [NSString stringWithFormat:@"%@%@%d%@",strs,dateString,0,initinfo.clientKEY];
    
    
    NSString * api_token = [md5Encryption md5:add];//y
    
    NSString *ai = paytoken;
    
    NSDictionary *behaviordic = @{@"a":a,@"o":o,@"zj":zj,@"v":v,@"z":z,@"w":w,@"d":d,@"x":x,@"y":api_token,@"ai":ai};
    
    
    //JSON化
    NSError * parseError_be = nil;
    
    NSData * jsonData_be = [NSJSONSerialization dataWithJSONObject:behaviordic
                                                           options:NSJSONWritingPrettyPrinted error:&parseError_be];
    
    NSString * action = [[NSString alloc]initWithData:jsonData_be encoding:NSUTF8StringEncoding];
    
    QWSEncipher *encipher = [[QWSEncipher alloc] init];
    
    NSString * restr1 =[encipher QWSEncryption:action];
    
    QWSGzip *zip = [QWSGzip sharedGzip];
    
    NSData *data1 = [zip gZipDataPressure:[restr1 dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    //网络请求
    
    [network QWSRequest_Otherinterface:data1 RequestURL:[NSString stringWithFormat:@"%@alipay/alipay.php",HTTPHead] successBlock:^(NSDictionary *success) {
        
        
        successBlock(success);
        
    } failBlock:^(NSError *error, NSString *errorMsg) {
        
        failBlock(error,errorMsg);
    }];
    
}

- (void)initWithSYFPayServerName:(NSString*)serverName andServerId:(NSString*)serverId andProductname:(NSString*)productname andProductdesc:(NSString*)productdesc andAttach:(NSString*)attach  andRoleName:(NSString*)roleName andRoleId:(NSString*)roleId andAmount:(NSString*)amount successBlock:(successBlock)successBlock failBlock:(failBlock)failBlock{
    QWSNetworkRequest *network = [QWSNetworkRequest sharedNetworkRequest];
    TQStaticLoginInfo  *logininfo = [TQStaticLoginInfo singleStaticLoginInfo];
    QWSMD5Encryption *md5Encryption = [QWSMD5Encryption sharedMD5Encryption];
    TQInitInfo   *initinfo =  [TQInitInfo singleInitInfo];
    
    //拼接参数
    NSString *a =  initinfo.appID;
    NSString *c = [KeyChainManager keyChainReadData:@"4CSDKUUID"];
    NSString *d = @"3";
//    NSStringEncoding enc;
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"gameChannel" ofType:nil];
//    NSString *str = [NSString stringWithContentsOfFile:path usedEncoding:&enc error:nil];
//    NSString *estr;
//    if (str == nil) {
//        estr = @"default";
//    }else{
//        estr = str;
//    }
//    NSString *e = str;
    NSString *e = [KeyChainManager keyChainReadData:SDK_GAME_KEYCHAIN_CHANNEL];
//    NSString *e = @"jailbreak";
    NSString *f = [NSString stringWithFormat:@"%@||%@||%@||%@",[[UIDevice currentDevice] name],[[UIDevice currentDevice] model],[[UIDevice currentDevice] systemName],[[UIDevice currentDevice] systemVersion]];  //设备信息;
    QWSGainUA *gainUA = [QWSGainUA sharedGainUA];
    NSString *g = [gainUA createHttpRequest];
    NSString *i = serverName;
    NSString *ao = serverId;
    NSString *k = productname;
    NSString *l = productdesc;
    NSString *m = attach;
    NSString *p = roleName;
    NSString *ap = roleId;
    NSString *z = logininfo.user_token;
    NSString *o = amount;
    NSString *x = initinfo.clientID;
     NSString *ac = initinfo.cityID;
     NSString *j = @"syfpay";
    NSString *v = logininfo.mem_id;
     NSString *w = @"0";
    NSString * user_ip =  initinfo.ipstr;
     NSString * packagename =  [self getBundleID];
    
    NSDate *currentDate = [NSDate date];
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    
    [dateFormatter setDateFormat:@"Y-MM-dd"];
    
    NSString * dateString = [dateFormatter stringFromDate:currentDate];
    
    NSString * strs = @"syfpay";
    
    NSString * add = [NSString stringWithFormat:@"%@%@%d%@",strs,dateString,0,initinfo.clientKEY];
    
    
    NSString * api_token = [md5Encryption md5:add];//y
    
    NSString *param_token_az = [NSString stringWithFormat:@"a=%@&c=%@&d=%@&e=%@&f=%@&g=%@&i=%@&ao=%@&k=%@&l=%@&m=%@&p=%@&ap=%@&z=%@&o=%@&x=%@&ac=%@&j=%@&v=%@&w=%@&user_ip=%@&packagename=%@&y=%@",a,c,d,e,f,g,i,ao,k,l,m,p,ap,z,o,x,ac,j,v,w,user_ip,packagename,api_token];
    
    NSString * param_token_az_Str = [md5Encryption md5:[NSString stringWithFormat:@"%@%@",[md5Encryption md5:param_token_az],initinfo.clientKEY]];//az
    
    
    NSString *tmpac;//淘宝API有时候会崩，崩了直接判断一下，传空就行
    if (ac == nil) {
        tmpac = @"";
    }else{
        tmpac =ac;
    }
    
    NSDictionary *behaviordic = @{@"a":a,@"c":c,@"d":d,@"e":e,@"f":f,@"g":g,@"i":i,@"ao":ao,@"k":k,@"l":l,@"m":m,@"p":p,@"ap":ap,@"z":z,@"o":o,@"x":x,@"ac":tmpac,@"j":j,@"v":v,@"w":w,@"user_ip":user_ip,@"packagename":packagename,@"y":api_token,@"az":param_token_az_Str};
    
    //JSON化
    NSError * parseError_be = nil;
    
    NSData * jsonData_be = [NSJSONSerialization dataWithJSONObject:behaviordic
                                                           options:NSJSONWritingPrettyPrinted error:&parseError_be];
    
    NSString * action = [[NSString alloc]initWithData:jsonData_be encoding:NSUTF8StringEncoding];
    
    QWSEncipher *encipher = [[QWSEncipher alloc] init];
    
    NSString * restr1 =[encipher QWSEncryption:action];
    
    QWSGzip *zip = [QWSGzip sharedGzip];
    
    NSData *data1 = [zip gZipDataPressure:[restr1 dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    //网络请求
    
    [network QWSRequest_Otherinterface:data1 RequestURL:[NSString stringWithFormat:@"%@syfpay/syfpay.php",HTTPHead] successBlock:^(NSDictionary *success) {
        
        
        successBlock(success);
        
    } failBlock:^(NSError *error, NSString *errorMsg) {
        
        failBlock(error,errorMsg);
    }];
    
}


- (void)initWithSYFPayServerNameWechat:(NSString*)serverName andServerId:(NSString*)serverId andProductname:(NSString*)productname andProductdesc:(NSString*)productdesc andAttach:(NSString*)attach  andRoleName:(NSString*)roleName andRoleId:(NSString*)roleId andAmount:(NSString*)amount andPayWay:(NSString*)payWay successBlock:(successBlock)successBlock failBlock:(failBlock)failBlock{
    QWSNetworkRequest *network = [QWSNetworkRequest sharedNetworkRequest];
    TQStaticLoginInfo  *logininfo = [TQStaticLoginInfo singleStaticLoginInfo];
    QWSMD5Encryption *md5Encryption = [QWSMD5Encryption sharedMD5Encryption];
    TQInitInfo   *initinfo =  [TQInitInfo singleInitInfo];
    
    //拼接参数
    NSString *a =  initinfo.appID;
    NSString *c = [KeyChainManager keyChainReadData:@"4CSDKUUID"];
    NSString *d = @"3";
    //    NSStringEncoding enc;
    //    NSString *path = [[NSBundle mainBundle] pathForResource:@"gameChannel" ofType:nil];
    //    NSString *str = [NSString stringWithContentsOfFile:path usedEncoding:&enc error:nil];
    //    NSString *estr;
    //    if (str == nil) {
    //        estr = @"default";
    //    }else{
    //        estr = str;
    //    }
    //    NSString *e = str;
    NSString *e = [KeyChainManager keyChainReadData:SDK_GAME_KEYCHAIN_CHANNEL];
    //    NSString *e = @"jailbreak";
    NSString *f = [NSString stringWithFormat:@"%@||%@||%@||%@",[[UIDevice currentDevice] name],[[UIDevice currentDevice] model],[[UIDevice currentDevice] systemName],[[UIDevice currentDevice] systemVersion]];  //设备信息;
    QWSGainUA *gainUA = [QWSGainUA sharedGainUA];
    NSString *g = [gainUA createHttpRequest];
    NSString *i = serverName;
    NSString *ao = serverId;
    NSString *k = productname;
    NSString *l = productdesc;
    NSString *m = attach;
    NSString *p = roleName;
    NSString *ap = roleId;
    NSString *z = logininfo.user_token;
    NSString *o = amount;
    NSString *x = initinfo.clientID;
    NSString *ac = initinfo.cityID;
    NSString *v = logininfo.mem_id;
    NSString *w = @"0";
    NSString * user_ip =  initinfo.ipstr;
    NSString * packagename =  [self getBundleID];
    NSArray *payList = initinfo.payarr;
    NSDate *currentDate = [NSDate date];
    
    NSString *j = payWay;
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    
    [dateFormatter setDateFormat:@"Y-MM-dd"];
    
    NSString * dateString = [dateFormatter stringFromDate:currentDate];
    
    NSString * strs = payList[0][@"a"];
    
    NSString * add = [NSString stringWithFormat:@"%@%@%d%@",strs,dateString,0,initinfo.clientKEY];
    
    
    NSString * api_token = [md5Encryption md5:add];//y
    
    NSString *param_token_az = [NSString stringWithFormat:@"a=%@&c=%@&d=%@&e=%@&f=%@&g=%@&i=%@&ao=%@&k=%@&l=%@&m=%@&p=%@&ap=%@&z=%@&o=%@&x=%@&ac=%@&j=%@&v=%@&w=%@&user_ip=%@&packagename=%@&y=%@",a,c,d,e,f,g,i,ao,k,l,m,p,ap,z,o,x,ac,j,v,w,user_ip,packagename,api_token];
    
    NSString * param_token_az_Str = [md5Encryption md5:[NSString stringWithFormat:@"%@%@",[md5Encryption md5:param_token_az],initinfo.clientKEY]];//az
    
    
    NSString *tmpac;//淘宝API有时候会崩，崩了直接判断一下，传空就行
    if (ac == nil) {
        tmpac = @"";
    }else{
        tmpac =ac;
    }
    
    NSDictionary *behaviordic = @{@"a":a,@"c":c,@"d":d,@"e":e,@"f":f,@"g":g,@"i":i,@"ao":ao,@"k":k,@"l":l,@"m":m,@"p":p,@"ap":ap,@"z":z,@"o":o,@"x":x,@"ac":tmpac,@"j":j,@"v":v,@"w":w,@"user_ip":user_ip,@"packagename":packagename,@"y":api_token,@"az":param_token_az_Str};
    
    //JSON化
    NSError * parseError_be = nil;
    
    NSData * jsonData_be = [NSJSONSerialization dataWithJSONObject:behaviordic
                                                           options:NSJSONWritingPrettyPrinted error:&parseError_be];
    
    NSString * action = [[NSString alloc]initWithData:jsonData_be encoding:NSUTF8StringEncoding];
    
    QWSEncipher *encipher = [[QWSEncipher alloc] init];
    
    NSString * restr1 =[encipher QWSEncryption:action];
    
    QWSGzip *zip = [QWSGzip sharedGzip];
    
    NSData *data1 = [zip gZipDataPressure:[restr1 dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    //网络请求
    
    [network QWSRequest_Otherinterface:data1 RequestURL:[NSString stringWithFormat:@"%@ysfpay/ysfpay.php",HTTPHead] successBlock:^(NSDictionary *success) {
        
        
        successBlock(success);
        
    } failBlock:^(NSError *error, NSString *errorMsg) {
        
        failBlock(error,errorMsg);
    }];
    
}

//请求二维码
- (void)initWithQcodePayServerNameWechat:(NSString*)serverName andServerId:(NSString*)serverId andProductname:(NSString*)productname andProductdesc:(NSString*)productdesc andAttach:(NSString*)attach  andRoleName:(NSString*)roleName andRoleId:(NSString*)roleId andAmount:(NSString*)amount andPayWay:(NSString*)payWay successBlock:(successBlock)successBlock failBlock:(failBlock)failBlock{
    QWSNetworkRequest *network = [QWSNetworkRequest sharedNetworkRequest];
    TQStaticLoginInfo  *logininfo = [TQStaticLoginInfo singleStaticLoginInfo];
    QWSMD5Encryption *md5Encryption = [QWSMD5Encryption sharedMD5Encryption];
    TQInitInfo   *initinfo =  [TQInitInfo singleInitInfo];
    
    //拼接参数
    NSString *a =  initinfo.appID;
    NSString *c = [KeyChainManager keyChainReadData:@"4CSDKUUID"];
    NSString *d = @"3";
    //    NSStringEncoding enc;
    //    NSString *path = [[NSBundle mainBundle] pathForResource:@"gameChannel" ofType:nil];
    //    NSString *str = [NSString stringWithContentsOfFile:path usedEncoding:&enc error:nil];
    //    NSString *estr;
    //    if (str == nil) {
    //        estr = @"default";
    //    }else{
    //        estr = str;
    //    }
    //    NSString *e = str;
    NSString *e = [KeyChainManager keyChainReadData:SDK_GAME_KEYCHAIN_CHANNEL];
    //    NSString *e = @"jailbreak";
    NSString *f = [NSString stringWithFormat:@"%@||%@||%@||%@",[[UIDevice currentDevice] name],[[UIDevice currentDevice] model],[[UIDevice currentDevice] systemName],[[UIDevice currentDevice] systemVersion]];  //设备信息;
    QWSGainUA *gainUA = [QWSGainUA sharedGainUA];
    NSString *g = [gainUA createHttpRequest];
    NSString *i = serverName;
    NSString *ao = serverId;
    NSString *k = productname;
    NSString *l = productdesc;
    NSString *m = attach;
    NSString *p = roleName;
    NSString *ap = roleId;
    NSString *z = logininfo.user_token;
    NSString *o = amount;
    NSString *x = initinfo.clientID;
    NSString *ac = initinfo.cityID;
    NSString *v = logininfo.mem_id;
    NSString *w = @"0";
    NSString * user_ip =  initinfo.ipstr;
    NSString * packagename =  [self getBundleID];
    NSArray *payList = initinfo.payarr;
    NSString * is_qcode = @"1";
    NSDate *currentDate = [NSDate date];
    
    NSString *j = payWay;
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    
    [dateFormatter setDateFormat:@"Y-MM-dd"];
    
    NSString * dateString = [dateFormatter stringFromDate:currentDate];
    
    NSString * strs = payList[0][@"a"];
    
    NSString * add = [NSString stringWithFormat:@"%@%@%d%@",strs,dateString,0,initinfo.clientKEY];
    
    
    NSString * api_token = [md5Encryption md5:add];//y
    
    NSString *param_token_az = [NSString stringWithFormat:@"a=%@&c=%@&d=%@&e=%@&f=%@&g=%@&i=%@&ao=%@&k=%@&l=%@&m=%@&p=%@&ap=%@&z=%@&o=%@&x=%@&ac=%@&j=%@&v=%@&w=%@&user_ip=%@&packagename=%@&y=%@&is_qcode=%@",a,c,d,e,f,g,i,ao,k,l,m,p,ap,z,o,x,ac,j,v,w,user_ip,packagename,api_token,is_qcode];
    
    NSString * param_token_az_Str = [md5Encryption md5:[NSString stringWithFormat:@"%@%@",[md5Encryption md5:param_token_az],initinfo.clientKEY]];//az
    
    
    NSString *tmpac;//淘宝API有时候会崩，崩了直接判断一下，传空就行
    if (ac == nil) {
        tmpac = @"";
    }else{
        tmpac =ac;
    }
    
    NSDictionary *behaviordic = @{@"a":a,@"c":c,@"d":d,@"e":e,@"f":f,@"g":g,@"i":i,@"ao":ao,@"k":k,@"l":l,@"m":m,@"p":p,@"ap":ap,@"z":z,@"o":o,@"x":x,@"ac":tmpac,@"j":j,@"v":v,@"w":w,@"user_ip":user_ip,@"packagename":packagename,@"y":api_token,@"az":param_token_az_Str,@"is_qcode":is_qcode};
    
    //JSON化
    NSError * parseError_be = nil;
    
    NSData * jsonData_be = [NSJSONSerialization dataWithJSONObject:behaviordic
                                                           options:NSJSONWritingPrettyPrinted error:&parseError_be];
    
    NSString * action = [[NSString alloc]initWithData:jsonData_be encoding:NSUTF8StringEncoding];
    
    QWSEncipher *encipher = [[QWSEncipher alloc] init];
    
    NSString * restr1 =[encipher QWSEncryption:action];
    
    QWSGzip *zip = [QWSGzip sharedGzip];
    
    NSData *data1 = [zip gZipDataPressure:[restr1 dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    //网络请求
    
    [network QWSRequest_Otherinterface:data1 RequestURL:[NSString stringWithFormat:@"%@ysfpay/ysfpay.php",HTTPHead] successBlock:^(NSDictionary *success) {
        
        
        successBlock(success);
        
    } failBlock:^(NSError *error, NSString *errorMsg) {
        
        failBlock(error,errorMsg);
    }];
    
}

//请求支付宝二维码
- (void)initWithQcodePayServerNameAlipay:(NSString*)serverName andServerId:(NSString*)serverId andProductname:(NSString*)productname andProductdesc:(NSString*)productdesc andAttach:(NSString*)attach  andRoleName:(NSString*)roleName andRoleId:(NSString*)roleId andAmount:(NSString*)amount andPayWay:(NSString*)payWay successBlock:(successBlock)successBlock failBlock:(failBlock)failBlock{
    QWSNetworkRequest *network = [QWSNetworkRequest sharedNetworkRequest];
    TQStaticLoginInfo  *logininfo = [TQStaticLoginInfo singleStaticLoginInfo];
    QWSMD5Encryption *md5Encryption = [QWSMD5Encryption sharedMD5Encryption];
    TQInitInfo   *initinfo =  [TQInitInfo singleInitInfo];
    
    //拼接参数
    NSString *a =  initinfo.appID;
    NSString *c = [KeyChainManager keyChainReadData:@"4CSDKUUID"];
    NSString *d = @"3";
    //    NSStringEncoding enc;
    //    NSString *path = [[NSBundle mainBundle] pathForResource:@"gameChannel" ofType:nil];
    //    NSString *str = [NSString stringWithContentsOfFile:path usedEncoding:&enc error:nil];
    //    NSString *estr;
    //    if (str == nil) {
    //        estr = @"default";
    //    }else{
    //        estr = str;
    //    }
    //    NSString *e = str;
    NSString *e = [KeyChainManager keyChainReadData:SDK_GAME_KEYCHAIN_CHANNEL];
    //    NSString *e = @"jailbreak";
    NSString *f = [NSString stringWithFormat:@"%@||%@||%@||%@",[[UIDevice currentDevice] name],[[UIDevice currentDevice] model],[[UIDevice currentDevice] systemName],[[UIDevice currentDevice] systemVersion]];  //设备信息;
    QWSGainUA *gainUA = [QWSGainUA sharedGainUA];
    NSString *g = [gainUA createHttpRequest];
    NSString *i = serverName;
    NSString *ao = serverId;
    NSString *k = productname;
    NSString *l = productdesc;
    NSString *m = attach;
    NSString *p = roleName;
    NSString *ap = roleId;
    NSString *z = logininfo.user_token;
    NSString *o = amount;
    NSString *x = initinfo.clientID;
    NSString *ac = initinfo.cityID;
    NSString *v = logininfo.mem_id;
    NSString *w = @"0";
    NSString * user_ip =  initinfo.ipstr;
    NSString * packagename =  [self getBundleID];
    NSArray *payList = initinfo.payarr;
    NSString * is_qcode = @"2";
    NSDate *currentDate = [NSDate date];
    
    NSString *j = payWay;
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    
    [dateFormatter setDateFormat:@"Y-MM-dd"];
    
    NSString * dateString = [dateFormatter stringFromDate:currentDate];
    
    NSString * strs = payList[0][@"a"];
    
    NSString * add = [NSString stringWithFormat:@"%@%@%d%@",strs,dateString,0,initinfo.clientKEY];
    
    
    NSString * api_token = [md5Encryption md5:add];//y
    
    NSString *param_token_az = [NSString stringWithFormat:@"a=%@&c=%@&d=%@&e=%@&f=%@&g=%@&i=%@&ao=%@&k=%@&l=%@&m=%@&p=%@&ap=%@&z=%@&o=%@&x=%@&ac=%@&j=%@&v=%@&w=%@&user_ip=%@&packagename=%@&y=%@&is_qcode=%@",a,c,d,e,f,g,i,ao,k,l,m,p,ap,z,o,x,ac,j,v,w,user_ip,packagename,api_token,is_qcode];
    
    NSString * param_token_az_Str = [md5Encryption md5:[NSString stringWithFormat:@"%@%@",[md5Encryption md5:param_token_az],initinfo.clientKEY]];//az
    
    
    NSString *tmpac;//淘宝API有时候会崩，崩了直接判断一下，传空就行
    if (ac == nil) {
        tmpac = @"";
    }else{
        tmpac =ac;
    }
    
    NSDictionary *behaviordic = @{@"a":a,@"c":c,@"d":d,@"e":e,@"f":f,@"g":g,@"i":i,@"ao":ao,@"k":k,@"l":l,@"m":m,@"p":p,@"ap":ap,@"z":z,@"o":o,@"x":x,@"ac":tmpac,@"j":j,@"v":v,@"w":w,@"user_ip":user_ip,@"packagename":packagename,@"y":api_token,@"az":param_token_az_Str,@"is_qcode":is_qcode};
    
    //JSON化
    NSError * parseError_be = nil;
    
    NSData * jsonData_be = [NSJSONSerialization dataWithJSONObject:behaviordic
                                                           options:NSJSONWritingPrettyPrinted error:&parseError_be];
    
    NSString * action = [[NSString alloc]initWithData:jsonData_be encoding:NSUTF8StringEncoding];
    
    QWSEncipher *encipher = [[QWSEncipher alloc] init];
    
    NSString * restr1 =[encipher QWSEncryption:action];
    
    QWSGzip *zip = [QWSGzip sharedGzip];
    
    NSData *data1 = [zip gZipDataPressure:[restr1 dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    //网络请求
    
    [network QWSRequest_Otherinterface:data1 RequestURL:[NSString stringWithFormat:@"%@ysfpay/ysfpay.php",HTTPHead] successBlock:^(NSDictionary *success) {
        
        
        successBlock(success);
        
    } failBlock:^(NSError *error, NSString *errorMsg) {
        
        failBlock(error,errorMsg);
    }];
    
}

//轮询请求二维码是否还能用
- (void)initWithQcodeUsableWithOrderNum:(NSString*)orderNum successBlock:(successBlock)successBlock failBlock:(failBlock)failBlock{
    QWSNetworkRequest *network = [QWSNetworkRequest sharedNetworkRequest];
    //拼接参数
//    NSString *a =  initinfo.appID;

    
    NSDictionary *behaviordic = @{@"order_id":orderNum};
    
    //JSON化
    NSError * parseError_be = nil;
    
    NSData * jsonData_be = [NSJSONSerialization dataWithJSONObject:behaviordic
                                                           options:NSJSONWritingPrettyPrinted error:&parseError_be];
    
    NSString * action = [[NSString alloc]initWithData:jsonData_be encoding:NSUTF8StringEncoding];
    
    QWSEncipher *encipher = [[QWSEncipher alloc] init];
    
    NSString * restr1 =[encipher QWSEncryption:action];
    
    QWSGzip *zip = [QWSGzip sharedGzip];
    
    NSData *data1 = [zip gZipDataPressure:[restr1 dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    //网络请求
    
    [network QWSRequest_Otherinterface:data1 RequestURL:[NSString stringWithFormat:@"%@pay/query.php",HTTPHead] successBlock:^(NSDictionary *success) {
        
        successBlock(success);
        
    } failBlock:^(NSError *error, NSString *errorMsg) {
        
        failBlock(error,errorMsg);
    }];
    
}
-(void)initWithPaypalCallBack:(NSString*)Amount andNonce:(NSString*)nonce andOrderID:(NSString*)orderid andClientToken:(NSString*)ClientToken andMerchatAccountId:(NSString*)MerchatAccountId successBlock:(successBlock)successBlock failBlock:(failBlock)failBlock{
    TQStaticLoginInfo  *logininfo = [TQStaticLoginInfo singleStaticLoginInfo];
     QWSNetworkRequest *network = [QWSNetworkRequest sharedNetworkRequest];
    //拼接参数
    NSString *amount = Amount;
    NSString *payment_method_nonce = nonce;
    NSString *order_id = orderid;
    NSString *clientToken = ClientToken;
    NSString *merchatAccountId = MerchatAccountId;
    NSString *mem_id = logininfo.mem_id;
    
    NSDictionary *behaviordic = @{@"amount":amount,@"payment_method_nonce":payment_method_nonce,@"order_id":order_id,@"clientToken":clientToken,@"merchatAccountId":merchatAccountId,@"mem_id":mem_id};
    
//    NSLog(@"------PAYPAL的回调---%@",behaviordic);
    //JSON化
    NSError * parseError_be = nil;
    
    NSData * jsonData_be = [NSJSONSerialization dataWithJSONObject:behaviordic
                                                           options:NSJSONWritingPrettyPrinted error:&parseError_be];

    [network QWSRequest_Normalinterface:jsonData_be RequestURL:[NSString stringWithFormat:@"%@paypal/transaction.php",HTTPHead] successBlock:^(NSDictionary *success) {


        successBlock(success);

    } failBlock:^(NSError *error, NSString *errorMsg) {

          failBlock(error,errorMsg);


    }];
    
 
}


- (void)POSTWithUrl:(NSString *)url parameters:(NSDictionary *)dict success:(successBlock)successBlock fail:(failblock)failBlock{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    [manager POST:url parameters:dict progress:^(NSProgress * _Nonnull uploadProgress){
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        if(responseObject){
            NSLog(@"responseObject = %@,responseObject =:%@",task,responseObject);
            successBlock(responseObject);
            
        }else{
            NSError *error = [[NSError alloc] initWithDomain:@"网络错误" code:-1001 userInfo:nil];
            NSLog(@"error = %@",error);

            failBlock(error);
        }
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
            NSLog(@"error = %@",error);
            failBlock(error);
        }];
}



//获取BundleID
-(NSString*) getBundleID

{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    
}
@end
