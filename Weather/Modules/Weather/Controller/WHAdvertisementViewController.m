//
//  WHAdvertisementViewController.m
//  Weather
//
//  Created by Liang Tang on 2021/3/14.
//

#import "WHAdvertisementViewController.h"
#import <BUAdSDK/BUNativeExpressBannerView.h>

@interface WHAdvertisementViewController () <BUNativeExpressBannerViewDelegate>
@property(nonatomic, strong) BUNativeExpressBannerView *banner;
@property (nonatomic, strong) RACDisposable *disposable;
@end

@implementation WHAdvertisementViewController

- (void)dealloc
{
    [self.disposable dispose];
    self.disposable = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.hidden = YES;
    
    switch (self.adtype) {
        case WHAdvertisementTypeFeed:
            self.view.backgroundColor = UIColor.whiteColor;
            self.view.layer.cornerRadius = 14;
            break;
        case WHAdvertisementTypeBanner:
            self.view.backgroundColor = UIColor.clearColor;
            break;
    }
    
    @weakify(self)
    
    self.disposable = [WHSubscribeManager.sharedInstance.subscribeChanged
                       subscribeNext:^(NSNumber *isSubscribed) {
        @strongify(self)
        self.view.hidden = YES;
        
        if (isSubscribed.boolValue) {
            [self.banner removeFromSuperview];
            self.banner = nil;
            return;
        }
        
        CGSize size;
        switch (self.adtype) {
            case WHAdvertisementTypeFeed:
                size = CGSizeMake(345, 194);
                break;
            case WHAdvertisementTypeBanner:
                size = CGSizeMake(300, 75);
                break;
        }
        self.banner = [[BUNativeExpressBannerView alloc] initWithSlotID:self.adid
                                                     rootViewController:self
                                                                 adSize:size
                                                               interval:30];
        self.banner.delegate = self;
        [self.view addSubview:self.banner];
        [self.banner mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(size);
            make.centerX.equalTo(self.view);
            MASConstraint *top = make.top.equalTo(self.view);
            MASConstraint *bottom = make.bottom.equalTo(self.view);
            switch (self.adtype) {
                case WHAdvertisementTypeFeed:
                    top.offset(8);
                    bottom.offset(-8);
                    break;
                default: break;
            }
        }];
        [self.banner loadAdData];
    }];
}

#pragma mark - BUNativeExpressBannerViewDelegate

- (void)nativeExpressBannerAdViewDidLoad:(BUNativeExpressBannerView *)bannerAdView
{
    if (WHSubscribeManager.sharedInstance.isSubscribed) {
        [self.banner removeFromSuperview];
        self.banner = nil;
        self.view.hidden = YES;
    } else {
        self.view.hidden = NO;
    }
}

@end
