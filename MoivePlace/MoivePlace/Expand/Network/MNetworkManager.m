//
//  MMNetworkManager.m
//  MoivePlace
//
//  Created by yanglin on 2017/2/13.
//  Copyright © 2017年 cxmx. All rights reserved.
//

#import "MNetworkManager.h"
#import "ConstantPublicHeader.h"
#import "MJExtension.h"
#import "Common.h"

static MNetworkManager *manager;

@implementation MNetworkManager
+(instancetype)sharedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [super manager];
        manager.requestSerializer.timeoutInterval = 30.0;
        //        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    });
    return manager;
}

+ (void)getDefaultIndexSuccess:(void(^)(NSString *urlStr))success failure:(void(^)(NSError *error))failure{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:@"2" forKey:@"os"];
    [param setValue:kDefaultIndex forKey:@"service"];
    [[self sharedManager] GET:kAPI parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = [responseObject valueForKey:@"data"];
            if ([dict isKindOfClass:[NSDictionary class]]) {
                NSString *urlStr = [dict valueForKey:@"url"];
                if ([urlStr isKindOfClass:[NSString class]]) {
                    
                    //保存到本地
                    [[NSUserDefaults standardUserDefaults] setValue:urlStr forKey:kDefaultIndexUrl];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    success ? success(urlStr) : nil;
                }else{
                    failure ? failure(nil) : nil;
                }
            }else{
                failure ? failure(nil) : nil;
            }
        }else{
            failure ? failure(nil) : nil;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure ? failure(error) : nil;
    }];
}

+ (void)getDefaultStartSuccess:(void(^)(DefaultStart *defaulStart))success failure:(void(^)(NSError *error))failure{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:@"2" forKey:@"os"];
    [param setValue:kDefaultStart forKey:@"service"];
    [[self sharedManager] GET:kAPI parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = [responseObject valueForKey:@"data"];
            if ([dict isKindOfClass:[NSDictionary class]]) {
                DefaultStart *defautStart = [DefaultStart mj_objectWithKeyValues:dict];
                
                //保存到本地
                [[NSUserDefaults standardUserDefaults] setValue:defautStart.share_url forKey:kShare_Url];
                [[NSUserDefaults standardUserDefaults] setValue:defautStart.baidu_from forKey:kBaidu_From];
                [[NSUserDefaults standardUserDefaults] setValue:defautStart.check_version forKey:kCheck_Verison];
                [[NSUserDefaults standardUserDefaults] setValue:defautStart.isarchitecture forKey:kIsArchitecture];
                [[NSUserDefaults standardUserDefaults] synchronize];
                success ? success(defautStart) : nil;
            }else{
                failure ? failure(nil) : nil;
            }
        }else{
            failure ? failure(nil) : nil;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure ? failure(error) : nil;
    }];
}

/**
 获取发现APP接口
 */
+ (void)getFindAppSuccess:(void(^)(NSArray<MFAppGroupModel *> *appModel))success failure:(void(^)(NSError *error))failure;
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:kFindApp forKey:@"service"];
    [param setValue:@"2" forKey:@"os"];
    [param setValue:
     [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] forKey:@"version"];
    
    [[self sharedManager] GET:kAPI parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSArray *dictArr = [responseObject valueForKey:@"data"];
            if ([dictArr isKindOfClass:[NSArray class]]) {
                NSArray *groups = [MFAppGroupModel mj_objectArrayWithKeyValuesArray:dictArr];
                success ? success(groups) : nil;
            }else{
                failure ? failure(nil) : nil;
            }
        }else{
            failure ? failure(nil) : nil;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure ? failure(error) : nil;
    }];
}


+ (void)getRecommendSuccess:(void(^)(NSArray<MovieGroup *> *groups))success failure:(void(^)(NSError *error))failure{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:kMovieRecommend forKey:@"service"];
    [[self sharedManager] GET:kAPI parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSArray *dictArr = [responseObject valueForKey:@"data"];
            if ([dictArr isKindOfClass:[NSArray class]]) {
                NSArray *groups = [MovieGroup mj_objectArrayWithKeyValuesArray:dictArr];
                success ? success(groups) : nil;
            }else{
                failure ? failure(nil) : nil;
            }
        }else{
            failure ? failure(nil) : nil;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure ? failure(error) : nil;
    }];
}

