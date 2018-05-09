//
//  NetworkManager.m
//  box-Staff-Manager
//
//  Created by Rony on 2018/2/26.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "NetworkManager.h"

static NetworkManager *_networkManager;
static AFHTTPSessionManager *_manager;

@implementation NetworkManager

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _networkManager = [[self alloc] init];
    });
    return _networkManager;
}

- (AFHTTPSessionManager *)sharedHTTPSession {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [AFHTTPSessionManager manager];
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _manager.requestSerializer.timeoutInterval = 10;
        _manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];

        // 1.设置非校验证书模式 支持https（不校验证书，可以抓包查看）
        _manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        _manager.securityPolicy.allowInvalidCertificates = YES;
        _manager.securityPolicy.validatesDomainName=NO;
        
        /*
        // 2.设置证书模式 支持https（校验证书，不可以抓包)
        NSString * cerPath = [[NSBundle mainBundle] pathForResource:@"xxx" ofType:@"cer"];
        NSData * cerData = [NSData dataWithContentsOfFile:cerPath];
        _manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate withPinnedCertificates:[[NSSet alloc] initWithObjects:cerData, nil]];
        // 客户端是否信任非法证书
        _manager.securityPolicy.allowInvalidCertificates = YES;
        // 是否在证书域字段中验证域名
        [_manager.securityPolicy setValidatesDomainName:NO];
        */
        
    });
    return _manager;
}

- (void)requestWithMethod:(HTTPMethod)method withUrl:(NSString *)url params:(NSDictionary *)params success:(requestSuccessBlock)successBlock fail:(requestFailureBlock)failBlock
{
    url = [NSString stringWithFormat:@"%@%@",[BoxDataManager sharedManager].box_IP, url];
    NSLog(@"URL:---\n%@",url);
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    __weak AFHTTPSessionManager *manager = [self sharedHTTPSession];
    switch (method) {
        case GET:{
            [manager GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (successBlock) {
                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
                    NSLog(@"JSON: %@", dict);
                    successBlock(dict);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"Error: %@", error);
                 [ProgressHUD showStatus:10000];
                failBlock(error);
            }];
            break;
        }
        case POST:{
            [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {

            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (successBlock) {
                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
                    NSLog(@"JSON: %@", dict);
                    successBlock(dict);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"Error: %@", error);
                [ProgressHUD showStatus:10000];
                failBlock(error);
            }];
            
            break;
        }
        default:
            break;
    }
}


@end
