//
//  UDPViewController.h
//  udp
//
//  Created by Jakey on 15/1/12.
//  Copyright (c) 2015年 jakey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCDAsyncUdpSocket.h"
#import "AsyncUdpSocket.h"
#import "ConnetService.h"
#import "Reachability.h"

@interface MainViewController : UIViewController<GCDAsyncUdpSocketDelegate,UITextFieldDelegate,ConnetServiceDelegate>
{
    GCDAsyncUdpSocket *_udpSocket;
}
@property (weak, nonatomic) IBOutlet UILabel *connectWifiLabel;
@property (weak, nonatomic) IBOutlet UILabel *connectModemLabel;
@property (weak, nonatomic) IBOutlet UILabel *ssidLabel;
@property (weak, nonatomic) IBOutlet UILabel *wskeyLabel;
@property (weak, nonatomic) IBOutlet UITextField *ssidTextField;
@property (weak, nonatomic) IBOutlet UITextField *wskeyTextField;
@property (weak, nonatomic) IBOutlet UITextField *wakeyTextField;
@property (weak, nonatomic) IBOutlet UIImageView *wskeyShowImageView;
@property (weak, nonatomic) IBOutlet UIImageView *wakeyShowImageView;
@property (weak, nonatomic) IBOutlet UILabel *moduleNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *checkCodeLabel;







//@property ( nonatomic) int*cellCount;



- (IBAction)clickSetButton:(id)sender;
//- (IBAction)SetAction:(id)sender;

@end
