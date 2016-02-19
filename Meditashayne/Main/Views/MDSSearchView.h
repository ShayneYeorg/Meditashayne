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
- (void)searchView:(MDSSearchView *)searchView didDragging:(CGFloat)dragDistance;

@end

@interface MDSSearchView : UIView

@property (nonatomic, strong) id <MDSSearchViewDelegate> delegate;

+ (instancetype)loadFromNibWithFrame:(CGRect)frame;

@end
