//
//  UIImage+Extensions.m
//  Weather
//
//  Created by Liang Tang on 2021/3/9.
//

#import "UIImage+Extensions.h"

static NSDictionary * bgMapping;
static NSDictionary * moonPhaseMapping;
static NSDictionary * lifeIndexMapping;
static NSDictionary * disasterTypeMapping;
static NSDictionary * disasterLevelMapping;

@implementation UIImage (Extensions)

+ (void)load
{
    bgMapping = @{
        @"0": @"1",
        @"1": @"2",
        @"2": @"1",
        @"3": @"2",
        @"4": @"3",
        @"5": @"1",
        @"6": @"3",
        @"7": @"1",
        @"8": @"3",
        @"9": @"5",
        @"10": @"1",
        @"11": @"5",
        @"12": @"5",
        @"13": @"5",
        @"14": @"5",
        @"15": @"5",
        @"16": @"5",
        @"17": @"5",
        @"18": @"5",
        @"19": @"5",
        @"20": @"6",
        @"21": @"6",
        @"22": @"6",
        @"23": @"6",
        @"24": @"6",
        @"25": @"6",
        @"26": @"4",
        @"27": @"4",
        @"28": @"4",
        @"29": @"4",
        @"30": @"4",
        @"31": @"4",
        @"32": @"4",
        @"33": @"4",
        @"34": @"4",
        @"35": @"4",
        @"36": @"4",
        @"37": @"6",
        @"38": @"1",
        @"99": @"1"
      };
    
    moonPhaseMapping = @{
        @"新月": @"new_moon",
        @"满月": @"full_moon",
        @"上弦月": @"first_quarter",
        @"下弦月": @"last_quarter",
        @"蛾眉月": @"waxing_crescent",
        @"盈凸月": @"waxing_gibbous",
        @"亏眉月": @"waning_crescent",
        @"亏凸月": @"waning_gibbous"
    };
    
    NSArray *lifeIndexArray = @[
        @"穿衣", @"紫外线强度", @"洗车", @"旅游", @"感冒", @"运动",
        @"交通", @"路况",
        @"晾晒", @"雨伞", @"空调开启", @"啤酒", @"逛街", @"夜生活", @"约会",
        @"晨练", @"钓鱼", @"划船", @"放风筝",
        @"过敏", @"美发", @"化妆", @"风寒", @"防晒", @"空气污染扩散条件", @"舒适度", @"心情"
    ];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [lifeIndexArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [dict setObject:@(idx + 1).stringValue forKey:obj];
    }];
    lifeIndexMapping = dict.copy;
    
    disasterTypeMapping = @{
        @"台风": @"taifeng",
        @"暴雨": @"baoyu",
        @"暴雪": @"baoxue",
        @"寒潮": @"hanchao",
        @"大风": @"dafeng",
        @"沙尘暴": @"shachenbao",
        @"高温": @"gaowen",
        @"干旱": @"ganhan",
        @"雷电": @"leidian",
        @"冰雹": @"bingbao",
        @"霜冻": @"shuangdong",
        @"大雾": @"dawu",
        @"霾": @"mai",
        @"道路结冰": @"daolujiebing",
        @"森林火险": @"senlinhuoxian",
        @"雷雨大风": @"leiyudafeng"
    };
    
    disasterLevelMapping = @{
        @"蓝色": @"lan",
        @"黄色": @"huang",
        @"橙色": @"cheng",
        @"红色": @"hong",
        @"白色": @"bai",
    };
}

+ (instancetype)weatherIconWithCode:(NSString *)code
{
    return [UIImage imageNamed:[NSString stringWithFormat:@"weather_icon_%@", code]];
}

+ (instancetype)weatherLineWithCode:(NSString *)code
{
    return [UIImage imageNamed:[NSString stringWithFormat:@"line_icon_%@", code]];
}

+ (instancetype)weatherBgWithCode:(NSString *)code
{
    return [UIImage imageNamed:[NSString stringWithFormat:@"weather_bg_%@", bgMapping[code]]];
}

+ (instancetype)moonPhaseWithName:(NSString *)name
{
    return [UIImage imageNamed:[NSString stringWithFormat:@"home_pic_%@", moonPhaseMapping[name]]];
}

+ (instancetype)lifeIndexWithName:(NSString *)name
{
    return [UIImage imageNamed:[NSString stringWithFormat:@"home_shzs_icon_%@", lifeIndexMapping[name]]];
}

+ (instancetype)disasterWithType:(NSString *)type level:(NSString *)level
{
    NSString *name = [NSString stringWithFormat:@"%@_%@",
                      disasterTypeMapping[type],
                      disasterLevelMapping[level]];
    return [UIImage imageNamed:name];
}

@end
