//
//  InvsCell.h
//  ShinePhone
//
//  Created by LinKai on 15/5/29.
//  Copyright (c) 2015年 binghe168. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EquipmentCell : UITableViewCell

@property (nonatomic, assign) NSInteger type;

- (void)setData:(NSDictionary *)dataDict;

@end
