//
//  StationDetailViewController.m
//  ShinePhone
//
//  Created by ZML on 15/5/21.
//  Copyright (c) 2015年 binghe168. All rights reserved.
//

#import "StationMapViewController.h"
#import <BaiduMapAPI/BMapKit.h>
#import "GoogleMapViewController.h"

@interface RouteAnnotation : BMKPointAnnotation
{
    int _type; ///<0:起点 1：终点 2：公交 3：地铁 4:驾乘 5:途经点
    int _degree;
}

@property (nonatomic) int type;
@property (nonatomic) int degree;
@end

@implementation RouteAnnotation

@synthesize type = _type;
@synthesize degree = _degree;
@end

@interface StationMapViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKRouteSearchDelegate,UITextFieldDelegate,BMKPoiSearchDelegate>
@property(nonatomic,strong)BMKMapView *mapView;
@property(nonatomic,strong)UIView *allButtonView;
@property(nonatomic,strong)BMKLocationService *locService;
@property(nonatomic,strong)CLLocation *location;
@property(nonatomic,strong)UIView *changeUIView;
@property(nonatomic,strong)BMKRouteSearch *routesearch;
@property(nonatomic,strong)CLLocation *longClickLocation;
@property(nonatomic,strong)UIView *searchView;
@property(nonatomic,strong)UITextField *textField;
@property(nonatomic,strong)BMKPoiSearch *poisearch;
@property(nonatomic,strong)UIImageView *imgView;
@property(nonatomic,strong)CLLocation *plantLocation;
@end

@implementation StationMapViewController

-(instancetype)init{
    self=[super init];
    //设置定位精确度，默认：kCLLocationAccuracyBest
    //[BMKLocationServicesetLocationDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    //指定最小距离更新(米)，默认：kCLDistanceFilterNone
    //[BMKLocationServicesetLocationDistanceFilter:100.f];
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.navigationController.navigationBarHidden = YES;
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:IMAGE(@"返回_03.png") style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    backButton.imageInsets=UIEdgeInsetsMake(10, 5, 10, 5);
    self.navigationItem.leftBarButtonItem.imageInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    self.navigationItem.leftBarButtonItem = backButton;
    self.navigationItem.title = root_Map;
}

- (void)back {
    [self.tabBarController.navigationController popViewControllerAnimated:YES];
    self.tabBarController.navigationController.navigationBarHidden = NO;
}


-(void)viewDidLoad{
    [super viewDidLoad];
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    [_locService startUserLocationService];
    _routesearch = [[BMKRouteSearch alloc]init];
    _routesearch.delegate = self;
    _poisearch = [[BMKPoiSearch alloc]init];
    _poisearch.delegate=self;
    _mapView=[[BMKMapView alloc]init];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    [self requestData];
}


- (void)dealloc {
    if (_mapView) {
        _mapView.delegate = nil; // 不用时，置nil
        _routesearch.delegate = nil;
        _poisearch.delegate=nil;
        _mapView = nil;
    }
}

-(void)requestData{
    [self showProgressView];
    [BaseRequest requestWithMethodResponseJsonByGet:HEAD_URL paramars:@{@"id":_stationId} paramarsSite:@"/plantA.do?op=getLatLng" sucessBlock:^(id content) {
        [self hideProgressView];
        if ([content[@"success"] boolValue] == true) {
            _plantLocation=[[CLLocation alloc]initWithLatitude:[content[@"Lat"] doubleValue] longitude:[content[@"Lng"] doubleValue]];
        }
        [self initUI];
    } failure:^(NSError *error) {
        [self hideProgressView];
        [self showToastViewWithTitle:root_Networking];
    }];
}


//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation{
    //NSLog(@"heading is %@",userLocation.heading);
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    //NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    _location =[[CLLocation alloc]initWithLatitude:userLocation.location.coordinate.latitude longitude:userLocation.location.coordinate.longitude];
    
    //显示定位图层
    _mapView.showsUserLocation = YES;
    [_mapView updateLocationData:userLocation];
}



