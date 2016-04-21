//
//  UIAlertView+Block.h
//  UIAlertview-study
//
//  Created by Kevin Jin on 13-9-2.
//  Copyright (c) 2013年 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^CompleteBlock) (NSInteger buttonIndex);

@interface UIAlertView (Block)

// 用Block的方式回调，这时候会默认用self作为Delegate
- (void)showAlertViewWithCompleteBlock:(CompleteBlock) block;

@end
