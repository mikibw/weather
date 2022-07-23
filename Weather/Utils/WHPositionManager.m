//
//  WHPositionManager.m
//  Weather
//
//  Created by Liang Tang on 2021/3/19.
//

#import "WHPositionManager.h"
#import "WHWeatherNetwork.h"

@interface WHPositionManager ()<CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocation *loc;
@property (nonatomic, strong) CLLocationManager *locManager;
@property (nonatomic, strong) RACSubject *positionChanged;
@end

@implementation WHPositionManager

- (CLLocationManager *)locManager
{
    if (!_locManager) {
        _locManager = [[CLLocationManager alloc] init];
        _locManager.distanceFilter = kCLLocationAccuracyHundredMeters;
        _locManager.delegate = self;
    }
    return _locManager;
}

- (RACSubject *)positionChanged
{
    if (!_positionChanged) {
        _positionChanged = [RACSubject subject];
    }
    return _positionChanged;
}

- (RACSignal *)rac_positionChanged
{
    @weakify(self)
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self)
        id disposable = [self.positionChanged subscribeNext:^(id  _Nullable x) {
            [subscriber sendNext:x];
            [subscriber sendCompleted];
        }];
        [self startUpdatingLocationIfNeeded];
        return disposable;
    }];
}

- (void)startUpdatingLocationIfNeeded
{
    CLAuthorizationStatus status;
    if (@available(iOS 14.0, *)) {
        status = self.locManager.authorizationStatus;
    } else {
        status = CLLocationManager.authorizationStatus;
    }
    switch (status) {
        case kCLAuthorizationStatusRestricted:
        case kCLAuthorizationStatusDenied:
            [self.positionChanged sendNext:nil];
            break;
        case kCLAuthorizationStatusNotDetermined:
            [self.locManager requestAlwaysAuthorization];
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            [self.locManager startUpdatingLocation];
            break;
    }
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManagerDidChangeAuthorization:(CLLocationManager *)manager
{
    [self startUpdatingLocationIfNeeded];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    [manager stopUpdatingLocation];
    
    if (self.loc) return;
    
    self.loc = locations.firstObject;
    if (self.loc) {
        NSString *loc = [NSString stringWithFormat:@"%f:%f",
                         self.loc.coordinate.latitude, self.loc.coordinate.longitude];
        @weakify(self)
        [[[[[WHWeatherNetwork.sharedNetwork postionSignal:loc limit:1]
            map:^id _Nullable(id  _Nullable value) {
                NSArray *results = [value objectForKey:@"results"];
                return results.firstObject;
            }]
           mapObject:WHPositionModel.class]
          catchTo:[RACSignal return:nil]]
         subscribeNext:^(WHPositionModel * _Nullable x) {
            @strongify(self)
            [self.positionChanged sendNext:x];
            self.loc = nil;
         }];
    } else {
        [self.positionChanged sendNext:nil];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [manager stopUpdatingLocation];
    
    [self.positionChanged sendNext:nil];
}

@end
