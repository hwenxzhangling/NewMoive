//
//  MovieModel.m
//  MoivePlace
//
//  Created by TNP on 17/2/10.
//  Copyright © 2017年 cxmx. All rights reserved.
//

#import "MovieModel.h"
#import "MJRefresh.h"

//---------电影模型---------------------------------------------------
@implementation MovieModel

@end

//---------电影分组模型---------------------------------------------------
@implementation MovieGroup
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"datas" : [MovieModel class]};
}

@end

//---------电影分类模型---------------------------------------------------
@implementation MovieCategory
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"child" : [MovieCategory class]};
}

- (id) initWithCoder: (NSCoder *)coder
{
    if (self = [super init])
    {
        self.t_id = [coder decodeObjectForKey:@"t_id"];
        self.t_name = [coder decodeObjectForKey:@"t_name"];
        self.t_enname = [coder decodeObjectForKey:@"t_enname"];
        self.t_pid = [coder decodeObjectForKey:@"t_pid"];
    
    }
    return self;
}

- (void) encodeWithCoder: (NSCoder *)coder
{
    [coder encodeObject:_t_id forKey:@"t_id"];
    [coder encodeObject:_t_name forKey:@"t_name"];
    [coder encodeObject:_t_enname forKey:@"t_enname"];
    [coder encodeObject:_t_pid forKey:@"t_pid"];
}  


@end

//---------广告模型---------------------------------------------------
@implementation BannerModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID" : @"id"};
}

@end

//---------版本模型---------------------------------------------------
@implementation VersionModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID" : @"id"};
}

@end

//---------播放地址---------------------------------------------------
@implementation PlaySource

@end

//---------电影详情---------------------------------------------------
@implementation MovieDetail
- (void)setD_type:(NSString *)d_type{
    _d_type = d_type;
    _movieType =  [d_type integerValue];
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"d_playurl" : [PlaySource class]};
}

@end

//---------电影初始化信息---------------------------------------------------
@implementation DefaultStart

@end



