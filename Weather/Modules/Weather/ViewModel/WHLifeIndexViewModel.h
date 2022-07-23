//
//  WHLifeIndexViewModel.h
//  Weather
//
//  Created by Liang Tang on 2021/3/13.
//

#import <Foundation/Foundation.h>
#import "WHLifeIndexModel.h"

@interface WHLifeIndexViewModel : NSObject
@property (nonatomic, strong, readonly) NSArray <WHLifeIndexGroupModel *> *groups;
@property (nonatomic, strong, readonly) RACCommand *fetchLifeIndex;
@end
