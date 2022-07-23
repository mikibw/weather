//
//  WHRoutes.m
//  Weather
//
//  Created by Liang Tang on 2021/3/10.
//

#import "WHRoutes.h"

@implementation WHRoutes

+ (instancetype)routesWithRoute:(WHRoute)route
{
    return [self routesWithRoute:route parameters:nil];
}

+ (instancetype)routesWithRoute:(WHRoute)route parameters:(id)parameters
{
    WHRoutes *routes = [[WHRoutes alloc] init];
    routes->_route = route;
    routes->_parameters = parameters;
    return routes;
}

@end

WHRoutes *routesInit(WHRoute to, id parameters) {
    return [WHRoutes routesWithRoute:to parameters:parameters];
}

