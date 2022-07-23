//
//  WHLifeIndexModel.h
//  Weather
//
//  Created by Liang Tang on 2021/3/13.
//

#import <Foundation/Foundation.h>


@interface WHLifeIndexItemModel : NSObject
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , copy) NSString              * brief;
@property (nonatomic , copy) NSString              * details;
@end

@interface WHLifeIndexModel : NSObject
@property (nonatomic , strong) WHLifeIndexItemModel              * ac;
@property (nonatomic , strong) WHLifeIndexItemModel              * air_pollution;
@property (nonatomic , strong) WHLifeIndexItemModel              * airing;
@property (nonatomic , strong) WHLifeIndexItemModel              * allergy;
@property (nonatomic , strong) WHLifeIndexItemModel              * beer;
@property (nonatomic , strong) WHLifeIndexItemModel              * boating;
@property (nonatomic , strong) WHLifeIndexItemModel              * car_washing;
@property (nonatomic , strong) WHLifeIndexItemModel              * chill;
@property (nonatomic , strong) WHLifeIndexItemModel              * comfort;
@property (nonatomic , strong) WHLifeIndexItemModel              * dating;
@property (nonatomic , strong) WHLifeIndexItemModel              * dressing;
@property (nonatomic , strong) WHLifeIndexItemModel              * fishing;
@property (nonatomic , strong) WHLifeIndexItemModel              * flu;
@property (nonatomic , strong) WHLifeIndexItemModel              * hair_dressing;
@property (nonatomic , strong) WHLifeIndexItemModel              * kiteflying;
@property (nonatomic , strong) WHLifeIndexItemModel              * makeup;
@property (nonatomic , strong) WHLifeIndexItemModel              * mood;
@property (nonatomic , strong) WHLifeIndexItemModel              * morning_sport;
@property (nonatomic , strong) WHLifeIndexItemModel              * night_life;
@property (nonatomic , strong) WHLifeIndexItemModel              * road_condition;
@property (nonatomic , strong) WHLifeIndexItemModel              * shopping;
@property (nonatomic , strong) WHLifeIndexItemModel              * sport;
@property (nonatomic , strong) WHLifeIndexItemModel              * sunscreen;
@property (nonatomic , strong) WHLifeIndexItemModel              * traffic;
@property (nonatomic , strong) WHLifeIndexItemModel              * travel;
@property (nonatomic , strong) WHLifeIndexItemModel              * umbrella;
@property (nonatomic , strong) WHLifeIndexItemModel              * uv;
@end

@interface WHLifeIndexGroupModel : NSObject
@property (nonatomic , copy) NSString *category;
@property (nonatomic , strong) NSArray <WHLifeIndexItemModel *> *items;
@end
