//
//  NJKWebViewProgress.h
//
//  Created by Satoshi Aasano on 4/20/13.
//  Copyright (c) 2013 Satoshi Asano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CYWebViewController.h"
#undef njk_weak
#if __has_feature(objc_arc_weak)
#define njk_weak weak
#else
#define njk_weak unsafe_unretained
#endif

#define KBDSearchWebViewTag 500


extern const float NJKInitialProgressValue;
extern const float NJKInteractiveProgressValue;
extern const float NJKFinalProgressValue;

typedef void (^NJKWebViewProgressBlock)(float progress);
@protocol NJKWebViewProgressDelegate;
@interface NJKWebViewProgress : NSObject<UIWebViewDelegate>
+(NJKWebViewProgress *)shaareNJKWebViewProgress;

@property (nonatomic, weak) id<NJKWebViewProgressDelegate>progressDelegate;
@property (nonatomic, weak) id<UIWebViewDelegate>webViewProxyDelegate;
@property (nonatomic, copy) NJKWebViewProgressBlock progressBlock;
@property (nonatomic, readonly) float progress; // 0.0..1.0
@property (assign, nonatomic) BOOL hideHUD;


- (void)reset;
@end

@protocol NJKWebViewProgressDelegate <NSObject>
- (void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress;

@optional
- (void)back;
- (void)login;
- (void)pushURL:(NSURL *)url;
@end

