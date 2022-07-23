//
//  WHLifeIndexViewModel.m
//  Weather
//
//  Created by Liang Tang on 2021/3/13.
//

#import "WHLifeIndexViewModel.h"
#import "WHWeatherNetwork.h"

@implementation WHLifeIndexViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        @weakify(self)
        _fetchLifeIndex = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(WHPositionModel * _Nullable x) {
            @strongify(self)
            return [[[[[[WHWeatherNetwork.sharedNetwork lifeIndexSignal:x.id] map:^id _Nullable(id  _Nullable x) {
                NSArray *results = [x objectForKey:@"results"];
                if (results.count == 0) return nil;
                return results.firstObject[@"suggestion"];
            }] mapObject:WHLifeIndexModel.class] map:^id _Nullable(WHLifeIndexModel * _Nullable x) {
                
                NSMutableArray *groups = [NSMutableArray array];
                
                WHLifeIndexGroupModel *group;
                NSMutableArray *items;
                
                group = WHLifeIndexGroupModel.new;
                group.category = @"基本类";
                items = [NSMutableArray array];
                if (x.dressing) {
                    x.dressing.name = @"穿衣";
                    [items addObject:x.dressing];
                }
                if (x.uv) {
                    x.uv.name = @"紫外线强度";
                    [items addObject:x.uv];
                }
                if (x.car_washing) {
                    x.car_washing.name = @"洗车";
                    [items addObject:x.car_washing];
                }
                if (x.travel) {
                    x.travel.name = @"旅游";
                    [items addObject:x.travel];
                }
                if (x.flu) {
                    x.flu.name = @"感冒";
                    [items addObject:x.flu];
                }
                if (x.sport) {
                    x.sport.name = @"运动";
                    [items addObject:x.sport];
                }
                group.items = items;
                [groups addObject:group];
                
                group = WHLifeIndexGroupModel.new;
                group.category = @"交通类";
                items = [NSMutableArray array];
                if (x.traffic) {
                    x.traffic.name = @"交通";
                    [items addObject:x.traffic];
                }
                if (x.road_condition) {
                    x.road_condition.name = @"路况";
                    [items addObject:x.road_condition];
                }
                group.items = items;
                [groups addObject:group];
                
                group = WHLifeIndexGroupModel.new;
                group.category = @"生活类";
                items = [NSMutableArray array];
                if (x.airing) {
                    x.airing.name = @"晾晒";
                    [items addObject:x.airing];
                }
                if (x.umbrella) {
                    x.umbrella.name = @"雨伞";
                    [items addObject:x.umbrella];
                }
                if (x.ac) {
                    x.ac.name = @"空调开启";
                    [items addObject:x.ac];
                }
                if (x.beer) {
                    x.beer.name = @"啤酒";
                    [items addObject:x.beer];
                }
                if (x.shopping) {
                    x.shopping.name = @"逛街";
                    [items addObject:x.shopping];
                }
                if (x.night_life) {
                    x.night_life.name = @"夜生活";
                    [items addObject:x.night_life];
                }
                if (x.dating) {
                    x.dating.name = @"约会";
                    [items addObject:x.dating];
                }
                group.items = items;
                [groups addObject:group];
                
                group = WHLifeIndexGroupModel.new;
                group.category = @"运动类";
                items = [NSMutableArray array];
                if (x.morning_sport) {
                    x.morning_sport.name = @"晨练";
                    [items addObject:x.morning_sport];
                }
                if (x.fishing) {
                    x.fishing.name = @"钓鱼";
                    [items addObject:x.fishing];
                }
                if (x.boating) {
                    x.boating.name = @"划船";
                    [items addObject:x.boating];
                }
                if (x.kiteflying) {
                    x.kiteflying.name = @"放风筝";
                    [items addObject:x.kiteflying];
                }
                group.items = items;
                [groups addObject:group];
                
                group = WHLifeIndexGroupModel.new;
                group.category = @"健康类";
                items = [NSMutableArray array];
                if (x.allergy) {
                    x.allergy.name = @"过敏";
                    [items addObject:x.allergy];
                }
                if (x.hair_dressing) {
                    x.hair_dressing.name = @"美发";
                    [items addObject:x.hair_dressing];
                }
                if (x.makeup) {
                    x.makeup.name = @"化妆";
                    [items addObject:x.makeup];
                }
                if (x.chill) {
                    x.chill.name = @"风寒";
                    [items addObject:x.chill];
                }
                if (x.sunscreen) {
                    x.sunscreen.name = @"防晒";
                    [items addObject:x.sunscreen];
                }
                if (x.air_pollution) {
                    x.air_pollution.name = @"空气污染扩散条件";
                    [items addObject:x.air_pollution];
                }
                if (x.comfort) {
                    x.comfort.name = @"舒适度";
                    [items addObject:x.comfort];
                }
                if (x.mood) {
                    x.mood.name = @"心情";
                    [items addObject:x.mood];
                }
                group.items = items;
                [groups addObject:group];
                
                return groups;
            }] catchTo: [RACSignal return:nil]] doNext:^(id  _Nullable x) {
                @strongify(self)
                self->_groups = x;
            }];
        }];
    }
    return self;
}

@end
