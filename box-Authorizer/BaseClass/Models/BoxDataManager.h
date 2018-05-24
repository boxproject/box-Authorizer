//
//  BoxDataManager.h
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/3/31.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>

typedef NS_ENUM (NSInteger, LaunchState){
    PerfectInformation,        //首次进入，完善信息
    NotBackupPassword,         //未备份密码
    BackupPasswordCompleted,   //已经备份密码
    EnterHomeBox               //直接进入主页
};

typedef NS_ENUM(NSInteger, ServerStatus) {
    NotConnectedStatus,          //0-未连接
    NotCreatedContractStatus,    //1-未创建合约
    CreatedContractStatus,       //2-已创建合约
    PublishContractStatus,       //3-已发布合约
    StartedServiceStatus,        //4-已启动服务
    StoppedServiceStatus         //5-已停止服务
};

typedef NS_ENUM(NSInteger, AgentOperate) {
    AddPublickeyOperate,        //0-添加公钥
    CreateContractOperate,      //1-创建合约
    PublishContractOperate,     //2-发布合约
    StartServiceOperate,        //3-启动服务
    StopServiceOperate          //4-停止服务
};

@interface BoxDataManager : NSObject
/** IP地址 */
@property(nonatomic, strong)NSString *box_IP;
/** IP-Port */
@property(nonatomic, strong)NSString *box_IpPort;
/** 申请者唯一识别码 */
@property(nonatomic, strong)NSString *applyer_id;
/** 账户地址 */
@property(nonatomic, strong)NSString *Address;
/** 合约地址 */
@property(nonatomic, strong)NSString *ContractAddress;
/** 账号唯一标识符 */
@property(nonatomic, strong)NSString *app_account_id;
/** 账号扫码注册生成的固定随机值 */
@property(nonatomic, strong)NSString *app_account_random;
/** 签名机随机值 */
@property(nonatomic, strong)NSString *randomValue;
/** 新注册私钥APP账号 */
@property(nonatomic, strong)NSString *applyer_account;
/** 公钥  */
@property(nonatomic, strong)NSString *publicKeyBase64;
/** 私钥 */
@property(nonatomic, strong)NSString *privateKeyBase64;
/** 启动状态 */
@property(nonatomic, assign)LaunchState launchState;
/** 口令 */
@property(nonatomic, strong)NSString *passWord;
/** 备份密码 */
@property(nonatomic, strong)NSString *codePassWord;
/** D - 用于私钥的恢复  */
@property(nonatomic, strong)NSString *stringD;
/** KeyStoreStatus */
@property(nonatomic, strong)NSString *KeyStoreStatus;
/** 服务状态 */
@property(nonatomic, assign)ServerStatus serverStatus;
/** 签名机操作 */
@property(nonatomic, assign)AgentOperate agentOperate;
/** 等待校验初始时间 */
@property(nonatomic, strong)NSString *checkTime;

+(instancetype)sharedManager;
/** 获取本地数据 */
-(void)getAllData;
/** 获取数据到本地 */
-(void)saveDataWithCoding:(NSString *)coding codeValue:(NSString *)codeValue;
-(void)removeDataWithCoding:(NSString *)coding;

@end
