//
//  AddCellectViewController.m
//  ShinePhone
//
//  Created by ZML on 15/5/26.
//  Copyright (c) 2015年 binghe168. All rights reserved.
//

#import "AddCellectViewController.h"
#import "TempViewController.h"
#import "SHBQRView.h"
#import "MainViewController.h"
#import "DeviceManageViewController.h"

@interface AddCellectViewController ()<SHBQRViewDelegate>
@property(nonatomic,strong)UITextField *cellectId;
@property(nonatomic,strong)UITextField *cellectNo;
@end

@implementation AddCellectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.title = root_Add;
}



-(void)initUI{
    //数据采集器序列号
    UIImageView *userBgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(40*NOW_SIZE, 90*NOW_SIZE, SCREEN_Width - 80*NOW_SIZE, 45*NOW_SIZE)];
    userBgImageView.userInteractionEnabled = YES;
    userBgImageView.image = IMAGE(@"圆角矩形空心.png");
    [self.view addSubview:userBgImageView];
    
    _cellectId = [[UITextField alloc] initWithFrame:CGRectMake(60*NOW_SIZE, 0, CGRectGetWidth(userBgImageView.frame) - 50*NOW_SIZE, 45*NOW_SIZE)];
    _cellectId.placeholder = root_Enter_DatalogSN;
    _cellectId.textColor = [UIColor grayColor];
    _cellectId.tintColor = [UIColor grayColor];
    [_cellectId setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_cellectId setValue:[UIFont systemFontOfSize:11*NOW_SIZE] forKeyPath:@"_placeholderLabel.font"];
    _cellectId.font = [UIFont systemFontOfSize:11*NOW_SIZE];
    [userBgImageView addSubview:_cellectId];
    
    //数据采集器效验码
    UIImageView *pwdBgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(40*NOW_SIZE, 150*NOW_SIZE, SCREEN_Width - 80*NOW_SIZE, 45*NOW_SIZE)];
    pwdBgImageView.image = IMAGE(@"圆角矩形空心.png");
    pwdBgImageView.userInteractionEnabled = YES;
    [self.view addSubview:pwdBgImageView];
    
    _cellectNo = [[UITextField alloc] initWithFrame:CGRectMake(60*NOW_SIZE, 0, CGRectGetWidth(pwdBgImageView.frame) - 50*NOW_SIZE, 45*NOW_SIZE)];
    _cellectNo.placeholder = root_Datalog_Valicode;
    _cellectNo.textColor = [UIColor grayColor];
    _cellectNo.tintColor = [UIColor grayColor];
    [_cellectNo setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_cellectNo setValue:[UIFont systemFontOfSize:11*NOW_SIZE] forKeyPath:@"_placeholderLabel.font"];
    _cellectNo.font = [UIFont systemFontOfSize:11*NOW_SIZE];
    [pwdBgImageView addSubview:_cellectNo];
    
    UIButton *delButton=[[UIButton alloc]initWithFrame:CGRectMake(40*NOW_SIZE, 250*NOW_SIZE, 100*NOW_SIZE, 35*NOW_SIZE)];
    [delButton setBackgroundImage:IMAGE(@"圆角矩形.png") forState:0];
    [delButton setTitle:root_Cancel forState:UIControlStateNormal];
    [delButton setTitleColor:COLOR(73, 135, 43, 1) forState:UIControlStateNormal];
    [delButton addTarget:self action:@selector(delButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:delButton];
    
    UIButton *addButton=[[UIButton alloc]initWithFrame:CGRectMake(180*NOW_SIZE, 250*NOW_SIZE, 100*NOW_SIZE, 35*NOW_SIZE)];
    [addButton setBackgroundImage:IMAGE(@"圆角矩形.png") forState:0];
    [addButton setTitle:root_Yes forState:UIControlStateNormal];
    [addButton setTitleColor:COLOR(73, 135, 43, 1) forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addButton];
    
    UIButton *QR=[[UIButton alloc]initWithFrame:CGRectMake(40*NOW_SIZE,400*NOW_SIZE , 240*NOW_SIZE, 60*NOW_SIZE)];
    [QR setBackgroundImage:IMAGE(@"圆角矩形.png") forState:0];
    [QR setTitle:root_QR forState:UIControlStateNormal];
    [QR setTitleColor:COLOR(73, 135, 43, 1) forState:UIControlStateNormal];
    [QR addTarget:self action:@selector(ScanQR) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:QR];
}

