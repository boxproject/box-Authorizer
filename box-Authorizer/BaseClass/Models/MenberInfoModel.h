//
//  MenberInfoModel.h
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/4/7.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenberInfoModel : NSObject
/** 员工Id */
@property (nonatomic,strong) NSString *menber_id;
/** 员工账号 */
@property (nonatomic,strong) NSString *menber_account;
/** 员工公钥 */
@property (nonatomic,strong) NSString *publicKey;
/** 直系下属员工固定随机值 */
@property (nonatomic,strong) NSString *menber_random;
/** 是否是直系下属 1-YES 0-NO  */
@property (nonatomic,assign) NSInteger directIdentify;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
