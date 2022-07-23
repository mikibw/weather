//
//  WH24HoursForecastViewController.h
//  Weather
//
//  Created by Liang Tang on 2021/3/11.
//

#import <UIKit/UIKit.h>

@interface WH24HoursForecastViewController : UIViewController
@property (nonatomic, strong, readonly) RACReplaySubject *refresh;
@end
