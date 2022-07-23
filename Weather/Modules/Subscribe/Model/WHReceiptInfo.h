//
//  WHReceiptInfo.h
//  Weather
//
//  Created by shoujian on 2021/3/18.
//

#import <Foundation/Foundation.h>


@interface WHReceiptInfo : NSObject
@property (nonatomic, copy) NSString *product_id;
@property (nonatomic, copy) NSString *expires_date_ms;
@property (nonatomic, copy) NSString *cancellation_date_ms;
@property (nonatomic, assign) BOOL is_trial_period;
@end

