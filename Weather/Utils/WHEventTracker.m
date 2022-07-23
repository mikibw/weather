//
//  WHEventTracker.m
//  Weather
//
//  Created by Liang Tang on 2021/3/22.
//

#import "WHEventTracker.h"
#import <UICKeyChainStore/UICKeyChainStore.h>

@interface WHEventTracker ()
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@end

@interface WHEventTracker ()
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *userAgent;
@end

@implementation WHEventTracker

+ (instancetype)sharedTracker
{
    static WHEventTracker *_tracker;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _tracker = [[WHEventTracker alloc] init];
    });
    return _tracker;
}

- (AFHTTPSessionManager *)manager
{
    if (!_manager) {
        NSURL *baseURL = [NSURL URLWithString:@"http://maidian.etolled.xyz"];
        _manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
        _manager.responseSerializer = AFHTTPResponseSerializer.serializer;
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    }
    return _manager;
}

- (void)openApp
{
    [self logEvent:@"open"];
}

- (void)enterSellPage
{
    [self logEvent:@"sellpage"];
}

- (void)clickSubscribeButton
{
    [self logEvent:@"click_buby"];
}

- (void)subscribeSuccess
{
    [self logEvent:@"buy_success"];
}

- (void)logEvent:(NSString *)event
{
    [self.manager POST:@"/save.php" parameters:@{
        @"uid": self.uid,
        @"sub_type": @"weather-a",
        @"key": event,
        @"event_time": self.logTime,
        @"remark": self.userAgent
    } headers:nil constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

- (NSString *)logTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [formatter stringFromDate:NSDate.date];
}

- (NSString *)uid
{
    if (!_uid) {
        
        NSString *uidKey = @"uid";
        
        UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"cn.weather.uid"];
        _uid = [keychain stringForKey:uidKey];
        
        if (!_uid) {
            _uid = NSUUID.UUID.UUIDString;
            [keychain setString:_uid forKey:uidKey];
        }
    }
    return _uid;
}

- (NSString *)userAgent
{
    if (!_userAgent) {
        _userAgent = [NSString stringWithFormat:@"%@/%@ (%@; iOS %@; Scale/%0.2f)", [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleExecutableKey] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleIdentifierKey], [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleVersionKey], [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion], [[UIScreen mainScreen] scale]];
    }
    return _userAgent;
}

@end
