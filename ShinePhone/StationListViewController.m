//
//  StationListViewController.m
//  ShinePhone
//
//  Created by LinKai on 15/5/20.
//  Copyright (c) 2015年 binghe168. All rights reserved.
//

#import "StationListViewController.h"
#import "StationCell.h"
#import "StationStorageCell.h"
#import "AddStationViewController.h"
#import "EditStationMenuView.h"
#import "StationMapViewController.h"
#import "StationOverviewViewController.h"
#import "StationDetailsViewController.h"
#import "StationEquipmentsViewController.h"
#import "StationLogsViewController.h"
#import "BaiduMapViewController.h"
#import "GoogleMapEditViewController.h"

@interface StationListViewController () <UITableViewDelegate, UITableViewDataSource, EditStationMenuViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITabBarControllerDelegate>

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) UIActionSheet *uploadImageActionSheet;
@property (nonatomic, strong) UIActionSheet *chooseMapActionSheet;
@property (nonatomic, strong) UIImagePickerController *cameraImagePicker;
@property (nonatomic, strong) UIImagePickerController *photoLibraryImagePicker;

@property (nonatomic, strong) EditStationMenuView *menuView;

@end

@implementation StationListViewController

- (instancetype)initWithStationList:(NSArray *)dataArr {
    if (self = [super init]) {
        self.dataArr = [NSMutableArray array];
        [self.dataArr addObjectsFromArray:dataArr];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self initData];
}

#pragma mark - RequestData

- (void)initData {
    //非自动登陆
    //[self showProgressView];
    [BaseRequest requestWithMethodByGet:HEAD_URL paramars:nil paramarsSite:@"/PlantListAPI.do" sucessBlock:^(id content) {
        //[self hideProgressView];
        if ([content[@"success"] integerValue] != 0) {
            self.dataArr = [NSMutableArray array];
            [self.dataArr addObjectsFromArray:content[@"data"]];
            [_tableView reloadData];
        }
    } failure:^(NSError *error) {
        //[self hideProgressView];
        [self showToastViewWithTitle:root_Networking];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI {
    self.view.backgroundColor = [UIColor clearColor];
    
    //背景图
    UIImage *clearImage = [self createImageWithColor:COLOR(0, 0, 0, 0) rect:self.view.bounds];
    self.view.layer.contents = (id)clearImage.CGImage;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_Width, SCREEN_Height - 64) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:NOTIFICATION_ADD_STATION_SUCCESSFUL object:nil];
}

- (void)refreshData {
    [self showProgressView];
    [BaseRequest requestWithMethodByGet:HEAD_URL paramars:nil paramarsSite:@"/PlantListAPI.do" sucessBlock:^(id content) {
        [self hideProgressView];
        if ([content[@"success"] integerValue] != 0) {
            [self.dataArr removeAllObjects];
            [self.dataArr addObjectsFromArray:content[@"data"]];
            [self.tableView reloadData];
            
            [self showToastViewWithTitle:NSLocalizedString(@"Add success!", @"Add success!")];
        }
    } failure:^(NSError *error) {
        [self hideProgressView];
        [self showToastViewWithTitle:root_Networking];
    }];
}

- (void)cellDidLongPressed:(UIGestureRecognizer *)recognizer{
    if(recognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [recognizer locationInView:self.tableView];
        self.indexPath = [self.tableView indexPathForRowAtPoint:point];
        if(_indexPath == nil) return ;
        //
        self.menuView = [[EditStationMenuView alloc] initWithFrame:self.view.bounds];
        self.menuView.delegate = self;
        self.menuView.tintColor = [UIColor blackColor];
        self.menuView.dynamic = NO;
        self.menuView.blurRadius = 10.0f;
        [[UIApplication sharedApplication].keyWindow addSubview:_menuView];
    }
}

#pragma mark - EditStationMenuViewDelegate

- (void)menuDidSelectAtRow:(NSInteger)row {
    if (row == 0) {
        //取消菜单
        [_menuView removeFromSuperview];
        return;
    }
    
    //4.根据是否为浏览用户(登录接口返回参数判断)，屏蔽添加电站、添加采集器、修改电站信息功能，给予提示(浏览用户禁止操作)。
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isDemo"] isEqualToString:@"isDemo"]) {
        [_menuView removeFromSuperview];
        [self showAlertViewWithTitle:nil message:NSLocalizedString(@"Browse user prohibited operation", @"Browse user prohibited operation") cancelButtonTitle:root_Yes];
        return;
    }
    if (row == 1) {
        //添加电站
        [_menuView removeFromSuperview];
        AddStationViewController *asvc = [[AddStationViewController alloc] init];
        [self.navigationController pushViewController:asvc animated:YES];
    }
    
    if (row == 2) {
        //删除电站
        [_menuView removeFromSuperview];
        
        NSString *plantId = _dataArr[_indexPath.row][@"plantId"];
        
        [BaseRequest requestWithMethodResponseStringResult:HEAD_URL paramars:@{@"plantId":[NSNumber numberWithInteger:[plantId integerValue]]} paramarsSite:@"/plantA.do?op=del" sucessBlock:^(id content) {
            NSString *res = [[NSString alloc] initWithData:content encoding:NSUTF8StringEncoding];
            if ([res isEqualToString:@"true"]) {
                [self.dataArr removeObjectAtIndex:_indexPath.row];
                [self.tableView reloadData];
                
                [self showToastViewWithTitle:root_Successfully_modified];
            } else {
                [self showToastViewWithTitle:root_Delete_failed];
            }
        } failure:^(NSError *error) {
            [self showToastViewWithTitle:root_Networking];
        }];
    }
    
    if (row == 3) {
        //上传电站图片
        [_menuView removeFromSuperview];
        
        self.uploadImageActionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Choice", @"Choice") delegate:self cancelButtonTitle:root_Cancel destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Shooting", @"Shooting"), NSLocalizedString(@"Album", @"Album"), nil];
        self.uploadImageActionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
        [self.uploadImageActionSheet showInView:self.view];
    }
    
    if (row == 4) {
        //设置电站地图
        [_menuView removeFromSuperview];
        
        self.chooseMapActionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Choice", @"Choice") delegate:self cancelButtonTitle:root_Cancel destructiveButtonTitle:nil otherButtonTitles:root_Baidu_Map, root_Google_Map, nil];
        self.chooseMapActionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
        [self.chooseMapActionSheet showInView:self.view];
    }
    
