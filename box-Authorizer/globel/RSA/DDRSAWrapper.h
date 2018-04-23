
#import <Foundation/Foundation.h>

@interface DDRSAWrapper : NSObject

#pragma mark ----- 生成密钥对 -----
-(void)generateSecKeyPairWithKey;
#pragma mark ------ SecKeyRef -----
- (BOOL)generateSecKeyPairWithKeySize:(NSUInteger)keySize publicKeyRef:(SecKeyRef *)publicKeyRef privateKeyRef:(SecKeyRef *)privateKeyRef;
#pragma mark ------ 签名 -----
-(NSString *)PKCSSignBytesSHA256withRSA:(NSString *)plainText privateStr:(NSString *)privateStr;
#pragma mark ------ 验证 -----
-(BOOL)PKCSVerifyBytesSHA256withRSA:(NSString *)plaintext signature:(NSString *)sign publicStr:(NSString *)publicStr;
#pragma mark ------ 获取本地密钥对 BOOL：YES-私钥 NO-公钥 -----
- (SecKeyRef)getKeyRef:(BOOL)isPrivate;

- (NSData *)publicKeyBitsFromSecKey:(SecKeyRef)givenKey;
- (SecKeyRef)publicSecKeyFromKeyBits:(NSData *)givenData;

- (NSData *)privateKeyBitsFromSecKey:(SecKeyRef)givenKey;
- (SecKeyRef)privateSecKeyFromKeyBits:(NSData *)givenData;

/*
 padding ： kSecPaddingNone 或 kSecPaddingPKCS1
 */
- (NSData *)encryptWithKey:(SecKeyRef)key plainData:(NSData *)plainData padding:(SecPadding)padding;
- (NSData *)decryptWithKey:(SecKeyRef)key cipherData:(NSData *)cipherData padding:(SecPadding)padding;
- (NSData *)encryptWithPrivateKey:(SecKeyRef)key plainData:(NSData *)plainData;
- (NSData *)decryptWithPublicKey:(SecKeyRef)publicKey cipherData:(NSData *)cipherData;

#pragma mark - 指数和模数
- (NSData *)getPublicKeyExp:(NSData *)pk;
- (NSData *)getPublicKeyMod:(NSData *)pk ;
- (SecKeyRef)publicKeyDataWithMod:(NSData *)modBits exp:(NSData *)expBits;

@end
