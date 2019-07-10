//
//  TQPay.h
//  TQSDK_v1.0
//
//  Created by valen on 2018/3/31.
//  Copyright © 2018年 广东天启互动娱乐. All rights reserved.
//
#pragma mark - 支付的所有接口逻辑
#import <Foundation/Foundation.h>

typedef void(^successBlock)(NSDictionary *success);
typedef void(^failBlock)(NSError *error,NSString *errorMsg);
typedef void(^failblock)(NSError *error);
@interface TQPay : NSObject

//PayPal 文档
//https://developer.paypal.com/docs/accept-payments/express-checkout/ec-braintree-sdk/client-side/ios/v4/

/**单例*/
+ (instancetype)singleTQPay;

/** 1、支付宝充值平台币 创建订单

 * money 充值金额
 *
 */
- (void)initWithMoney:(NSString*)money  successBlock:(successBlock)successBlock failBlock:(failBlock)failBlock;

/**  2、支付宝充值平台币请求地址
 * paytoken 订单创建成功返回
 * money 金额
 */
- (void)initWithPayToken:(NSString*)paytoken  andmoney:(NSString*)money successBlock:(successBlock)successBlock failBlock:(failBlock)failBlock;

//********************** 最新的支付方式 ******************
- (void)initWithPaymoney:(NSString*)money withPayWay:(NSString*)payWay successBlock:(successBlock)successBlock failBlock:(failBlock)failBlock;

/**  3、平台币充值 数娱付  (微信支付)
 *  money 支付金额
 *
 */
- (void)initWithPaymoney:(NSString*)money successBlock:(successBlock)successBlock failBlock:(failBlock)failBlock;


/**  4、平台币充值  PayPal
 * Merchat 币种 HKD(港币) SGD(新加坡币) TWD(台湾币) USD(美金)
 * money 金额 以人民币为准
 */
- (void)initWithPayMerchatAccountId:(NSString*)Merchat  andMoney:(NSString*)money successBlock:(successBlock)successBlock failBlock:(failBlock)failBlock;

/**  5、 购买游戏道具  支付宝和平台币初始化
 * serverId      游戏道具ID
 * productname   游戏道具名称
 * productdesc   产品描述
 * attach        传空即可@""
 * amount        金额
 * roleId        角色ID
 * roleName      角色名字
 * serverName    游戏服务器名字
 * style         支付方式
 */
- (void)initWithPayGameCurrencyServerId:(NSString*)serverId andProductname:(NSString*)productname andProductdesc:(NSString*)productdesc andAttach:(NSString*)attach andAmount:(NSString*)amount andRoleId:(NSString*)roleId andServerName:(NSString*)serverName andRoleName:(NSString*)roleName andStyle:(NSString*)style successBlock:(successBlock)successBlock failBlock:(failBlock)failBlock;


/**  6、平台币购买游戏道具
 *  money 支付金额
 *  yxbnum 传 跟money一样就行
 * payToken 初始化后返回的
 *
 */
- (void)initWithPaymoney:(NSString*)money andyxbnum:(NSString*)yxbnum andPayToken:(NSString*)payToken choosePay:(NSString *)ptbID successBlock:(successBlock)successBlock failBlock:(failBlock)failBlock;


/**  7、支付宝购买游戏道具
 * paytoken 订单创建成功返回
 * money 金额
 */
- (void)initWithPayPropsToken:(NSString*)paytoken  andmoney:(NSString*)money successBlock:(successBlock)successBlock failBlock:(failBlock)failBlock;


/**  8、数娱付(微信) 购买游戏道具
 * serverName 游戏服务器名字
 *  serverId  服务器ID
 * productname 道具名
 * attach 传空即可
 * roleName 角色名
 * roleId 角色ID
 * amount 金额
 */
- (void)initWithSYFPayServerNameWechat:(NSString*)serverName andServerId:(NSString*)serverId andProductname:(NSString*)productname andProductdesc:(NSString*)productdesc andAttach:(NSString*)attach  andRoleName:(NSString*)roleName andRoleId:(NSString*)roleId andAmount:(NSString*)amount andPayWay:(NSString*)payWay successBlock:(successBlock)successBlock failBlock:(failBlock)failBlock;

//请求二维码
- (void)initWithQcodePayServerNameWechat:(NSString*)serverName andServerId:(NSString*)serverId andProductname:(NSString*)productname andProductdesc:(NSString*)productdesc andAttach:(NSString*)attach  andRoleName:(NSString*)roleName andRoleId:(NSString*)roleId andAmount:(NSString*)amount andPayWay:(NSString*)payWay successBlock:(successBlock)successBlock failBlock:(failBlock)failBlock;

//轮询接口
- (void)initWithQcodeUsableWithOrderNum:(NSString*)orderNum successBlock:(successBlock)successBlock failBlock:(failBlock)failBlock;

- (void)initWithSYFPayServerNameWechat:(NSString*)serverName andServerId:(NSString*)serverId andProductname:(NSString*)productname andProductdesc:(NSString*)productdesc andAttach:(NSString*)attach  andRoleName:(NSString*)roleName andRoleId:(NSString*)roleId andAmount:(NSString*)amount successBlock:(successBlock)successBlock failBlock:(failBlock)failBlock;

/** 9 、 paypal 的回调
 * amount 经过汇率换算后的金额
 * nonce PayPal返回的
 * order_id 订单号
 * clientToken 掉起PayPal的key
 * merchatAccountId 货币种类
 */
-(void)initWithPaypalCallBack:(NSString*)Amount andNonce:(NSString*)nonce andOrderID:(NSString*)orderid andClientToken:(NSString*)ClientToken andMerchatAccountId:(NSString*)MerchatAccountId successBlock:(successBlock)successBlock failBlock:(failBlock)failBlock;

- (void)POSTWithUrl:(NSString *)url parameters:(NSDictionary *)dict success:(successBlock)successBlock fail:(failblock)failBlock;

- (void)initQRCodeWithPaymoney:(NSString*)money successBlock:(successBlock)successBlock failBlock:(failBlock)failBlock;

- (void)initQRCodeWithAlipayPaymoney:(NSString*)money successBlock:(successBlock)successBlock failBlock:(failBlock)failBlock;

- (void)initWithQcodePayServerNameAlipay:(NSString*)serverName andServerId:(NSString*)serverId andProductname:(NSString*)productname andProductdesc:(NSString*)productdesc andAttach:(NSString*)attach  andRoleName:(NSString*)roleName andRoleId:(NSString*)roleId andAmount:(NSString*)amount andPayWay:(NSString*)payWay successBlock:(successBlock)successBlock failBlock:(failBlock)failBlock;

- (void)initWithSXYPayToken:(NSString*)paytoken  andmoney:(NSString*)money successBlock:(successBlock)successBlock failBlock:(failBlock)failBlock;


- (void)initAlipaySXYWithPaymoney:(NSString*)money successBlock:(successBlock)successBlock failBlock:(failBlock)failBlock;


@end
