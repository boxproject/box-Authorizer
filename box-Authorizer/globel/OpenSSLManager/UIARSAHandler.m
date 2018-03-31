//
//  UIARSAHandler.m
//  UIADemo
//
//  Created by zhangchao on 16/12/13.
//  Copyright © 2016年 王龙. All rights reserved.
//

#import "UIARSAHandler.h"


typedef enum {
    RSA_PADDING_TYPE_NONE       = RSA_NO_PADDING,
    RSA_PADDING_TYPE_PKCS1      = RSA_PKCS1_PADDING,
    RSA_PADDING_TYPE_SSLV23     = RSA_SSLV23_PADDING
}RSA_PADDING_TYPE;

#define  PADDING   RSA_PADDING_TYPE_PKCS1
#define  RSASIZE   2048

@implementation UIARSAHandler
{
    
    RSA* _rsa_pub;
    RSA* _rsa_pri;
    
    RSA *publicKey;
    RSA *privateKey;
    
    NSString *_publicKeyBase64;
    NSString *_privateKeyBase64;
    
    
}

#pragma mark ----- openssl -----
#pragma mark ----- 生成密钥对 -----
-(void)opensslGenerateKey
{
    if ([DDRSAWrapper generateRSAKeyPairWithKeySize:RSASIZE publicKey:&publicKey privateKey:&privateKey]) {
        
        char * m = [DDRSAWrapper openssl_modFromPublicKey:publicKey];
        char * e = [DDRSAWrapper openssl_expFromPublicKey:publicKey];;
        
        _publicKeyBase64 = [DDRSAWrapper base64EncodedStringPublicKey:publicKey];
        _privateKeyBase64 = [DDRSAWrapper base64EncodedStringPrivateKey:privateKey];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:_publicKeyBase64 forKey: @"publicKeyBase64"];
        [defaults setObject:_privateKeyBase64 forKey: @"privateKeyBase64"];
        [defaults synchronize];
        
        NSLog(@"openssl 生成密钥成功！\n公钥-----\n模数：%s\n指数：%s\n-------",m,e);
        NSLog(@"%@",_publicKeyBase64);
        NSLog(@"%@",_privateKeyBase64);
        
     }
}


#pragma mark ----- 读取公钥 -----
-(RSA *)opensslReadPublicKeyPEM
{
    if(!_publicKeyBase64) {
        return nil;
    }
    if ([DDRSAWrapper openssl_publicKeyFromBase64:_publicKeyBase64]) {
        return [DDRSAWrapper openssl_publicKeyFromBase64:_publicKeyBase64];
    }else{
        return nil;
    }
}

#pragma mark ----- 读取私钥 -----
-(RSA *)opensslReadPrivateeyPEM
{
    if(!_privateKeyBase64) {
        return nil;
    }
    privateKey = [DDRSAWrapper openssl_privateKeyFromBase64:_privateKeyBase64];
    if ([DDRSAWrapper openssl_privateKeyFromBase64:_privateKeyBase64]){
        return [DDRSAWrapper openssl_privateKeyFromBase64:_privateKeyBase64];
    }else{
        return nil;
    }
}

