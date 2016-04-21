//
//  GoogleMapViewController.m
//  ShinePhone
//
//  Created by ZML on 15/6/2.
//  Copyright (c) 2015年 binghe168. All rights reserved.
//

#import "GoogleMapViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface GoogleMapViewController ()<GMSMapViewDelegate,UITextFieldDelegate>
@property(nonatomic,strong)GMSMapView *mapView;
@property(nonatomic,strong)UIView *allButtonView;
@property(nonatomic,strong)UIView *changeUIView;
@property(nonatomic,strong)CLLocation *longClickLocation;
@property(nonatomic,strong)UIImageView *imgView;
@property(nonatomic,strong)UIView *searchView;
@property(nonatomic,strong)UITextField *textField;
@end

@implementation GoogleMapViewController

-(instancetype)initWithLocation:(CLLocation *)location name:(NSString *)name{
    self=[super init];
    _plantLocation=location;
    _stationName=name;
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:_plantLocation.coordinate.latitude
                                                            longitude:_plantLocation.coordinate.longitude
                                                                 zoom:12];
    if ([UIScreen mainScreen].bounds.size.height==480) {
        _mapView = [GMSMapView mapWithFrame:CGRectMake(0, 64, 320*NOW_SIZE, 260*NOW_SIZE) camera:camera];
    }else{
        _mapView = [GMSMapView mapWithFrame:CGRectMake(0, 64, 320*NOW_SIZE, 340*NOW_SIZE) camera:camera];
    }

    _mapView.delegate=self;
    _mapView.myLocationEnabled = YES;
    [self.view addSubview:_mapView];
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(_plantLocation.coordinate.latitude, _plantLocation.coordinate.longitude);
    marker.title = _stationName;
    marker.map = _mapView;
    
    [self initUI];
    return self;
}


- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.navigationController.navigationBarHidden = YES;
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:IMAGE(@"fanhui_03.png") style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem.imageInsets = UIEdgeInsetsMake(10, 5, 10, 5);
    self.navigationItem.leftBarButtonItem = backButton;
    self.navigationItem.title = self.navigationItem.title = root_Map;
}
- (void)back {
    [self.tabBarController.navigationController popViewControllerAnimated:YES];
    self.tabBarController.navigationController.navigationBarHidden = NO;
}


-(void)initUI{
    //底部按钮背景
    _allButtonView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_mapView.frame), 320*NOW_SIZE, SCREEN_Height-114-CGRectGetMaxY(_mapView.bounds))];
    _allButtonView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_allButtonView];
    
    //底部6个按钮
    NSArray *titleArray=[NSArray arrayWithObjects:root_Station_Location, root_Growatt_Location, root_My_Location, root_Satellite_Images, root_Search, root_Baidu_Map, nil];
    UIColor *color1=COLOR(152, 251, 152, 1);
    UIColor *color2=COLOR(255, 215, 0,   1);
    UIColor *color3=COLOR(147, 112, 219, 1);
    UIColor *color4=COLOR(238, 130, 130, 1);
    UIColor *color5=COLOR(127, 251, 212, 1);
    UIColor *color6=COLOR(238, 130, 238, 1);
    NSArray *colorArray=[NSArray arrayWithObjects:color1,color2,color3,color4,color5,color6,nil];
    for (int i=0; i<6; i++) {
        UIView *buttonView=[[UIView alloc]initWithFrame:CGRectMake((320/3*(i%3))*NOW_SIZE, i/3*_allButtonView.bounds.size.height/2, 320/3*NOW_SIZE, _allButtonView.bounds.size.height/2)];
        [_allButtonView addSubview:buttonView];
        
        UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake((320/3-50)/2*NOW_SIZE, 4*NOW_SIZE, 50*NOW_SIZE, 50*NOW_SIZE)];
        button.backgroundColor=colorArray[i];
        button.titleLabel.font=[UIFont fontWithName:nil size:12*NOW_SIZE];
        button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        button.tag=i;
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.cornerRadius=25*NOW_SIZE;
        [buttonView addSubview:button];
    }
}



-(void)buttonPressed:(UIButton *)sender{
    [_mapView clear];
    if (sender.tag==0) {
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:_plantLocation.coordinate.latitude longitude:_plantLocation.coordinate.longitude zoom:12];
        _mapView.camera=camera;
        
        // Creates a marker in the center of the map.
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(_plantLocation.coordinate.latitude, _plantLocation.coordinate.longitude);
        marker.title = _stationName;
        marker.map = _mapView;
    }
    
    if (sender.tag==1) {
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:22.694859 longitude:113.933232 zoom:12];
        _mapView.camera=camera;
        
        // Creates a marker in the center of the map.
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(22.694859, 113.933232);
        marker.title = @"growatt";
        marker.map = _mapView;
    }
    
    if (sender.tag==2) {
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:_mapView.myLocation.coordinate.latitude longitude:_mapView.myLocation.coordinate.longitude zoom:12];
        _mapView.camera=camera;
    }
    
    if (sender.tag==3) {
        if (!sender.selected) {
            _mapView.mapType = kGMSTypeSatellite;
        }else{
            _mapView.mapType = kGMSTypeNormal;
        }
        sender.selected=!sender.selected;
    }
    
    if (sender.tag==4) {
        if (!sender.selected) {
            [self search];
        }else{
            [_searchView removeFromSuperview];
            _searchView=nil;
        }
        sender.selected=!sender.selected;
    }
    
    if (sender.tag==5) {
        [self.navigationController popViewControllerAnimated:NO];
    }
}



