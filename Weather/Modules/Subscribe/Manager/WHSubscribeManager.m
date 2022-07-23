//
//  WHSubscribeManager.m
//  Weather
//
//  Created by shoujian on 2021/3/11.
//

#import "WHSubscribeManager.h"
#import "WHWeatherNetwork.h"
#import <StoreKit/StoreKit.h>

#import "IAPHelper.h"
#import "IAPShare.h"
#import <UICKeyChainStore/UICKeyChainStore.h>

static NSString *const productId = @"weather_90days";
static NSString *const sharedSecret = @"5026ba01edbc4c12af665ff1fb744445";

static NSString *const keychainService = @"com.weather.ins";
static NSString *const subscribedKey = @"weather_90days_subscribed";
static NSString *const expirationKey = @"weather_90days_expiration";

@interface WHSubscribeManager()
@property (nonatomic, strong) WHSubscribeVersionModel *versionModel;
@property (nonatomic, strong) RACCommand *fetchVersionCommand;
@end

@interface WHSubscribeManager()
@property (nonatomic, strong) UICKeyChainStore *keychain;
@property (nonatomic, strong) RACSignal *subscribeSignal;
@property (nonatomic, strong) RACSignal *expirationSignal;
@end

@interface WHSubscribeManager()
@property (nonatomic, strong) NSTimer *popUpTimer;
@end

@implementation WHSubscribeManager

+ (instancetype)sharedInstance
{
    static WHSubscribeManager *manager;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        manager = [[WHSubscribeManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _keychain = [UICKeyChainStore keyChainStoreWithService:keychainService];
        self.subscribed = [self.keychain stringForKey:subscribedKey] != nil;
        self.expiration_ms = [self.keychain stringForKey:expirationKey];
        
        _subscribeSignal = RACObserve(self, subscribed).replayLast;
        _expirationSignal = RACObserve(self, subscribed).replayLast;
        
        @weakify(self)
        
        _fetchVersionCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id _Nullable x) {
            @strongify(self)
            if (self.versionModel) {
                return [RACSignal return:self.versionModel];
            }
            NSString *vv = [NSBundle.mainBundle.infoDictionary objectForKey:@"CFBundleShortVersionString"];
            return [[[[[WHWeatherNetwork.sharedNetwork subscribeVersionSignal:vv app:@"Weather"] map:^id _Nullable(id  _Nullable value) {
                return [value objectForKey:@"data"];
            }] mapObject:WHSubscribeVersionModel.class] doNext:^(id  _Nullable x) {
                @strongify(self)
                self.versionModel = x;
            }] catchTo:[RACSignal return:nil]];
        }];
        
    }
    return self;
}

- (RACSignal *)getVersion
{
    return [self.fetchVersionCommand execute:nil];
}

- (RACSignal *)subscribeChanged
{
    return _subscribeSignal;
}

- (RACSignal *)expirationChanged
{
    return _expirationSignal;
}

- (void)setSubscribed:(BOOL)subscribed
{
    if (self.subscribed != subscribed) {
        [self willChangeValueForKey:@"subscribed"];
        self->_subscribed = subscribed;
        [self didChangeValueForKey:@"subscribed"];
    }
}

- (void)setExpiration_ms:(NSString *)expiration_ms
{
    if (![self.expiration_ms isEqualToString:expiration_ms]) {
        [self willChangeValueForKey:@"expiration_ms"];
        self->_expiration_ms = expiration_ms;
        [self didChangeValueForKey:@"expiration_ms"];
    }
}

- (void)initIAPConfiguration
{
    if(!IAPShare.sharedHelper.iap) {
        NSSet* dataSet = [[NSSet alloc] initWithObjects:productId, nil];
        [IAPShare sharedHelper].iap = [[IAPHelper alloc] initWithProductIdentifiers:dataSet];
    }
    IAPShare.sharedHelper.iap.production = YES;
}

- (void)verifyReceiptAfterLaunchingApplication
{
    if (!self.isSubscribed) return;
    [self verifyReceipt:nil];
}

- (void)subscribe:(void (^)(WHSubscribeResult))completion
{
    [IAPShare.sharedHelper.iap requestProductsWithCompletion:^(SKProductsRequest* request, SKProductsResponse* response) {
        if (response) {
            SKProduct *product =[IAPShare.sharedHelper.iap.products objectAtIndex:0];
            [IAPShare.sharedHelper.iap buyProduct:product onCompletion:^(SKPaymentTransaction *trans) {
                switch (trans.transactionState) {
                    case SKPaymentTransactionStatePurchased: {
                        [self verifyReceipt:^(WHReceiptInfo *receipt, NSError *error) {
                            !completion ?: completion(receipt ? WHSubscribeResultSuccess : WHSubscribeResultFailure);
                        }];
                        break;
                    }
                    case SKPaymentTransactionStateFailed: {
                        !completion ?: completion(trans.error.code == SKErrorPaymentCancelled ? WHSubscribeResultCancelled : WHSubscribeResultFailure);
                        break;
                    }
                    default: break;
                }
            }];
        } else {
            !completion ?: completion(WHSubscribeResultFailure);
        }
    }];
}