//    if (row == 5) {
//        //百度地图
//        [_menuView removeFromSuperview];
//        
//        NSString *plantId = _dataArr[_indexPath.row][@"plantId"];
//        [BaseRequest requestWithMethodResponseJsonByGet:HEAD_URL paramars:@{@"id":[NSNumber numberWithInteger:[plantId integerValue]]} paramarsSite:@"/plantA.do?op=getLatLng" sucessBlock:^(id content) {
//            //            "Lng": "104.035287",
//            //            "Lat": "30.645607",
//            //            "success": true
//            if ([content[@"success"] boolValue] == true) {
//                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//                [dict setObject:content[@"Lng"] forKey:@"plantLng"];
//                [dict setObject:content[@"Lat"] forKey:@"plantLat"];
//                
//                
//                BaiduMapViewController *bmvc = [[BaiduMapViewController alloc] initWithDataDict:dict];
//                bmvc.snapshotSuccessBlock = ^(UIImage *snapshotImage) {
//                    //            NSString *plantId = _dataArr[_indexPath.row][@"plantId"];
//                    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
//                    [dataDict setObject:UIImageJPEGRepresentation(snapshotImage, 0.5) forKey:@"plantImg"];
//                    [BaseRequest uplodImageWithMethod:HEAD_URL paramars:@{@"id":[NSNumber numberWithInteger:[plantId integerValue]]} paramarsSite:@"/plantA.do?op=updatePlantMap" dataImageDict:dataDict sucessBlock:^(id content) {
//                        NSString *res = [[NSString alloc] initWithData:content encoding:NSUTF8StringEncoding];
//                        if ([res isEqualToString:@"true"]) {
//                            [self showToastViewWithTitle:NSLocalizedString(@"Successfully modified", @"Successfully modified")];
//                            NSArray *indexPaths = @[_indexPath];
//                            [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
//                        } else {
//                            [self showToastViewWithTitle:NSLocalizedString(@"Modification fails", @"Modification fails")];
//                        }
//                    } failure:^(NSError *error) {
//                        [self showToastViewWithTitle:root_Networking];
//                    }];
//                };
//                [self.navigationController pushViewController:bmvc animated:YES];
//                
//            }
//        } failure:^(NSError *error) {
//            
//        }];
//        
//        
//    }
//    
//    if (row == 6) {
//        //谷歌地图
//        [_menuView removeFromSuperview];
    
