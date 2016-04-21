//
//  InvsCell.m
//  ShinePhone
//
//  Created by LinKai on 15/5/29.
//  Copyright (c) 2015年 binghe168. All rights reserved.
//

#import "EquipmentCell.h"

@interface EquipmentCell ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UILabel *nicknameLable;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *addressLable;
@property (nonatomic, strong) UILabel *funcationTitleLabel;
@property (nonatomic, strong) UILabel *funcationLabel;
@property (nonatomic, strong) UILabel *updateTimeLabel;
@property (nonatomic, strong) UILabel *cellectionLabel;

@end

@implementation EquipmentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        
        //背景
        self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_Width, 150*NOW_SIZE)];
        self.bgView.backgroundColor = COLOR(81, 200, 194, 1);
        [self.contentView addSubview:_bgView];
        
        //箭头
        UIImageView *arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_Width - 32*NOW_SIZE, (150*NOW_SIZE - 30*NOW_SIZE)/2, 30*NOW_SIZE, 30*NOW_SIZE)];
        arrowView.image = IMAGE(@"icon_arrow.png");
        [self.contentView addSubview:arrowView];
        
        //封面
        self.coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(25*NOW_SIZE/2, 25*NOW_SIZE/2, 100*NOW_SIZE, 100*NOW_SIZE)];
        [self.contentView addSubview:_coverImageView];
        
        //别名
        UILabel *nicknameTitleLable = [[UILabel alloc] initWithFrame:CGRectMake(110*NOW_SIZE, 30*NOW_SIZE/2 + 0*25*NOW_SIZE, 80*NOW_SIZE, 20*NOW_SIZE)];
        nicknameTitleLable.text = root_Aliases;
        nicknameTitleLable.font = [UIFont systemFontOfSize:8*NOW_SIZE];
        nicknameTitleLable.textColor = [UIColor whiteColor];
        [self.contentView addSubview:nicknameTitleLable];
        
        self.nicknameLable = [[UILabel alloc] initWithFrame:CGRectMake(190*NOW_SIZE, 30*NOW_SIZE/2 + 0*25*NOW_SIZE, 90*NOW_SIZE, 20*NOW_SIZE)];
        self.nicknameLable.font = [UIFont systemFontOfSize:12*NOW_SIZE];
        self.nicknameLable.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_nicknameLable];
        
        //状态
        self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(270*NOW_SIZE, 30*NOW_SIZE/2 + 0*25*NOW_SIZE, 60*NOW_SIZE, 20*NOW_SIZE)];
        self.statusLabel.textAlignment = NSTextAlignmentCenter;
