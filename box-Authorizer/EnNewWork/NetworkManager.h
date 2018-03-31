//
//  NetworkManager.h
//  box-Staff-Manager
//
//  Created by Rony on 2018/2/26.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <Foundation/Foundation.h>

//请求成功回调block
typedef void (^requestSuccessBlock)(id responseObject);

//请求失败回调block
typedef void (^requestFailureBlock)(NSError *error);

//请求方法define
typedef enum {
    GET,
    POST,
    PUT,
    DELETE,
    HEAD
} HTTPMethod;

@interface NetworkManager : NSObject

+ (instancetype)shareInstance;

- (void)requestWithMethod:(HTTPMethod)method withUrl:(NSString *)url params:(NSDictionary *)params success:(requestSuccessBlock)successBlock fail:(requestFailureBlock)failBlock;


@end
