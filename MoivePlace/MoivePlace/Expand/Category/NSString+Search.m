//
//  NSString+Search.m
//  1122Tool
//
//  Created by yanglin on 16/10/16.
//  Copyright © 2016年 wapushidai. All rights reserved.
//

#import "NSString+Search.h"

@implementation NSString (Search)

-(BOOL)containStr:(NSString *)str{
    if([self rangeOfString:str].location !=NSNotFound){
        return YES;
    }else{
        return NO;
    }
}

@end
