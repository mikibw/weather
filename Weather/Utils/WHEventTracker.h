//
//  WHEventTracker.h
//  Weather
//
//  Created by Liang Tang on 2021/3/22.
//

#import <Foundation/Foundation.h>

@interface WHEventTracker : NSObject

+ (instancetype)sharedTracker;

- (void)openApp;
- (void)enterSellPage;
- (void)clickSubscribeButton;
- (void)subscribeSuccess;

@end
