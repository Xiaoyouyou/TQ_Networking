//
//  TQStaticLoginInfo.h
//  TQSDK_v1.0
//
//  Created by valen on 2018/3/31.
//  Copyright © 2018年 广东天启互动娱乐. All rights reserved.
//

#import <Foundation/Foundation.h>
#pragma mark - 单例，保存登录后的信息，提供给其他接口使用
@interface TQStaticLoginInfo : NSObject
+ (instancetype)singleStaticLoginInfo;
@property(nonatomic,strong)NSString *mem_id;
@property(nonatomic,strong)NSString *user_token;
@property(nonatomic,strong)NSNumber *user_tel;//未绑定返回0，已绑定返回手机号
@property(nonatomic,strong)NSString *user_age;//验证是否已实名
@property(nonatomic,strong)NSNumber *user_money;//用户平台币 通用币
@property(nonatomic,strong)NSNumber *f;//绑定币
@property(nonatomic,strong)NSArray *loginPayArr;//充值平台比
@property(nonatomic,strong)NSArray *yuanBaoPayArr;//充值元宝

@property(nonatomic,strong)NSNumber *isSign;//0没签到 1已签到
@property(nonatomic,strong)NSString *avatarUrl; //用户头像
@property(nonatomic,strong)NSString *is_gi;//是否开启检测设备码 1开启 0关闭
@property(nonatomic,strong)NSString *gi;//1新设备好登录 0正常
@property(nonatomic,assign)NSInteger is_g;//是否开启充值模块的实名认证
@property(nonatomic,assign)NSInteger g;//是否已实名
@property (nonatomic ,strong)NSString *cardInfo;//汇率现实字段
@property (nonatomic ,assign)NSInteger iscard;//汇率开关
@property (nonatomic ,assign)NSInteger phoneType;//手机绑定开关

@end
