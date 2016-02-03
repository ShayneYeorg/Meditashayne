//
//  MDSSearchView.m
//  Meditashayne
//
//  Created by 杨淳引 on 16/2/3.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "MDSSearchView.h"

@implementation MDSSearchView

#pragma mark - Public

+ (instancetype)loadFromNib {
    MDSSearchView *view = [[NSBundle mainBundle] loadNibNamed:@"MDSSearchView" owner:nil options:nil][0];
    
    return view;
}

@end