//搜索的UI
-(void)search{
    _searchView=[[UIView alloc]initWithFrame:CGRectMake(20*NOW_SIZE, 0*NOW_SIZE, 280*NOW_SIZE, 30*NOW_SIZE)];
    [self.view addSubview:_searchView];
    [UIView animateWithDuration:0.4 animations:^{
        _searchView.frame=CGRectMake(20*NOW_SIZE, 64, 280*NOW_SIZE, 30*NOW_SIZE);
        _searchView.backgroundColor=[UIColor clearColor];
        [self.view addSubview:_searchView];
        
        _textField = [[UITextField alloc]initWithFrame:CGRectMake(5*NOW_SIZE, 1*NOW_SIZE, 270*NOW_SIZE, 28*NOW_SIZE)];
        _textField.backgroundColor = COLOR(82, 201, 194, 0.5);
        _textField.layer.cornerRadius = 5;
        _textField.layer.borderColor = COLOR(100, 100, 100, 1).CGColor;
        _textField.layer.borderWidth = 0.5;
        _textField.delegate = self;
        _textField.keyboardType=UIKeyboardTypeWebSearch;
        [_textField addTarget:self action:@selector(backgroundTap:) forControlEvents:UIControlEventEditingDidEndOnExit];
        [_searchView addSubview:_textField];
    }];
}


//执行搜索功能,收起键盘
-(void)backgroundTap:(id)sender{
    NSString *search=_textField.text;
    NSString *lat=[NSString stringWithFormat:@"%f",_mapView.myLocation.coordinate.latitude];
    NSString *lng=[NSString stringWithFormat:@"%f",_mapView.myLocation.coordinate.longitude];
    NSString *url=[NSString stringWithFormat:@"comgooglemaps://?q=%@&center=%@,%@&zoom=13&views=transit",search,lat,lng];
    if ([[UIApplication sharedApplication] canOpenURL:
         [NSURL URLWithString:@"comgooglemaps://"]]) {
        [[UIApplication sharedApplication] openURL:
         [NSURL URLWithString:url]];
    } else {
        NSLog(@"Can't use comgooglemaps://");
    }
    [_textField resignFirstResponder];
}



