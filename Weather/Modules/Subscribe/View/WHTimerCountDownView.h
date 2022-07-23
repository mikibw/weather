//
//  WHTimerCountDownView.h
//  Weather
//
//  Created by shoujian on 2021/3/11.
//

#import <UIKit/UIKit.h>
typedef void(^TimerCountDownCompletion)(void);
NS_ASSUME_NONNULL_BEGIN

@interface WHTimerCountDownView : UIView
- (instancetype)initTimeNum:(CGFloat)timeNum frame:(CGRect)frame completion:(TimerCountDownCompletion)completion;

@end

NS_ASSUME_NONNULL_END
