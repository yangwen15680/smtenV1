//
//  LineView.m
//  ShinePhone
//
//  Created by LinKai on 15/5/26.
//  Copyright (c) 2015年 binghe168. All rights reserved.
//

#import "LineView.h"
#import "SHLineGraphView/SHLineGraphView.h"
#import "SHLineGraphView/SHPlot.h"
#import <PNChart.h>

@interface LineView () <PNChartDelegate>

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSMutableDictionary *dataDict;

@property (nonatomic, strong) UILabel *unitLabel;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UILabel *moneyTitleLabel;
@property (nonatomic, strong) UILabel *energyLabel;
@property (nonatomic, strong) UILabel *energyTitleLabel;
@property (nonatomic, strong) NSArray *xArray;
@property (nonatomic, strong) NSMutableArray *valuesArray;

@property (nonatomic, assign) NSInteger lineType;

@property (nonatomic, strong) SHLineGraphView *lineChartView;
@property (nonatomic, strong) SHPlot *lineChartPlot;
@property (nonatomic, strong) PNBarChart *barChartView;

@property (nonatomic, strong) UILabel *noDataLabel;

@end

@implementation LineView

- (void)setDataDict:(NSMutableDictionary *)dataDict {
    self.moneyLabel.text = dataDict[@"plantData"][@"plantMoneyText"];
    self.energyLabel.text = dataDict[@"plantData"][@"currentEnergy"];
    
    NSMutableDictionary *dict = dataDict[@"data"];
    if (dict.count == 0 || !dict.count) {
        self.unitLabel.hidden = NO;
        //[self addSubview:self.noDataLabel];
        dict=[NSMutableDictionary new];
        [dict setObject:@"0.0" forKey:@"01:30"];
        [dict setObject:@"0.0" forKey:@"02:30"];
        [dict setObject:@"0.0" forKey:@"03:30"];
        [dict setObject:@"0.0" forKey:@"04:30"];
        [dict setObject:@"0.0" forKey:@"05:30"];
        [dict setObject:@"0.0" forKey:@"06:30"];
        [dict setObject:@"0.0" forKey:@"07:30"];
        [dict setObject:@"0.0" forKey:@"08:30"];
        [dict setObject:@"0.0" forKey:@"09:30"];
        [dict setObject:@"0.0" forKey:@"10:30"];
        [dict setObject:@"0.0" forKey:@"11:30"];
        [dict setObject:@"0.0" forKey:@"12:30"];
        [dict setObject:@"0.0" forKey:@"13:30"];
        [dict setObject:@"0.0" forKey:@"14:30"];
        [dict setObject:@"0.0" forKey:@"15:30"];
        [dict setObject:@"0.0" forKey:@"16:30"];
        [dict setObject:@"0.0" forKey:@"17:30"];
        [dict setObject:@"0.0" forKey:@"18:30"];
        [dict setObject:@"0.0" forKey:@"19:30"];
        [dict setObject:@"0.0" forKey:@"20:30"];
        [dict setObject:@"0.0" forKey:@"21:30"];
        [dict setObject:@"0.0" forKey:@"22:30"];
        [dict setObject:@"0.0" forKey:@"23:30"];
        [dict setObject:@"0.0" forKey:@"24:30"];
        [dict setObject:@"0.0" forKey:@"01:00"];
        [dict setObject:@"0.0" forKey:@"02:00"];
        [dict setObject:@"0.0" forKey:@"03:00"];
        [dict setObject:@"0.0" forKey:@"04:00"];
        [dict setObject:@"0.0" forKey:@"05:00"];
        [dict setObject:@"0.0" forKey:@"06:00"];
        [dict setObject:@"0.0" forKey:@"07:00"];
        [dict setObject:@"0.0" forKey:@"08:00"];
        [dict setObject:@"0.0" forKey:@"09:00"];
        [dict setObject:@"0.0" forKey:@"10:00"];
        [dict setObject:@"0.0" forKey:@"11:00"];
        [dict setObject:@"0.0" forKey:@"12:00"];
        [dict setObject:@"0.0" forKey:@"13:00"];
        [dict setObject:@"0.0" forKey:@"14:00"];
        [dict setObject:@"0.0" forKey:@"15:00"];
        [dict setObject:@"0.0" forKey:@"16:00"];
        [dict setObject:@"0.0" forKey:@"17:00"];
        [dict setObject:@"0.0" forKey:@"18:00"];
        [dict setObject:@"0.0" forKey:@"19:00"];
        [dict setObject:@"0.0" forKey:@"20:00"];
        [dict setObject:@"0.0" forKey:@"21:00"];
        [dict setObject:@"0.0" forKey:@"22:00"];
        [dict setObject:@"0.0" forKey:@"23:00"];
//        [dict setObject:@"0.0" forKey:@"24:00"];
    } else {
        if (_noDataLabel) {
            [_noDataLabel removeFromSuperview];
        }
        self.unitLabel.hidden = NO;
    }
    self.xArray = dict.allKeys;
    NSStringCompareOptions comparisonOptions = NSCaseInsensitiveSearch|NSNumericSearch|NSWidthInsensitiveSearch|NSForcedOrderingSearch;
    NSComparator sort = ^(NSString *obj1, NSString *obj2){
        NSRange range = NSMakeRange(0, obj1.length);
        return [obj1 compare:obj2 options:comparisonOptions range:range];
    };
    self.xArray = [dict.allKeys sortedArrayUsingComparator:sort];
    
    self.valuesArray = [NSMutableArray array];
    for (NSString *key in self.xArray) {
        [self.valuesArray addObject:dict[key]];
    }
    
//    if (dict.count == 0) {
//        self.unitLabel.hidden = YES;
//        [self addSubview:self.noDataLabel];
//    } else {
//        if (_noDataLabel) {
//            [_noDataLabel removeFromSuperview];
//        }
//        self.unitLabel.hidden = NO;
//    }
}

