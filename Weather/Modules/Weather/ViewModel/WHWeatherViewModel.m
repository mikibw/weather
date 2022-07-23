//
//  WHWeatherViewModel.m
//  Weather
//
//  Created by Liang Tang on 2021/3/10.
//

#import "WHWeatherViewModel.h"
#import "WHWeatherNetwork.h"

@interface WHWeatherViewModel () <CLLocationManagerDelegate>
@property (nonatomic, strong) WHPositionManager *positionManager;
@end

@implementation WHWeatherViewModel

- (WHPositionManager *)positionManager
{
    if (!_positionManager) {
        _positionManager = [[WHPositionManager alloc] init];
    }
    return _positionManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        @weakify(self)
        
        _fetchPostion = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self)
            return [self.positionManager.rac_positionChanged map:^id _Nullable(id  _Nullable position) {
                if (position) {
                    //保存定位地址
                    [WHPositionStorage.sharedStorage storePosition:position];
                    WHPositionStorage.sharedStorage.locationPosition = position;
                    return position;
                } else {
                    position = WHPositionStorage.sharedStorage.storedPosition;
                    return position ? position : WHPositionStorage.sharedStorage.defaultPosition;
                }
            }];
        }];
    }
    return self;    
}

@end
