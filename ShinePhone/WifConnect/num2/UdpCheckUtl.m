//
//  UdpCheckUtl.m
//  SuperSmart
//
//  Created by mqw on 15/10/22.
//  Copyright © 2015年 gicisky. All rights reserved.
//

#import "UdpCheckUtl.h"
#import "AppDelegate.h"
#include <ifaddrs.h>
#include <arpa/inet.h>
#import "MainViewController.h"

__strong static UdpCheckUtl *udpCheckUtl = nil;
@implementation UdpCheckUtl


NSMutableDictionary * scanDeviceDic;

+(UdpCheckUtl *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        udpCheckUtl = [[super allocWithZone:NULL]init];
        [udpCheckUtl openUDPServer];
    });
    return udpCheckUtl;
}

+(id)allocWithZone:(struct _NSZone *)zone
{
    return [self shareInstance];
}



-(void) startUdpCheck
{
    scanDeviceDic =[NSMutableDictionary dictionaryWithCapacity:0];
    //   NSLog(@"获取IP");
    NSString *localIP =  [self getIPAddress];
    if(localIP != nil &&![localIP isEqualToString:@"error"]){
        NSMutableArray *components = [localIP componentsSeparatedByString:@"."];
        if (components.count>0) {
            [components removeLastObject];
            NSString *str = [components componentsJoinedByString:@"."];
           NSString  *UdpIp = [NSString stringWithFormat:@"%@.%@",str,@"255"];
            [self sendMassage:@"HLK" withIP:UdpIp];
        }
    }else{
        //NSLog(@"本机IP失败：%@",localIP);
    }
}
//建立基于UDP的Socket连接
-(void)openUDPServer{
    //初始化udp
    if (udpSocket == nil) {
        
        udpSocket=[[AsyncUdpSocket alloc] initIPv4];
        [udpSocket setDelegate:self];
    }
    //绑定端口
    NSError *error = nil;
    [udpSocket bindToPort:988 error:&error];
    
    //发送广播设置
    [udpSocket enableBroadcast:YES error:&error];
   	//启动接收线程
    [udpSocket receiveWithTimeout:-1 tag:0];
}

//通过UDP,发送消息
-(void)sendMassage:(NSString *)message withIP:(NSString*)UdpIp
{
    NSMutableString *sendString=[NSMutableString stringWithCapacity:100];
    [sendString appendString:message];
    //开始发送
    BOOL res = [udpSocket sendData:[sendString dataUsingEncoding:NSUTF8StringEncoding]
                            toHost:UdpIp port:988 withTimeout:-1 tag:0];
    NSLog(@"发送：%d",res);
}

#pragma mark -
// http://zachwaugh.me/posts/programmatically-retrieving-ip-address-of-iphone/
- (NSString *)getIPAddress
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    
    return address;
}


- (BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port
{
    [udpSocket receiveWithTimeout:-1 tag:0];
    NSString *info=[[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding];
    NSLog(@"udpj接收 ：@%@",info);
    if ([info hasPrefix:@"HLK-M30"]) {
        //       NSLog(@"获取IP:%@",host);
        [[NSNotificationCenter defaultCenter] postNotificationName:kOnGotDeviceByScan object:@{@"deviceMac" : host}];
    }
    return true;
}
@end
