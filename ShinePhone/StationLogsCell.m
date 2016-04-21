//
//  StationLogsCell.m
//  ShinePhone
//
//  Created by ZML on 15/5/29.
//  Copyright (c) 2015年 binghe168. All rights reserved.
//

#import "StationLogsCell.h"

@interface StationLogsCell ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *todayEnergyLabel;
@property (nonatomic, strong) UILabel *totalEnergyLabel;
@property (nonatomic, strong) UILabel *currentPowerLabel;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UILabel *equipTpye;

@end

@implementation StationLogsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        
        //背景
        self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_Width, 260*NOW_SIZE)];
        self.bgView.backgroundColor = COLOR(0, 200, 154, 1);
        [self.contentView addSubview:_bgView];
        
        
        //逆变器
        UILabel *othername = [[UILabel alloc] initWithFrame:CGRectMake(10*NOW_SIZE, 0, 90*NOW_SIZE, 40*NOW_SIZE)];
        othername.text = root_Name;
        othername.textColor = [UIColor whiteColor];
        othername.font=[UIFont systemFontOfSize:12*NOW_SIZE];
        [self.contentView addSubview:othername];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100*NOW_SIZE, 0, 210*NOW_SIZE, 40*NOW_SIZE)];
        self.titleLabel.text = @"";
        self.titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font=[UIFont systemFontOfSize:12*NOW_SIZE];
        [self.contentView addSubview:_titleLabel];
        
        UIView *line1=[[UIView alloc]initWithFrame:CGRectMake(10*NOW_SIZE, 40*NOW_SIZE, 300*NOW_SIZE, 0.5)];
        line1.backgroundColor=[UIColor whiteColor];
        [self.contentView addSubview:line1];
        
        //时间
        UILabel *todayEnergyTitleLable = [[UILabel alloc] initWithFrame:CGRectMake(10*NOW_SIZE, 40*NOW_SIZE, 90*NOW_SIZE, 40*NOW_SIZE)];
        todayEnergyTitleLable.text = root_Time;
        todayEnergyTitleLable.font = [UIFont systemFontOfSize:12*NOW_SIZE];
        todayEnergyTitleLable.textColor = [UIColor whiteColor];
        [self.contentView addSubview:todayEnergyTitleLable];
        
        self.todayEnergyLabel = [[UILabel alloc] initWithFrame:CGRectMake(100*NOW_SIZE, 40*NOW_SIZE, 210*NOW_SIZE, 40*NOW_SIZE)];
        self.todayEnergyLabel.text = @"2015-05-05";
        self.todayEnergyLabel.font = [UIFont systemFontOfSize:12*NOW_SIZE];
        self.todayEnergyLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_todayEnergyLabel];
        
        UIView *line2=[[UIView alloc]initWithFrame:CGRectMake(10*NOW_SIZE, 80*NOW_SIZE, 300*NOW_SIZE, 0.5)];
        line2.backgroundColor=[UIColor whiteColor];
        [self.contentView addSubview:line2];
        
        //设备类型
        UILabel *type = [[UILabel alloc] initWithFrame:CGRectMake(10*NOW_SIZE, 80*NOW_SIZE, 90*NOW_SIZE, 40*NOW_SIZE)];
        type.text = root_device_type;
        type.font = [UIFont systemFontOfSize:12*NOW_SIZE];
        type.textColor = [UIColor whiteColor];
        [self.contentView addSubview:type];
        
        self.equipTpye = [[UILabel alloc] initWithFrame:CGRectMake(100*NOW_SIZE, 80*NOW_SIZE, 210*NOW_SIZE, 40*NOW_SIZE)];
        self.equipTpye.text = @"";
        self.equipTpye.font = [UIFont systemFontOfSize:12*NOW_SIZE];
        self.equipTpye.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_equipTpye];
        
        UIView *line3=[[UIView alloc]initWithFrame:CGRectMake(10*NOW_SIZE, 120*NOW_SIZE, 300*NOW_SIZE, 0.5)];
        line3.backgroundColor=[UIColor whiteColor];
        [self.contentView addSubview:line3];
        
        //错误码
        UILabel *totalEnergyTitleLable = [[UILabel alloc] initWithFrame:CGRectMake(10*NOW_SIZE, 120*NOW_SIZE, 90*NOW_SIZE, 40*NOW_SIZE)];
        totalEnergyTitleLable.text = root_Warning_Code;
        totalEnergyTitleLable.font = [UIFont systemFontOfSize:12*NOW_SIZE];
        totalEnergyTitleLable.textColor = [UIColor whiteColor];
        [self.contentView addSubview:totalEnergyTitleLable];
        
        self.totalEnergyLabel = [[UILabel alloc] initWithFrame:CGRectMake(100*NOW_SIZE, 120*NOW_SIZE, 210*NOW_SIZE, 40*NOW_SIZE)];
        self.totalEnergyLabel.text = @"";
        self.totalEnergyLabel.font = [UIFont systemFontOfSize:12*NOW_SIZE];
        self.totalEnergyLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_totalEnergyLabel];
        
        UIView *line4=[[UIView alloc]initWithFrame:CGRectMake(10*NOW_SIZE, 160*NOW_SIZE, 300*NOW_SIZE, 0.5)];
        line4.backgroundColor=[UIColor whiteColor];
        [self.contentView addSubview:line4];
        
        //错误描述
        UILabel *currentPowerTitleLable = [[UILabel alloc] initWithFrame:CGRectMake(10*NOW_SIZE, 160*NOW_SIZE, 90*NOW_SIZE, 40*NOW_SIZE)];
        currentPowerTitleLable.text = root_Warning_Description;
        currentPowerTitleLable.font = [UIFont systemFontOfSize:12*NOW_SIZE];
        currentPowerTitleLable.numberOfLines=2;
        currentPowerTitleLable.textAlignment=UITextLayoutDirectionUp;
        currentPowerTitleLable.textColor = [UIColor whiteColor];
        [self.contentView addSubview:currentPowerTitleLable];
        
        self.currentPowerLabel = [[UILabel alloc] initWithFrame:CGRectMake(100*NOW_SIZE, 160*NOW_SIZE, 210*NOW_SIZE, 100*NOW_SIZE)];
        self.currentPowerLabel.text = @"";
        self.currentPowerLabel.font = [UIFont systemFontOfSize:12*NOW_SIZE];
        self.currentPowerLabel.textColor = [UIColor whiteColor];
        self.currentPowerLabel.numberOfLines=5;
        self.currentPowerLabel.textAlignment=UITextLayoutDirectionUp;
        [self.contentView addSubview:_currentPowerLabel];
        
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
    self.titleLabel.text=dataDict[@"deviceSerialNum"];
    self.todayEnergyLabel.text=dataDict[@"occurTime"];
    self.equipTpye.text=dataDict[@"deviceType"];
    self.totalEnergyLabel.text = dataDict[@"eventId"];
    self.currentPowerLabel.text = dataDict[@"eventDescription"];
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
