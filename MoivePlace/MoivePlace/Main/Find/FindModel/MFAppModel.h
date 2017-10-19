//
//  MFAppModel.h
//  MoivePlace
//
//  Created by hewenxue on 17/2/16.
//  Copyright © 2017年 cxmx. All rights reserved.
//

#import <Foundation/Foundation.h>
//-----------发现App分组模型-----------//
@class MFAppModel;
@interface MFAppGroupModel : NSObject
@property (nonatomic,copy)NSString *ID;//分组id
@property (nonatomic,copy)NSString *title;//标题
@property (nonatomic,copy)NSString *logo_url;//icon
@property (nonatomic,copy)NSString *showtype;//显示类型
@property (nonatomic,strong)NSArray<MFAppModel *> *list;

@end

//-----------发App模型-----------//
@interface MFAppModel : NSObject
@property (nonatomic,copy)NSString *ID;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *item_id;
@property (nonatomic,copy)NSString *is_android;
@property (nonatomic,copy)NSString *is_ios;
@property (nonatomic,copy)NSString *is_wap;
@property (nonatomic,copy)NSString *is_recommend;
@property (nonatomic,copy)NSString *px;
@property (nonatomic,copy)NSString *stat;
@property (nonatomic,copy)NSString *is_delete;
@property (nonatomic,copy)NSString *url_open_type;
@property (nonatomic,copy)NSString *logo_url;
@property (nonatomic,copy)NSString *android_url;
@property (nonatomic,copy)NSString *creater;
@property (nonatomic,copy)NSString *ios_url;
@property (nonatomic,copy)NSString *wap_url;
@property (nonatomic,copy)NSString *desc;

@end


