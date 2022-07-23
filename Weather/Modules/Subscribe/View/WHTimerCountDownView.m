//
//  WHTimerCountDownView.m
//  Weather
//
//  Created by shoujian on 2021/3/11.
//

#import "WHTimerCountDownView.h"
@interface WHTimerCountDownView()
{
    CGFloat midValue;
}
@property (nonatomic,copy) TimerCountDownCompletion completion;
@property (nonatomic,assign) CGFloat timeNum;
@property (nonatomic,assign) CGFloat labelTime;
@property (nonatomic,assign) CGRect viewFrame;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) CAShapeLayer *shapeLayer;
@property (nonatomic,strong) UILabel *timeLabel;
@end
@implementation WHTimerCountDownView

- (instancetype)initTimeNum:(CGFloat)timeNum frame:(CGRect)frame completion:(nonnull TimerCountDownCompletion)completion{
    self = [super init];
    if (self){
        midValue = 0;
        self.completion = completion;
        self.timeNum = timeNum;
        self.viewFrame = frame;
        self.labelTime = timeNum * 10;
        [self createTImer];
        [self drawRound];
        [self createTimeLabel];
    }
    return self;
}

#pragma mark 创建定时器
- (void)createTImer{
    self.timer = [NSTimer timerWithTimeInterval:0.1
                                         target:self
                                       selector:@selector(timerSelectedEvents)
                                       userInfo:nil
                                        repeats:YES];
    [self.timer fire];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

#pragma mark 贝塞尔曲线画圆
- (void)drawRound{
    CGFloat Width = MIN(self.viewFrame.size.width, self.viewFrame.size.height);
    self.shapeLayer = [CAShapeLayer layer];
    self.shapeLayer.frame = CGRectMake(0, 0, Width, Width);
    self.shapeLayer.fillColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.5].CGColor;
    self.shapeLayer.lineWidth = 2.0f;
    self.shapeLayer.strokeColor = [UIColor greenColor].CGColor;
    self.shapeLayer.strokeStart = 0;
    self.shapeLayer.strokeEnd = 0;

    UIBezierPath *backGroungPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, Width, Width)];
    self.shapeLayer.path = backGroungPath.CGPath;
    [self.layer addSublayer:self.shapeLayer];
}

#pragma mark 显示时间
- (void)createTimeLabel{
    self.timeLabel = [UILabel new];
    self.timeLabel.font = [UIFont systemFontOfSize:20.0f];
    CGFloat Width = MIN(self.viewFrame.size.width, self.viewFrame.size.height);
    self.timeLabel.frame = CGRectMake(0, 0, Width, Width);
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.timeLabel];
}

- (void)timerSelectedEvents{
    CGFloat t = self.timeNum/0.1;
    CGFloat m = 1/t;
    midValue += m;
//    NSLog(@"StrokeEnd:%f",self.shapeLayer.strokeEnd);
    CGFloat tt = self.labelTime / 10;
    if (tt<= 0.1){//这个地方有误差，这个操作是使误差归零
        tt = 0;
    }
    self.timeLabel.text = [NSString stringWithFormat:@"%.fs",tt];
    self.shapeLayer.strokeEnd = midValue;
    if (self.shapeLayer.strokeEnd >= 1){
        [self.timer invalidate];
        self.timer = nil;
        if (self.completion) {
            self.completion();
        }
        [self removeFromSuperview];
    }
    self.labelTime = self.labelTime - 1;
}


@end
