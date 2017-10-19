//
//  MFAppModel.m
//  MoivePlace
//
//  Created by hewenxue on 17/2/16.
//  Copyright © 2017年 cxmx. All rights reserved.
//

#import "MFAppModel.h"
#import "MJExtension.h"
//-----------发现App分组模型-----------//
@implementation MFAppGroupModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID" : @"id",
             };
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{ @"list" :[MFAppModel class]};
}
@end

//-----------发App模型-----------//
@implementation MFAppModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID" : @"id"
            };
}
@end