+ (void)getCategorySuccess:(void(^)(NSArray<MovieCategory *> *categorys))success failure:(void(^)(NSError *error))failure{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:kMovieCategory forKey:@"service"];
    [[self sharedManager] GET:kAPI parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSArray *dictArr = [responseObject valueForKey:@"data"];
            if ([dictArr isKindOfClass:[NSArray class]]) {
                NSArray *categorys = [MovieCategory mj_objectArrayWithKeyValuesArray:dictArr];
                success ? success(categorys) : nil;
            }else{
                failure ? failure(nil) : nil;
            }
        }else{
            failure ? failure(nil) : nil;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure ? failure(error) : nil;
    }];
}

+ (void)getDetailWithID:(NSString *)ID Success:(void(^)(NSArray<MovieDetail *> *details))success failure:(void(^)(NSError *error))failure{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:kMovieDetail forKey:@"service"];
    [param setValue:ID forKey:@"id"];
    [[self sharedManager] GET:kAPI parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSArray *dictArr = [responseObject valueForKey:@"data"];
            if ([dictArr isKindOfClass:[NSArray class]]) {
                NSArray *details = [MovieDetail mj_objectArrayWithKeyValuesArray:dictArr];
                success ? success(details) : nil;
            }else{
                failure ? failure(nil) : nil;
            }
        }else{
            failure ? failure(nil) : nil;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure ? failure(error) : nil;
    }];
}

+ (void)getIndexWithID:(NSString *)ID recommend:(NSString *)recommend keyword:(NSString *)keyword page:(NSString *)page limit:(NSString *)limit success:(void(^)(NSArray<MovieModel *> *movies))success failure:(void(^)(NSError *error))failure{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:kMovieIndex forKey:@"service"];
    [param setValue:ID forKey:@"id"];
    [param setValue:recommend forKey:@"recommend"];
    [param setValue:keyword forKey:@"keyword"];
    [param setValue:page forKey:@"page"];
    [param setValue:limit forKey:@"limit"];
    [[self sharedManager] GET:kAPI parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSArray *dictArr = [responseObject valueForKey:@"data"];
            if ([dictArr isKindOfClass:[NSArray class]]) {
                NSArray *details = [MovieModel mj_objectArrayWithKeyValuesArray:dictArr];
                success ? success(details) : nil;
            }else{
                failure ? failure(nil) : nil;
            }
        }else{
            failure ? failure(nil) : nil;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure ? failure(error) : nil;
    }];
}


+ (void)getBannersSuccess:(void(^)(NSArray<BannerModel *> *banners))success failure:(void(^)(NSError *error))failure{    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:kMovieBanner forKey:@"service"];
    [[self sharedManager] GET:kAPI parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSArray *dictArr = [responseObject valueForKey:@"data"];
            if ([dictArr isKindOfClass:[NSArray class]]) {
                NSArray *banners = [BannerModel mj_objectArrayWithKeyValuesArray:dictArr];
                success ? success(banners) : nil;
            }else{
                failure ? failure(nil) : nil;
            }
        }else{
            failure ? failure(nil) : nil;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure ? failure(error) : nil;
    }];
}

+ (void)getVersionSuccess:(void(^)(VersionModel *version))success failure:(void(^)(NSError *error))failure{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:kVersionIndex forKey:@"service"];
    [[self sharedManager] GET:kAPI parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = [responseObject valueForKey:@"data"];
            if ([dict isKindOfClass:[NSDictionary class]]) {
                VersionModel *version = [VersionModel mj_objectWithKeyValues:dict];
                success ? success(version) : nil;
            }else{
                failure ? failure(nil) : nil;
            }
        }else{
            failure ? failure(nil) : nil;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure ? failure(error) : nil;
    }];
}


@end