- (UILabel *)noDataLabel {
    if (!_noDataLabel) {
        self.noDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100*NOW_SIZE, 30*NOW_SIZE)];
        self.noDataLabel.center = self.center;
        self.noDataLabel.textAlignment = NSTextAlignmentCenter;
        self.noDataLabel.textColor = [UIColor whiteColor];
        self.noDataLabel.font = [UIFont boldSystemFontOfSize:17*NOW_SIZE];
        self.noDataLabel.text = NSLocalizedString(@"No data", @"No data");
    }
    return _noDataLabel;
}

- (void)setType:(NSInteger)type {
    self.lineType = type;
    if (type == 1) {
        self.moneyTitleLabel.text = root_Daily_Returns;
        self.energyTitleLabel.text = root_Daily_Electricity;
        self.unitLabel.text = root_Powre;
    } else if (type == 2) {
        self.moneyTitleLabel.text = root_Earnings;
        self.energyTitleLabel.text = root_Month_energy;
        self.unitLabel.text = root_Energy;
    } else if (type == 3) {
        self.moneyTitleLabel.text = root_Earnings;
        self.energyTitleLabel.text = root_Year_energy;
        self.unitLabel.text = root_Energy;
    } else {
        self.moneyTitleLabel.text = root_Earnings;
        self.energyTitleLabel.text = root_Total_energy;
        self.unitLabel.text = root_Energy;
    }
}

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        for (int i=0; i<2; i++) {
            UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width - 150*NOW_SIZE, (i+1)*15*NOW_SIZE + i * 35*NOW_SIZE, 145*NOW_SIZE, 35*NOW_SIZE)];
            bgView.backgroundColor = COLOR(39, 183, 99, 1);
            [self addSubview:bgView];
            
            UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(7*NOW_SIZE, 7*NOW_SIZE, 21*NOW_SIZE, 21*NOW_SIZE)];
            [bgView addSubview:iconImageView];
            
            if (i == 0) {
                iconImageView.image = IMAGE(@"shouyi.png");
                self.moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(22*NOW_SIZE, 0, CGRectGetWidth(bgView.frame), CGRectGetHeight(bgView.frame)/2)];
                self.moneyLabel.adjustsFontSizeToFitWidth = YES;
                self.moneyLabel.textAlignment = NSTextAlignmentCenter;
                self.moneyLabel.textColor = [UIColor whiteColor];
                [bgView addSubview:self.moneyLabel];
                
                self.moneyTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15*NOW_SIZE, CGRectGetHeight(bgView.frame)/2, CGRectGetWidth(bgView.frame), CGRectGetHeight(bgView.frame)/2)];
                self.moneyTitleLabel.font = [UIFont boldSystemFontOfSize:8*NOW_SIZE];
                self.moneyTitleLabel.textAlignment = NSTextAlignmentCenter;
                self.moneyTitleLabel.textColor = [UIColor whiteColor];
                [bgView addSubview:self.moneyTitleLabel];
                
            } else if (i == 1) {
                iconImageView.image = IMAGE(@"fadian.png");
                
                self.energyLabel = [[UILabel alloc] initWithFrame:CGRectMake(22*NOW_SIZE, 0, CGRectGetWidth(bgView.frame), CGRectGetHeight(bgView.frame)/2)];
                self.energyLabel.textAlignment = NSTextAlignmentCenter;
                self.energyLabel.adjustsFontSizeToFitWidth = YES;
                self.energyLabel.textColor = [UIColor whiteColor];
                [bgView addSubview:self.energyLabel];
                
                
                self.energyTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15*NOW_SIZE, CGRectGetHeight(bgView.frame)/2, CGRectGetWidth(bgView.frame), CGRectGetHeight(bgView.frame)/2)];
                self.energyTitleLabel.font = [UIFont boldSystemFontOfSize:8*NOW_SIZE];
                self.energyTitleLabel.textAlignment = NSTextAlignmentCenter;
                self.energyTitleLabel.textColor = [UIColor whiteColor];
                [bgView addSubview:self.energyTitleLabel];
            }
            
        }
        
        self.unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(5*NOW_SIZE, 120*NOW_SIZE, 70*NOW_SIZE, 30*NOW_SIZE)];
        self.unitLabel.font = [UIFont boldSystemFontOfSize:10*NOW_SIZE];
        self.unitLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.unitLabel];
        
    }
    return self;
}


