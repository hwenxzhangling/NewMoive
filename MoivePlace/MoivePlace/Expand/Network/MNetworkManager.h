//
//  MMNetworkManager.h
//  MoivePlace
//
//  Created by yanglin on 2017/2/13.
//  Copyright © 2017年 cxmx. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "AFHTTPSessionManager.h"
#import <Foundation/Foundation.h>
#import "MovieModel.h"
#import "MFAppModel.h"

@interface MNetworkManager : AFHTTPSessionManager


/**
 默认接口服务
 */
+ (void)getDefaultIndexSuccess:(void(^)(NSString *urlStr))success failure:(void(^)(NSError *error))failure;

/**
 电影初始化信息
 */
+ (void)getDefaultStartSuccess:(void(^)(DefaultStart *defaulStart))success failure:(void(^)(NSError *error))failure;

/**
 获取首页推荐的内容
 */
+ (void)getRecommendSuccess:(void(^)(NSArray<MovieGroup *> *groups))success failure:(void(^)(NSError *error))failure;

/**
 获取发现APP接口
 */
+ (void)getFindAppSuccess:(void(^)(NSArray<MFAppGroupModel *> *appModel))success failure:(void(^)(NSError *error))failure;

/**
 获取电影分类列表
 */
+ (void)getCategorySuccess:(void(^)(NSArray<MovieCategory *> *categorys))success failure:(void(^)(NSError *error))failure;

/**
 获取电影详细信息
 */
+ (void)getDetailWithID:(NSString *)ID Success:(void(^)(NSArray<MovieDetail *> *details))success failure:(void(^)(NSError *error))failure;


/**
 获取电影列表信息

 @param ID          可选	1		分类ID：电视剧是0，电影是1
 @param recommend   可选	0		推荐:0是不推荐，1是推荐
 @param keyword     可选			关键字：模糊查询标题
 @param page        可选	1		第几页：默认第一页
 @param limit       可选	15		每页多少条：默认15条
 */
+ (void)getIndexWithID:(NSString *)ID recommend:(NSString *)recommend keyword:(NSString *)keyword page:(NSString *)page limit:(NSString *)limit success:(void(^)(NSArray<MovieModel *> *movies))success failure:(void(^)(NSError *error))failure;

/**
 获取广告信息
 */
+ (void)getBannersSuccess:(void(^)(NSArray<BannerModel *> *banners))success failure:(void(^)(NSError *error))failure;

/**
 获取最新版本接口（暂时这个接口是定死的，每次客户端更新版本需要告知后台人员通知修改接口）！
 */
+ (void)getVersionSuccess:(void(^)(VersionModel *version))success failure:(void(^)(NSError *error))failure;


@end
