//
//  UdpCheckUtl.h
//  SuperSmart
//
//  Created by mqw on 15/10/22.
//  Copyright © 2015年 gicisky. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "AsyncUdpSocket.h"
@interface UdpCheckUtl : NSObject
{
    AsyncUdpSocket* udpSocket;
}
-(void)startUdpCheck;
@end
