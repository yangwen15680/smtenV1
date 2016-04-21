//
//  StationCellectTableViewCell.m
//  ShinePhone
//
//  Created by ZML on 15/5/26.
//  Copyright (c) 2015年 binghe168. All rights reserved.
//

#import "StationCellectTableViewCell.h"
@interface StationCellectTableViewCell ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *todayEnergyLabel;
@property (nonatomic, strong) UILabel *totalEnergyLabel;
@property (nonatomic, strong) UILabel *currentPowerLabel;
@property (nonatomic, strong) UILabel *moneyLabel;

@end

@implementation StationCellectTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        
        //背景
        self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_Width, 200*NOW_SIZE)];
        self.bgView.backgroundColor = COLOR(0, 200, 154, 1);
        [self.contentView addSubview:_bgView];
        
//        //箭头
//        UIImageView *arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_Width - 32*NOW_SIZE, (200*NOW_SIZE - 30*NOW_SIZE)/2, 30*NOW_SIZE, 30*NOW_SIZE)];
//        arrowView.image = IMAGE(@"icon_arrow.png");
//        [self.contentView addSubview:arrowView];
        
        //别名
        UILabel *othername = [[UILabel alloc] initWithFrame:CGRectMake(40*NOW_SIZE, 12*NOW_SIZE, 120*NOW_SIZE, 20*NOW_SIZE)];
        othername.text = root_aliases;
        othername.textColor = [UIColor whiteColor];
        othername.font=[UIFont systemFontOfSize:12*NOW_SIZE];
        [self.contentView addSubview:othername];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(160*NOW_SIZE, 14*NOW_SIZE, 140*NOW_SIZE, 20*NOW_SIZE)];
        self.titleLabel.text = root_aliases;
        self.titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font=[UIFont systemFontOfSize:14*NOW_SIZE];
        [self.contentView addSubview:_titleLabel];

        self.statusLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_titleLabel.frame)+2*NOW_SIZE, 12*NOW_SIZE, 20*NOW_SIZE, 20*NOW_SIZE)];
        self.statusLabel.textColor = [UIColor yellowColor];
        self.statusLabel.font=[UIFont systemFontOfSize:14*NOW_SIZE];
        [self.contentView addSubview:self.statusLabel];
        
        UIView *line1=[[UIView alloc]initWithFrame:CGRectMake(40*NOW_SIZE, 40*NOW_SIZE, 240*NOW_SIZE, 0.5)];
        line1.backgroundColor=[UIColor whiteColor];
        [self.contentView addSubview:line1];
        
        //采集器序列号
        UILabel *todayEnergyTitleLable = [[UILabel alloc] initWithFrame:CGRectMake(40*NOW_SIZE, 40*NOW_SIZE, 120*NOW_SIZE, 40*NOW_SIZE)];
        todayEnergyTitleLable.text = root_datalog_sn;
        todayEnergyTitleLable.font = [UIFont systemFontOfSize:12*NOW_SIZE];
        todayEnergyTitleLable.textColor = [UIColor whiteColor];
        [self.contentView addSubview:todayEnergyTitleLable];
        
        self.todayEnergyLabel = [[UILabel alloc] initWithFrame:CGRectMake(160*NOW_SIZE, 40*NOW_SIZE, 120*NOW_SIZE, 40*NOW_SIZE)];
        self.todayEnergyLabel.text = root_datalog_sn;
        self.todayEnergyLabel.font = [UIFont systemFontOfSize:14*NOW_SIZE];
        self.todayEnergyLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_todayEnergyLabel];
        
        UIView *line2=[[UIView alloc]initWithFrame:CGRectMake(40*NOW_SIZE, 80*NOW_SIZE, 240*NOW_SIZE, 0.5)];
        line2.backgroundColor=[UIColor whiteColor];
        [self.contentView addSubview:line2];
        
        //组别
        UILabel *totalEnergyTitleLable = [[UILabel alloc] initWithFrame:CGRectMake(40*NOW_SIZE, 80*NOW_SIZE, 120*NOW_SIZE, 40*NOW_SIZE)];
        totalEnergyTitleLable.text = root_group;
        totalEnergyTitleLable.font = [UIFont systemFontOfSize:12*NOW_SIZE];
        totalEnergyTitleLable.textColor = [UIColor whiteColor];
        [self.contentView addSubview:totalEnergyTitleLable];
        
        self.totalEnergyLabel = [[UILabel alloc] initWithFrame:CGRectMake(160*NOW_SIZE, 80*NOW_SIZE, 120*NOW_SIZE, 40*NOW_SIZE)];
        self.totalEnergyLabel.text = root_group;
        self.totalEnergyLabel.font = [UIFont systemFontOfSize:14*NOW_SIZE];
        self.totalEnergyLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_totalEnergyLabel];
        
        UIView *line3=[[UIView alloc]initWithFrame:CGRectMake(40*NOW_SIZE, 120*NOW_SIZE, 240*NOW_SIZE, 0.5)];
        line3.backgroundColor=[UIColor whiteColor];
        [self.contentView addSubview:line3];
        
        //设备类型
        UILabel *currentPowerTitleLable = [[UILabel alloc] initWithFrame:CGRectMake(40*NOW_SIZE, 120*NOW_SIZE, 120*NOW_SIZE, 40*NOW_SIZE)];
        currentPowerTitleLable.text = root_device_type;
        currentPowerTitleLable.font = [UIFont systemFontOfSize:12*NOW_SIZE];
        currentPowerTitleLable.textColor = [UIColor whiteColor];
        [self.contentView addSubview:currentPowerTitleLable];
        
        self.currentPowerLabel = [[UILabel alloc] initWithFrame:CGRectMake(160*NOW_SIZE, 120*NOW_SIZE, 120*NOW_SIZE, 40*NOW_SIZE)];
        self.currentPowerLabel.text = root_device_type;
        self.currentPowerLabel.font = [UIFont systemFontOfSize:14*NOW_SIZE];
        self.currentPowerLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_currentPowerLabel];
        
        UIView *line4=[[UIView alloc]initWithFrame:CGRectMake(40*NOW_SIZE, 160*NOW_SIZE, 240*NOW_SIZE, 0.5)];
        line4.backgroundColor=[UIColor whiteColor];
        [self.contentView addSubview:line4];
        
        //更新间隔
        UILabel *moneyTitleLable = [[UILabel alloc] initWithFrame:CGRectMake(40*NOW_SIZE, 160*NOW_SIZE, 120*NOW_SIZE, 40*NOW_SIZE)];
        moneyTitleLable.text = root_data_update_interval;
        moneyTitleLable.font = [UIFont systemFontOfSize:12*NOW_SIZE];
        moneyTitleLable.textColor = [UIColor whiteColor];
        [self.contentView addSubview:moneyTitleLable];
        
        self.moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(160*NOW_SIZE, 160*NOW_SIZE, 120*NOW_SIZE, 40*NOW_SIZE)];
        self.moneyLabel.text = root_data_update_interval;
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

- (void)setData:(NSDictionary *)dataDict {
    
    _titleLabel.text=dataDict[@"alias"];
    [_titleLabel sizeToFit];
    
    _statusLabel.frame=CGRectMake(CGRectGetMaxX(_titleLabel.frame)+2*NOW_SIZE, 12*NOW_SIZE, 60*NOW_SIZE, 20*NOW_SIZE);
    

    if ([dataDict[@"lost"] integerValue]==1) {
        _statusLabel.text=NSLocalizedString(@"(Off-line)", @"(Off-line)");
    }else{
        _statusLabel.text = NSLocalizedString(@"(On-line)", @"(On-line)");
    }
    self.todayEnergyLabel.text = dataDict[@"datalog_sn"];
    self.totalEnergyLabel.text = dataDict[@"unit_id"];
    self.currentPowerLabel.text = dataDict[@"device_type"];
    self.moneyLabel.text = dataDict[@"update_interval"];
    
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