//        self.statusLabel.textColor = COLOR(123, 19, 29, 1);
        self.statusLabel.font = [UIFont systemFontOfSize:8*NOW_SIZE];
        [self.contentView addSubview:_statusLabel];
        
        //地址
        UILabel *addressTitleLable = [[UILabel alloc] initWithFrame:CGRectMake(110*NOW_SIZE, 30*NOW_SIZE/2 + 1*25*NOW_SIZE, 80*NOW_SIZE, 20*NOW_SIZE)];
        addressTitleLable.text = root_Address;
        addressTitleLable.font = [UIFont systemFontOfSize:8*NOW_SIZE];
        addressTitleLable.textColor = [UIColor whiteColor];
        [self.contentView addSubview:addressTitleLable];
        
        self.addressLable = [[UILabel alloc] initWithFrame:CGRectMake(190*NOW_SIZE, 30*NOW_SIZE/2 + 1*25*NOW_SIZE, 100*NOW_SIZE, 20*NOW_SIZE)];
        self.addressLable.font = [UIFont systemFontOfSize:12*NOW_SIZE];
        self.addressLable.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_addressLable];
        
        //总发电量
        self.funcationTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(110*NOW_SIZE, 30*NOW_SIZE/2 + 2*25*NOW_SIZE, 80*NOW_SIZE, 20*NOW_SIZE)];
        self.funcationTitleLabel.font = [UIFont systemFontOfSize:8*NOW_SIZE];
        self.funcationTitleLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:self.funcationTitleLabel];
        
        self.funcationLabel = [[UILabel alloc] initWithFrame:CGRectMake(190*NOW_SIZE, 30*NOW_SIZE/2 + 2*25*NOW_SIZE, 100*NOW_SIZE, 20*NOW_SIZE)];
        self.funcationLabel.font = [UIFont systemFontOfSize:12*NOW_SIZE];
        self.funcationLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_funcationLabel];
        
        //更新时间
        UILabel *updateTimeTitleLable = [[UILabel alloc] initWithFrame:CGRectMake(110*NOW_SIZE, 30*NOW_SIZE/2 + 3*25*NOW_SIZE, 80*NOW_SIZE, 20*NOW_SIZE)];
        updateTimeTitleLable.text = root_Update_Time;
        updateTimeTitleLable.font = [UIFont systemFontOfSize:8*NOW_SIZE];
        updateTimeTitleLable.textColor = [UIColor whiteColor];
        [self.contentView addSubview:updateTimeTitleLable];
        
        self.updateTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(190*NOW_SIZE, 30*NOW_SIZE/2 + 3*25*NOW_SIZE, 120*NOW_SIZE, 20*NOW_SIZE)];
        self.updateTimeLabel.font = [UIFont systemFontOfSize:12*NOW_SIZE];
        self.updateTimeLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_updateTimeLabel];
        
        //采集器
        UILabel *cellectionTitleLable = [[UILabel alloc] initWithFrame:CGRectMake(110*NOW_SIZE, 30*NOW_SIZE/2 + 4*25*NOW_SIZE, 80*NOW_SIZE, 20*NOW_SIZE)];
        cellectionTitleLable.text = root_Datalog;
        cellectionTitleLable.font = [UIFont systemFontOfSize:8*NOW_SIZE];
        cellectionTitleLable.textColor = [UIColor whiteColor];
        [self.contentView addSubview:cellectionTitleLable];
        
        self.cellectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(190*NOW_SIZE, 30*NOW_SIZE/2 + 4*25*NOW_SIZE, 120*NOW_SIZE, 20*NOW_SIZE)];
        self.cellectionLabel.font = [UIFont systemFontOfSize:12*NOW_SIZE];
        self.cellectionLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_cellectionLabel];
    }
    
    return self;
}

