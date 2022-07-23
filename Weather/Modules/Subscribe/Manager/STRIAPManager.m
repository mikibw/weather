//
//  STRIAPManager.m
//  Weather
//
//  Created by shoujian on 2021/3/16.
//

#import "STRIAPManager.h"
#import <StoreKit/StoreKit.h>
@interface STRIAPManager()<SKPaymentTransactionObserver,SKProductsRequestDelegate>{
   NSString           *_purchID;
   IAPCompletionHandle _handle;
    IAPCompletionHandle _restoreHandle;
}
@end
@implementation STRIAPManager
 
#pragma mark - ♻️life cycle
+ (instancetype)shareSIAPManager{
     
    static STRIAPManager *IAPManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        IAPManager = [[STRIAPManager alloc] init];
    });
    return IAPManager;
}
- (instancetype)init{
    self = [super init];
    if (self) {
        // 购买监听写在程序入口,程序挂起时移除监听,这样如果有未完成的订单将会自动执行并回调 paymentQueue:updatedTransactions:方法
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    return self;
}
 
- (void)dealloc{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}
 
#pragma mark - 🚪public
- (void)startPurchWithID:(NSString *)purchID completeHandle:(IAPCompletionHandle)handle{
    if (purchID) {
        if ([SKPaymentQueue canMakePayments]) {
            // 开始购买服务
            _purchID = purchID;
            _handle = handle;
            NSSet *nsset = [NSSet setWithArray:@[purchID]];
            SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:nsset];
            request.delegate = self;
            [request start];
        }else{
            [self handleActionWithType:SIAPPurchNotArrow data:nil];
        }
    }
}
#pragma mark - 🔒private
- (void)handleActionWithType:(SIAPPurchType)type data:(NSData *)data{
    switch (type) {
        case SIAPPurchSuccess:
            NSLog(@"购买成功");
            break;
        case SIAPPurchFailed:
            NSLog(@"购买失败");
            break;
        case SIAPPurchCancle:
            NSLog(@"用户取消购买");
            break;
        case SIAPPurchVerFailed:
            NSLog(@"订单校验失败");
            break;
        case SIAPPurchVerSuccess:
            NSLog(@"订单校验成功");
            break;
        case SIAPPurchNotArrow:
            NSLog(@"不允许程序内付费");
            break;
        default:
            break;
    }
    if(_handle){
        _handle(type,data);
        _handle = nil;
    }
    
    if (_restoreHandle) {
        _restoreHandle(type,data);
        _restoreHandle = nil;
    }
}
#pragma mark - 🍐delegate
// 交易结束
- (void)completeTransaction:(SKPaymentTransaction *)transaction{
  // Your application should implement these two methods.
    NSString * productIdentifier = transaction.payment.productIdentifier;

    NSString * receipt1 = [[NSString alloc] initWithData:transaction.transactionReceipt encoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]];
    NSString *base64Data = [data base64EncodedStringWithOptions:0];
    //[transaction.transactionReceipt base64EncodedString];
    if ([productIdentifier length] > 0) {
        // 向自己的服务器验证购买凭证
    }
 
    [self verifyPurchaseWithPaymentTransaction:transaction isTestServer:NO];
}
 
// 交易失败
- (void)failedTransaction:(SKPaymentTransaction *)transaction{
    if (transaction.error.code != SKErrorPaymentCancelled) {
        [self handleActionWithType:SIAPPurchFailed data:nil];
    }else{
        [self handleActionWithType:SIAPPurchCancle data:nil];
    }
     
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}
 
