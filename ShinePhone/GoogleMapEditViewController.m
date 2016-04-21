//
//  GoogleMapEditViewController.m
//  ShinePhone
//
//  Created by ZML on 15/6/3.
//  Copyright (c) 2015年 binghe168. All rights reserved.
//

#import "GoogleMapEditViewController.h"

@interface GoogleMapEditViewController ()<GMSMapViewDelegate>
@property (nonatomic, strong) NSMutableDictionary *dataDict;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, assign) CLLocationCoordinate2D stationLocation;
@property (nonatomic, strong) GMSMarker *stationAnnotation;
@property (nonatomic, strong) GMSMapView *mapView;
@end

@implementation GoogleMapEditViewController

- (instancetype)initWithDataDict:(NSMutableDictionary *)dataDict {
    if (self = [super init]) {
        self.dataDict = [NSMutableDictionary dictionaryWithDictionary:dataDict];
        [self initUI];
    }
    return self;
}

- (instancetype)initToGetLocation {
    if (self = [super init]) {
        [self startLocate];
    }
    return self;
}

#pragma mark - 截图

- (void)initUI {
    self.title = NSLocalizedString(@"Interception picture", @"Interception picture");
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[_dataDict[@"plantLat"] doubleValue]
                                                            longitude:[_dataDict[@"plantLng"] doubleValue]
                                                                 zoom:12];
    _mapView = [GMSMapView mapWithFrame:CGRectMake(0, 64, 320*NOW_SIZE, 280*NOW_SIZE) camera:camera];
    _mapView.delegate=self;
    _mapView.myLocationEnabled = YES;
    [self.view addSubview:_mapView];
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake([_dataDict[@"plantLat"] doubleValue], [_dataDict[@"plantLng"] doubleValue]);
    marker.title = @"电站";
    marker.map = _mapView;

    
    UIButton *cutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cutButton.frame = CGRectMake(40*NOW_SIZE, 425*NOW_SIZE, SCREEN_Width - 80*NOW_SIZE, 50*NOW_SIZE);
    [cutButton setBackgroundImage:IMAGE(@"圆角矩形.png") forState:UIControlStateNormal];
    [cutButton setTitle:NSLocalizedString(@"Intercept", @"Intercept") forState:UIControlStateNormal];
    [cutButton setTitleColor:COLOR(73, 135, 43, 1) forState:UIControlStateNormal];
    cutButton.tag = 1001;
    [cutButton addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cutButton];
}

#pragma mark - UI 事件
- (void)buttonDidClicked:(UIButton *)sender {
    //截图
    if (sender.tag == 1001) {
        [self.navigationController popViewControllerAnimated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _snapshotSuccessBlock([self shotImage]);
        });
    }
    //获取坐标
    if (sender.tag == 1002) {
        [self.navigationController popViewControllerAnimated:YES];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _locationBlock(self.stationLocation);
        });
    }
}


//生成截图
-(UIImage *)shotImage{
    UIGraphicsBeginImageContext(_mapView.bounds.size);
    [_mapView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}



#pragma mark - 获取坐标

- (void)startLocate {
    self.title = NSLocalizedString(@"Coordinate", @"Coordinate");
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:22.694859
                                                            longitude:113.933232
                                                                 zoom:12];
    _mapView = [GMSMapView mapWithFrame:CGRectMake(0, 64, 320*NOW_SIZE, 280*NOW_SIZE) camera:camera];
    _mapView.delegate=self;
    _mapView.myLocationEnabled = YES;
    _mapView.tag=1011;
    [self.view addSubview:_mapView];
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(22.694859, 113.933232);
    self.stationLocation=marker.position;
    marker.title = root_Set_Station_Location;
    marker.map = _mapView;
    
    
    UIButton *downButton = [UIButton buttonWithType:UIButtonTypeCustom];
    downButton.frame = CGRectMake(40*NOW_SIZE, 425*NOW_SIZE, SCREEN_Width - 80*NOW_SIZE, 50*NOW_SIZE);
    [downButton setBackgroundImage:IMAGE(@"圆角矩形.png") forState:UIControlStateNormal];
    [downButton setTitle:root_Finish forState:UIControlStateNormal];
    [downButton setTitleColor:COLOR(73, 135, 43, 1) forState:UIControlStateNormal];
    downButton.tag = 1002;
    [downButton addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:downButton];
}



- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate{
    if (mapView.tag==1011) {
        [_mapView clear];
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:coordinate.latitude longitude:coordinate.longitude zoom:12];
        _mapView.camera=camera;
        
        // Creates a marker in the center of the map.
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude);
        marker.title = root_Set_Station_Location;
        marker.map = _mapView;
        
        _stationLocation=coordinate;
    }
}

@end
