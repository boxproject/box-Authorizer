//
//  BoxDataManager.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/3/31.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "BoxDataManager.h"

@interface BoxDataManager()

@end

@implementation BoxDataManager

+(instancetype)sharedManager{
    static dispatch_once_t onceToken;
    static BoxDataManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[BoxDataManager alloc] init];
    });
    return instance;
}

- (instancetype)init{
    if(self = [super init]){
    }
    return self;
}

-(void)getAllData
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.box_IP = [defaults valueForKey:@"box_IP"];
    self.applyer_id = [defaults valueForKey:@"applyer_id"];
    self.app_account_id = [defaults valueForKey:@"applyer_id"];
    self.applyer_account = [defaults valueForKey:@"applyer_account"];
    self.publicKeyBase64 = [defaults valueForKey:@"publicKeyBase64"];
    self.privateKeyBase64 = [defaults valueForKey:@"privateKeyBase64"];
    self.launchState = [[defaults valueForKey:@"launchState"] integerValue];
    self.passWord = [defaults valueForKey:@"passWord"];
    self.app_account_random = [defaults valueForKey:@"app_account_random"];
    self.Address = [defaults valueForKey:@"Address"];
    self.ContractAddress = [defaults valueForKey:@"ContractAddress"];
    self.KeyStoreStatus = [defaults valueForKey:@"KeyStoreStatus"];
    self.randomValue = [defaults valueForKey:@"randomValue"];
    self.box_IpPort = [defaults valueForKey:@"box_IpPort"];
    self.codePassWord = [defaults valueForKey:@"codePassWord"];
}


-(void)removeDataWithCoding:(NSString *)coding
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:coding];
    [defaults synchronize];
    if ([coding isEqualToString:@"codePassWord"]){
        self.codePassWord = nil;
    }
}

-(void)saveDataWithCoding:(NSString *)coding codeValue:(NSString *)codeValue
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([coding isEqualToString:@"box_IP"]) {
        self.box_IP = codeValue;
    }else if ([coding isEqualToString:@"applyer_id"]){
        self.applyer_id = codeValue;
        self.app_account_id = codeValue;
    }else if ([coding isEqualToString:@"applyer_account"]){
        self.applyer_account = codeValue;
    }else if ([coding isEqualToString:@"publicKeyBase64"]){
        self.publicKeyBase64 = codeValue;
    }else if ([coding isEqualToString:@"privateKeyBase64"]){
        self.privateKeyBase64 = codeValue;
    }else if ([coding isEqualToString:@"launchState"]){
        self.launchState = [codeValue integerValue];
    }else if ([coding isEqualToString:@"passWord"]){
        self.passWord = codeValue;
    }else if ([coding isEqualToString:@"app_account_random"]){
        self.app_account_random = codeValue;
    }else if ([coding isEqualToString:@"Address"]){
        self.Address = codeValue;
    }else if ([coding isEqualToString:@"ContractAddress"]){
        self.ContractAddress = codeValue;
    }else if ([coding isEqualToString:@"KeyStoreStatus"]){
        self.KeyStoreStatus = codeValue;
    }else if ([coding isEqualToString:@"randomValue"]){
        self.randomValue = codeValue;
    }else if ([coding isEqualToString:@"box_IpPort"]){
        self.box_IpPort = codeValue;
    }else if ([coding isEqualToString:@"codePassWord"]){
        self.codePassWord = codeValue;
    }
    [defaults setObject:codeValue forKey: coding];
    [defaults synchronize];
}


@end
