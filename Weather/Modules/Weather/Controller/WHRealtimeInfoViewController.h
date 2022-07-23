//
//  WHRealtimeInfoViewController.h
//  Weather
//
//  Created by Liang Tang on 2021/3/10.
//

#import <UIKit/UIKit.h>

@interface WHRealtimeInfoViewController : UIViewController

@property (nonatomic, strong, readonly) RACReplaySubject *refresh;

@property (nonatomic, strong, readonly) RACReplaySubject *dataChanged;

@end

