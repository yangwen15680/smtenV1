//
//  AddDeviceViewController.m
//  smartYogurtMaker
//
//  Created by mqw on 15/6/3.
//  Copyright (c) 2015年 mqw. All rights reserved.
//

#import "AddDeviceViewController.h"
#import "DeviceManageViewController.h"


#import "elian.h"
#import "EasyTimeline.h"
#import "UdpCheckUtl.h"
#import "Toast+UIView.h"
#import "StationCellectViewController.h"


@interface AddDeviceViewController ()

@end

@implementation AddDeviceViewController{
    EasyTimeline *_timelineConfig;
    
}

NSString* authMode = @"9";
static void *context = NULL;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillDisappear:(BOOL)animated{
    [self stopSearch];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _deviceArray = [[NSMutableArray alloc] initWithCapacity:1];
    
    
  //[self.addDeviceBtn setStyleType:ACPButtonMain];
  //[self.addDeviceBtn setLabelTextColor:[UIColor blueColor] highlightedColor:[UIColor grayColor] disableColor:nil];
  //[self.addDeviceBtn setLabelFont:[UIFont fontWithName:@"Trebuchet MS" size:20]];
    
    NSString *Setting = NSLocalizedString(@"Setting", nil);
    NSString *Back = NSLocalizedString(@"Back", nil);
            self.title = Setting;
  
    
    UIBarButtonItem *backItem =  [[UIBarButtonItem alloc] initWithTitle:Back
                                  
                                  
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(goBack)];
    backItem.tag = 1;
    backItem.tintColor=[UIColor whiteColor];
   // [backItem setImage:[UIImage imageNamed:@"navi_back_white_nor.png"]];
    self.navigationItem.leftBarButtonItem = backItem;
    // self.view.viewPrintFormatter
    //backgroundColor=[UIColor clearColor];
    
   
    //set NavigationBar 背景颜色&title 颜色
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]]];
 
    
    
   // self.view.backgroundColor = [UIColor whiteColor];
     self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSString *ssid = [delegate getWifiName];
    
    if(ssid!=nil&&ssid.length>0 )
    {
        self.ipName.text = ssid;
    }else{
         NSString *A7 = NSLocalizedString(@"A7", nil);
        self.ipName.text = A7;
    
    }
    self.pswd.secureTextEntry = true;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onGotDeviceByScan:) name:kOnGotDeviceByScan object:nil];
}




-(void)goBack{
  [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)onDeviceFindResultNotify:(NSNotification*)notify{
    [self performSelectorOnMainThread:@selector(doDeviceFindResult:) withObject:notify waitUntilDone:NO];
}





#pragma mark 扫描到设备
//用户登陆成功回调
-(void)onGotDeviceByScan:(NSNotification*)noti{
    NSString* deviceMac = [noti.object objectForKey:@"deviceMac"];
    
    if (![_deviceArray containsObject:deviceMac]) {
        [_deviceArray addObject:deviceMac];
        int count =(int)[_deviceArray count];
        NSLog(@"Countt=%d",count);
          NSLog(@"cellCount0=%ld",(long)self.cellCount0);
        
        //if (count<=_cellCount) {
            
        //    myAlertView.message = [NSString stringWithFormat:@"查找设备中. 发现设备：%d个",count ];
        //}
       
        
         NSString *A8= NSLocalizedString(@"A8", nil);
        myAlertView.title=A8;
            NSString *A4= NSLocalizedString(@"A4", nil);
        
       int count2=0;
        
        if (count<=self.cellCount0) {
            count2=0;
            NSLog(@"1");
        }
        if (count>self.cellCount0) {
             count2=count-(int)self.cellCount0;
             NSLog(@"2");
        }
      
        
         myAlertView.message = [NSString stringWithFormat:A4,count2 ];
        
        
    }
    
}


-(IBAction)pswdShowPressed{
    
    if (self.pswd.secureTextEntry == true) {
        [self.pswd setSecureTextEntry:false];
    }else
    {
        [self.pswd setSecureTextEntry:true];
     
    }
}


//点击屏幕空白处去掉键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.ipName resignFirstResponder];
    [self.pswd resignFirstResponder];
}

-(void)OnSend:(unsigned int)flag SSID:(NSString*)ssidName PSWD:(NSString*)pswd{
    const char *ssid = [ssidName cStringUsingEncoding:NSASCIIStringEncoding];
    const char *s_authmode = [authMode cStringUsingEncoding:NSASCIIStringEncoding];
    int authmode = atoi(s_authmode);
    const char *password = [pswd cStringUsingEncoding:NSASCIIStringEncoding];
    unsigned char target[] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
    
    NSLog(@"OnSend: ssid = %s, authmode = %d, password = %s", ssid, authmode, password);
    if (context)
    {
        elianStop(context);
        elianDestroy(context);
        context = NULL;
    }
    
    context = elianNew(NULL, 0, target, flag);
    if (context == NULL)
    {
        NSLog(@"OnSend elianNew fail");
        return;
    }
    
    elianPut(context, TYPE_ID_AM, (char *)&authmode, 1);
    elianPut(context, TYPE_ID_SSID, (char *)ssid, strlen(ssid));
    elianPut(context, TYPE_ID_PWD, (char *)password, strlen(password));
    elianStart(context);
   
}


