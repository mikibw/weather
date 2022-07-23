//
//  WHNibView.m
//  Weather
//
//  Created by Liang Tang on 2021/3/10.
//

#import "WHNibView.h"

@interface WHNibView ()
@property (nonatomic, strong) UIView *contentView;
@end

@implementation WHNibView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    self.backgroundColor = UIColor.clearColor;
    
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    UINib *nib = [UINib nibWithNibName:NSStringFromClass(self.class) bundle:bundle];
    
    self.contentView = [nib instantiateWithOwner:self options:nil].firstObject;
    [self addSubview:self.contentView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.contentView.frame = self.bounds;
}

@end