-(void)initUI{
    self.tabBarController.navigationItem.title=root_Map;
    self.title = root_Map;
    
    if (_allButtonView) {
        [_allButtonView removeFromSuperview];
        _allButtonView=nil;
        //清除之前的标注
        [_mapView removeOverlays:_mapView.overlays];
        [_mapView removeAnnotations:_mapView.annotations];
    }
    
    //百度地图
    _mapView.frame =CGRectMake(0, 64, 320*NOW_SIZE, 340*NOW_SIZE);
    if ([UIScreen mainScreen].bounds.size.height==480) {
        _mapView.frame =CGRectMake(0, 64, 320*NOW_SIZE, 260*NOW_SIZE);
    }
    // 添加一个PointAnnotation
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D coor=_plantLocation.coordinate;
    annotation.coordinate = coor;
    annotation.title = _stationName;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //视图移动到电站位置
        BMKCoordinateSpan span=BMKCoordinateSpanMake(0.06, 0.06);
        BMKCoordinateRegion region=BMKCoordinateRegionMake(_plantLocation.coordinate, span);
        _mapView.region=region;
        
        
        [_mapView addAnnotation:annotation];
        [self.view addSubview:_mapView];
    });
    
    //底部按钮背景
    _allButtonView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_mapView.frame), 320*NOW_SIZE, SCREEN_Height-114-CGRectGetMaxY(_mapView.bounds))];
    _allButtonView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_allButtonView];
    
    //底部6个按钮
    NSArray *titleArray=[NSArray arrayWithObjects:root_Station_Location, root_Growatt_Location, root_My_Location, root_Satellite_Images, root_Search, root_Google_Map, nil];
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
    //清除之前的标注
    [_mapView removeOverlays:_mapView.overlays];
    [_mapView removeAnnotations:_mapView.annotations];
    
    if (sender.tag==0) {
        // 添加一个PointAnnotation
        BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
        CLLocationCoordinate2D coor=_plantLocation.coordinate;
        annotation.coordinate = coor;
        annotation.title = _stationName;
        [_mapView addAnnotation:annotation];
        
        //视图移动到电站位置
        BMKCoordinateSpan span=BMKCoordinateSpanMake(0.06, 0.06);
        BMKCoordinateRegion region=BMKCoordinateRegionMake(coor, span);
        _mapView.region=region;
    }
    
    if (sender.tag==1) {
        // 添加一个PointAnnotation
        BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
        CLLocationCoordinate2D coor=CLLocationCoordinate2DMake(22.694859, 113.933232);
        annotation.coordinate = coor;
        annotation.title = @"growatt";
        [_mapView addAnnotation:annotation];
        
        //视图移动到电站位置
        BMKCoordinateSpan span=BMKCoordinateSpanMake(0.06, 0.06);
        BMKCoordinateRegion region=BMKCoordinateRegionMake(coor, span);
        _mapView.region=region;
    }
    
    if (sender.tag==2) {
        //视图移动到我的位置
        BMKCoordinateSpan span=BMKCoordinateSpanMake(0.06, 0.06);
        BMKCoordinateRegion region=BMKCoordinateRegionMake(_location.coordinate, span);
        _mapView.region=region;
    }
    
    if (sender.tag==3) {
        if (!sender.selected) {
            [_mapView setMapType:BMKMapTypeSatellite];
        }else{
            [_mapView setMapType:BMKMapTypeStandard];
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
        GoogleMapViewController *google=[[GoogleMapViewController alloc]initWithLocation:_plantLocation name:_stationName];
        google.stationId=_stationId;
        [self.navigationController pushViewController:google animated:NO];
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

//收起键盘
-(void)backgroundTap:(id)sender{
    BMKCitySearchOption *citySearchOption = [[BMKCitySearchOption alloc]init];
    citySearchOption.pageCapacity = 10;
    //citySearchOption.city=@"成都市";
    citySearchOption.keyword =_textField.text;
    BOOL flag = [_poisearch poiSearchInCity:citySearchOption];
    if(flag)
    {
        // _nextPageButton.enabled = true;
        NSLog(@"城市内检索发送成功");
    }
    else
    {
        // _nextPageButton.enabled = false;
        NSLog(@"城市内检索发送失败");
    }
    [_textField resignFirstResponder];
}



#pragma mark implement BMKSearchDelegate
- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult*)result errorCode:(BMKSearchErrorCode)error{
    // 清楚屏幕中所有的annotation
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    
    if (error == BMK_SEARCH_NO_ERROR) {
        for (int i = 0; i < result.poiInfoList.count; i++) {
            BMKPoiInfo* poi = [result.poiInfoList objectAtIndex:i];
            BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
            item.coordinate = poi.pt;
            item.title = poi.name;
            [_mapView addAnnotation:item];
            if(i == 0)
            {
                //将第一个点的坐标移到屏幕中央
                _mapView.centerCoordinate = poi.pt;
            }
        }
    } else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR){
        NSLog(@"起始点有歧义");
    } else {
        // 各种情况的判断。。。
    }
}




#pragma 标注的回调函数,设置标注的样式和功能
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation{
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


#pragma 路线的回调函数,设置路线的样式和功能
- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:1];
        polylineView.strokeColor = [COLOR(82, 201, 194, 0.5) colorWithAlphaComponent:0.5];
        polylineView.lineWidth = 15.0;
        return polylineView;
    }
    return nil;
}

#pragma 每次重画地图时调用
//- (void) mapView:(BMKMapView *)mapView onDrawMapFrame:(BMKMapStatus *)status{
//}



/**
 *长按地图时会回调此接口
 *@param mapview 地图View
 *@param coordinate 返回长按事件坐标点的经纬度
 */