-(void)ScanQR{
   // TempViewController *temp = [[TempViewController alloc] init];
   // [self.navigationController pushViewController:temp animated:true];
    
    SHBQRView *qrView = [[SHBQRView alloc] initWithFrame:self.view.bounds];
    qrView.delegate = self;
    [self.view addSubview:qrView];
}

- (void)qrView:(SHBQRView *)view ScanResult:(NSString *)result {
    [view stopScan];
  
    _cellectNo.text=[self getValidCode:result];
    NSLog(@"_cellectNo.text=%@",_cellectNo.text);
    _cellectId.text=result;
    NSLog(@"_cellectId.text=%@",_cellectId.text);
    
    [self showProgressView];
    [BaseRequest requestWithMethodResponseStringResult:HEAD_URL paramars:@{@"plantID":_stationId,@"datalogSN":_cellectId.text,@"validCode":_cellectNo.text} paramarsSite:@"/datalogA.do?op=add" sucessBlock:^(id content) {
        [self hideProgressView];
        id jsonObj = [NSJSONSerialization JSONObjectWithData:content options:NSJSONReadingAllowFragments error:nil];
        if ([[jsonObj objectForKey:@"success"] integerValue] ==0) {
            if ([[jsonObj objectForKey:@"msg"] isEqual:@"errDatalogSN"]) {
                [self showAlertViewWithTitle:nil message:root_Insert_true_datalog_sn cancelButtonTitle:root_Yes];
            }else if ([[jsonObj objectForKey:@"msg"] isEqual:@"errSystemDatalogLimit"]){
                [self showAlertViewWithTitle:nil message:root_Insert_true_datalog_sn cancelButtonTitle:root_Yes];
            }else if ([[jsonObj objectForKey:@"msg"] isEqual:@"errPlantDatalogNumLimit"]){
                [self showAlertViewWithTitle:nil message:root_Insert_true_datalog_sn cancelButtonTitle:root_Yes];
            }else if ([[jsonObj objectForKey:@"msg"] isEqual:@"errDatalogAndValidCode"]){
                [self showAlertViewWithTitle:nil message:root_Insert_datalog_code cancelButtonTitle:root_Yes];
            }else if ([[jsonObj objectForKey:@"msg"] isEqual:@"errDatalogExist"]){
                [self showAlertViewWithTitle:nil message:root_Insert_true_datalog_sn cancelButtonTitle:root_Yes];
            }
        }else{
            
               // [self showAlertViewWithTitle:nil message:root_Added_successfully cancelButtonTitle:root_Yes];
            
             NSString *IdString1= _cellectId.text;
            NSString *IdString=[IdString1 substringWithRange:NSMakeRange(0, 2)];
            
            NSString *demoId=[NSString stringWithFormat:@"4K"];
            if ([IdString isEqualToString:demoId]) {
                UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                DeviceManageViewController *rootView = [mainStoryBoard instantiateViewControllerWithIdentifier:@"DeviceManager"];
                [self.navigationController pushViewController:rootView animated:YES];
            }else
            {
              
                UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                MainViewController *rootView = [mainStoryBoard instantiateViewControllerWithIdentifier:@"MainViewController"];
                [self.navigationController pushViewController:rootView animated:YES];
                
            }
             //UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
             //MainViewController *rootView = [mainStoryBoard instantiateViewControllerWithIdentifier:@"MainViewController"];
             //AddCellectViewController *addCellect=[[AddCellectViewController alloc]init];
             //  addCellect.stationId=_stationId;
             //[self.navigationController pushViewController:rootView animated:YES];
           
     
        }
    } failure:^(NSError *error) {
        [self hideProgressView];
        [self showToastViewWithTitle:root_Networking];
    }];
  //  [self presentViewController:alert animated:true completion:nil];
}

