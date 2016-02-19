//
//  MDSSearchView.h
//  Meditashayne
//
//  Created by 杨淳引 on 16/2/3.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MDSSearchView;

@protocol MDSSearchViewDelegate <NSObject>

- (void)searchViewDidClicksSearchBtn:(MDSSearchView *)searchView;

@end

@interface MDSSearchView : UIView

+ (instancetype)loadFromNibWithFrame:(CGRect)frame;

@end
