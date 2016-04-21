//
//  DayEquipGraphViewController.m
//  ShinePhone
//
//  Created by LinKai on 15/5/25.
//  Copyright (c) 2015年 binghe168. All rights reserved.
//

#import "DayEquipGraphViewController.h"
#import "Line2View.h"
#import "EditGraphView.h"

static const NSTimeInterval secondsPerDay = 24 * 60 * 60;

@interface DayEquipGraphViewController ()<EditGraphViewDelegate>

@property (nonatomic, strong) UIView *timeDisplayView;
@property (nonatomic, strong) UIButton *datePickerButton;
@property (nonatomic, strong) UIButton *lastButton;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) NSString *currentDay;
@property (nonatomic, strong) NSMutableDictionary *dayDict;
@property (nonatomic, strong) NSDateFormatter *dayFormatter;
@property (nonatomic, strong) UIDatePicker *dayPicker;
@property (nonatomic, strong) UIToolbar *toolBar;
@property (nonatomic, strong) Line2View *Line2View;
@property(nonatomic,strong)EditGraphView *editGraph;
@property(nonatomic,strong)NSString *type;
@property(nonatomic,strong)UIButton *selectButton;
@property(nonatomic,strong)UIScrollView *scrollView;

@end

@implementation DayEquipGraphViewController

- (instancetype)initWithName:(NSString *)name
{
    self = [super init];
    if (self) {
        self.navigationItem.title = name;

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _type=@"1";
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self initUI];
}

- (void)initUI {
    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_Width, SCREEN_Height)];
    [self.view addSubview:_scrollView];
    
    self.timeDisplayView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_Width, 30*NOW_SIZE)];
    self.timeDisplayView.backgroundColor = COLOR(140, 220, 220, 1);
    [_scrollView addSubview:self.timeDisplayView];
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_Width - 120*NOW_SIZE)/2, 4*NOW_SIZE, 120*NOW_SIZE, 30*NOW_SIZE - 8*NOW_SIZE)];
    bgImageView.image = IMAGE(@"rili.png");
    bgImageView.userInteractionEnabled = YES;
    [self.timeDisplayView addSubview:bgImageView];
    
    self.lastButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.lastButton.frame = CGRectMake(0, 0, 22*NOW_SIZE, 22*NOW_SIZE);
    [self.lastButton setImage:IMAGE(@"shang.png") forState:UIControlStateNormal];
    self.lastButton.imageEdgeInsets = UIEdgeInsetsMake(7*NOW_SIZE, 7*NOW_SIZE, 7*NOW_SIZE, 7*NOW_SIZE);
    self.lastButton.tag = 1004;
    [self.lastButton addTarget:self action:@selector(lastDate:) forControlEvents:UIControlEventTouchUpInside];
    [bgImageView addSubview:self.lastButton];
    
    self.nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nextButton.frame = CGRectMake(CGRectGetWidth(bgImageView.frame) - 22*NOW_SIZE, 0, 22*NOW_SIZE, 22*NOW_SIZE);
    [self.nextButton setImage:IMAGE(@"xia.png") forState:UIControlStateNormal];
    self.nextButton.imageEdgeInsets = UIEdgeInsetsMake(7*NOW_SIZE, 7*NOW_SIZE, 7*NOW_SIZE, 7*NOW_SIZE);
    self.nextButton.tag = 1005;
    [self.nextButton addTarget:self action:@selector(nextDate:) forControlEvents:UIControlEventTouchUpInside];
    [bgImageView addSubview:self.nextButton];
    
    self.dayFormatter = [[NSDateFormatter alloc] init];
    [self.dayFormatter setDateFormat:@"yyyy-MM-dd"];
    self.datePickerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.datePickerButton.frame = CGRectMake(22*NOW_SIZE, 0, CGRectGetWidth(bgImageView.frame) - 44*NOW_SIZE, 22*NOW_SIZE);
    self.currentDay = [_dayFormatter stringFromDate:[NSDate date]];
    [self.datePickerButton setTitle:self.currentDay forState:UIControlStateNormal];
    [self.datePickerButton setTitleColor:COLOR(7, 64, 52, 1) forState:UIControlStateNormal];
    self.datePickerButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.datePickerButton.titleLabel.font = [UIFont boldSystemFontOfSize:10*NOW_SIZE];
    [self.datePickerButton addTarget:self action:@selector(pickDate) forControlEvents:UIControlEventTouchUpInside];
    [bgImageView addSubview:self.datePickerButton];
    
    _type=_dict[@"1"][0];
    [self showProgressView];
    [BaseRequest requestWithMethodResponseJsonByGet:HEAD_URL paramars:@{@"id":_equipId,@"addr":_address, @"type":_dict[@"1"][0], @"date":self.currentDay} paramarsSite:_site sucessBlock:^(id content) {
        NSLog(@"testtest: %@", content);
        NSLog(@"paramars:%@",@{@"id":_equipId,@"addr":_address, @"type":_dict[@"1"][0], @"date":self.currentDay});
        [self hideProgressView];
        if (content) {
            self.dayDict=[NSMutableDictionary new];
            //[self.dayDict setObject:content forKey:@"data"];
            self.Line2View = [[Line2View alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.timeDisplayView.frame), SCREEN_Width, SCREEN_Height - self.tabBarController.tabBar.frame.size.height - CGRectGetMaxY(self.timeDisplayView.frame))];
            [_scrollView addSubview:self.Line2View];
            [self.Line2View refreshLineChartViewWithDataDict:content];
            _selectButton=[[UIButton alloc]initWithFrame:CGRectMake(110*NOW_SIZE, 50*NOW_SIZE, 210*NOW_SIZE, 30*NOW_SIZE)];
            [_selectButton setTitle:_dict[@"1"][1] forState:0];
            [_selectButton addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
            _selectButton.backgroundColor = COLOR(39, 183, 99, 1);
            _selectButton.layer.cornerRadius = 5*NOW_SIZE;
            _selectButton.clipsToBounds = YES;
            [_Line2View addSubview:_selectButton];
            _scrollView.contentSize=CGSizeMake(SCREEN_Width, CGRectGetMaxY(_Line2View.frame)+20*NOW_SIZE);
        }
        
    } failure:^(NSError *error) {
        [self hideProgressView];
    }];
}


