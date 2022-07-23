//
//  AFHTTPSessionManager+Extensions.m
//  Weather
//
//  Created by Liang Tang on 2021/3/11.
//

#import "AFHTTPSessionManager+Extensions.h"

static NSErrorDomain const domain = @"domain.weather";
static NSInteger const code = -8888;

@implementation AFHTTPSessionManager (Extensions)

- (RACSignal *)rac_GET:(NSString *)URLString parameters:(id)parameters
{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionDataTask *t = [self GET:URLString parameters:parameters headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
            if (response.statusCode >= 200 && response.statusCode < 300) {
                [subscriber sendNext:responseObject];
                [subscriber sendCompleted];
            } else {
                NSDictionary * userInfo = @{
                    @"statusCode": @(response.statusCode),
                    @"responseObject": responseObject ?: @{}
                };
                [subscriber sendError:[NSError errorWithDomain:domain code:code userInfo:userInfo]];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [subscriber sendError:error];
        }];
        return [RACDisposable disposableWithBlock:^{ [t cancel]; }];
    }];
}

@end
