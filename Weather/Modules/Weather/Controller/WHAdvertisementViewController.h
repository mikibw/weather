//
//  WHAdvertisementViewController.h
//  Weather
//
//  Created by Liang Tang on 2021/3/14.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WHAdvertisementType) {
    WHAdvertisementTypeFeed,
    WHAdvertisementTypeBanner
};

@interface WHAdvertisementViewController : UIViewController
@property (nonatomic, copy) NSString *adid;
@property (nonatomic, assign) WHAdvertisementType adtype;
@end
