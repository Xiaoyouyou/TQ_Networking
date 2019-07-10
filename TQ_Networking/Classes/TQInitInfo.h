//
//  TQInitInfo.h
//  TQSDK_v1.0
//
//  Created by valen on 2018/4/1.
//  Copyright © 2018年 广东天启互动娱乐. All rights reserved.
//

#import <Foundation/Foundation.h>
#pragma mark - init初始化返回的数据  &&  平台给CP的一些固定数据  && 淘宝api返回的cityID
@interface TQInitInfo : NSObject
+ (instancetype)singleInitInfo;
@property(nonatomic,strong)NSString *appID;//平台给CP的
@property(nonatomic,strong)NSString *clientID;//同上
@property(nonatomic,strong)NSString *clientKEY;//同上
@property(nonatomic,strong)NSString *ua;//UA信息
@property(nonatomic,strong)NSString *macadd;//Mac地址，对应本来的IMEI
//------
@property(nonatomic,strong)NSString *qqstr;//QQ
@property(nonatomic,strong)NSArray *payWayArray;//支付方式数组
@property(nonatomic,strong)NSString *emailstr;//邮箱
@property(nonatomic,strong)NSString *qqgroupstr;//QQ组
@property (nonatomic ,strong)NSString *type;//是否初始化的type
@property(nonatomic,strong)NSString *service_timestr;//服务时间
@property(nonatomic,strong)NSString *telstr;//电话
@property(nonatomic,strong)NSString *wxstr;//微信
@property(nonatomic,strong)NSString *h5str;//推荐H5
@property(nonatomic,strong)NSString *ipstr;//外网IP
@property(nonatomic,strong)NSString *qqcomplaint;//投诉建议的QQ号
@property(nonatomic,strong)NSArray *dyArray;
@property(nonatomic,strong)NSString *yzBtn;//是否开启实名认证
@property(nonatomic,strong)NSString *renzhengMessage;//是否开启实名认证
//------
@property(nonatomic,strong)NSString *cityID;//IP对应城市的ID
//--新增，支付方式
@property(nonatomic,strong)NSArray *payarr;

//登录支付方式
@property(nonatomic,strong)NSArray *loginPayArr;
@property(nonatomic,strong)NSString *info;

@property(nonatomic,strong)NSString *payType;

@property(nonatomic,strong)NSString *is_pay;
@property(nonatomic,strong)NSString *is_register;

@property(nonatomic,strong)NSString *is_register_msg;
@property(nonatomic,strong)NSString *is_pay_msg;

@property(nonatomic,strong)NSString *h5_url;
@property(nonatomic,strong)NSString *tousu_url;

@property(nonatomic,strong)NSString *h5ptb_url;//平台币h5

@property(nonatomic,strong)NSString *register_key;//注册先后顺序
@end
/**
 

 
 NSDictionary *dataDic1 =success[@"data"];
 NSString *ipstr = dataDic1[@"b"];//外网IP
 NSDictionary  *dataDic2  = dataDic1[@"e"];
 
 NSString  *qq = dataDic2[@"qq"];
 NSString  *email = dataDic2[@"email"];
 NSString  *qqgroup = dataDic2[@"qqgroup"];
 NSString  *service_time = dataDic2[@"service_time"];
 NSString  *tel = dataDic2[@"tel"];
 NSString  *wx = dataDic2[@"wx"];
 NSString *i = dataDic1[@"i"];
 */
