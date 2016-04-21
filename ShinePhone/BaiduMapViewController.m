//
//  BaiduMapViewController.m
//  ShinePhone
//
//  Created by LinKai on 15/5/24.
//  Copyright (c) 2015年 binghe168. All rights reserved.
//

#import "BaiduMapViewController.h"

@interface BaiduMapViewController () <BMKMapViewDelegate, BMKLocationServiceDelegate>

@property (nonatomic, strong) NSMutableDictionary *dataDict;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, assign) CLLocationCoordinate2D stationLocation;
@property (nonatomic, strong) BMKPointAnnotation *stationAnnotation;
@property (nonatomic, strong) BMKLocationService *locService;
@property (nonatomic, strong) BMKMapView *mapView;

@end

@implementation BaiduMapViewController

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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 截图

- (void)initUI {
    self.title = NSLocalizedString(@"Interception picture", @"Interception picture");
    
    //百度地图
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 64, 320*NOW_SIZE, 280*NOW_SIZE)];
    // 添加一个PointAnnotation
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    CLLocationDegrees latitude = [_dataDict[@"plantLat"] doubleValue];
    CLLocationDegrees longitude = [_dataDict[@"plantLng"] doubleValue];
    CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(latitude, longitude);
    annotation.coordinate = coor;
    annotation.title = _dataDict[@"plantName"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //视图移动到电站位置
        BMKCoordinateSpan span = BMKCoordinateSpanMake(0.06, 0.06);
        BMKCoordinateRegion region = BMKCoordinateRegionMake(coor, span);
        _mapView.region = region;
        _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
        [_mapView addAnnotation:annotation];
        [self.view addSubview:_mapView];
    });
    
    UIButton *cutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cutButton.frame = CGRectMake(40*NOW_SIZE, 425*NOW_SIZE, SCREEN_Width - 80*NOW_SIZE, 50*NOW_SIZE);
    [cutButton setBackgroundImage:IMAGE(@"圆角矩形.png") forState:UIControlStateNormal];
    [cutButton setTitle:NSLocalizedString(@"Intercept", @"Intercept") forState:UIControlStateNormal];
    [cutButton setTitleColor:COLOR(73, 135, 43, 1) forState:UIControlStateNormal];
    cutButton.tag = 1001;
    [cutButton addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cutButton];
}

//标注的回调函数,设置标注的样式和功能
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation {
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.image = [UIImage imageNamed:@"poi_1.png"];
        newAnnotationView.centerOffset = CGPointMake(0, -(newAnnotationView.frame.size.height * 0.5));
        newAnnotationView.canShowCallout = TRUE;
        //        newAnnotationView.pinColor = BMKPinAnnotationColorRed;
        //        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        //newAnnotationView.draggable = YES; // 设置可拖拽
        return newAnnotationView;
    }
    return nil;
}

#pragma mark - UI 事件
- (void)buttonDidClicked:(UIButton *)sender {
    //截图
    if (sender.tag == 1001) {
        [self.navigationController popViewControllerAnimated:YES];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _snapshotSuccessBlock([_mapView takeSnapshot]);
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


#pragma mark - 获取坐标

- (void)startLocate {
    self.title = NSLocalizedString(@"Coordinate", @"Coordinate");
    
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 64, 320*NOW_SIZE, 280*NOW_SIZE)];
    _mapView.tag = 1010;
    [self.view addSubview:_mapView];
    
    _locService = [[BMKLocationService alloc] init];
    _locService.delegate = self;
    [_locService startUserLocationService];
    
    
    UIButton *downButton = [UIButton buttonWithType:UIButtonTypeCustom];
    downButton.frame = CGRectMake(40*NOW_SIZE, 425*NOW_SIZE, SCREEN_Width - 80*NOW_SIZE, 50*NOW_SIZE);
    [downButton setBackgroundImage:IMAGE(@"圆角矩形.png") forState:UIControlStateNormal];
    [downButton setTitle:root_Finish forState:UIControlStateNormal];
    [downButton setTitleColor:COLOR(73, 135, 43, 1) forState:UIControlStateNormal];
    downButton.tag = 1002;
    [downButton addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:downButton];
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    annotation.coordinate = userLocation.location.coordinate;
    annotation.title = NSLocalizedString(@"My coordinates", @"My coordinates");
    self.stationLocation = userLocation.location.coordinate;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //视图移动到电站位置
        BMKCoordinateSpan span = BMKCoordinateSpanMake(0.06, 0.06);
        BMKCoordinateRegion region = BMKCoordinateRegionMake(userLocation.location.coordinate, span);
        _mapView.region = region;
        _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
        [_mapView addAnnotation:annotation];
        [_locService stopUserLocationService];
    });
}

//- (void)mapView:(BMKMapView *)mapView onClickedMapPoi:(BMKMapPoi *)mapPoi {
//    if (mapView.tag == 1010) {
//        if (self.stationAnnotation) {
//            [self.mapView removeAnnotation:self.stationAnnotation];
//            self.stationAnnotation = nil;
//        }
//        self.stationAnnotation = [[BMKPointAnnotation alloc] init];
//        self.stationAnnotation.coordinate = mapPoi.pt;
//        self.stationAnnotation.title = root_Set_Station_Location;
//        [mapView addAnnotation:_stationAnnotation];
//    }
//    
//}

- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate {
    if (mapView.tag == 1010) {
        if (self.stationAnnotation) {
            [self.mapView removeAnnotation:self.stationAnnotation];
            self.stationAnnotation = nil;
        }
        self.stationAnnotation = [[BMKPointAnnotation alloc] init];
        self.stationAnnotation.coordinate = coordinate;
        self.stationAnnotation.title = root_Set_Station_Location;
        self.stationLocation=coordinate;
        [mapView addAnnotation:_stationAnnotation];
    }
}

- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view {
    if (mapView.tag == 1010) {
        self.stationLocation = view.annotation.coordinate;
        [self showToastViewWithTitle:NSLocalizedString(@"Set up successfully, click Finish to return!", @"Set up successfully, click Finish to return!")];
    }
}


@end