#pragma mark ----- RSA 公钥加密 && 私钥解密 -----
#pragma mark ----- RSA 公钥加密  -----
-(NSString *)opensslPubcliKeyEncrypt:(NSString *)encryptMsg publicKeyBase64:(NSString *)publicKeyBase64
{
    NSData *plainData = [encryptMsg dataUsingEncoding:NSUTF8StringEncoding];
    NSData *cipherData = [DDRSAWrapper openssl_encryptWithPublicKey:[DDRSAWrapper openssl_publicKeyFromBase64:publicKeyBase64]
                                                          plainData:plainData
                                                            padding:RSA_PKCS1_PADDING];
    
    NSString * msgStr = [cipherData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSLog(@"%@",msgStr);
    return msgStr;
}

#pragma mark ----- RSA 私钥解密  -----
-(NSString *)opensslPrivateKeyDecrypt:(NSString *)decryptMsg privateKeyBase64:(NSString *)privateKeyBase64
{
    NSData *cipherData = [[NSData alloc] initWithBase64EncodedString:decryptMsg options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    NSData *plainData = [DDRSAWrapper openssl_decryptWithPrivateKey:[DDRSAWrapper openssl_privateKeyFromBase64:privateKeyBase64]
                                                         cipherData:cipherData
                                                            padding:RSA_PKCS1_PADDING];
    
    NSString *outputPlainString = [[NSString alloc] initWithData:plainData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",outputPlainString);
    return outputPlainString;
}

#pragma mark ----- RSA 私钥加密 && 公钥解密 -----
#pragma mark ----- RSA 私钥加密  -----
-(NSString *)opensslPrivateEncrypt:(NSString *)encryptMsg privateKeyBase64:(NSString *)privateKeyBase64
{
    NSData *plainData = [encryptMsg dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *cipherData = [DDRSAWrapper openssl_encryptWithPrivateRSA:[DDRSAWrapper openssl_privateKeyFromBase64:privateKeyBase64]
                                                           plainData:plainData
                                                             padding:RSA_PKCS1_PADDING];
    
    NSString * msgStr = [cipherData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return msgStr;
}

#pragma mark ----- RSA 公钥解密  -----
-(NSString *)opensslPublicKeyDecrypt:(NSString *)decryptMsg publicKeyBase64:(NSString *)publicKeyBase64
{
    NSData *cipherData = [[NSData alloc] initWithBase64EncodedString:decryptMsg options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    NSData *plainData = [DDRSAWrapper openssl_decryptWithPublicKey:[DDRSAWrapper openssl_publicKeyFromBase64:publicKeyBase64]
                                                        cipherData:cipherData
                                                           padding:RSA_PKCS1_PADDING];
    
    NSString *outputPlainString = [[NSString alloc] initWithData:plainData encoding:NSUTF8StringEncoding];
    return outputPlainString;
}

#pragma mark ----- RSA sha256签名  -----
- (NSString *)signRSAString:(NSString *)string privateKeyBase64:(NSString *)privateKeyBase64
{
    RSA *rsa_pri = [DDRSAWrapper openssl_privateKeyFromBase64:privateKeyBase64];
    if (!rsa_pri) {
        NSLog(@"please import private key first");
        return nil;
    }
    const char *message = [string cStringUsingEncoding:NSUTF8StringEncoding];
    int messageLength = (int)strlen(message);
    unsigned char *sig = (unsigned char *)malloc(256);
    //unsigned char sig[256];
    unsigned int sig_len;
    
    unsigned char sha1[SHA256_DIGEST_LENGTH];
    SHA256((unsigned char *)message, messageLength, sha1);
    
    int rsa_sign_valid = RSA_sign(NID_sha256
                                  , sha1, SHA256_DIGEST_LENGTH
                                  , sig, &sig_len
                                  , rsa_pri);
    if (rsa_sign_valid == 1) {
        NSData* data = [NSData dataWithBytes:sig length:sig_len];
        
        NSString * base64String = [data base64EncodedStringWithOptions:0];
        free(sig);
        return base64String;
    }
    
    free(sig);
    return nil;
    
}

#pragma mark ----- RSA sha256验证签名 -----
//signString为base64字符串
- (BOOL)verifyRSAString:(NSString *)string withSign:(NSString *)signString publicKeyBase64:(NSString *)publicKeyBase64
{
    RSA *rsa_pub = [DDRSAWrapper openssl_publicKeyFromBase64:publicKeyBase64];
    if (!rsa_pub) {
        NSLog(@"please import public key first");
        return NO;
    }
    
    const char *message = [string cStringUsingEncoding:NSUTF8StringEncoding];
    int messageLength = (int)[string lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    NSData *signatureData = [[NSData alloc]initWithBase64EncodedString:signString options:0];
    unsigned char *sig = (unsigned char *)[signatureData bytes];
    unsigned int sig_len = (int)[signatureData length];
    
    
    unsigned char sha1[SHA256_DIGEST_LENGTH];
    SHA256((unsigned char *)message, messageLength, sha1);
    int verify_ok = RSA_verify(NID_sha256
                               , sha1, SHA256_DIGEST_LENGTH
                               , sig, sig_len
                               , rsa_pub);
    
    
    if (1 == verify_ok){
        return   YES;
    }
    return NO;
}




#pragma mark RSA sha256签名 ---
- (NSString *)signString:(NSString *)string rsa_pri:(RSA *)rsa_pri
{
    if (!rsa_pri) {
        NSLog(@"please import private key first");
        return nil;
    }
    const char *message = [string cStringUsingEncoding:NSUTF8StringEncoding];
    int messageLength = (int)strlen(message);
    unsigned char *sig = (unsigned char *)malloc(256);
    //unsigned char sig[256];
    unsigned int sig_len;
    
    unsigned char sha1[SHA256_DIGEST_LENGTH];
    SHA256((unsigned char *)message, messageLength, sha1);
    
    int rsa_sign_valid = RSA_sign(NID_sha256
                                  , sha1, SHA256_DIGEST_LENGTH
                                  , sig, &sig_len
                                  , rsa_pri);
    if (rsa_sign_valid == 1) {
        NSData* data = [NSData dataWithBytes:sig length:sig_len];
        
        NSString * base64String = [data base64EncodedStringWithOptions:0];
        free(sig);
        return base64String;
    }
    
    free(sig);
    return nil;
}


#pragma mark RSA sha256验证签名 ---
//signString为base64字符串
- (BOOL)verifyString:(NSString *)string withSign:(NSString *)signString rsa_pub:(RSA *)rsa_pub
{
    if (!rsa_pub) {
        NSLog(@"please import public key first");
        return NO;
    }
    
    const char *message = [string cStringUsingEncoding:NSUTF8StringEncoding];
    int messageLength = (int)[string lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    NSData *signatureData = [[NSData alloc]initWithBase64EncodedString:signString options:0];
    unsigned char *sig = (unsigned char *)[signatureData bytes];
    unsigned int sig_len = (int)[signatureData length];
    
    
    unsigned char sha1[SHA256_DIGEST_LENGTH];
    SHA256((unsigned char *)message, messageLength, sha1);
    int verify_ok = RSA_verify(NID_sha256
                               , sha1, SHA256_DIGEST_LENGTH
                               , sig, sig_len
                               , rsa_pub);
    
    
    if (1 == verify_ok){
        return   YES;
    }
    return NO;
}





#pragma mark - public methord
-(BOOL)importKeyWithType:(KeyType)type andPath:(NSString *)path
{
    BOOL status = NO;
    const char* cPath = [path cStringUsingEncoding:NSUTF8StringEncoding];
    FILE* file = fopen(cPath, "rb");
    if (!file) {
        return status;
    }
    if (type == KeyTypePublic) {
        _rsa_pub = NULL;
        if((_rsa_pub = PEM_read_RSA_PUBKEY(file, NULL, NULL, NULL))){
            status = YES;
        }
        
        
    }else if(type == KeyTypePrivate){
        _rsa_pri = NULL;
        if ((_rsa_pri = PEM_read_RSAPrivateKey(file, NULL, NULL, NULL))) {
            status = YES;
        }
        
    }
    fclose(file);
    return status;
    
}
- (BOOL)importKeyWithType:(KeyType)type andkeyString:(NSString *)keyString
{
    if (!keyString) {
        return NO;
    }
    BOOL status = NO;
    BIO *bio = NULL;
    RSA *rsa = NULL;
    bio = BIO_new(BIO_s_file());
    NSString* temPath = NSTemporaryDirectory();
    NSString* rsaFilePath = [temPath stringByAppendingPathComponent:@"RSAKEY"];
    NSString* formatRSAKeyString = [self formatRSAKeyWithKeyString:keyString andKeytype:type];
    BOOL writeSuccess = [formatRSAKeyString writeToFile:rsaFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    if (!writeSuccess) {
        return NO;
    }
    const char* cPath = [rsaFilePath cStringUsingEncoding:NSUTF8StringEncoding];
    BIO_read_filename(bio, cPath);
    if (type == KeyTypePrivate) {
        rsa = PEM_read_bio_RSAPrivateKey(bio, NULL, NULL, "");
        _rsa_pri = rsa;
        if (rsa != NULL && 1 == RSA_check_key(rsa)) {
            status = YES;
        } else {
            status = NO;
        }
        
        
    }
    else{
        rsa = PEM_read_bio_RSA_PUBKEY(bio, NULL, NULL, NULL);
        _rsa_pub = rsa;
        if (rsa != NULL) {
            status = YES;
        } else {
            status = NO;
        }
    }
    
    BIO_free_all(bio);
    [[NSFileManager defaultManager] removeItemAtPath:rsaFilePath error:nil];
    return status;
}

#pragma mark RSA MD5 验证签名
- (BOOL)verifyMD5String:(NSString *)string withSign:(NSString *)signString
{
    if (!_rsa_pub) {
        NSLog(@"please import public key first");
        return NO;
    }
    
    const char *message = [string cStringUsingEncoding:NSUTF8StringEncoding];
    // int messageLength = (int)[string lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    NSData *signatureData = [[NSData alloc]initWithBase64EncodedString:signString options:0];
    unsigned char *sig = (unsigned char *)[signatureData bytes];
    unsigned int sig_len = (int)[signatureData length];
    
    unsigned char digest[MD5_DIGEST_LENGTH];
    MD5_CTX ctx;
    MD5_Init(&ctx);
    MD5_Update(&ctx, message, strlen(message));
    MD5_Final(digest, &ctx);
    int verify_ok = RSA_verify(NID_md5
                               , digest, MD5_DIGEST_LENGTH
                               , sig, sig_len
                               , _rsa_pub);
    if (1 == verify_ok){
        return   YES;
    }
    return NO;
    
}

- (NSString *)signMD5String:(NSString *)string
{
    if (!_rsa_pri) {
        NSLog(@"please import private key first");
        return nil;
    }
    const char *message = [string cStringUsingEncoding:NSUTF8StringEncoding];
    //int messageLength = (int)strlen(message);
    unsigned char *sig = (unsigned char *)malloc(256);
    unsigned int sig_len;
    
    unsigned char digest[MD5_DIGEST_LENGTH];
    MD5_CTX ctx;
    MD5_Init(&ctx);
    MD5_Update(&ctx, message, strlen(message));
    MD5_Final(digest, &ctx);
    
    int rsa_sign_valid = RSA_sign(NID_md5
                                  , digest, MD5_DIGEST_LENGTH
                                  , sig, &sig_len
                                  , _rsa_pri);
    
    if (rsa_sign_valid == 1) {
        NSData* data = [NSData dataWithBytes:sig length:sig_len];
        
        NSString * base64String = [data base64EncodedStringWithOptions:0];
        free(sig);
        return base64String;
    }
    
    free(sig);
    return nil;
    
    
}

- (NSString *)encryptWithPublicKey:(NSString*)content
{
    if (!_rsa_pub) {
        NSLog(@"please import public key first");
        return nil;
    }
    int status;
    int length  = (int)[content length];
    unsigned char input[length + 1];
    bzero(input, length + 1);
    int i = 0;
    for (; i < length; i++)
    {
        input[i] = [content characterAtIndex:i];
    }
    
    NSInteger  flen = [self getBlockSizeWithRSA_PADDING_TYPE:PADDING andRSA:_rsa_pub];
    
    char *encData = (char*)malloc(flen);
    bzero(encData, flen);
    status = RSA_public_encrypt(length, (unsigned char*)input, (unsigned char*)encData, _rsa_pub, PADDING);
    
    if (status){
        NSData *returnData = [NSData dataWithBytes:encData length:status];
        free(encData);
        encData = NULL;
        
        //NSString *ret = [returnData base64EncodedString];
        NSString *ret = [returnData base64EncodedStringWithOptions: NSDataBase64Encoding64CharacterLineLength];
        return ret;
    }
    
    free(encData);
    encData = NULL;
    
    return nil;
}

- (NSString *)decryptWithPrivatecKey:(NSString*)content
{
    if (!_rsa_pri) {
        NSLog(@"please import private key first");
        return nil;
    }    int status;
    
    //NSData *data = [content base64DecodedData];
    NSData *data = [[NSData alloc]initWithBase64EncodedString:content options:NSDataBase64DecodingIgnoreUnknownCharacters];
    int length = (int)[data length];
    
    NSInteger flen = [self getBlockSizeWithRSA_PADDING_TYPE:PADDING andRSA:_rsa_pri];
    char *decData = (char*)malloc(flen);
    bzero(decData, flen);
    
    status = RSA_private_decrypt(length, (unsigned char*)[data bytes], (unsigned char*)decData, _rsa_pri, PADDING);
    
    if (status)
    {
        NSMutableString *decryptString = [[NSMutableString alloc] initWithBytes:decData length:strlen(decData) encoding:NSASCIIStringEncoding];
        free(decData);
        decData = NULL;
        
        return decryptString;
    }
    
    free(decData);
    decData = NULL;
    
    return nil;
}

- (int)getBlockSizeWithRSA_PADDING_TYPE:(RSA_PADDING_TYPE)padding_type andRSA:(RSA*)rsa
{
    int len = RSA_size(rsa);
    
    if (padding_type == RSA_PADDING_TYPE_PKCS1 || padding_type == RSA_PADDING_TYPE_SSLV23) {
        len -= 11;
    }
    
    return len;
}

- (NSString*)formatRSAKeyWithKeyString:(NSString*)keyString andKeytype:(KeyType)type
{
    NSInteger lineNum = -1;
    NSMutableString *result = [NSMutableString string];
    
    if (type == KeyTypePrivate) {
        [result appendString:@"-----BEGIN PRIVATE KEY-----\n"];
        lineNum = 79;
    }else if(type == KeyTypePublic){
        [result appendString:@"-----BEGIN PUBLIC KEY-----\n"];
        lineNum = 76;
    }
    
    int count = 0;
    for (int i = 0; i < [keyString length]; ++i) {
        unichar c = [keyString characterAtIndex:i];
        if (c == '\n' || c == '\r') {
            continue;
        }
        [result appendFormat:@"%c", c];
        if (++count == lineNum) {
            [result appendString:@"\n"];
            count = 0;
        }
    }
    if (type == KeyTypePrivate) {
        [result appendString:@"\n-----END PRIVATE KEY-----"];
        
    }else if(type == KeyTypePublic){
        [result appendString:@"\n-----END PUBLIC KEY-----"];
    }
    return result;
}
@end