#pragma mark - line chart
- (SHLineGraphView *)lineChartView {
    if (!_lineChartView) {
        self.lineChartView = [[SHLineGraphView alloc] initWithFrame:CGRectMake(0, 135*NOW_SIZE, 315*NOW_SIZE, 250*NOW_SIZE)];
        NSDictionary *_themeAttributes = @{
                                           kXAxisLabelColorKey : [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0],
                                           kXAxisLabelFontKey : [UIFont fontWithName:@"TrebuchetMS" size:10],
                                           kYAxisLabelColorKey : [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0],
                                           kYAxisLabelFontKey : [UIFont fontWithName:@"TrebuchetMS" size:10],
                                           kYAxisLabelSideMarginsKey : @(5*NOW_SIZE),
                                           kPlotBackgroundLineColorKey : [UIColor colorWithRed:0.48 green:0.48 blue:0.49 alpha:0.4],
                                           kDotSizeKey : @0
                                           };
        self.lineChartView.themeAttributes = _themeAttributes;
        self.lineChartView.xAxisValues = @[
                                           @{ @1 : @""},
                                           @{ @2 : @""},
                                           @{ @3 : @""},
                                           @{ @4 : @"2"},
                                           @{ @5 : @""},
                                           @{ @6 : @""},
                                           @{ @7 : @""},
                                           @{ @8 : @"4"},
                                           @{ @9 : @""},
                                           @{ @10 : @""},
                                           @{ @11 : @""},
                                           @{ @12 : @"6"},
                                           @{ @13 : @""},
                                           @{ @14 : @""},
                                           @{ @15 : @""},
                                           @{ @16 : @"8"},
                                           @{ @17 : @"" },
                                           @{ @18 : @"" },
                                           @{ @19 : @"" },
                                           @{ @20 : @"10"},
                                           @{ @21 : @"" },
                                           @{ @22 : @"" },
                                           @{ @23 : @"" },
                                           @{ @24 : @"12"},
                                           @{ @25 : @"" },
                                           @{ @26 : @"" },
                                           @{ @27 : @"" },
                                           @{ @28 : @"14"},
                                           @{ @29 : @"" },
                                           @{ @30 : @"" },
                                           @{ @31 : @"" },
                                           @{ @32 : @"16"},
                                           @{ @33 : @"" },
                                           @{ @34 : @"" },
                                           @{ @35 : @"" },
                                           @{ @36 : @"18"},
                                           @{ @37 : @"" },
                                           @{ @38 : @"" },
                                           @{ @39 : @"" },
                                           @{ @40 : @"20"},
                                           @{ @41 : @"" },
                                           @{ @42 : @"" },
                                           @{ @43 : @"" },
                                           @{ @44 : @"22"},
                                           @{ @45 : @"" },
                                           @{ @46 : @"" },
                                           @{ @47 : @"" }
                                           ];
        
        
        self.lineChartPlot = [[SHPlot alloc] init];
        NSDictionary *_plotThemeAttributes = @{
                                               kPlotFillColorKey : [UIColor colorWithRed:0.47 green:0.75 blue:0.78 alpha:0.5],
                                               kPlotStrokeWidthKey : @2,
                                               kPlotStrokeColorKey : [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1],
                                               kPlotPointFillColorKey : [UIColor colorWithRed:0.18 green:0.36 blue:0.41 alpha:1],
                                               kPlotPointValueFontKey : [UIFont fontWithName:@"TrebuchetMS" size:10]
                                               };
        self.lineChartPlot.plotThemeAttributes = _plotThemeAttributes;
    }
    return _lineChartView;
}

