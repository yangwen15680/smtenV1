//
//  EditCellectView.h
//  ShinePhone
//
//  Created by ZML on 15/5/26.
//  Copyright (c) 2015年 binghe168. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <FXBlurView/FXBlurView.h>

@protocol EditCellectViewDelegate <NSObject>

@optional

- (void)menuDidSelectAtRow:(NSInteger)row;

@end

@interface EditCellectView : FXBlurView

@property (nonatomic, assign) id<EditCellectViewDelegate> delegate;

@end
