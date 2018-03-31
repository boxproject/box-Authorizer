//
//  UIARSAHandler.h
//  UIADemo
//
//  Created by zhangchao on 16/12/13.
//  Copyright © 2016年 王龙. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <openssl/rsa.h>
#include <openssl/pem.h>
#include <openssl/err.h>
#include <openssl/md5.h>
#import "DDRSAWrapper+openssl.h"

// 首先使用cocoapods 导入 pod 'OpenSSL', '~> 1.0.208' 和 afnetworking 第三方库

typedef enum {
    KeyTypePublic = 0,
    KeyTypePrivate
}KeyType;

@interface UIARSAHandler : NSObject


// ----- 生成密钥对 -----
-(void)opensslGenerateKey;
// ----- RSA 公钥加密  -----
-(NSString *)opensslPubcliKeyEncrypt:(NSString *)encryptMsg publicKeyBase64:(NSString *)publicKeyBase64;
// ----- RSA 私钥解密  -----
-(NSString *)opensslPrivateKeyDecrypt:(NSString *)decryptMsg privateKeyBase64:(NSString *)privateKeyBase64;
// ----- RSA 私钥加密  -----
-(NSString *)opensslPrivateEncrypt:(NSString *)encryptMsg privateKeyBase64:(NSString *)privateKeyBase64;
// ----- RSA 公钥解密  -----
-(NSString *)opensslPublicKeyDecrypt:(NSString *)decryptMsg publicKeyBase64:(NSString *)publicKeyBase64;
// ----- RSA sha256签名  -----
- (NSString *)signRSAString:(NSString *)string privateKeyBase64:(NSString *)privateKeyBase64;
// ----- RSA sha256验证签名 -----
- (BOOL)verifyRSAString:(NSString *)string withSign:(NSString *)signString publicKeyBase64:(NSString *)publicKeyBase64;


- (BOOL)importKeyWithType:(KeyType)type andPath:(NSString*)path;
- (BOOL)importKeyWithType:(KeyType)type andkeyString:(NSString *)keyString;

//私钥验证签名 Sha256 + RSA ---项目用到
- (BOOL)verifyString:(NSString *)string withSign:(NSString *)signString rsa_pub:(RSA *)rsa_pub;
//验证签名 md5 + RSA
- (BOOL)verifyMD5String:(NSString *)string withSign:(NSString *)signString;

//私钥签名 Sha256 + RSA  ---项目用到
- (NSString *)signString:(NSString *)string rsa_pri:(RSA *)rsa_pri;
- (NSString *)signMD5String:(NSString *)string;

//公钥加密
- (NSString *)encryptWithPublicKey:(NSString*)content;
//私钥解密
- (NSString *)decryptWithPrivatecKey:(NSString*)content;
@end
