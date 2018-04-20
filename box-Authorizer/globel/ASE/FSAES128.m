//
//  FSAES128.m
//  BoxAuthorizer
//
//  Created by Rony on 2018/1/17.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "FSAES128.h"
#import "NSData+AES128.h"

//#define IV  @"1234567890654321"
//#define  KEY  @"16BytesLengthKey"
#define count  16

@implementation FSAES128

/**
 *  加密
 *
 *  @param string 需要加密的string
 *
 *  @return 加密后的字符串
 */
+ (NSString *)AES128EncryptStrig:(NSString *)string keyStr:(NSString *)keyStr{
    NSString *iv = [JsonObject getRandomStringWithNum:count];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSData *aesData = [data AES128EncryptWithKey:keyStr iv:iv];
    NSData *ivData = [iv dataUsingEncoding:NSUTF8StringEncoding];
    Byte *ivByte = (Byte *)[ivData bytes];
    Byte *aesByte = (Byte *)[aesData bytes];
    NSMutableData * contentData = [[NSMutableData alloc]init];
    [contentData appendBytes:ivByte length:[ivData length]];
    [contentData appendBytes:aesByte length:[aesData length]];
    return [FSAES128 convertDataToHexStr:contentData];
}

/**
 *  解密
 *
 *  @param string 加密的字符串
 *
 *  @return 解密后的内容
 */
+ (NSString *)AES128DecryptString:(NSString *)string keyStr:(NSString *)keyStr{
    NSData *data  = [FSAES128 convertHexStrToData:string];
    NSRange range = NSMakeRange(0, count);
    NSRange aesRange = NSMakeRange(count, [data length] - count);
    NSData *ivData = [data subdataWithRange:range];
    NSData *aEsData = [data subdataWithRange:aesRange];
    NSString *iv = [[NSString alloc] initWithData:ivData encoding:NSUTF8StringEncoding];
    NSData *aesData = [aEsData AES128DecryptWithKey:keyStr iv:iv];
    return [[NSString alloc] initWithData:aesData encoding:NSUTF8StringEncoding];
}

//16进制转换为NSData
+ (NSData*)convertHexStrToData:(NSString*)str {
    if (!str || [str length] ==0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc]initWithCapacity:[str length]*2];
    NSRange range;
    if ([str length] %2==0) {
        range = NSMakeRange(0,2);
    } else {
        range = NSMakeRange(0,1);
    }
    for (NSInteger i = range.location; i < [str length]; i +=2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc]initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc]initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location+= range.length;
        range.length=2;
    }
    //    NSLog(@"hexdata: %@", hexData);
    return hexData;
}

//NSData转换为16进制
+ (NSString*)convertDataToHexStr:(NSData*)data {
    if (!data || [data length] ==0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc]initWithCapacity:[data length]/2];
    
    [data enumerateByteRangesUsingBlock:^(const void*bytes,NSRange byteRange,BOOL*stop) {
        unsigned char *dataBytes = (unsigned  char*)bytes;
        for (NSInteger i =0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] ==2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    
    return string;
}


@end
