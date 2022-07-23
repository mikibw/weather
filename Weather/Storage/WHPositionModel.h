//
//  WHPositionModel.h
//  Weather
//
//  Created by Liang Tang on 2021/3/11.
//

#import <Foundation/Foundation.h>

@interface WHPositionModel : NSObject <NSCoding>
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *country;
@property (nonatomic, copy) NSString *path;
@property (nonatomic, copy) NSString *timezone;
@property (nonatomic, copy) NSString *timezone_offset;
@end