//开始查找设备
-(IBAction) deviceSearchStart{
    _deviceArray = nil;
    _deviceArray = [[NSMutableArray alloc] initWithCapacity:1];
    
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSString *ssid = [delegate getWifiName];
    if(ssid == nil )
    {
        NSString *A6 = NSLocalizedString(@"A6", nil);
      
        [self.view makeToast:A6];
        return;
    }

   [[[UIApplication sharedApplication] keyWindow] endEditing:YES];

    
    
   int  currentCount =0;
    
    NSString *A1= NSLocalizedString(@"A1", nil);
    NSString *A2 = NSLocalizedString(@"A2", nil);
    NSString *A3= NSLocalizedString(@"A3", nil);
     myAlertView = [[SIAlertView alloc] initWithTitle:A1 andMessage:[NSString stringWithFormat:A2,currentCount]];
    [myAlertView addButtonWithTitle:A3
                               type:SIAlertViewButtonTypeDestructive
                            handler:^(SIAlertView *alertView) {
                                [alertView dismissAnimated:YES];
                            }];
    myAlertView.willShowHandler = ^(SIAlertView *alertView) {
        NSLog(@"%@, willShowHandler", alertView);
    };
    myAlertView.didShowHandler = ^(SIAlertView *alertView) {
        NSLog(@"%@, didShowHandler", alertView);
    };
    myAlertView.willDismissHandler = ^(SIAlertView *alertView) {
       
        //停止扫描
        [self  stopSearch];
        
        if ([_timelineConfig isRunning]) {
            [_timelineConfig stop];
        }
        
    };
    myAlertView.didDismissHandler = ^(SIAlertView *alertView) {
        NSLog(@"%@, didDismissHandler", alertView);
    };
    myAlertView.showIndicator = YES;
    [myAlertView show];
    isSearching= true;
    
 
    
    
    [self performSelectorInBackground:@selector(doneSearchDeviceAutoThread) withObject:nil];
}




-(void)doneSearchDeviceAutoThread{
    //进行一键配置
    NSLog(@"一键配置开始");
    [self OnSend:(ELIAN_SEND_V1 | ELIAN_SEND_V4) SSID:self.ipName.text PSWD:self.pswd.text];
    
    
    __weak AddDeviceViewController* selfView = self;
    if ( _timelineConfig == nil) {
        _timelineConfig = [[EasyTimeline alloc] init];
    }
    
    _timelineConfig.duration		= 60;
    _timelineConfig.tickPeriod	= 3;
    _timelineConfig.tickBlock		= ^void (NSTimeInterval time, EasyTimeline *timeline) {

        int timers = (int)(time/3.0 + 0.5);
        if ((timers%2 == 0)) {
             //进行一键配置
            NSLog(@"进行一键配置");
            [self OnSend:(ELIAN_SEND_V1 ) SSID:self.ipName.text PSWD:self.pswd.text];
        }else{
            [selfView stopSmartConfig];
             NSLog(@"停止配置，查找设备");
            UdpCheckUtl *udpCheck = [[UdpCheckUtl alloc]init];
            [udpCheck startUdpCheck];
        }

    };
    _timelineConfig.completionBlock = ^void (EasyTimeline *timeline) {
        //查找完成
         NSLog(@"停止配置");
        
        if (![myAlertView isHidden]) {
            [myAlertView dismissAnimated:YES];
        }
        
        [selfView  stopSearch];
    };

    
    [_timelineConfig start];
    [[NSRunLoop currentRunLoop] run];

}

-(void)stopSmartConfig{
    if (context!=nil) {
        elianStop(context);
        elianDestroy(context);
    }
   
    context = NULL;
}


-(void)stopSearch{
    
    if (_timelineConfig!=nil &&[_timelineConfig hasStarted]) {
        [_timelineConfig stop];
         _timelineConfig = nil;
    }
    if(isSearching){
        if (context)
        {
            NSLog(@"查找完成");
            
            elianStop(context);
            elianDestroy(context);
            context = NULL;
        }
        
        NSLog(@"OnStop");
    }
   

}


#pragma mark UDP检测


- (IBAction)pullBack:(id)sender {
    
     [self.navigationController popToRootViewControllerAnimated:YES];
    
  //  StationCellectViewController *backView=[[StationCellectViewController alloc]init];
  //  [self presentViewController:backView animated:YES completion:nil];
    
}
@end

