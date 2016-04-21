//
//  LineView.h
//  ShinePhone
//
//  Created by LinKai on 15/5/26.
//  Copyright (c) 2015年 binghe168. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LineView : UIView

- (void)refreshLineChartViewWithDataDict:(NSMutableDictionary *)dataDict;

- (void)refreshBarChartViewWithDataDict:(NSMutableDictionary *)dataDict chartType:(NSInteger)type;

@end