-(void)delButtonPressed{
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSString*)getValidCode:(NSString*)serialNum{
    if (serialNum==NULL||serialNum==nil) {
        return @"";
    }
    NSData *testData = [serialNum dataUsingEncoding: NSUTF8StringEncoding];
      int sum=0;
    
    Byte *snBytes=(Byte*)[testData bytes];
  
    for(int i=0;i<[testData length];i++)
    {
        sum+=snBytes[i];
    }
    NSInteger B=sum%8;
    NSString *B1= [NSString stringWithFormat: @"%d", B];
    int C=sum*sum;
    
   NSString *text = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",C]];
    int length = [text length];
    NSString *resultTemp;
    NSString *resultTemp3;
    NSString *resultTemp1=[text substringWithRange:NSMakeRange(0, 2)];
     NSString *resultTemp2=[text substringWithRange:NSMakeRange(length - 2, 2)];
  
   resultTemp3= [resultTemp1 stringByAppendingString:resultTemp2];
    resultTemp=[resultTemp3 stringByAppendingString:B1];
    
    NSString *result = @"";

    char *charArray = [resultTemp cStringUsingEncoding:NSASCIIStringEncoding];
    for (int i=0; i<[resultTemp length]; i++) {
        if (charArray[i]==0x30||charArray[i]==0x4F||charArray[i]==0x4F) {
            charArray[i]++;
        }
        result=[result stringByAppendingFormat:@"%c",charArray[i]];
    }
   
   
    return [result uppercaseString];
    
}



-(void)addButtonPressed{
    if ([_cellectId.text isEqual:@""]) {
        [self showAlertViewWithTitle:nil message:root_Insert_true_datalog_sn cancelButtonTitle:root_Yes];
        return;
    }
    if ([_cellectNo.text isEqual:@""]) {
        [self showAlertViewWithTitle:nil message:root_Datalog_verification_code_is_incorrect cancelButtonTitle:root_Yes];
        return;
    }
    [self showProgressView];
    [BaseRequest requestWithMethodResponseStringResult:HEAD_URL paramars:@{@"plantID":_stationId,@"datalogSN":_cellectId.text,@"validCode":_cellectNo.text} paramarsSite:@"/datalogA.do?op=add" sucessBlock:^(id content) {
        [self hideProgressView];
        id jsonObj = [NSJSONSerialization JSONObjectWithData:content options:NSJSONReadingAllowFragments error:nil];
        if ([[jsonObj objectForKey:@"success"] integerValue] ==0) {
            if ([[jsonObj objectForKey:@"msg"] isEqual:@"errDatalogSN"]) {
                [self showAlertViewWithTitle:nil message:root_Insert_true_datalog_sn cancelButtonTitle:root_Yes];
            }else if ([[jsonObj objectForKey:@"msg"] isEqual:@"errSystemDatalogLimit"]){
                [self showAlertViewWithTitle:nil message:root_Insert_true_datalog_sn cancelButtonTitle:root_Yes];
            }else if ([[jsonObj objectForKey:@"msg"] isEqual:@"errPlantDatalogNumLimit"]){
                [self showAlertViewWithTitle:nil message:root_Insert_true_datalog_sn cancelButtonTitle:root_Yes];
            }else if ([[jsonObj objectForKey:@"msg"] isEqual:@"errDatalogAndValidCode"]){
                [self showAlertViewWithTitle:nil message:root_Insert_datalog_code cancelButtonTitle:root_Yes];
            }else if ([[jsonObj objectForKey:@"msg"] isEqual:@"errDatalogExist"]){
                [self showAlertViewWithTitle:nil message:root_Insert_true_datalog_sn cancelButtonTitle:root_Yes];
            }
        }else{
            
            NSString *IdString1= _cellectId.text;
            NSString *IdString=[IdString1 substringWithRange:NSMakeRange(0, 2)];
            
            NSString *demoId=[NSString stringWithFormat:@"4K"];
            if ([IdString isEqualToString:demoId]) {
                UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                DeviceManageViewController *rootView = [mainStoryBoard instantiateViewControllerWithIdentifier:@"DeviceManager"];
                [self.navigationController pushViewController:rootView animated:YES];
            }else
            {
                
                UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                MainViewController *rootView = [mainStoryBoard instantiateViewControllerWithIdentifier:@"MainViewController"];
                [self.navigationController pushViewController:rootView animated:YES];
                
            }

         
        }
    } failure:^(NSError *error) {
        [self hideProgressView];
        [self showToastViewWithTitle:root_Networking];
    }];
}

@end
