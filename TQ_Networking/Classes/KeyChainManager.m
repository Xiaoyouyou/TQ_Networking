//
//  KeyChainManager.m
//  TQSDK_v1.0
//
//  Created by valen on 2018/5/22.
//  Copyright © 2018年 广东天启互动娱乐. All rights reserved.
//

#import "KeyChainManager.h"
#import <Security/Security.h>
@implementation KeyChainManager

/**
 * gameChannel：渠道号，数据是分包时由后端写入，默认default。
 */

/**
 游戏群--->>APP：数据互通处理逻辑：
 //一、账号密码：
 1、先从对方的keychain读取，读取到就显示到登录页面上(登录框)
 2、点击登录后，就把它存入自己的keychain。修改密码后也是存自己的keychain。下次登录直接从自己keychain获取账号密码
 3、如果对方不存在，就从自身获取(账号密码就自己新建输入)，然后存keychain
 4、所有游戏存keychain的key都是一样的，所以说：账号密码会覆盖！场景：GameA的keychain有账号密码，GameB首先搜APP，搜不到直接读游戏群"xxx"KEY的钥匙串。
 5、方便用户而已，跟渠道号的互通本质不一样
 //二、渠道号：
 1、(先读自己(读到表示对方已经安装并迁移到游戏的keychain)-->>读对方---->>读本地)
 2、先从init读APP的keychain，读取到就把他放在自己keychain，下次就从自己keychain读取作为入参
 3、如果对方没安装，就读自己本地的，然后放在自己keychain，下次也是从自己keychain读作为入参。
 4、渠道号也是同一个KEY。场景跟上面账号密码一样
 
 APP--->>游戏群：数据互通处理逻辑：
 跟上面一样的逻辑
 */
//涉及的类：  账号密码：  TQHomeVC   TQLoginView | TQChangePwdVC  TQChangeTELVC  TQSwitchAccountView  TQPayGameCurrency-->USERACCOUNTSTR
//渠道号：TQInit  | TQLogin  TQNumberRegister TQAutoRegister TQTELRegistered TQPay-->>NSString *path = [[NSBundle mainBundle] pathForResource:@"gameChannel" ofType:nil];

/*!
 创建生成保存数据查询条件
 */
+(NSMutableDictionary*) keyChainIdentifier:(NSString*)identifier {
    NSMutableDictionary * keyChainMutableDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:(id)kSecClassGenericPassword,kSecClass,identifier,kSecAttrService,identifier,kSecAttrAccount,kSecAttrAccessibleAfterFirstUnlock,kSecAttrAccessible, nil];
    return keyChainMutableDictionary;
}

/*!
 保存数据
 */
+(BOOL) keyChainSaveData:(id)data withIdentifier:(NSString*)identifier{
    // 获取存储的数据的条件
    NSMutableDictionary * saveQueryMutableDictionary = [self keyChainIdentifier:identifier];
    // 删除旧的数据
    SecItemDelete((CFDictionaryRef)saveQueryMutableDictionary);
    // 设置新的数据
    [saveQueryMutableDictionary setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    // 添加数据
    OSStatus saveState = SecItemAdd((CFDictionaryRef)saveQueryMutableDictionary, nil);
    // 释放对象
    saveQueryMutableDictionary = nil ;
    // 判断是否存储成功
    if (saveState == errSecSuccess) {
        return YES;
    }
    return NO;
}


/*!
 读取数据
 */
+(id) keyChainReadData:(NSString*)identifier{
    id idObject = nil ;
    // 通过标记获取数据查询条件
    NSMutableDictionary * keyChainReadQueryMutableDictionary = [self keyChainIdentifier:identifier];
    // 这是获取数据的时，必须提供的两个属性
    // TODO: 查询结果返回到 kSecValueData
    [keyChainReadQueryMutableDictionary setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    // TODO: 只返回搜索到的第一条数据
    [keyChainReadQueryMutableDictionary setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    // 创建一个数据对象
    CFDataRef keyChainData = nil ;
    // 通过条件查询数据
    if (SecItemCopyMatching((CFDictionaryRef)keyChainReadQueryMutableDictionary , (CFTypeRef *)&keyChainData) == noErr){
        @try {
            idObject = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)(keyChainData)];
        } @catch (NSException * exception){
            NSLog(@"Unarchive of search data where %@ failed of %@ ",identifier,exception);
        }
    }
    if (keyChainData) {
        CFRelease(keyChainData);
    }
    // 释放对象
    keyChainReadQueryMutableDictionary = nil;
    // 返回数据
    return idObject ;
}


/*!
 更新数据
 
 @data  要更新的数据
 @identifier 数据存储时的标示
 */
+(BOOL)keyChainUpdata:(id)data withIdentifier:(NSString*)identifier {
    // 通过标记获取数据更新的条件
    NSMutableDictionary * keyChainUpdataQueryMutableDictionary = [self keyChainIdentifier:identifier];
    // 创建更新数据字典
    NSMutableDictionary * updataMutableDictionary = [NSMutableDictionary dictionaryWithCapacity:0];
    // 存储数据
    [updataMutableDictionary setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    // 获取存储的状态
    OSStatus  updataStatus = SecItemUpdate((CFDictionaryRef)keyChainUpdataQueryMutableDictionary, (CFDictionaryRef)updataMutableDictionary);
    // 释放对象
    keyChainUpdataQueryMutableDictionary = nil;
    updataMutableDictionary = nil;
    // 判断是否更新成功
    if (updataStatus == errSecSuccess) {
        return  YES ;
    }
    return NO;
}


/*!
 删除数据
 */
+(void) keyChainDelete:(NSString*)identifier {
    // 获取删除数据的查询条件
    NSMutableDictionary * keyChainDeleteQueryMutableDictionary = [self keyChainIdentifier:identifier];
    // 删除指定条件的数据
    SecItemDelete((CFDictionaryRef)keyChainDeleteQueryMutableDictionary);
    // 释放内存
    keyChainDeleteQueryMutableDictionary = nil ;
}


/** ************************************ keychain 测试代码  ************************************
 
 // 存储数据
 BOOL save = [KeyChainManager keyChainSaveData:@"思念诉说，眼神多像云朵" withIdentifier:Keychain];
 if (save) {
 NSLog(@"存储成功");
 }else {
 NSLog(@"存储失败");
 }
 // 获取数据
 NSString * readString = [KeyChainManager keyChainReadData:Keychain];
 NSLog(@"获取得到的数据:%@",readString);
 
 // 更新数据
 BOOL updata = [KeyChainManager keyChainUpdata:@"长发落寞，我期待的女孩" withIdentifier:Keychain];
 if (updata) {
 NSLog(@"更新成功");
 }else{
 NSLog(@"更新失败");
 }
 // 读取数据
 NSString * readUpdataString = [KeyChainManager keyChainReadData:Keychain];
 NSLog(@"获取更新后得到的数据:%@",readUpdataString);
 
 // 删除数据
 [KeyChainManager keyChainDelete:Keychain];
 // 读取数据
 NSString * readDeleteString = [KeyChainManager keyChainReadData:Keychain];
 NSLog(@"获取删除后得到的数据:%@",readDeleteString);
 
 
 */
@end
