//
//  WHMeteDisasterWarningModel.h
//  Weather
//
//  Created by shoujian on 2021/3/12.
//

#import <Foundation/Foundation.h>

@interface WHMeteDisasterWarningModel : NSObject
@property (nonatomic , copy) NSString              * title;
@property (nonatomic , copy) NSString              * type;
@property (nonatomic , copy) NSString              * level;
@property (nonatomic , copy) NSString              * status;
@property (nonatomic , copy) NSString              * desc;
@property (nonatomic , copy) NSString              * pub_date;
@end

