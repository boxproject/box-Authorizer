//
//  MenberInfoManager.h
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/4/7.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MemberInfoModel.h"

@interface MemberInfoManager : NSObject

+(instancetype)sharedManager;
- (NSMutableArray *)loadMenberInfo:(NSString *)menberId;
- (BOOL)createMenberInfoTable;
- (BOOL)deleteMenberInfoModel:(MemberInfoModel *)model;
- (BOOL)updateMenberInfoModel:(MemberInfoModel *)model;
- (BOOL)insertMenberInfoModel:(MemberInfoModel *)model;

@end
