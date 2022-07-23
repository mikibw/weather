//
//  WH5DaysForecastViewController.h
//  Weather
//
//  Created by Liang Tang on 2021/3/11.
//

#import <UIKit/UIKit.h>

@interface WH5DaysForecastViewController : UIViewController
@property (nonatomic, strong, readonly) RACReplaySubject *refresh;
@end

