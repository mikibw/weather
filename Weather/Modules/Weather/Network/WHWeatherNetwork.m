//
//  WHWeatherNetwork.m
//  Weather
//
//  Created by Liang Tang on 2021/3/11.
//

#import "WHWeatherNetwork.h"

@interface WHWeatherNetwork ()<NSURLSessionDelegate>
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@end

@implementation WHWeatherNetwork

+ (instancetype)sharedNetwork
{
    static WHWeatherNetwork *network;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        network = [[WHWeatherNetwork alloc] init];
    });
    return network;
}

- (AFHTTPSessionManager *)manager
{
    if (!_manager) {
        NSURL *baseURL = [NSURL URLWithString:@"https://api.seniverse.com/v3"];
        _manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    }
    return _manager;
}

- (NSDictionary *)parameters:(NSString *)loc
{
    return @{@"key": @"SJVMIbslsLqxfGYwk", @"location": loc};
}

- (RACSignal *)postionSignal:(NSString *)loc limit:(int)limit
{
    NSMutableDictionary *parameters = [self parameters:loc].mutableCopy;
    [parameters removeObjectForKey:@"location"];
    [parameters setObject:loc forKey:@"q"];
    [parameters setObject:@(limit) forKey:@"limit"];
    return [self.manager rac_GET:@"/v3/location/search.json" parameters:parameters];
}

- (RACSignal *)realtimeInfoSignal:(NSString *)loc
{
    return [self.manager rac_GET:@"/v3/weather/now.json" parameters:[self parameters:loc]];
}

- (RACSignal *)h24ForecastSignal:(NSString *)loc
{
    NSMutableDictionary *parameters = [self parameters:loc].mutableCopy;
    [parameters setObject:@24 forKey:@"hours"];
    return [self.manager rac_GET:@"/v3/weather/hourly.json" parameters:parameters];
}

- (RACSignal *)futureDaysForecastSignal:(NSString *)loc days:(int)days
{
    NSMutableDictionary *parameters = [self parameters:loc].mutableCopy;
    [parameters setObject:@(days) forKey:@"days"];
    return [self.manager rac_GET:@"/v3/weather/daily.json" parameters:parameters];
}

- (RACSignal *)airQualitySignal:(NSString *)loc
{
    return [self.manager rac_GET:@"/v3/air/now.json" parameters:[self parameters:loc]];
}

- (RACSignal *)sunSignal:(NSString *)loc days:(int)days
{
    NSMutableDictionary *parameters = [self parameters:loc].mutableCopy;
    [parameters setObject:@(days) forKey:@"days"];
    return [self.manager rac_GET:@"/v3/geo/sun.json" parameters:parameters];
}

- (RACSignal *)realtimeRainForecastSignal:(NSString *)loc
{
    return [self.manager rac_GET:@"/v3/weather/grid/minutely.json" parameters:[self parameters:loc]];
}

- (RACSignal *)moonPhaseSignal:(NSString *)loc days:(int)days
{
    NSMutableDictionary *parameters = [self parameters:loc].mutableCopy;
    [parameters setObject:@(days) forKey:@"days"];
    return [self.manager rac_GET:@"/v3/geo/moon.json" parameters:parameters];
}

- (RACSignal *)trafficRestrictionSignal:(NSString *)loc
{
    return [self.manager rac_GET:@"/v3/life/driving_restriction.json" parameters:[self parameters:loc]];
}

- (RACSignal *)searchCitySignal:(NSString *)q limit:(int)limit
{
    NSMutableDictionary *parameters = [self parameters:q].mutableCopy;
    [parameters removeObjectForKey:@"location"];
    [parameters setObject:q forKey:@"q"];
    if (limit>0) {
        [parameters setObject:@(limit) forKey:@"limit"];
    }
//    [parameters setObject:@"zh-Hans" forKey:@"language"];
    return [self.manager rac_GET:@"/v3/location/search.json" parameters:parameters];
}
- (RACSignal *)lifeIndexSignal:(NSString *)loc
{
    return [self.manager rac_GET:@"/v3/life/suggestion.json" parameters:[self parameters:loc]];
}

- (RACSignal *)disasterWarningSignal:(NSString *)loc
{
    return [self.manager rac_GET:@"/v3/weather/alarm.json" parameters:[self parameters:loc]];
}

- (RACSignal *)subscribeVersionSignal:(NSString *)vv app:(NSString *)app
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setObject:vv forKey:@"vv"];
    [parameters setObject:app forKey:@"app"];
    
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[[NSOperationQueue alloc]init]];
        NSString *url = [NSString stringWithFormat:@"http://version.control.etolled.xyz/translate_config?app=%@&vv=%@",app,vv];
        NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:req completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    [subscriber sendNext:error];
                } else {
                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                    [subscriber sendNext:dict];
                    [subscriber sendCompleted];
                }
            });
        }];
        [task resume];
        
        return [RACDisposable disposableWithBlock:^{ [task cancel]; }];
    }];
        
    return signal;
}

#pragma mark - NSURLSessionDelegate
- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
    
    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    __block NSURLCredential *credential = nil;
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        if (credential) {
            disposition = NSURLSessionAuthChallengeUseCredential;
        } else {
            disposition = NSURLSessionAuthChallengePerformDefaultHandling;
        }
    } else {
        disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    }
    
    if (completionHandler) {
        completionHandler(disposition, credential);
    }
}


@end
