//
//  BlueToothListModel.m
//  box-Authorizer
//
//  Created by Yu Huang on 2018/3/13.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "BlueToothListModel.h"

@implementation BlueToothListModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        if(![dict[@"peripheral"] isKindOfClass:[NSNull class]]){
            CBPeripheral *peripheral = dict[@"peripheral"];
            self.blueTooth = peripheral.name;
        }
        self.isSelect = NO;
    }
    return self;
}

@end
