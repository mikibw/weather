//
//  WHGrandientButton.m
//  Weather
//
//  Created by Liang Tang on 2021/3/9.
//

#import "WHGrandientButton.h"

@interface WHGrandientButton ()
@property (nonatomic, weak) CAGradientLayer *grandientLayer;
@end

@implementation WHGrandientButton

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    self.layer.shadowColor = UIColor.shadowColor.CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 2.5);
    self.layer.shadowOpacity = 1;
    self.layer.shadowRadius = 7;
    
    CAGradientLayer *grandientLayer = [CAGradientLayer layer];
    grandientLayer.colors = @[
        (__bridge id)[UIColor colorWithHex:0x047bff alpha:1.0].CGColor,
        (__bridge id)[UIColor colorWithHex:0x669eff alpha:1.0].CGColor
    ];
    grandientLayer.locations = @[@(0), @(1.0f)];
    grandientLayer.startPoint = CGPointMake(1, 0.5);
    grandientLayer.endPoint = CGPointMake(0.03, 0.5);
    [self.layer insertSublayer:grandientLayer atIndex:0];
    
    self.grandientLayer = grandientLayer;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.grandientLayer.masksToBounds = YES;
    self.grandientLayer.frame = self.bounds;
    self.layer.cornerRadius = self.grandientLayer.cornerRadius = self.bounds.size.height / 2;
}

@end
