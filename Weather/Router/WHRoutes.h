//
//  WHRoutes.h
//  Weather
//
//  Created by Liang Tang on 2021/3/10.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, WHRoute) {
    WHRouteGuide = 0,
    WHRouteGuide2,
    WHRouteGuide3,
    WHRouteWeather,
    WHRouteMe,
    WHRouteSubscribeGuide,//订阅引导
    WHRouteSubscribeStay,//订阅挽留
    WHRoutePostionSearch,//搜索
    WHRoutePostionSearchResult,//搜索城市
    WHRoutePravicy,//隐私政策
    WHRouteServiceItem,//服务条款
    WHRoutePopUp,
    WHRouteOption,
    WHRouteLifeIndexPopUp
};

@interface WHRoutes : NSObject
@property (nonatomic, assign, readonly) WHRoute route;
@property (nonatomic, strong, readonly) id parameters;
+ (instancetype)routesWithRoute:(WHRoute)route;
+ (instancetype)routesWithRoute:(WHRoute)route parameters:(id)parameters;
@end

FOUNDATION_EXPORT WHRoutes *routesInit(WHRoute to, id parameters);
