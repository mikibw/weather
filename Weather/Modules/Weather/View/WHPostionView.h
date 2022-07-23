//
//  WHPostionView.h
//  Weather
//
//  Created by Liang Tang on 2021/3/10.
//

#import "WHNibView.h"

@interface WHPostionView : WHNibView
@property (nonatomic, copy) void (^onSearch)(void);
- (void)setPosition:(WHPositionModel *)position;
@end
