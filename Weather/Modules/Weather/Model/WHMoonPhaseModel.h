//
//  WHMoonPhaseModel.h
//  Weather
//
//  Created by Liang Tang on 2021/3/13.
//

#import <Foundation/Foundation.h>

@interface WHMoonPhaseModel : NSObject
@property (nonatomic , copy) NSString              * date;
@property (nonatomic , copy) NSString              * rise;
@property (nonatomic , copy) NSString              * set;
@property (nonatomic , copy) NSString              * fraction;
@property (nonatomic , copy) NSString              * phase;
@property (nonatomic , copy) NSString              * phase_name;
@end
