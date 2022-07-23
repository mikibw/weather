//
//  WHPositionStorage.m
//  Weather
//
//  Created by Liang Tang on 2021/3/11.
//

#import "WHPositionStorage.h"

@implementation WHPositionStorage

+ (instancetype)sharedStorage
{
    static WHPositionStorage *storage;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        storage = [[WHPositionStorage alloc] init];
    });
    return storage;
}

- (WHPositionModel *)defaultPosition
{
    WHPositionModel *p = WHPositionModel.new;
    p.id = @"WX4FBXXFKE4F";
    p.name = @"北京";
    p.country = @"CN";
    p.path = @"北京,北京,中国";
    p.timezone = @"Asia/Shanghai";
    p.timezone_offset = @"+08:00";
    return p;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

- (WHPositionModel *)storedPosition
{
    NSData *data = [NSKeyedUnarchiver unarchiveObjectWithFile:self.filepath1];
    return [WHPositionModel mj_objectWithKeyValues:data];
}

- (void)storePosition:(WHPositionModel *)position
{
    [NSKeyedArchiver archiveRootObject:position.mj_JSONData toFile:self.filepath1];
}

- (NSArray <WHPositionModel *> *)storedPostions
{
    NSData *data = [NSKeyedUnarchiver unarchiveObjectWithFile:self.filepath2];
    return [WHPositionModel mj_objectArrayWithKeyValuesArray:data];
}

- (void)storePositions:(NSArray <WHPositionModel *> *)postions
{
    [NSKeyedArchiver archiveRootObject:postions toFile:self.filepath2];
}

#pragma clang diagnostic pop

- (NSString *)filepath1
{
    return [self.document stringByAppendingPathComponent:@"postion.archive"];
}

- (NSString *)filepath2
{
    return [self.document stringByAppendingPathComponent:@"postions.archive"];
}

- (NSString *)document
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

@end

