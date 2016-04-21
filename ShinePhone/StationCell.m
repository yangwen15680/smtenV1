//
//  StationCell.m
//  ShinePhone
//
//  Created by LinKai on 15/5/20.
//  Copyright (c) 2015年 binghe168. All rights reserved.
//

#import "StationCell.h"
#import <EGOCache.h>

@interface StationCell ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *todayEnergyLabel;
@property (nonatomic, strong) UILabel *totalEnergyLabel;
@property (nonatomic, strong) UILabel *currentPowerLabel;
@property (nonatomic, strong) UILabel *moneyLabel;

@property (nonatomic, strong) NSString *imageURlStr;

@end

@implementation StationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        
        //背景
        self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_Width, 125*NOW_SIZE)];
        self.bgView.backgroundColor = COLOR(81, 200, 194, 1);
        [self.contentView addSubview:_bgView];
        
        //箭头
        UIImageView *arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_Width - 32*NOW_SIZE, (125*NOW_SIZE - 30*NOW_SIZE)/2, 30*NOW_SIZE, 30*NOW_SIZE)];
        arrowView.image = IMAGE(@"icon_arrow.png");
        [self.contentView addSubview:arrowView];
        
        //封面
        self.coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(13*NOW_SIZE, 15*NOW_SIZE, 100*NOW_SIZE, 100*NOW_SIZE)];
        [self.contentView addSubview:_coverImageView];
        
        //标题
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(113*NOW_SIZE, 0, SCREEN_Width - 113*NOW_SIZE, 35*NOW_SIZE)];
        self.titleLabel.text = @"Demo Station";
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_titleLabel];
        
        //日发电量
        UILabel *todayEnergyTitleLable = [[UILabel alloc] initWithFrame:CGRectMake(120*NOW_SIZE, 35*NOW_SIZE, 90*NOW_SIZE, 20*NOW_SIZE)];
        todayEnergyTitleLable.text = root_Today_Energy;
        todayEnergyTitleLable.font = [UIFont systemFontOfSize:12*NOW_SIZE];
        todayEnergyTitleLable.textColor = [UIColor whiteColor];
        [self.contentView addSubview:todayEnergyTitleLable];
        
        self.todayEnergyLabel = [[UILabel alloc] initWithFrame:CGRectMake(215*NOW_SIZE, 35*NOW_SIZE, 70*NOW_SIZE, 20*NOW_SIZE)];
        self.todayEnergyLabel.text = root_Today_Energy;
        self.todayEnergyLabel.font = [UIFont systemFontOfSize:14*NOW_SIZE];
        self.todayEnergyLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_todayEnergyLabel];
        
        //总发电量
        UILabel *totalEnergyTitleLable = [[UILabel alloc] initWithFrame:CGRectMake(120*NOW_SIZE, 55*NOW_SIZE, 90*NOW_SIZE, 20*NOW_SIZE)];
        totalEnergyTitleLable.text = root_Total_Energy;
        totalEnergyTitleLable.font = [UIFont systemFontOfSize:12*NOW_SIZE];
        totalEnergyTitleLable.textColor = [UIColor whiteColor];
        [self.contentView addSubview:totalEnergyTitleLable];
        
        self.totalEnergyLabel = [[UILabel alloc] initWithFrame:CGRectMake(215*NOW_SIZE, 55*NOW_SIZE, 70*NOW_SIZE, 20*NOW_SIZE)];
        self.totalEnergyLabel.text = root_Total_Energy;
        self.totalEnergyLabel.font = [UIFont systemFontOfSize:14*NOW_SIZE];
        self.totalEnergyLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_totalEnergyLabel];
        
        //当前功率
        UILabel *currentPowerTitleLable = [[UILabel alloc] initWithFrame:CGRectMake(120*NOW_SIZE, 75*NOW_SIZE, 90*NOW_SIZE, 20*NOW_SIZE)];
        currentPowerTitleLable.text = root_Current_Power;
        currentPowerTitleLable.font = [UIFont systemFontOfSize:12*NOW_SIZE];
        currentPowerTitleLable.textColor = [UIColor whiteColor];
        [self.contentView addSubview:currentPowerTitleLable];
        
        self.currentPowerLabel = [[UILabel alloc] initWithFrame:CGRectMake(215*NOW_SIZE, 75*NOW_SIZE, 70*NOW_SIZE, 20*NOW_SIZE)];
        self.currentPowerLabel.text = root_Current_Power;
        self.currentPowerLabel.font = [UIFont systemFontOfSize:14*NOW_SIZE];
        self.currentPowerLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_currentPowerLabel];
        
        //电站收益
        UILabel *moneyTitleLable = [[UILabel alloc] initWithFrame:CGRectMake(120*NOW_SIZE, 95*NOW_SIZE, 90*NOW_SIZE, 20*NOW_SIZE)];
        moneyTitleLable.text = root_Gains;
        moneyTitleLable.font = [UIFont systemFontOfSize:12*NOW_SIZE];
        moneyTitleLable.textColor = [UIColor whiteColor];
        [self.contentView addSubview:moneyTitleLable];
        
        self.moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(215*NOW_SIZE, 95*NOW_SIZE, 70*NOW_SIZE, 20*NOW_SIZE)];
        self.moneyLabel.text = root_Gains;
        self.moneyLabel.font = [UIFont systemFontOfSize:14*NOW_SIZE];
        self.moneyLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_moneyLabel];
        
    }
    
    return self;
}

- (NSString *)urlFormat:(NSString *)urlStr {
    NSString *url = urlStr;
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *characters = @"!$&'()*+,-./:;=?@_~%#[]";
    url = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,  (__bridge CFStringRef)url, (__bridge CFStringRef)characters, nil, kCFStringEncodingUTF8));
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return url;
}

- (void)clearImageCache {
    [[EGOCache globalCache] removeCacheForKey:self.imageURlStr];
}

- (void)setData:(NSDictionary *)dataDict {

    self.imageURlStr = [NSString stringWithFormat:@"%@/plantA.do?op=getImg&id=%@", HEAD_URL, dataDict[@"plantId"]];
    
    if ([[EGOCache globalCache] hasCacheForKey:self.imageURlStr]) {
        _coverImageView.image = [[EGOCache globalCache] imageForKey:self.imageURlStr];
    } else {
        [BaseRequest requestImageWithMethodByGet:HEAD_URL paramars:@{@"id":dataDict[@"plantId"]} paramarsSite:@"/plantA.do?op=getImg" sucessBlock:^(id content) {
            self.coverImageView.image = content;
            [[EGOCache globalCache] setImage:content forKey:self.imageURlStr];
        } failure:^(NSError *error) {
            
        }];
    }

    self.titleLabel.text = dataDict[@"plantName"];
    self.todayEnergyLabel.text = dataDict[@"todayEnergy"];
    self.totalEnergyLabel.text = dataDict[@"totalEnergy"];
    self.currentPowerLabel.text = dataDict[@"currentPower"];
    self.moneyLabel.text = dataDict[@"plantMoneyText"];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    
    UIView *selectedBgView = [[UIView alloc] initWithFrame:self.frame];
    selectedBgView.backgroundColor = [UIColor clearColor];
    UIView *forgroundSelectedBgView = [[UIView alloc] initWithFrame:self.bgView.frame];
    forgroundSelectedBgView.backgroundColor = COLOR(31, 166, 148, 1);
    [selectedBgView addSubview:forgroundSelectedBgView];
    
    self.selectedBackgroundView = selectedBgView;
    
//    self.selectedBackgroundView.backgroundColor = COLOR(31, 166, 148, 1);

//    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
