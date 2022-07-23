//
//  WHSubscribeManager.h
//  Weather
//
//  Created by shoujian on 2021/3/11.
//

#import <Foundation/Foundation.h>
#import "WHSubscribeVersionModel.h"
#import "WHReceiptInfo.h"

#define nonSubcribeAlertSec 180 //秒

typedef NS_ENUM(NSInteger, WHSubscribeResult) {
    WHSubscribeResultSuccess,
    WHSubscribeResultFailure,
    WHSubscribeResultCancelled
};

@interface WHSubscribeManager : NSObject

+ (instancetype)sharedInstance;

- (RACSignal *)getVersion;

@property (nonatomic, assign, getter=isSubscribed) BOOL subscribed;
@property (nonatomic, copy) NSString *expiration_ms;
- (RACSignal *)subscribeChanged;
- (RACSignal *)expirationChanged;

- (void)initIAPConfiguration;
- (void)verifyReceiptAfterLaunchingApplication;
- (void)subscribe:(void (^)(WHSubscribeResult result))completion;
- (void)restore:(void (^)(BOOL success))completion;

- (void)startPopUpTimer;
- (void)stopPopUpTimer;

@end
