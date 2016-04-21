//
//  BaiduMapViewController.h
//  ShinePhone
//
//  Created by LinKai on 15/5/24.
//  Copyright (c) 2015年 binghe168. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import <BaiduMapAPI/BMapKit.h>

typedef void(^SnapshotSuccessBlock)(UIImage *snapshotImage);
typedef void(^LocationBlock)(CLLocationCoordinate2D coordinate);

@interface BaiduMapViewController : RootViewController

@property (nonatomic, copy) SnapshotSuccessBlock snapshotSuccessBlock;
@property (nonatomic, copy) LocationBlock locationBlock;

- (instancetype)initWithDataDict:(NSMutableDictionary *)dataDict;

- (instancetype)initToGetLocation;

@end
