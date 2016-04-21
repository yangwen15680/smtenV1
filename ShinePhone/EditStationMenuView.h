//
//  EditStationMenuView.h
//  ShinePhone
//
//  Created by LinKai on 15/5/22.
//  Copyright (c) 2015年 binghe168. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FXBlurView/FXBlurView.h>

@protocol EditStationMenuViewDelegate <NSObject>

@optional

- (void)menuDidSelectAtRow:(NSInteger)row;

@end

@interface EditStationMenuView : FXBlurView

@property (nonatomic, assign) id<EditStationMenuViewDelegate> delegate;

@end
