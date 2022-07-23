//
//  WHPositionStorage.h
//  Weather
//
//  Created by Liang Tang on 2021/3/11.
//

#import <Foundation/Foundation.h>
#import "WHPositionModel.h"

@interface WHPositionStorage : NSObject

+ (instancetype)sharedStorage;
@property (nonatomic,strong) WHPositionModel *locationPosition;
- (WHPositionModel *)defaultPosition;
- (WHPositionModel *)storedPosition;
- (void)storePosition:(WHPositionModel *)position;
- (NSArray <WHPositionModel *> *)storedPostions;
- (void)storePositions:(NSArray <WHPositionModel *> *)postions;
@end
