//
//  MovieModel.h
//  MoivePlace
//
//  Created by TNP on 17/2/10.
//  Copyright © 2017年 cxmx. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,MMovieType)
{
    MMovieType_Unknown      = 0,//未知
    MMovieType_Movie        = 1,//电影
    MMovieType_MTV          = 2,//电视剧
    MMovieType_Variety      = 3,//综艺
    MMovieType_CTV          = 12, //国产剧
    MMovieType_HTV          = 13, //港台剧
    MMovieType_JTV          = 14, //日韩剧
    MMovieType_ETV          = 19, //美剧
};

//---------电影模型---------------------------------------------------
@interface MovieModel : NSObject
@property (copy, nonatomic) NSString *d_id;
@property (copy, nonatomic) NSString *d_name;
@property (copy, nonatomic) NSString *d_picthumb;
@property (copy, nonatomic) NSString *d_remarks;    //超清
@property (copy, nonatomic) NSString *d_time;       //2017-02-04

@end

//---------电影分组模型---------------------------------------------------
@interface MovieGroup : NSObject
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *type;
@property (strong, nonatomic) NSArray<MovieModel *> *datas;

@end

//---------电影分类模型---------------------------------------------------
@interface MovieCategory : NSObject
@property (copy, nonatomic) NSString *t_id;
@property (copy, nonatomic) NSString *t_name;
@property (copy, nonatomic) NSString *t_enname;
@property (copy, nonatomic) NSString *t_pid;
@property (strong, nonatomic) NSArray<MovieCategory *> *child;  //子分组

@end

//---------广告模型---------------------------------------------------
@interface BannerModel : NSObject
@property (copy, nonatomic) NSString *ID;
@property (copy, nonatomic) NSString *ad_title;
@property (copy, nonatomic) NSString *ad_url;
@property (copy, nonatomic) NSString *ad_img;
@property (copy, nonatomic) NSString *seconds;      //秒数
@property (copy, nonatomic) NSString *show;         //是否显示，1是，0否

@end

//---------版本模型---------------------------------------------------
@interface VersionModel : NSObject
@property (copy, nonatomic) NSString *ID;
@property (copy, nonatomic) NSString *app_name;
@property (copy, nonatomic) NSString *app_version;
@property (copy, nonatomic) NSString *app_size;
@property (copy, nonatomic) NSString *app_url;
@property (copy, nonatomic) NSString *ctime;        //发布时间
@property (copy, nonatomic) NSString *need;         //强制更新，1是，0否

@end

//---------播放地址---------------------------------------------------
@interface PlaySource : NSObject
@property (copy, nonatomic) NSString *title;        //超清版
@property (copy, nonatomic) NSString *src;          //播放地址

@end

//---------电影详情---------------------------------------------------
@interface MovieDetail : NSObject
@property (copy, nonatomic) NSString *d_id;
@property (copy, nonatomic) NSString *d_name;       //乘风破浪
@property (copy, nonatomic) NSString *d_subname;
@property (copy, nonatomic) NSString *d_enname;     //chengfengpolang
@property (copy, nonatomic) NSString *d_letter;     //C
@property (copy, nonatomic) NSString *d_color;
@property (copy, nonatomic) NSString *d_pic;        //大图
@property (copy, nonatomic) NSString *d_picthumb;   //缩略图
@property (copy, nonatomic) NSString *d_picslide;
@property (copy, nonatomic) NSString *d_starring;
@property (copy, nonatomic) NSString *d_directed;
@property (copy, nonatomic) NSString *d_tag;
@property (copy, nonatomic) NSString *d_remarks;    //抢先版
@property (copy, nonatomic) NSString *d_area;
@property (copy, nonatomic) NSString *d_lang;
@property (copy, nonatomic) NSString *d_year;
@property (copy, nonatomic) NSString *d_type;       //资源类型
@property (assign, nonatomic) MMovieType movieType; //资源类型
@property (copy, nonatomic) NSString *d_type_expand;
@property (copy, nonatomic) NSString *d_class;
@property (copy, nonatomic) NSString *d_topic;
@property (copy, nonatomic) NSString *d_hide;
@property (copy, nonatomic) NSString *d_lock;
@property (copy, nonatomic) NSString *d_state;
@property (copy, nonatomic) NSString *d_level;
@property (copy, nonatomic) NSString *d_usergroup;
@property (copy, nonatomic) NSString *d_stint;
@property (copy, nonatomic) NSString *d_stintdown;
@property (copy, nonatomic) NSString *d_hits;
@property (copy, nonatomic) NSString *d_dayhits;
@property (copy, nonatomic) NSString *d_weekhits;
@property (copy, nonatomic) NSString *d_monthhits;
@property (copy, nonatomic) NSString *d_duration;
@property (copy, nonatomic) NSString *d_up;
@property (copy, nonatomic) NSString *d_down;
@property (copy, nonatomic) NSString *d_score;
@property (copy, nonatomic) NSString *d_scoreall;
@property (copy, nonatomic) NSString *d_scorenum;
@property (copy, nonatomic) NSString *d_addtime;    //1485620774
@property (copy, nonatomic) NSString *d_time;       //2017-02-04
@property (copy, nonatomic) NSString *d_hitstime;
@property (copy, nonatomic) NSString *d_maketime;   //2017-02-09
@property (copy, nonatomic) NSString *d_content;
@property (copy, nonatomic) NSString *d_playfrom;   //ckplayer
@property (copy, nonatomic) NSString *d_playserver;
@property (copy, nonatomic) NSString *d_playnote;
@property (copy, nonatomic) NSString *d_downfrom;
@property (copy, nonatomic) NSString *d_downserver;
@property (copy, nonatomic) NSString *d_downnote;
@property (copy, nonatomic) NSString *d_downurl;
@property (strong, nonatomic) NSArray<PlaySource *> *d_playurl;

@end

//---------电影初始化信息---------------------------------------------------
@interface DefaultStart : NSObject
@property (copy, nonatomic) NSString *share_url;            //分享URL路径
@property (copy, nonatomic) NSString *baidu_from;           //百度fromID
@property (copy, nonatomic) NSString *check_version;        //IOS审核版本号
@property (copy, nonatomic) NSString *isarchitecture;       //架构是否变化：0是不变，1是变

@end




