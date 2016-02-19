//
//  MDSSearchView.h
//  Meditashayne
//
//  Created by 杨淳引 on 16/2/3.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum _SearchViewState {
    Search_View_State_Hidden = 0,
    Search_View_State_Show,
    Search_View_State_Input
} SearchViewState;

@class MDSSearchView;

@protocol MDSSearchViewDelegate <NSObject>

- (void)searchViewDidClickSearchBtn:(MDSSearchView *)searchView;
- (void)searchView:(MDSSearchView *)searchView didDragging:(CGFloat)dragDistance;
- (void)searchViewDidEndDragging:(MDSSearchView *)searchView ;

@end

@interface MDSSearchView : UIView

@property (nonatomic, strong) id <MDSSearchViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *searchfield; //搜索框

+ (instancetype)loadFromNibWithFrame:(CGRect)frame;
//+ (instancetype)loadFromNib;

@end
