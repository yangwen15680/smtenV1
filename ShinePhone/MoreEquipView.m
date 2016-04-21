//
//  MoreEquipView.m
//  ShinePhone
//
//  Created by ZML on 15/6/1.
//  Copyright (c) 2015年 binghe168. All rights reserved.
//

#import "MoreEquipView.h"

@implementation MoreEquipView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(frame.size.width - 64, 44, 44*NOW_SIZE, 44*NOW_SIZE);
        cancelButton.imageEdgeInsets = UIEdgeInsetsMake(7*NOW_SIZE, 7*NOW_SIZE, 7*NOW_SIZE, 7*NOW_SIZE);
        [cancelButton setImage:IMAGE(@"btn_cha.png") forState:UIControlStateNormal];
        cancelButton.tag = 1050;
        [cancelButton addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelButton];
        
        UIScrollView *bgImageView = [[UIScrollView alloc] initWithFrame:CGRectMake(55*NOW_SIZE, 150*NOW_SIZE, frame.size.width - 110*NOW_SIZE, 180*NOW_SIZE)];
        bgImageView.backgroundColor=COLOR(82, 201, 194, 1);
        [self addSubview:bgImageView];
        bgImageView.contentSize=CGSizeMake(frame.size.width - 110*NOW_SIZE, 181*NOW_SIZE);
        
        UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        addButton.frame = CGRectMake(0, 0 , CGRectGetWidth(bgImageView.frame), 60*NOW_SIZE);
        [addButton setTitle:@"智能电表" forState:UIControlStateNormal];
        [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [addButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        addButton.tag = 1051;
        [addButton addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        [bgImageView addSubview:addButton];
        
        UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteButton.frame = CGRectMake(0, 60*NOW_SIZE, CGRectGetWidth(bgImageView.frame), 60*NOW_SIZE);
        [deleteButton setTitle:@"汇流箱" forState:UIControlStateNormal];
        [deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [deleteButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        deleteButton.tag = 1052;
        [deleteButton addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        [bgImageView addSubview:deleteButton];
        
        UIButton *uploadStationImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        uploadStationImageButton.frame = CGRectMake(0, 120*NOW_SIZE, CGRectGetWidth(bgImageView.frame), 60*NOW_SIZE);
        [uploadStationImageButton setTitle:@"环境监测仪" forState:UIControlStateNormal];
        [uploadStationImageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [uploadStationImageButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        uploadStationImageButton.tag = 1053;
        [uploadStationImageButton addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        [bgImageView addSubview:uploadStationImageButton];
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
