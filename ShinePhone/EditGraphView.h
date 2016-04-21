//
//  EditGraphView.h
//  ShinePhone
//
//  Created by ZML on 15/6/4.
//  Copyright (c) 2015年 binghe168. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FXBlurView/FXBlurView.h>

@protocol EditGraphViewDelegate <NSObject>

@optional

- (void)menuDidSelectAtRow:(NSInteger)row;

@end

@interface EditGraphView : FXBlurView

@property (nonatomic, assign) id<EditGraphViewDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame dictionary:(NSDictionary *)dictionary;
@end