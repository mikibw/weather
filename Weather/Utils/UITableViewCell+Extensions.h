//
//  UITableViewCell+Extensions.h
//  Weather
//
//  Created by Liang Tang on 2021/3/19.
//

#import <UIKit/UIKit.h>
#import "WHRealtimeInfoModel.h"

@interface UITableViewCell (Extensions)

- (void)setRealtimeWeatherWithPosition:(WHPositionModel *)position
                                before:(void (^)(void))before
                            completion:(void (^)(WHRealtimeInfoModel *info))completion;

@end

