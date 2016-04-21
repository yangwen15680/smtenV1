//
//  UDPViewController.m
//  udp
//
//  Created by Jakey on 15/1/12.
//  Copyright (c) 2015年 jakey. All rights reserved.
//

#import "MainViewController.h"
#import "UINavigationController+CustomNavigation.h"
#import "AppMacro.h"
#import "InfoSend.h"
#include "JDStatusBarNotification.h"
#import "Reachability.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import <CommonCrypto/CommonDigest.h>
#import "StationCellectViewController.h"

@implementation MainViewController


- (void)viewDidLoad {
    [super viewDidLoad];
 
    //网络状态
    
    
    [self connectUDP];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]]];
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top"] forBarMetrics:UIBarMetricsDefault];
    _ssidTextField.delegate = self;
    _wskeyTextField.delegate = self;
    _wakeyTextField.delegate = self;
    
    UITapGestureRecognizer *wskeyImageViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(wskeyImageViewClick)];
    [_wskeyShowImageView addGestureRecognizer:wskeyImageViewTap];
    UITapGestureRecognizer *wakeyImageViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(wakeyImageViewClick)];
    [_wakeyShowImageView addGestureRecognizer:wakeyImageViewTap];
}






-(void)connectUDP{
    NSError *error = nil;
    if (!_udpSocket)
    {
        _udpSocket=nil;
    }
    _udpSocket = [[GCDAsyncUdpSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    [ConnetService shareConnetService].udpSocket = _udpSocket;
    [ConnetService shareConnetService].delegate = self;
    
    if (error!=nil) {
        NSLog(@"连接失败：%@",error);
    }else{
        NSLog(@"连接成功");
    }
    if (![_udpSocket bindToPort:PORT error:&error]) {
        NSLog(@"Error starting server (bind): %@", error);
        return;
    }
    if (![_udpSocket enableBroadcast:YES error:&error]) {
        NSLog(@"Error enableBroadcast (bind): %@", error);
        return;
    }
    if (![_udpSocket beginReceiving:&error]) {
        [_udpSocket close];
        NSLog(@"Error starting server (recv): %@", error);
        return;
    }
}

- (IBAction)clickSetButton:(id)sender {
    BOOL isEmptySSID = _ssidTextField.text.length==0;
    BOOL isEmptyWskey = _wskeyTextField.text.length==0;
    BOOL isEmptyWakey = _wakeyTextField.text.length==0;
    if (isEmptySSID && isEmptyWskey && isEmptyWakey) {
        [ConnetService shareConnetService].type = k_connect_module;
    }else if (isEmptyWakey && !isEmptySSID){
        if (!isEmptyWskey && _wskeyTextField.text.length > 7) {
            [ConnetService shareConnetService].type = k_connect_wsss;
        }else{
            [JDStatusBarNotification showWithStatus:NSLocalizedString(@"Prog_SetPwdFail",nil) dismissAfter:2.0 styleName:JDStatusBarStyleWarning];
            return;
        }
    }else if (!isEmptyWakey){
        if (!isEmptySSID && !isEmptyWskey && _wskeyTextField.text.length > 7 && _wakeyTextField.text.length > 7) {
            [ConnetService shareConnetService].type = k_reset_passwork;
        }else{
            [JDStatusBarNotification showWithStatus:NSLocalizedString(@"Prog_SetPwdFail",nil) dismissAfter:2.0 styleName:JDStatusBarStyleWarning];
            return;
        }
    }
    [[ConnetService shareConnetService] beginSetup];
}




-(void)wskeyImageViewClick{
    _wskeyShowImageView.highlighted = !_wskeyShowImageView.highlighted;
    _wskeyTextField.secureTextEntry = !_wskeyShowImageView.highlighted;
}

-(void)wakeyImageViewClick{
    _wakeyShowImageView.highlighted = !_wakeyShowImageView.highlighted;
    _wakeyTextField.secureTextEntry = !_wakeyShowImageView.highlighted;                                       
 
}


#pragma mark UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]){
        return YES;
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (_ssidTextField == textField){
        if ([toBeString length] > 25) {
            textField.text = [toBeString substringToIndex:25];
            return NO;
        }
    }
    if (_wskeyTextField == textField){
        if ([toBeString length] > 22){
            textField.text = [toBeString substringToIndex:22];
            return NO;
        }
    }
    if (_wakeyTextField == textField){
        if ([toBeString length] > 22){
            textField.text = [toBeString substringToIndex:22];
            return NO;
        }
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark GCDAsyncUdpSocketDelegate
-(void)udpSocket:(GCDAsyncUdpSocket *)sock didConnectToAddress:(NSData *)address
{
    NSError *error = nil;
    NSLog(@"Message didConnectToAddress: %@",[[NSString alloc]initWithData:address encoding:NSUTF8StringEncoding]);
    [_udpSocket beginReceiving:&error];
}

-(void)udpSocket:(GCDAsyncUdpSocket *)sock didNotConnect:(NSError *)error
{
    NSLog(@"Message didNotConnect: %@",error);
}

-(void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
    NSLog(@"Message didNotSendDataWithTag: %@",error);
}

-(void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext
{
    NSString *receiveString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"Message didReceiveData :%@", receiveString);
    
    InfoSend *infoSend = [[InfoSend alloc] init];
    infoSend.wsssid = _ssidTextField.text;
    infoSend.wskey = [NSString stringWithFormat:@"WPA2PSK,AES,%@",_wskeyTextField.text];
    infoSend.wakey = [NSString stringWithFormat:@"WPA2PSK,AES,%@",_wakeyTextField.text];
    [[ConnetService shareConnetService] reciveData:data infoSend:infoSend];
}

-(void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
    NSLog(@"Message didSendDataWithTag");
}

-(void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError *)error
{
    [JDStatusBarNotification showActivityIndicator:NO indicatorStyle:UIActivityIndicatorViewStyleGray];
    [JDStatusBarNotification showWithStatus:error.localizedDescription dismissAfter:2.0 styleName:JDStatusBarStyleWarning];
    NSLog(@"Message withError: %@",error);
}

#pragma mark ConnetServiceDelegate
-(void)updateModuleInfo:(ModuleInfo *)moduleInfo{
    NSLog(@"%@,%@",moduleInfo.name,moduleInfo.checkCode);
    if (moduleInfo.name.length > 0) {
        _moduleNameLabel.text = moduleInfo.name;
    }
    if (moduleInfo.checkCode.length > 0) {
        _checkCodeLabel.text = moduleInfo.checkCode;
    }
}



@end
