//
//  MenberInfoManager.h
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/4/7.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MenberInfoModel.h"

@interface MenberInfoManager : NSObject

+(instancetype)sharedManager;
- (NSMutableArray *)loadMenberInfo:(NSString *)menberId;
- (BOOL)createMenberInfoTable;
- (BOOL)deleteMenberInfoModel:(MenberInfoModel *)model;
- (BOOL)updateMenberInfoModel:(MenberInfoModel *)model;
- (BOOL)insertMenberInfoModel:(MenberInfoModel *)model;

@end
