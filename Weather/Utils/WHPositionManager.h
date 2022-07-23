//
//  WHPositionManager.h
//  Weather
//
//  Created by Liang Tang on 2021/3/19.
//

#import <Foundation/Foundation.h>

@interface WHPositionManager : NSObject

- (RACSignal <WHPositionModel *> *)rac_positionChanged;

@end
