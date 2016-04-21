//
//  EditStationMenuView.m
//  ShinePhone
//
//  Created by LinKai on 15/4/22.
//  Copyright (c) 2015年 binghe168. All rights reserved.
//

#import "EditStationMenuView.h"

@implementation EditStationMenuView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(frame.size.width - 64, 44, 44*NOW_SIZE, 44*NOW_SIZE);
        cancelButton.imageEdgeInsets = UIEdgeInsetsMake(7*NOW_SIZE, 7*NOW_SIZE, 7*NOW_SIZE, 7*NOW_SIZE);
        [cancelButton setImage:IMAGE(@"btn_cha.png") forState:UIControlStateNormal];
        cancelButton.tag = 1050;
        [cancelButton addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelButton];
        
        UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(55*NOW_SIZE, 180*NOW_SIZE, frame.size.width - 110*NOW_SIZE, 230*NOW_SIZE)];
        bgImageView.image = IMAGE(@"bg_list_popver.png");
        bgImageView.userInteractionEnabled = YES;
        [self addSubview:bgImageView];
        
        UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        addButton.frame = CGRectMake(0, 0 * CGRectGetHeight(bgImageView.frame)/4, CGRectGetWidth(bgImageView.frame), CGRectGetHeight(bgImageView.frame)/4);
        [addButton setTitle:root_Add_Plant forState:UIControlStateNormal];
        [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [addButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        addButton.tag = 1051;
        [addButton addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        [bgImageView addSubview:addButton];
        
        UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteButton.frame = CGRectMake(0, 1 * CGRectGetHeight(bgImageView.frame)/4, CGRectGetWidth(bgImageView.frame), CGRectGetHeight(bgImageView.frame)/4);
        [deleteButton setTitle:root_Remove_Station forState:UIControlStateNormal];
        [deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [deleteButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        deleteButton.tag = 1052;
        [deleteButton addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        [bgImageView addSubview:deleteButton];
        
        UIButton *uploadStationImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        uploadStationImageButton.frame = CGRectMake(0, 2 * CGRectGetHeight(bgImageView.frame)/4, CGRectGetWidth(bgImageView.frame), CGRectGetHeight(bgImageView.frame)/4);
        [uploadStationImageButton setTitle:root_Upload_Picture forState:UIControlStateNormal];
        [uploadStationImageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [uploadStationImageButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        uploadStationImageButton.tag = 1053;
        [uploadStationImageButton addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        [bgImageView addSubview:uploadStationImageButton];
        
        UIButton *setMapButton = [UIButton buttonWithType:UIButtonTypeCustom];
        setMapButton.frame = CGRectMake(0, 3 * CGRectGetHeight(bgImageView.frame)/4, CGRectGetWidth(bgImageView.frame), CGRectGetHeight(bgImageView.frame)/4);
        [setMapButton setTitle:root_Setting_Station_Map forState:UIControlStateNormal];
        [setMapButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [setMapButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        setMapButton.tag = 1054;
        [setMapButton addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        [bgImageView addSubview:setMapButton];
//        
//        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 4 * CGRectGetHeight(bgImageView.frame)/4, CGRectGetWidth(bgImageView.frame), 0.5*NOW_SIZE)];
//        lineView.backgroundColor = [UIColor whiteColor];
//        [bgImageView addSubview:lineView];
//        
//        UIView *vLineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(bgImageView.frame)/2, 4 * CGRectGetHeight(bgImageView.frame)/4, 0.5*NOW_SIZE, CGRectGetHeight(bgImageView.frame)/4 - 10*NOW_SIZE)];
//        vLineView.backgroundColor = [UIColor whiteColor];
//        [bgImageView addSubview:vLineView];
//        
//        UIButton *baiduMapButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        baiduMapButton.frame = CGRectMake(0, 4 * CGRectGetHeight(bgImageView.frame)/4, CGRectGetWidth(bgImageView.frame)/2, CGRectGetHeight(bgImageView.frame)/4 - 10*NOW_SIZE);
//        [baiduMapButton setTitle:root_Baidu_Map forState:UIControlStateNormal];
//        [baiduMapButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [baiduMapButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
//        baiduMapButton.tag = 1055;
//        [baiduMapButton addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
//        [bgImageView addSubview:baiduMapButton];
//        
//        UIButton *googleMapButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        googleMapButton.frame = CGRectMake(CGRectGetWidth(bgImageView.frame)/2, 4 * CGRectGetHeight(bgImageView.frame)/4, CGRectGetWidth(bgImageView.frame)/2, CGRectGetHeight(bgImageView.frame)/4 - 10*NOW_SIZE);
//        [googleMapButton setTitle:root_Google_Map forState:UIControlStateNormal];
//        [googleMapButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [googleMapButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
//        googleMapButton.tag = 1056;
//        [googleMapButton addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
//        [bgImageView addSubview:googleMapButton];
    }
    
    return self;
}

- (void)buttonDidClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(menuDidSelectAtRow:)]) {
        [self.delegate menuDidSelectAtRow:(sender.tag - 1050)];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self removeFromSuperview];
}

@end
