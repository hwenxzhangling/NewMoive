//
//  UIImageView+SDWebImageExtenson.m
//  GSJuZhang
//
//  Created by Kings Yan on 15/5/7.
//  Copyright (c) 2015年 __Qing__. All rights reserved.
//

#import "UIImageView+SDWebImageExtenson.h"
#import "UIView+Category.h"
#import "NSString+Extension.h"

@implementation UIImageView (SDWebImageExtenson)

- (void)setImageAddtionalIndicatorWithURL:(NSURL *)url addtional:(id)addtional completed:(SDWebImageCompletedBlock)completedBlock
{
    [self setImageAddtionalIndicatorWithIndicatorStyle:UIActivityIndicatorViewStyleWhite URL:url addtional:addtional completed:completedBlock];
}

- (void)setImageAddtionalIndicatorWithIndicatorStyle:(UIActivityIndicatorViewStyle)indicatorStyle URL:(NSURL *)url addtional:(id)addtional completed:(SDWebImageCompletedBlock)completedBlock
{
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    indicator.center = CGPointMake(self.width / 2, self.height / 2);
    indicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [indicator setActivityIndicatorViewStyle:indicatorStyle];
    [self addSubview:indicator];
    [indicator startAnimating];
    
    __weak typeof(self) weakSelf = self;
    [self setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        
        [indicator stopAnimating];
        [indicator removeFromSuperview];
        if (error || !image) {
            [weakSelf _fetchImageAtFailureCount:2 indicatorStyle:indicatorStyle URL:url addtional:addtional completed:completedBlock];
        }
        else{
            if (completedBlock) {
                completedBlock(image, error, cacheType);
            }
        }
    }];
}

- (void)_fetchImageAtFailureCount:(NSInteger)fetchCount indicatorStyle:(UIActivityIndicatorViewStyle)indicatorStyle URL:(NSURL *)url addtional:(id)addtional completed:(SDWebImageCompletedBlock)completedBlock
{
    if (addtional && [addtional isKindOfClass:[NSString class]] && [((NSString *)addtional) isPureInt]) {
        NSInteger count = [((NSString *)addtional) integerValue];
        if (count < fetchCount) {
            [self setImageAddtionalIndicatorWithIndicatorStyle:indicatorStyle URL:url addtional:[NSString stringWithFormat:@"%ld", count + 1] completed:completedBlock];
        }
        else{
            if (completedBlock) {
                completedBlock(nil, [NSError errorWithDomain:000000 code:10000 userInfo:nil], SDImageCacheTypeNone);
                
                // addtional indicator
                UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
                indicator.center = CGPointMake(self.width / 2, self.height / 2);
                indicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
                [indicator setActivityIndicatorViewStyle:indicatorStyle];
                [self addSubview:indicator];
                [indicator startAnimating];
            }
        }
    }
    else{
        [self setImageAddtionalIndicatorWithIndicatorStyle:indicatorStyle URL:url addtional:@"1" completed:completedBlock];
    }
}

@end