//长按地图之后调用这个接口
- (void)mapView:(GMSMapView *)mapView didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate {
    [self changeUI];
    NSLog(@"You tapped at %f,%f", coordinate.latitude, coordinate.longitude);
    _longClickLocation =[[CLLocation alloc]initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
}


//长按地图后改变UI
-(void)changeUI{
    [UIView animateWithDuration:0.2 animations:^{
        _allButtonView.frame = CGRectMake(0, 550*NOW_SIZE+64, 320*NOW_SIZE, SCREEN_Height-114-CGRectGetMaxY(_mapView.bounds));
        _mapView.frame=CGRectMake(0, 64, 320*NOW_SIZE, 475*NOW_SIZE);
        _changeUIView=[[UIView alloc]initWithFrame:CGRectMake(0, 64,320*NOW_SIZE, 475*NOW_SIZE)];
        _changeUIView.backgroundColor=COLOR(200, 200, 200, 0.5);
        [self.view addSubview:_changeUIView];
        
        UIButton *delButton=[[UIButton alloc]initWithFrame:CGRectMake(290*NOW_SIZE, 10*NOW_SIZE, 20*NOW_SIZE, 20*NOW_SIZE)];
        [delButton setImage:[UIImage imageNamed:@"btn_cha.png"] forState:0];
        [delButton addTarget:self action:@selector(delButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [_changeUIView addSubview:delButton];
        
        NSArray *titleArray=[NSArray arrayWithObjects:root_Set_Station_Location,root_Set_Station_Map,NSLocalizedString(@"Walk", @"Walk"),NSLocalizedString(@"Self driving", @"Self driving"),NSLocalizedString(@"Bus", @"Bus"), nil];
        for (int i=0; i<5; i++) {
            UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(50*NOW_SIZE, (100+i*50)*NOW_SIZE, 220*NOW_SIZE, 50*NOW_SIZE)];
            [button setTitle:titleArray[i] forState:0];
            [button setTitleColor:[UIColor blackColor] forState:0];
            button.backgroundColor=COLOR(255, 228, 181, 1);
            button.tag=i;
            [button addTarget:self action:@selector(selectedButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [_changeUIView addSubview:button];
            
            if (i<4) {
                UIView *line=[[UIView alloc]initWithFrame:CGRectMake(60*NOW_SIZE, (149.5+i*50)*NOW_SIZE, 200*NOW_SIZE, 0.5)];
                line.backgroundColor=COLOR(82, 201, 194, 1);
                [_changeUIView addSubview:line];
            }
        }
    }];
}


//取消按钮动作
-(void)delButtonPressed{
    [UIView animateWithDuration:0.2 animations:^{
        [_changeUIView removeFromSuperview];
        _changeUIView=nil;
        _allButtonView.frame = CGRectMake(0, 340*NOW_SIZE+64, 320*NOW_SIZE, SCREEN_Height-114-340*NOW_SIZE);
        _mapView.frame=CGRectMake(0, 64, 320*NOW_SIZE, 340*NOW_SIZE);
        if ([UIScreen mainScreen].bounds.size.height==480) {
            _allButtonView.frame = CGRectMake(0, 260*NOW_SIZE+64, 320*NOW_SIZE, SCREEN_Height-114-260*NOW_SIZE);
            _mapView.frame=CGRectMake(0, 64, 320*NOW_SIZE, 260*NOW_SIZE);
        }

    }];
}



//选择按钮动作
-(void)selectedButtonPressed:(UIButton *)sender{
    [sender setTitleColor:[UIColor whiteColor] forState:0];
    sender.backgroundColor=COLOR(82, 201, 194, 1);
    
    if (sender.tag==0) {
        NSString *stringLng=[NSString stringWithFormat:@"%f",_longClickLocation.coordinate.longitude];
        NSString *stringLat=[NSString stringWithFormat:@"%f",_longClickLocation.coordinate.latitude];
        [self showProgressView];
        [BaseRequest requestWithMethod:HEAD_URL paramars:@{@"id":_stationId,@"lng":stringLng,@"lat":stringLat} paramarsSite:@"/plantA.do?op=updateSite" sucessBlock:^(id content) {
            if ([content isEqualToString:@"true"]) {
                [self showToastViewWithTitle:NSLocalizedString(@"Successfully modified", @"Successfully modified")];
            } else {
                [self showToastViewWithTitle:NSLocalizedString(@"Modification fails", @"Modification fails")];
            }
            
        } failure:^(NSError *error) {
            [self hideProgressView];
            //[self showToastViewWithTitle:root_Networking];
            //            [self requestData];
            _plantLocation=_longClickLocation;
            [self buttonPressed:0];
        }];
    }
    
    if (sender.tag==1) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _imgView=[[UIImageView alloc]init];
            [self.view bringSubviewToFront:_mapView];
            //获得地图当前可视区域截图
            UIGraphicsBeginImageContext(_mapView.bounds.size);
            [_mapView.layer renderInContext:UIGraphicsGetCurrentContext()];
            _imgView.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            if (_imgView.image) {
                NSLog(@"image yes");
            }
            NSData *imageData = UIImageJPEGRepresentation(_imgView.image, 1);
            NSLog(@"_stationId: %@", _stationId);
            
            NSMutableDictionary *imageDict=[NSMutableDictionary new];
            [imageDict setObject:imageData forKey:@"plantMap"];
            [self showProgressView];
            [BaseRequest uplodImageWithMethod:HEAD_URL paramars:@{@"id":_stationId} paramarsSite:@"/plantA.do?op=updatePlantMap" dataImageDict:imageDict sucessBlock:^(id content) {
                [self hideProgressView];
                NSString *res = [[NSString alloc] initWithData:content encoding:NSUTF8StringEncoding];
                if ([res isEqualToString:@"true"]) {
                    [self showToastViewWithTitle:NSLocalizedString(@"Successfully modified", @"Successfully modified")];
                } else {
                    [self showToastViewWithTitle:NSLocalizedString(@"Modification fails", @"Modification fails")];
                }
            } failure:^(NSError *error) {
                [self hideProgressView];
                [self showToastViewWithTitle:root_Networking];
            }];
        });
    }
    
    if (sender.tag==2) {
        if ([[UIApplication sharedApplication] canOpenURL:
             [NSURL URLWithString:@"comgooglemaps://"]]) {
            [[UIApplication sharedApplication] openURL:
             [NSURL URLWithString:@"comgooglemaps://?saddr=&daddr=&directionsmode=transit"]];
        } else {
            NSLog(@"Can't use comgooglemaps://");
        }
    }
    if (sender.tag==3) {
        if ([[UIApplication sharedApplication] canOpenURL:
             [NSURL URLWithString:@"comgooglemaps://"]]) {
            [[UIApplication sharedApplication] openURL:
             [NSURL URLWithString:@"comgooglemaps://?saddr=&daddr=&directionsmode=transit"]];
        } else {
            NSLog(@"Can't use comgooglemaps://");
        }
    }
    if (sender.tag==4) {
        if ([[UIApplication sharedApplication] canOpenURL:
             [NSURL URLWithString:@"comgooglemaps://"]]) {
            [[UIApplication sharedApplication] openURL:
             [NSURL URLWithString:@"comgooglemaps://?saddr=&daddr=&directionsmode=transit"]];
        } else {
            NSLog(@"Can't use comgooglemaps://");
        }
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self delButtonPressed];
    });
}


@end
