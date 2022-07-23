//
//  RACSignal+Extensions.h
//  Weather
//
//  Created by Liang Tang on 2021/3/11.
//

#import <ReactiveObjC/ReactiveObjC.h>

@interface RACSignal (Extensions)

- (RACSignal *)mapObject:(Class)objectClass;
- (RACSignal *)mapObjectArray:(Class)objectClass;

@end