#pragma mark - 获取、保存曲线图数据
- (void)requestDayDatasWithDayString:(NSString *)datString {
    [self showProgressView];
    [BaseRequest requestWithMethodResponseJsonByGet:HEAD_URL paramars:@{@"id":_equipId,@"addr":_address, @"type":_type, @"date":datString} paramarsSite:_site sucessBlock:^(id content) {
        NSLog(@"paramars:%@",@{@"id":_equipId,@"addr":_address, @"type":_type, @"date":datString});
        [self hideProgressView];
        if (content) {
            self.dayDict = [NSMutableDictionary dictionaryWithDictionary:content];
            [self.Line2View refreshLineChartViewWithDataDict:content];
        }
        
    } failure:^(NSError *error) {
        [self hideProgressView];
    }];
}

#pragma mark - 上一个时间  下一个时间  按钮事件
//上一个时间
- (void)lastDate:(UIButton *)sender {
    NSDate *currentDayDate = [self.dayFormatter dateFromString:self.currentDay];
    NSDate *yesterday = [currentDayDate dateByAddingTimeInterval: -secondsPerDay];
    self.currentDay = [self.dayFormatter stringFromDate:yesterday];
    [self.datePickerButton setTitle:self.currentDay forState:UIControlStateNormal];
    [self.dayDict removeAllObjects];
    [self requestDayDatasWithDayString:self.currentDay];
}

//下一个时间
- (void)nextDate:(UIButton *)sender {
    NSDate *currentDayDate = [self.dayFormatter dateFromString:self.currentDay];
    NSDate *tomorrow = [currentDayDate dateByAddingTimeInterval: secondsPerDay];
    self.currentDay = [self.dayFormatter stringFromDate:tomorrow];
    [self.datePickerButton setTitle:self.currentDay forState:UIControlStateNormal];
    [self.dayDict removeAllObjects];
    [self requestDayDatasWithDayString:self.currentDay];
}


