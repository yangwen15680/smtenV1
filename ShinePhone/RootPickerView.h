//
//  RootPickerView.h
//  ShinePhone
//
//  Created by ZML on 15/6/10.
//  Copyright (c) 2015年 binghe168. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootPickerView : UIPickerView <UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>
-(instancetype)initWithArray:(NSArray *)array;
-(instancetype)initWithTwoArray:(NSArray *)arrayOne arrayTwo:(NSArray *)arrayTwo;
-(void)viewAppear;
-(void)viewDisappear;
@end
