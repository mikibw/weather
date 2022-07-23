//
//  UITableViewCell+Extensions.m
//  Weather
//
//  Created by Liang Tang on 2021/3/19.
//

#import "UITableViewCell+Extensions.h"
#import "WHWeatherNetwork.h"

@interface WHCacheMapper : NSObject

@property (nonatomic, strong) NSMutableDictionary *weatherMapper;
@property (nonatomic, strong) NSMutableDictionary *disposableMapper;
@property (nonatomic, strong) NSMutableDictionary *completionMapper;

@end

@implementation WHCacheMapper

+ (instancetype)sharedMapper
{
    static WHCacheMapper *mapper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mapper = [[WHCacheMapper alloc] init];
    });
    return mapper;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _weatherMapper = [[NSMutableDictionary alloc] init];
        _disposableMapper = [[NSMutableDictionary alloc] init];
        _completionMapper = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (WHRealtimeInfoModel *)getWeather:(NSString *)loc
{
    if (!loc) return nil;
    return self.weatherMapper[loc];
}

- (void)setWeather:(WHRealtimeInfoModel *)weather forKey:(NSString *)loc
{
    if (!loc) return;
    if (weather) {
        self.weatherMapper[loc] = weather;
    } else {
        [self.weatherMapper removeObjectForKey:loc];
    }
}

- (RACDisposable *)getDisposable:(NSString *)loc
{
    if (!loc) return nil;
    return self.disposableMapper[loc];
}

- (void)setDisposable:(RACDisposable *)disposable forKey:(NSString *)loc
{
    if (!loc) return;
    if (disposable) {
        self.disposableMapper[loc] = disposable;
    } else {
        [self.disposableMapper removeObjectForKey:loc];
    }
}

- (void (^)(WHRealtimeInfoModel *))getCompletion:(NSString *)loc
{
    if (!loc) return nil;
    return self.completionMapper[loc];
}

- (void)setCompletion:(void (^)(WHRealtimeInfoModel *))completion forKey:(NSString *)loc
{
    if (!loc) return;
    if (completion) {
        self.completionMapper[loc] = completion;
    } else {
        [self.completionMapper removeObjectForKey:loc];
    }
}

@end

@implementation UITableViewCell (Extensions)

- (void)setRealtimeWeatherWithPosition:(WHPositionModel *)position
                                before:(void (^)(void))before
                            completion:(void (^)(WHRealtimeInfoModel *))completion
{
    WHRealtimeInfoModel *weather = [WHCacheMapper.sharedMapper getWeather:position.id];
    if (weather) {
        !completion ?: completion(weather);
        return;
    }
    
    !before ?: before();
    
    [WHCacheMapper.sharedMapper setCompletion:completion forKey:position.id];
    
    RACDisposable *disposable = [WHCacheMapper.sharedMapper getDisposable:position.id];
    if (disposable) return;
    
    disposable = [[[WHWeatherNetwork.sharedNetwork realtimeInfoSignal:position.id]
                        catchTo:[RACSignal return:nil]]
                       subscribeNext:^(id x) {
        NSArray *results = [x objectForKey:@"results"];
        NSDictionary *keyValues = results.firstObject[@"now"];
        WHRealtimeInfoModel *weather = [WHRealtimeInfoModel mj_objectWithKeyValues:keyValues];
        [WHCacheMapper.sharedMapper setWeather:weather forKey:position.id];
        [WHCacheMapper.sharedMapper setDisposable:nil forKey:position.id];
        void (^_completion)(WHRealtimeInfoModel *) = [WHCacheMapper.sharedMapper getCompletion:position.id];
        if (_completion) _completion(weather);
        [WHCacheMapper.sharedMapper setCompletion:nil forKey:position.id];
    }];
    [WHCacheMapper.sharedMapper setDisposable:disposable forKey:position.id];
}

@end