- (void)mapview:(BMKMapView *)mapView onLongClick:(CLLocationCoordinate2D)coordinate{
    [self changeUI];
    NSLog(@"onLongClick-latitude==%f,longitude==%f",coordinate.latitude,coordinate.longitude);
    NSString* showmeg = [NSString stringWithFormat:@"您长按了地图(long pressed).\r\n当前经度:%f,当前纬度:%f,\r\nZoomLevel=%d;RotateAngle=%d;OverlookAngle=%d", coordinate.longitude,coordinate.latitude,
                         (int)_mapView.zoomLevel,_mapView.rotation,_mapView.overlooking];
    NSLog(@"showmeg: %@", showmeg);
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
            [self initUI];
            
            
        }];
    }
    
    if (sender.tag==1) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _imgView=[[UIImageView alloc]init];
            [self.view bringSubviewToFront:_mapView];
            //获得地图当前可视区域截图
            _imgView.image = [_mapView takeSnapshot];
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
        BMKPlanNode *start=[[BMKPlanNode alloc]init];
        start.pt=_location.coordinate;
        BMKPlanNode *end=[[BMKPlanNode alloc]init];
        end.pt=_longClickLocation.coordinate;
        
        BMKWalkingRoutePlanOption *walkingRouteSearchOption = [[BMKWalkingRoutePlanOption alloc]init];
        walkingRouteSearchOption.from = start;
        walkingRouteSearchOption.to = end;
        BOOL flag = [_routesearch walkingSearch:walkingRouteSearchOption];
        if(flag)
        {
            NSLog(@"walk检索发送成功");
        }
        else
        {
            NSLog(@"walk检索发送失败");
        }
    }
    if (sender.tag==3) {
        BMKPlanNode *start=[[BMKPlanNode alloc]init];
        start.pt=_location.coordinate;
        BMKPlanNode *end=[[BMKPlanNode alloc]init];
        end.pt=_longClickLocation.coordinate;
        
        BMKDrivingRoutePlanOption *drivingRouteSearchOption = [[BMKDrivingRoutePlanOption alloc]init];
        drivingRouteSearchOption.from = start;
        drivingRouteSearchOption.to = end;
        BOOL flag = [_routesearch drivingSearch:drivingRouteSearchOption];
        if(flag)
        {
            NSLog(@"car检索发送成功");
        }
        else
        {
            NSLog(@"car检索发送失败");
        }
    }
    if (sender.tag==4) {
        BMKPlanNode *start=[[BMKPlanNode alloc]init];
        start.pt=_location.coordinate;
        BMKPlanNode *end=[[BMKPlanNode alloc]init];
        end.pt=_longClickLocation.coordinate;
        
        BMKTransitRoutePlanOption *transitRouteSearchOption = [[BMKTransitRoutePlanOption alloc]init];
        transitRouteSearchOption.city= @"北京市";
        transitRouteSearchOption.from = start;
        transitRouteSearchOption.to = end;
        BOOL flag = [_routesearch transitSearch:transitRouteSearchOption];
        
        if(flag)
        {
            NSLog(@"bus检索发送成功");
        }
        else
        {
            NSLog(@"bus检索发送失败");
        }
    }
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self delButtonPressed];
    });
}


#pragma 检索成功后生成路线的函数
- (void)onGetWalkingRouteResult:(BMKRouteSearch*)searcher result:(BMKWalkingRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    NSLog(@"onGetWalkingRouteResult:");
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKWalkingRouteLine* plan = (BMKWalkingRouteLine*)[result.routes objectAtIndex:0];
        NSUInteger size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKWalkingStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
                
            }else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [_mapView addAnnotation:item]; // 添加起点标注
            }
            //添加annotation节点
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.entraceInstruction;
            item.degree = transitStep.direction * 30;
            item.type = 4;
            [_mapView addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKWalkingStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
    }
}

- (void)onGetDrivingRouteResult:(BMKRouteSearch*)searcher result:(BMKDrivingRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKDrivingRouteLine* plan = (BMKDrivingRouteLine*)[result.routes objectAtIndex:0];
        // 计算路线方案中的路段数目
        NSUInteger size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
                
            }else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [_mapView addAnnotation:item]; // 添加起点标注
            }
            //添加annotation节点
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.entraceInstruction;
            item.degree = transitStep.direction * 30;
            item.type = 4;
            [_mapView addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        // 添加途经点
        if (plan.wayPoints) {
            for (BMKPlanNode* tempNode in plan.wayPoints) {
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item = [[RouteAnnotation alloc]init];
                item.coordinate = tempNode.pt;
                item.type = 5;
                item.title = tempNode.name;
                [_mapView addAnnotation:item];
            }
        }
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
        
        
    }
}

- (void)onGetTransitRouteResult:(BMKRouteSearch*)searcher result:(BMKTransitRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKTransitRouteLine* plan = (BMKTransitRouteLine*)[result.routes objectAtIndex:0];
        // 计算路线方案中的路段数目
        NSUInteger size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKTransitStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
                
            }else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [_mapView addAnnotation:item]; // 添加起点标注
            }
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.instruction;
            item.type = 3;
            [_mapView addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKTransitStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
    }
    
}

@end