- (void)restore:(void (^)(BOOL))completion
{
    [IAPShare.sharedHelper.iap restoreProductsWithCompletion:^(SKPaymentQueue *payment, NSError *error) {
        SKPaymentTransaction *trans = nil;
        for (SKPaymentTransaction *transaction in payment.transactions) {
            if ([transaction.payment.productIdentifier isEqualToString:productId]) {
                trans = transaction; break;
            }
        }
        if (trans) {
            [self verifyReceipt:^(WHReceiptInfo *receipt, NSError *error) {
                !completion ?: completion(receipt != nil);
            }];
        } else {
            !completion ?: completion(NO);
        }
    }];
}

- (void)verifyReceipt:(void (^)(WHReceiptInfo *receipt, NSError *error))completion
{
    [IAPShare.sharedHelper.iap checkReceipt:[NSData dataWithContentsOfURL:NSBundle.mainBundle.appStoreReceiptURL]
                            AndSharedSecret:sharedSecret
                               onCompletion:^(NSString *response, NSError *error) {
        if (response.length) {
            NSDictionary *rec = [IAPShare toJSON:response];
            if ([rec[@"status"] intValue] == 0) {
                WHReceiptInfo *receipt = [self parseReceiptResponse:rec];
                [self saveReceipt:receipt];
                if (receipt) {
                    !completion ?: completion(receipt, nil);
                } else {
                    !completion ?: completion(nil, error ? error : NSError.new);
                }
            } else {
                [self saveReceipt:nil];
                !completion ?: completion(nil, error ? error : NSError.new);
            }
        }else{
            [self saveReceipt:nil];
            !completion ?: completion(nil, error ? error : NSError.new);
        }
    }];
}

- (WHReceiptInfo *)parseReceiptResponse:(NSDictionary *)response
{
    NSArray *arr = [response objectForKey:@"latest_receipt_info"];
    
    NSArray <WHReceiptInfo *> *receipts = [WHReceiptInfo mj_objectArrayWithKeyValuesArray:arr];
    
    receipts = [[[receipts rac_sequence] filter:^BOOL(WHReceiptInfo *  _Nullable value) {
        return [value.product_id isEqualToString:productId] && value.cancellation_date_ms.length == 0;
    }] array];
    
    receipts = [receipts sortedArrayUsingComparator:^NSComparisonResult(WHReceiptInfo *  _Nonnull obj1, WHReceiptInfo *  _Nonnull obj2) {
        return obj1.expires_date_ms.longLongValue < obj2.expires_date_ms.longLongValue;
    }];
    
    WHReceiptInfo *receipt = receipts.firstObject;
    if (!receipt) return nil;
    
    long long now = NSDate.date.timeIntervalSince1970 * 1000;
    if (receipt.expires_date_ms.longLongValue < now) return nil;
    
    return receipt;
}

- (void)saveReceipt:(WHReceiptInfo *)receipt
{
    if (receipt) {
        self.subscribed = YES;
        [self.keychain setString:@"true" forKey:subscribedKey];
        self.expiration_ms = receipt.expires_date_ms;
        [self.keychain setString:receipt.expires_date_ms forKey:expirationKey];
    } else {
        self.subscribed = NO;
        [self.keychain setString:nil forKey:subscribedKey];
        self.expiration_ms = nil;
        [self.keychain setString:nil forKey:expirationKey];
    }
}

- (void)startPopUpTimer
{
    @weakify(self)
    [self.getVersion subscribeNext:^(WHSubscribeVersionModel *x) {
        @strongify(self)
        //线上 非会员 要弹，非线上 不弹
        if (!x.is_onlie || self.subscribed) return;
        
        self.popUpTimer = [NSTimer scheduledTimerWithTimeInterval:nonSubcribeAlertSec repeats:NO block:^(NSTimer * _Nonnull timer) {
            @strongify(self)
            [self stopPopUpTimer];
            if (!x.is_onlie || self.subscribed) return;
            [WHRouter.sharedRouter open:routesInit(WHRouteSubscribeGuide, nil)];
        }];
    }];
}

- (void)stopPopUpTimer
{
    [self.popUpTimer invalidate];
    self.popUpTimer = nil;
}

@end
