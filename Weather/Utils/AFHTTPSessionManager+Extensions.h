//
//  AFHTTPSessionManager+Extensions.h
//  Weather
//
//  Created by Liang Tang on 2021/3/11.
//

#import <AFNetworking/AFNetworking.h>

@interface AFHTTPSessionManager (Extensions)

- (RACSignal *)rac_GET:(NSString *)URLString parameters:(id)parameters;

@end