- (void)setData:(NSDictionary *)dataDict {
    if (_type == 1) {
        self.funcationTitleLabel.text = root_Total_Energy;
        self.coverImageView.image = IMAGE(@"逆变器.png");
        self.nicknameLable.text = dataDict[@"alias"];
        self.addressLable.text = [NSString stringWithFormat:@"%ld", (long)[dataDict[@"address"] integerValue]];
        self.funcationLabel.text = dataDict[@"energyMonthText"];
        self.updateTimeLabel.text = dataDict[@"lastUpdateTimeText"];
        if ([dataDict[@"status"] integerValue] == -1) {
            self.statusLabel.text = NSLocalizedString(@"Off-line", @"Off-line");
            self.statusLabel.textColor = [UIColor darkGrayColor];
        } else if ([dataDict[@"status"] integerValue] == 0) {
            self.statusLabel.text = NSLocalizedString(@"Wait", @"Wait");
            self.statusLabel.textColor = [UIColor lightGrayColor];
        } else if ([dataDict[@"status"] integerValue] == 1) {
            self.statusLabel.text = NSLocalizedString(@"On-line", @"On-line");
            self.statusLabel.textColor = [UIColor greenColor];
        } else {
            self.statusLabel.text = NSLocalizedString(@"Fault", @"Fault");
            self.statusLabel.textColor = [UIColor redColor];
        }
        self.cellectionLabel.text=dataDict[@"dataLogSn"];
    }
    
    if (_type == 2) {
        //5.设备-储能机列表：有功率改成电池容量
        self.funcationTitleLabel.text = root_Battery_Percentage;
        self.coverImageView.image = IMAGE(@"储能机.png");
        self.nicknameLable.text = dataDict[@"alias"];
        self.addressLable.text = [NSString stringWithFormat:@"%ld", (long)[dataDict[@"address"] integerValue]];
        self.funcationLabel.text = dataDict[@"capacityText"];
        self.updateTimeLabel.text = dataDict[@"time"];
        if ([dataDict[@"status"] integerValue] == -1) {
            self.statusLabel.text = @"lost";
            self.statusLabel.textColor=[UIColor grayColor];
        } else if ([dataDict[@"storageStatus"] integerValue] == 0) {
            self.statusLabel.text = @"standby";
            self.statusLabel.textColor=[UIColor orangeColor];
        } else if ([dataDict[@"storageStatus"] integerValue] == 1) {
            self.statusLabel.text = @"charge";
            self.statusLabel.textColor=[UIColor redColor];
        } else if ([dataDict[@"storageStatus"] integerValue] == 2) {
            self.statusLabel.text = @"discharge";
            self.statusLabel.textColor=[UIColor yellowColor];
        } else if ([dataDict[@"storageStatus"] integerValue] == 3) {
            self.statusLabel.text = @"fault";
            self.statusLabel.textColor=[UIColor blueColor];
        } else {
            self.statusLabel.text = @"flash";
            self.statusLabel.textColor=[UIColor whiteColor];
        }

        self.cellectionLabel.text=dataDict[@"dataLogSn"];
    }
    
    if (_type == 3) {
        NSString *ammeter=[NSString stringWithFormat:@"%@",dataDict[@"ammeterData"]];
        NSString *box=[NSString stringWithFormat:@"%@",dataDict[@"boxData"]];
        NSString *env=[NSString stringWithFormat:@"%@",dataDict[@"envData"]];
        NSString *ammeterData=@"";
        NSString *boxData=@"";
        NSString *envData=@"";
        if (![ammeter isEqual:@"<null>"]) {
            ammeterData=[NSString stringWithFormat:@"%@",dataDict[@"ammeterData"][@"calendar"]];
        }
        if (![box isEqual:@"<null>"]) {
            boxData=[NSString stringWithFormat:@"%@",dataDict[@"boxData"][@"calendar"]];
        }
        if (![env isEqual:@"<null>"]) {
            envData=[NSString stringWithFormat:@"%@",dataDict[@"envData"][@"calendar"]];
        }
        if (![ammeterData isEqual:@"<null>"]) {
            self.funcationTitleLabel.text = root_Active_Power;
            self.coverImageView.image = IMAGE(@"智能电表.png");
            self.nicknameLable.text = dataDict[@"deviceName"];
            self.addressLable.text = [NSString stringWithFormat:@"%ld", (long)[dataDict[@"address"] integerValue]];
            NSString *string= [NSString stringWithFormat:@"%@", dataDict[@"ammeterData"][@"activePower"]];
            NSRange range=[string rangeOfString:@"."];
            if ((string.length-range.location)>3) {
                self.funcationLabel.text = [string substringToIndex:range.location+3];
            }else{
                self.funcationLabel.text=string;
            }
            self.updateTimeLabel.text = dataDict[@"lastUpdateTimeText"];
            if ([dataDict[@"lost"] boolValue] == true) {
                self.statusLabel.text = NSLocalizedString(@"Off-line", @"Off-line");
                self.statusLabel.textColor = [UIColor darkGrayColor];
            } else {
                self.statusLabel.text = NSLocalizedString(@"On-line", @"On-line");
                self.statusLabel.textColor = [UIColor greenColor];
            }
            self.cellectionLabel.text=dataDict[@"dataLogSn"];
        }else if(![box isEqual:@"<null>"]){
            self.funcationTitleLabel.text = @"母线电压";
            self.coverImageView.image = IMAGE(@"汇流箱.png");
            self.nicknameLable.text = dataDict[@"deviceName"];
            self.addressLable.text = [NSString stringWithFormat:@"%ld", (long)[dataDict[@"address"] integerValue]];
            NSString *string= [NSString stringWithFormat:@"%@", dataDict[@"boxData"][@"activePower"]];
            NSRange range=[string rangeOfString:@"."];
            self.funcationLabel.text = [string substringToIndex:range.location+3];
            self.updateTimeLabel.text = dataDict[@"lastUpdateTimeText"];
            if ([dataDict[@"lost"] boolValue] == true) {
                self.statusLabel.text = NSLocalizedString(@"Off-line", @"Off-line");
                self.statusLabel.textColor = [UIColor darkGrayColor];
            } else {
                self.statusLabel.text = NSLocalizedString(@"On-line", @"On-line");
                self.statusLabel.textColor = [UIColor greenColor];
            }
            self.cellectionLabel.text=dataDict[@"dataLogSn"];
        }else if(![envData isEqual:@"<null>"]){
            self.funcationTitleLabel.text = root_RADIANT;
            self.coverImageView.image = IMAGE(@"环境检测仪.png");
            self.nicknameLable.text = dataDict[@"deviceName"];
            self.addressLable.text = [NSString stringWithFormat:@"%ld", (long)[dataDict[@"address"] integerValue]];
            self.funcationLabel.text = [NSString stringWithFormat:@"%@", dataDict[@"envData"][@"radiant"]];
            self.updateTimeLabel.text = dataDict[@"envData"][@"timeText"];
            if ([dataDict[@"lost"] boolValue] == true) {
                self.statusLabel.text = NSLocalizedString(@"Off-line", @"Off-line");
                self.statusLabel.textColor = [UIColor darkGrayColor];
            } else {
                self.statusLabel.text = NSLocalizedString(@"On-line", @"On-line");
                self.statusLabel.textColor = [UIColor greenColor];
            }
            self.cellectionLabel.text=dataDict[@"dataLogSn"];
        }
        
    }
    
    if (_type == 4) {
        self.funcationTitleLabel.text = @"母线电压";
        self.coverImageView.image = IMAGE(@"汇流箱.png");
        self.nicknameLable.text = dataDict[@"deviceName"];
        self.addressLable.text = [NSString stringWithFormat:@"%ld", (long)[dataDict[@"address"] integerValue]];
        NSString *string= [NSString stringWithFormat:@"%@", dataDict[@"ammeterData"][@"activePower"]];
        NSRange range=[string rangeOfString:@"."];
        self.funcationLabel.text = [string substringToIndex:range.location+3];
        self.updateTimeLabel.text = dataDict[@"lastUpdateTimeText"];
        if ([dataDict[@"lost"] boolValue] == true) {
            self.statusLabel.text = NSLocalizedString(@"Off-line", @"Off-line");
            self.statusLabel.textColor = [UIColor darkGrayColor];
        } else {
            self.statusLabel.text = NSLocalizedString(@"On-line", @"On-line");
            self.statusLabel.textColor = [UIColor greenColor];
        }
        self.cellectionLabel.text=dataDict[@"dataLogSn"];
    }
    
    if (_type == 5) {
        self.funcationTitleLabel.text = root_RADIANT;
        self.coverImageView.image = IMAGE(@"环境检测仪.png");
        self.nicknameLable.text = dataDict[@"deviceName"];
        self.addressLable.text = [NSString stringWithFormat:@"%ld", (long)[dataDict[@"address"] integerValue]];
        self.funcationLabel.text = [NSString stringWithFormat:@"%@", dataDict[@"envData"][@"radiant"]];
        self.updateTimeLabel.text = dataDict[@"envData"][@"timeText"];
        if ([dataDict[@"lost"] boolValue] == true) {
            self.statusLabel.text = NSLocalizedString(@"Off-line", @"Off-line");
            self.statusLabel.textColor = [UIColor darkGrayColor];
        } else {
            self.statusLabel.text = NSLocalizedString(@"On-line", @"On-line");
            self.statusLabel.textColor = [UIColor greenColor];
        }
        self.cellectionLabel.text=dataDict[@"dataLogSn"];
    }
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
}

@end
