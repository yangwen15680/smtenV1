//
//  CompleteAddViewController.m
//  ShinePhone
//
//  Created by LinKai on 15/5/21.
//  Copyright (c) 2015年 binghe168. All rights reserved.
//

#import "CompleteAddViewController.h"
#import "HomePageViewController.h"
#import "BaiduMapViewController.h"
#import "GoogleMapEditViewController.h"

@interface CompleteAddViewController () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIImageView *mapImgView;
@property (nonatomic, strong) UIActionSheet *uploadImageActionSheet;
@property (nonatomic, strong) UIImagePickerController *cameraImagePicker;
@property (nonatomic, strong) UIImagePickerController *photoLibraryImagePicker;
@property (nonatomic, strong) UIActionSheet *mapActionSheet;
@property (nonatomic, strong) NSMutableDictionary *dataDic;

@end

@implementation CompleteAddViewController

- (instancetype)initWithDataDict:(NSMutableDictionary *)dataDict {
    if (self = [super init]) {
        self.dataDic = [NSMutableDictionary dictionaryWithDictionary:dataDict];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)initUI {
    self.title = root_Add_Plant;
    
    for (int i=0; i<2; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40*NOW_SIZE, 94*NOW_SIZE + i*60*NOW_SIZE, 100*NOW_SIZE, 30*NOW_SIZE)];
        if (i == 0) {
            label.text = root_plant_image;
        } else {
            label.text = root_location_picture;
        }
        
        label.font = [UIFont systemFontOfSize:12*NOW_SIZE];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:label];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(40*NOW_SIZE, 125*NOW_SIZE + i*60*NOW_SIZE, SCREEN_Width - 80*NOW_SIZE, 0.5*NOW_SIZE)];
        lineView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:lineView];
    }
    
    UIView *imgBgView = [[UIView alloc] initWithFrame:CGRectMake(130*NOW_SIZE, 94*NOW_SIZE + 0*60*NOW_SIZE, SCREEN_Width - 134*NOW_SIZE - 40*NOW_SIZE, 30*NOW_SIZE)];
    imgBgView.tag = 1000;
    UITapGestureRecognizer *gesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidTapped:)];
    [imgBgView addGestureRecognizer:gesture1];
    
    [self.view addSubview:imgBgView];
    
    self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(imgBgView.frame) - 30*NOW_SIZE)/2, 0, 30*NOW_SIZE, 30*NOW_SIZE)];
    [imgBgView addSubview:_imgView];
    
    UIView *mapImgBgView = [[UIView alloc] initWithFrame:CGRectMake(130*NOW_SIZE, 94*NOW_SIZE + 1*60*NOW_SIZE, SCREEN_Width - 134*NOW_SIZE - 40*NOW_SIZE, 30*NOW_SIZE)];
    mapImgBgView.tag = 1001;
    UITapGestureRecognizer *gesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidTapped:)];
    [mapImgBgView addGestureRecognizer:gesture2];
    [self.view addSubview:mapImgBgView];
    
    self.mapImgView = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(mapImgBgView.frame) - 30*NOW_SIZE)/2, 0, 30*NOW_SIZE, 30*NOW_SIZE)];
    [mapImgBgView addSubview:_mapImgView];
    
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(40*NOW_SIZE, 425*NOW_SIZE, SCREEN_Width - 80*NOW_SIZE, 50*NOW_SIZE);
    [nextButton setBackgroundImage:IMAGE(@"圆角矩形.png") forState:UIControlStateNormal];
    [nextButton setTitle:root_Finish forState:UIControlStateNormal];
    [nextButton setTitleColor:COLOR(73, 135, 43, 1) forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    
}

- (void)viewDidTapped:(UITapGestureRecognizer *)gesture {
    if (gesture.view.tag == 1000) {
        //概貌图
        self.uploadImageActionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Choice", @"Choice") delegate:self cancelButtonTitle:root_Cancel destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Shooting", @"Shooting"), NSLocalizedString(@"Album", @"Album"), nil];
        self.uploadImageActionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
        [self.uploadImageActionSheet showInView:self.view];
    }
    
    if (gesture.view.tag == 1001) {
        //地图
        self.mapActionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"choose a map", @"choose a map") delegate:self cancelButtonTitle:root_Cancel destructiveButtonTitle:nil otherButtonTitles:root_Baidu_Map, root_Google_Map, nil];
        self.mapActionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
        [self.mapActionSheet showInView:self.view];
    }
}

- (void)buttonDidClicked:(UIButton *)sender {
    NSMutableDictionary *imageDict = [NSMutableDictionary dictionary];
    if (self.imgView.image) {
        [imageDict setObject:UIImageJPEGRepresentation(self.imgView.image, 0.5) forKey:@"plantImg"];
    }
    if (self.mapImgView.image) {
        [imageDict setObject:UIImageJPEGRepresentation(self.mapImgView.image, 0.5) forKey:@"plantMap"];
    }
    
    [self showProgressView];
    [BaseRequest uplodImageWithMethod:HEAD_URL paramars:_dataDic paramarsSite:@"/plantA.do?op=add" dataImageDict:imageDict sucessBlock:^(id content) {
        [self hideProgressView];
        if (content) {
            NSString *res = [[NSString alloc] initWithData:content encoding:NSUTF8StringEncoding];
            if ([res isEqualToString:@"true"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ADD_STATION_SUCCESSFUL object:nil];
                for (UIViewController *temp in self.navigationController.viewControllers) {
                    if ([temp isKindOfClass:[HomePageViewController class]]) {
                        [self.navigationController popToViewController:temp animated:YES];
                    }
                }
            } else if ([res isEqualToString:@"error_versionLimit"]) {
                [self showAlertViewWithTitle:nil message:NSLocalizedString(@"Beyond the limits of the number of power plants", @"Beyond the limits of the number of power plants") cancelButtonTitle:root_Yes];
            } else if ([res isEqualToString:@"error_userPlantNumLimit"]) {
                [self showAlertViewWithTitle:nil message:NSLocalizedString(@"Beyond the user limits the number of power plants", @"Beyond the user limits the number of power plants") cancelButtonTitle:root_Yes];
            } else if ([res isEqualToString:@"error_plantNameExist"]) {
                [self showAlertViewWithTitle:nil message:NSLocalizedString(@"Name of power station", @"Name of power station") cancelButtonTitle:root_Yes];
            } else {
                [self showAlertViewWithTitle:nil message:NSLocalizedString(@"Add failure", @"Add failure") cancelButtonTitle:root_Yes];
            }
        }
    } failure:^(NSError *error) {
        [self hideProgressView];
        [self showToastViewWithTitle:root_Networking];
    }];
    
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
    
    if (actionSheet == _mapActionSheet) {
        //百度地图
        if (buttonIndex == 0) {
            BaiduMapViewController *bmvc = [[BaiduMapViewController alloc] initWithDataDict:_dataDic];
            bmvc.snapshotSuccessBlock = ^(UIImage *snapshotImage) {
                self.mapImgView.image = snapshotImage;
            };
            [self.navigationController pushViewController:bmvc animated:YES];
            
        }
        //谷歌地图
        if (buttonIndex == 1) {
            GoogleMapEditViewController *bmvc = [[GoogleMapEditViewController alloc] initWithDataDict:_dataDic];
            bmvc.snapshotSuccessBlock = ^(UIImage *snapshotImage) {
                self.mapImgView.image = snapshotImage;
            };
            [self.navigationController pushViewController:bmvc animated:YES];
            
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = info[@"UIImagePickerControllerEditedImage"];

    self.imgView.image = image;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