- (void)verifyPurchaseWithPaymentTransaction:(SKPaymentTransaction *)transaction isTestServer:(BOOL)flag{
    //交易验证
    NSURL *recepitURL = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receipt = [NSData dataWithContentsOfURL:recepitURL];
     
    if(!receipt){
        // 交易凭证为空验证失败
        [self handleActionWithType:SIAPPurchVerFailed data:nil];
        return;
    }
    // 购买成功将交易凭证发送给服务端进行再次校验
    [self handleActionWithType:SIAPPurchSuccess data:receipt];
     
    NSError *error;
    NSDictionary *requestContents = @{
                                      @"receipt-data": [receipt base64EncodedStringWithOptions:0]
                                      };
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestContents
                                                          options:0
                                                            error:&error];
     
    if (error) { // 交易凭证为空验证失败
        [self handleActionWithType:SIAPPurchVerFailed data:nil];
        return;
    }
     
    //In the test environment, use https://sandbox.itunes.apple.com/verifyReceipt
    //In the real environment, use https://buy.itunes.apple.com/verifyReceipt
     
    NSString *serverString = @"https://buy.itunes.apple.com/verifyReceipt";
    if (flag) {
        serverString = @"https://sandbox.itunes.apple.com/verifyReceipt";
    }
    NSURL *storeURL = [NSURL URLWithString:serverString];
    NSMutableURLRequest *storeRequest = [NSMutableURLRequest requestWithURL:storeURL];
    [storeRequest setHTTPMethod:@"POST"];
    [storeRequest setHTTPBody:requestData];
     
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:storeRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable err) {
        if (err) {
            // 无法连接服务器,购买校验失败
            [self handleActionWithType:SIAPPurchVerFailed data:nil];
        } else {
            NSError *error;
            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            if (!jsonResponse) {
                // 苹果服务器校验数据返回为空校验失败
                [self handleActionWithType:SIAPPurchVerFailed data:nil];
            }
             
            // 先验证正式服务器,如果正式服务器返回21007再去苹果测试服务器验证,沙盒测试环境苹果用的是测试服务器
            NSString *status = [NSString stringWithFormat:@"%@",jsonResponse[@"status"]];
            if (status && [status isEqualToString:@"21007"]) {//21007表示沙盒环境
                [self verifyPurchaseWithPaymentTransaction:transaction isTestServer:YES];
            }else if(status && [status isEqualToString:@"0"]){//0正式环境通过
                [self handleActionWithType:SIAPPurchVerSuccess data:nil];
            }
            NSLog(@"----验证结果 %@",jsonResponse);
        }
    }];
    [dataTask resume];
    // 验证成功与否都注销交易,否则会出现虚假凭证信息一直验证不通过,每次进程序都得输入苹果账号
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}
 
#pragma mark - SKProductsRequestDelegate
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    NSArray *product = response.products;
    if([product count] <= 0){
        NSLog(@"--------------没有商品------------------");
        return;
    }
    SKProduct *p = nil;
    for(SKProduct *pro in product){
        if([pro.productIdentifier isEqualToString:_purchID]){
            p = pro;
            break;
        }
    }
     
    NSLog(@"productID:%@", response.invalidProductIdentifiers);
    NSLog(@"产品付费数量:%lu",(unsigned long)[product count]);
    NSLog(@"%@",[p description]);
    NSLog(@"%@",[p localizedTitle]);
    NSLog(@"%@",[p localizedDescription]);
    NSLog(@"%@",[p price]);
    NSLog(@"%@",[p productIdentifier]);
    NSLog(@"发送购买请求");
     
    SKPayment *payment = [SKPayment paymentWithProduct:p];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}
 
//请求失败
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    NSLog(@"------------------错误-----------------:%@", error);
}
 
- (void)requestDidFinish:(SKRequest *)request{
    NSLog(@"------------反馈信息结束-----------------");
}
 
#pragma mark - SKPaymentTransactionObserver
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions{
    for (SKPaymentTransaction *tran in transactions) {
        switch (tran.transactionState) {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:tran];
                break;
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"商品添加进列表");
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"已经购买过商品");
                if (_restoreHandle) {
                    [self handleActionWithType:(SIAPPurchSuccess) data:nil];
                }
                // 消耗型不支持恢复购买
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:tran];
                if (_restoreHandle) {
                    [self handleActionWithType:(SIAPPurchFailed) data:nil];
                }
                break;
            default:
                break;
        }
    }
}
//恢复购买
- (void)restorePay:(IAPCompletionHandle)restoreHandle{
    _restoreHandle = restoreHandle;
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}
@end