- (void)refreshLineChartViewWithDataDict:(NSMutableDictionary *)dataDict {
    //
    [self setDataDict:dataDict];
    
    //
    [self setType:1];
    
    if (_barChartView) {
        [_barChartView removeFromSuperview];
    }
    
    if (_xArray.count == 0) {
        [_lineChartView removeFromSuperview];
        _lineChartView = nil;
        return;
    }
    
    if (_lineChartView) {
        [_lineChartView removeFromSuperview];
        _lineChartView = nil;
        
        [self addSubview:self.lineChartView];
    } else {
        [self addSubview:self.lineChartView];
    }
    
    if (_valuesArray.count > 0) {
        //
        NSNumber *avg = [_valuesArray valueForKeyPath:@"@avg.floatValue"];
        if ([avg floatValue] != 0) {
            NSNumber *maxyAxisValue = [_valuesArray valueForKeyPath:@"@max.floatValue"];
            self.lineChartView.yAxisRange = maxyAxisValue;
            self.lineChartView.yAxisSuffix = @"";
            
            NSMutableArray *tempValuesArray = [NSMutableArray array];
            for (int i = 0; i < _valuesArray.count; i++) {
                NSDictionary *tempDict = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:[_valuesArray[i] floatValue]]forKey:[NSNumber numberWithInt:(i+1)]];
                [tempValuesArray addObject:tempDict];
            }
            
            self.lineChartPlot.plottingValues = tempValuesArray;
            self.lineChartPlot.plottingPointsLabels = _valuesArray;
            
            [self.lineChartView addPlot:self.lineChartPlot];
            [self.lineChartView setupTheView];
        } else {
            self.lineChartView.yAxisRange = @9000;
            self.lineChartView.yAxisSuffix = @"";
            
            NSMutableArray *tempValuesArray = [NSMutableArray array];
            for (int i = 0; i < _valuesArray.count; i++) {
                if (i == 0) {
                    NSDictionary *tempDict = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:1]forKey:[NSNumber numberWithInt:(i+1)]];
                    [tempValuesArray addObject:tempDict];
                } else {
                    NSDictionary *tempDict = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:[_valuesArray[i] floatValue]]forKey:[NSNumber numberWithInt:(i+1)]];
                    [tempValuesArray addObject:tempDict];
                }
            }
            
            self.lineChartPlot.plottingValues = tempValuesArray;
            self.lineChartPlot.plottingPointsLabels = _valuesArray;
            
            [self.lineChartView addPlot:self.lineChartPlot];
            [self.lineChartView setupTheView];
        }
    }
}


#pragma mark - bar chart
- (PNBarChart *)barChartView {
    if (!_barChartView) {
        self.barChartView = [[PNBarChart alloc] initWithFrame:CGRectMake(5*NOW_SIZE, 135*NOW_SIZE, 315*NOW_SIZE, 250*NOW_SIZE)];
        self.barChartView.backgroundColor = [UIColor clearColor];
        self.barChartView.barBackgroundColor = [UIColor clearColor];
        [self.barChartView setStrokeColor:[UIColor whiteColor]];
        [self.barChartView setLabelTextColor:[UIColor whiteColor]];
        self.barChartView.yChartLabelWidth = 20*NOW_SIZE;
        self.barChartView.chartMargin = 30*NOW_SIZE;
        self.barChartView.yLabelFormatter = ^(CGFloat yValue){
            CGFloat yValueParsed = yValue;
            NSString *labelText = [NSString stringWithFormat:@"%0.f",yValueParsed];
            return labelText;
        };
        self.barChartView.labelMarginTop = 5.0;
        self.barChartView.showChartBorder = YES;
        
    }
    return _barChartView;
}

- (void)refreshBarChartViewWithDataDict:(NSMutableDictionary *)dataDict chartType:(NSInteger)type {
    [self setDataDict:dataDict];
    [self setType:type];
    
    if (_lineChartView) {
        [_lineChartView removeFromSuperview];
    }
    
    if (_xArray.count == 0) {
        [_barChartView removeFromSuperview];
        _barChartView = nil;
        return;
    }
    
    if (_barChartView) {
        [_barChartView removeFromSuperview];
        _barChartView = nil;
        
        [self addSubview:self.barChartView];
    } else {
        [self addSubview:self.barChartView];
    }
    
    if (type == 2) {
        //当展示月时，x轴只显示偶数
        NSMutableArray *tempArr = [NSMutableArray array];
        for (NSString *str in _xArray) {
            if ([str integerValue] % 2 == 0) {
                [tempArr addObject:str];
            } else {
                [tempArr addObject:@""];
            }
        }
        [self.barChartView setXLabels:tempArr];
    } else {
        [self.barChartView setXLabels:_xArray];
    }
    
    [self.barChartView setYValues:_valuesArray];
    [self.barChartView strokeChart];
    
    self.barChartView.delegate = self;
    
    [self addSubview:self.barChartView];
}



@end
