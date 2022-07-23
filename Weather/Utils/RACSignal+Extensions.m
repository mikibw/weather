//
//  RACSignal+Extensions.m
//  Weather
//
//  Created by Liang Tang on 2021/3/11.
//

#import "RACSignal+Extensions.h"

@implementation RACSignal (Extensions)

- (RACSignal *)mapObject:(Class)objectClass
{
    return [self map:^id _Nullable(id  _Nullable value) {
        return [objectClass mj_objectWithKeyValues:value];
    }];
}

- (RACSignal *)mapObjectArray:(Class)objectClass
{
    return [self map:^id _Nullable(id  _Nullable value) {
        return [objectClass mj_objectArrayWithKeyValuesArray:value];
    }];
}

@end