#pragma mark - datePickerButton点击事件 选择时间
- (void)pickDate {
    self.lastButton.enabled = NO;
    self.nextButton.enabled = NO;
    NSDate *currentDayDate = [self.dayFormatter dateFromString:self.currentDay];
    
    if (!self.dayPicker) {
        self.dayPicker = [[UIDatePicker alloc] init];
        self.dayPicker.backgroundColor = [UIColor whiteColor];
        self.dayPicker.datePickerMode = UIDatePickerModeDate;
        self.dayPicker.date = currentDayDate;
        self.dayPicker.frame = CGRectMake(0, 70*NOW_SIZE + 64, SCREEN_Width, 216);
        [self.view addSubview:self.dayPicker];
    } else {
        [UIView animateWithDuration:0.3f animations:^{
            self.dayPicker.date = currentDayDate;
            self.dayPicker.alpha = 1;
            self.dayPicker.frame = CGRectMake(0, 70*NOW_SIZE + 64, SCREEN_Width, 216);
            [self.view addSubview:self.dayPicker];
        }];
    }
    if (self.toolBar) {
        [UIView animateWithDuration:0.3f animations:^{
            self.toolBar.alpha = 1;
            self.toolBar.frame = CGRectMake(0, 70*NOW_SIZE + 64 + 216, SCREEN_Width, 44);
            [self.view addSubview:_toolBar];
        }];
    } else {
        self.toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 70*NOW_SIZE + 64 + 216, SCREEN_Width, 44)];
        self.toolBar.barStyle = UIBarStyleDefault;
        self.toolBar.barTintColor = COLOR(101, 203, 197, 1);
        [self.view addSubview:self.toolBar];
        
        UIBarButtonItem *spaceButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:root_Finish style:UIBarButtonItemStyleDone target:self action:@selector(completeSelectDate:)];
        doneButton.tintColor = [UIColor whiteColor];
        self.toolBar.items = @[spaceButton, doneButton];
    }
}

#pragma mark 完成选择时间
- (void)completeSelectDate:(UIToolbar *)toolBar {
    self.lastButton.enabled = YES;
    self.nextButton.enabled = YES;
    if (self.dayPicker) {
        self.currentDay = [self.dayFormatter stringFromDate:self.dayPicker.date];
        [self.datePickerButton setTitle:self.currentDay forState:UIControlStateNormal];
        
        [self.dayDict removeAllObjects];
        [self requestDayDatasWithDayString:self.currentDay];
        
        [UIView animateWithDuration:0.3f animations:^{
            self.dayPicker.alpha = 0;
            self.toolBar.alpha = 0;
            self.dayPicker.frame = CGRectMake(0, -216 - 64 - 70*NOW_SIZE, SCREEN_Width, 216);
            self.toolBar.frame = CGRectMake(0, -216 - 64 - 70*NOW_SIZE - 44, SCREEN_Width, 44);
        } completion:^(BOOL finished) {
            [self.dayPicker removeFromSuperview];
            [self.toolBar removeFromSuperview];
        }];
        
    }
}

#pragma mark - 取消选择时间
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.dayPicker) {
        [UIView animateWithDuration:0.3f animations:^{
            self.dayPicker.alpha = 0;
            self.toolBar.alpha = 0;
            self.dayPicker.frame = CGRectMake(0, -216 - 64 - 70*NOW_SIZE, SCREEN_Width, 216);
            self.toolBar.frame = CGRectMake(0, -216 - 64 - 70*NOW_SIZE - 44, SCREEN_Width, 44);
        } completion:^(BOOL finished) {
            [self.dayPicker removeFromSuperview];
            [self.toolBar removeFromSuperview];
            self.lastButton.enabled = YES;
            self.nextButton.enabled = YES;
        }];
    }
}


-(void)buttonPressed{
    _editGraph = [[EditGraphView alloc] initWithFrame:self.view.bounds dictionary:_dict];
    _editGraph.delegate = self;
    _editGraph.tintColor = [UIColor blackColor];
    _editGraph.dynamic = NO;
    _editGraph.blurRadius = 10.0f;
    [[UIApplication sharedApplication].keyWindow addSubview:_editGraph];
}



#pragma mark - EditCellectViewDelegate
- (void)menuDidSelectAtRow:(NSInteger)row {
    if (row==0) {
        //取消菜单
        [_editGraph removeFromSuperview];
    }
    
    for (int i=0; i<_dict.count; i++) {
        if (row==i+1) {
            [_editGraph removeFromSuperview];
            NSString *string=[NSString stringWithFormat:@"%d",i+1];
            [_selectButton setTitle:_dict[string][1] forState:0];
            _type=_dict[string][0];
            [self requestDayDatasWithDayString:self.currentDay];
        }
    }
}

@end
