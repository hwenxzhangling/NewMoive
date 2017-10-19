//
//  TLSearchBar.h
//  1122Tool
//
//  Created by yanglin on 16/10/13.
//  Copyright © 2016年 wapushidai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TLSearchBar;

@protocol TLSearchBarDelegate <NSObject,UITextFieldDelegate>
@optional
-(void)searchBarValueChange:(TLSearchBar *)searchBar;

@end


@interface TLSearchBar : UITextField
@property (weak, nonatomic) id <TLSearchBarDelegate> searchBarDelegate;
-(instancetype)initWithTarget:(id)target;

- (void)reset;
@end
