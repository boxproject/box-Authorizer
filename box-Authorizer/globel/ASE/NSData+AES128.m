//
//  NSData+AES128.m
//  BoxAuthorizer
//
//  Created by Rony on 2018/1/17.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "NSData+AES128.h"

@implementation NSData (AES128)

/**
 *  根据CCOperation，确定加密还是解密
 *
 *  @param operation kCCEncrypt -> 加密  kCCDecrypt－>解密
 *  @param key       公钥
 *  @param iv        偏移量
 *
 *  @return 加密或者解密的NSData
 */
- (NSData *)AES128Operation:(CCOperation)operation key:(NSString *)key iv:(NSString *)iv

{
    
    char keyPtr[kCCKeySizeAES128 + 1];
    
    memset(keyPtr, 0, sizeof(keyPtr));
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    
    
    char ivPtr[kCCBlockSizeAES128 + 1];
    
    memset(ivPtr, 0, sizeof(ivPtr));
    
    [iv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    
    
    NSUInteger dataLength = [self length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    
    void *buffer = malloc(bufferSize);
    
    size_t numBytesCrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(operation,
                                          
                                          kCCAlgorithmAES128,
                                          
                                          kCCOptionPKCS7Padding,
                                          
                                          keyPtr,
                                          
                                          kCCBlockSizeAES128,
                                          
                                          ivPtr,
                                          
                                          [self bytes],
                                          
                                          dataLength,
                                          
                                          buffer,
                                          
                                          bufferSize,
                                          
                                          &numBytesCrypted);
    
    if (cryptStatus == kCCSuccess) {
        
        return [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
        
    }
    
    free(buffer);
    
    return nil;
    
}


- (NSData *)AES128EncryptWithKey:(NSString *)key iv:(NSString *)iv

{
    
    return [self AES128Operation:kCCEncrypt key:key iv:iv];
    
}


- (NSData *)AES128DecryptWithKey:(NSString *)key iv:(NSString *)iv

{
    
    return [self AES128Operation:kCCDecrypt key:key iv:iv];
    
}

    


@end
