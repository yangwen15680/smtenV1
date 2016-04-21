//
//  MoreEquipView.h
//  ShinePhone
//
//  Created by ZML on 15/6/1.
//  Copyright (c) 2015年 binghe168. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <FXBlurView/FXBlurView.h>

@protocol MoreEquipViewDelegate <NSObject>

@optional

- (void)menuDidSelectAtRow:(NSInteger)row;

@end

@interface MoreEquipView : FXBlurView

@property (nonatomic, assign) id<MoreEquipViewDelegate> delegate;

@end