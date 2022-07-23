//
//  WHSubscribeVersionModel.h
//  Weather
//
//  Created by shoujian on 2021/3/14.
//

#import <Foundation/Foundation.h>


@interface WHSubscribeVersionModel : NSObject

@property (nonatomic,assign) NSInteger id;
@property (nonatomic,copy) NSString *version;
@property (nonatomic,assign) BOOL is_onlie;
@property (nonatomic,copy) NSString *app;
@property (nonatomic,copy) NSString *product_id;//
@property (nonatomic,copy) NSString *describe;//
@property (nonatomic,copy) NSString *button_desc;//
@property (nonatomic,copy) NSString *button_desc_online;

@end


