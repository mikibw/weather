//
//  WHMoonPhaseViewController.h
//  Weather
//
//  Created by Liang Tang on 2021/3/11.
//

#import <UIKit/UIKit.h>

@interface WHMoonPhaseViewController : UIViewController

@property (nonatomic, strong, readonly) RACReplaySubject *refresh;

@end