//    }
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet == _uploadImageActionSheet) {
        //拍照
        if (buttonIndex == 0) {
            self.cameraImagePicker = [[UIImagePickerController alloc] init];
            self.cameraImagePicker.allowsEditing = YES;
            self.cameraImagePicker.delegate = self;
            self.cameraImagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:_cameraImagePicker animated:YES completion:nil];
        }
        //从相册选择
        if (buttonIndex == 1) {
            
            self.photoLibraryImagePicker = [[UIImagePickerController alloc] init];
            self.photoLibraryImagePicker.allowsEditing = YES;
            self.photoLibraryImagePicker.delegate = self;
            self.photoLibraryImagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:_photoLibraryImagePicker animated:YES completion:nil];
        }
    }
    
    if (actionSheet == _chooseMapActionSheet) {
        //拍照
        if (buttonIndex == 0) {
            NSString *plantId = _dataArr[_indexPath.row][@"plantId"];
            [BaseRequest requestWithMethodResponseJsonByGet:HEAD_URL paramars:@{@"id":[NSNumber numberWithInteger:[plantId integerValue]]} paramarsSite:@"/plantA.do?op=getLatLng" sucessBlock:^(id content) {
                //            "Lng": "104.035287",
                //            "Lat": "30.645607",
                //            "success": true
                if ([content[@"success"] boolValue] == true) {
                    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                    [dict setObject:content[@"Lng"] forKey:@"plantLng"];
                    [dict setObject:content[@"Lat"] forKey:@"plantLat"];
                    
                    BaiduMapViewController *bmvc = [[BaiduMapViewController alloc] initWithDataDict:dict];
                    bmvc.snapshotSuccessBlock = ^(UIImage *snapshotImage) {
                        //            NSString *plantId = _dataArr[_indexPath.row][@"plantId"];
                        NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
                        [dataDict setObject:UIImageJPEGRepresentation(snapshotImage, 0.5) forKey:@"plantImg"];
                        [BaseRequest uplodImageWithMethod:HEAD_URL paramars:@{@"id":[NSNumber numberWithInteger:[plantId integerValue]]} paramarsSite:@"/plantA.do?op=updatePlantMap" dataImageDict:dataDict sucessBlock:^(id content) {
                            NSString *res = [[NSString alloc] initWithData:content encoding:NSUTF8StringEncoding];
                            if ([res isEqualToString:@"true"]) {
                                [self showToastViewWithTitle:NSLocalizedString(@"Successfully modified", @"Successfully modified")];
                                NSArray *indexPaths = @[_indexPath];
                                [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
                            } else {
                                [self showToastViewWithTitle:NSLocalizedString(@"Modification fails", @"Modification fails")];
                            }
                        } failure:^(NSError *error) {
                            [self showToastViewWithTitle:root_Networking];
                        }];
                    };
                    [self.navigationController pushViewController:bmvc animated:YES];
                    
                }
            } failure:^(NSError *error) {
                
            }];
        }
        //从相册选择
        if (buttonIndex == 1) {
            NSString *plantId = _dataArr[_indexPath.row][@"plantId"];
            [BaseRequest requestWithMethodResponseJsonByGet:HEAD_URL paramars:@{@"id":[NSNumber numberWithInteger:[plantId integerValue]]} paramarsSite:@"/plantA.do?op=getLatLng" sucessBlock:^(id content) {
                //            "Lng": "104.035287",
                //            "Lat": "30.645607",
                //            "success": true
                if ([content[@"success"] boolValue] == true) {
                    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                    [dict setObject:content[@"Lng"] forKey:@"plantLng"];
                    [dict setObject:content[@"Lat"] forKey:@"plantLat"];
                    
                    
                    GoogleMapEditViewController *bmvc = [[GoogleMapEditViewController alloc] initWithDataDict:dict];
                    bmvc.snapshotSuccessBlock = ^(UIImage *snapshotImage) {
                        //            NSString *plantId = _dataArr[_indexPath.row][@"plantId"];
                        NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
                        [dataDict setObject:UIImageJPEGRepresentation(snapshotImage, 0.5) forKey:@"plantImg"];
                        [BaseRequest uplodImageWithMethod:HEAD_URL paramars:@{@"id":[NSNumber numberWithInteger:[plantId integerValue]]} paramarsSite:@"/plantA.do?op=updatePlantMap" dataImageDict:dataDict sucessBlock:^(id content) {
                            NSString *res = [[NSString alloc] initWithData:content encoding:NSUTF8StringEncoding];
                            if ([res isEqualToString:@"true"]) {
                                [self showToastViewWithTitle:NSLocalizedString(@"Successfully modified", @"Successfully modified")];
                                NSArray *indexPaths = @[_indexPath];
                                [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
                            } else {
                                [self showToastViewWithTitle:NSLocalizedString(@"Modification fails", @"Modification fails")];
                            }
                        } failure:^(NSError *error) {
                            [self showToastViewWithTitle:root_Networking];
                        }];
                    };
                    [self.navigationController pushViewController:bmvc animated:YES];
                    
                }
            } failure:^(NSError *error) {
                
            }];
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = info[@"UIImagePickerControllerEditedImage"];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    
    NSMutableDictionary *dataImageDict = [NSMutableDictionary dictionary];
    [dataImageDict setObject:imageData forKey:@"plantImg"];
    NSString *plantId = _dataArr[_indexPath.row][@"plantId"];
    [BaseRequest uplodImageWithMethod:HEAD_URL paramars:@{@"id":[NSNumber numberWithInteger:[plantId integerValue]]} paramarsSite:@"/plantA.do?op=updateImg" dataImageDict:dataImageDict sucessBlock:^(id content) {
        NSString *res = [[NSString alloc] initWithData:content encoding:NSUTF8StringEncoding];
        if ([res isEqualToString:@"true"]) {
            [self showToastViewWithTitle:NSLocalizedString(@"Successfully modified", @"Successfully modified")];
            NSArray *indexPaths = @[_indexPath];
            StationCell *cell = (StationCell *)[self.tableView cellForRowAtIndexPath:_indexPath];
            [cell clearImageCache];
            [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        } else {
            [self showToastViewWithTitle:NSLocalizedString(@"Modification fails", @"Modification fails")];
        }
    } failure:^(NSError *error) {
        [self showToastViewWithTitle:root_Networking];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_dataArr[indexPath.row][@"isHaveStorage"] boolValue]) {
        static NSString *identifier = @"stationstoragecellidentifier";
        StationStorageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[StationStorageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        UILongPressGestureRecognizer * longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(cellDidLongPressed:)];
        longPressGesture.minimumPressDuration = 1.0f;
        [cell addGestureRecognizer:longPressGesture];
        
        [cell setData:_dataArr[indexPath.row]];
        return cell;
    } else {
        static NSString *identifier = @"stationcellidentifier";
        StationCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[StationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        UILongPressGestureRecognizer * longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(cellDidLongPressed:)];
        longPressGesture.minimumPressDuration = 1.0f;
        [cell addGestureRecognizer:longPressGesture];
        
        [cell setData:_dataArr[indexPath.row]];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 25*NOW_SIZE;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_dataArr[indexPath.row][@"isHaveStorage"] boolValue]) {
        return 230*NOW_SIZE;
    } else {
        return 150*NOW_SIZE;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //电站概述
    StationOverviewViewController *sovc = [[StationOverviewViewController alloc] init];
    sovc.tabBarItem = [self createTabBarItem:root_Plant_Overview normalImage:@"dianzhan@2x.png" selectedImage:@"dianzhan@2x.png" itemTag:0];
    UINavigationController *sovcNav = [[UINavigationController alloc]initWithRootViewController:sovc];
    sovc.stationId = _dataArr[indexPath.row][@"plantId"];
    
    //电站详情
    StationDetailsViewController *sdvc = [[StationDetailsViewController alloc] init];
    sdvc.tabBarItem = [self createTabBarItem:root_Plant_Detail normalImage:@"xiangqing@2x.png" selectedImage:@"xiangqing@2x.png" itemTag:1];
    UINavigationController *sdvcNav = [[UINavigationController alloc]initWithRootViewController:sdvc];
    sdvc.stationId = _dataArr[indexPath.row][@"plantId"];
    
    //电站设备
    StationEquipmentsViewController *sevc = [[StationEquipmentsViewController alloc] init];
    sevc.tabBarItem = [self createTabBarItem:root_Device_List normalImage:@"shebei@2x.png" selectedImage:@"shebei@2x.png" itemTag:2];
    UINavigationController *sevcNav = [[UINavigationController alloc]initWithRootViewController:sevc];
    sevc.stationId = _dataArr[indexPath.row][@"plantId"];
    
    //电站日志
    StationLogsViewController *slvc = [[StationLogsViewController alloc] init];
    slvc.tabBarItem = [self createTabBarItem:root_Event_List normalImage:@"rizhi@2x.png" selectedImage:@"rizhi@2x.png" itemTag:3];
    UINavigationController *slvcNav = [[UINavigationController alloc]initWithRootViewController:slvc];
    slvc.stationId = _dataArr[indexPath.row][@"plantId"];

    //地图
    StationMapViewController *smvc = [[StationMapViewController alloc] init];
    smvc.tabBarItem = [self createTabBarItem:root_Map normalImage:@"ditu@2x.png" selectedImage:@"ditu@2x.png" itemTag:4];
    UINavigationController *smvcNav = [[UINavigationController alloc]initWithRootViewController:smvc];
    smvc.stationId = _dataArr[indexPath.row][@"plantId"];
    smvc.stationName = _dataArr[indexPath.row][@"plantName"];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    UIImage *bgImage = [self createImageWithColor:COLOR(37, 187, 166, 1) rect:CGRectMake(0, 0, SCREEN_Width/5, 49)];
    tabBarController.tabBar.selectionIndicatorImage = bgImage;
    tabBarController.delegate = self;
    tabBarController.viewControllers = @[sovcNav, sdvcNav, sevcNav, slvcNav, smvcNav];
    tabBarController.selectedIndex = 1;
    [tabBarController.tabBar setBarTintColor:COLOR(82, 201, 194, 1)];
    
    [self.navigationController pushViewController:tabBarController animated:YES];
}




@end
