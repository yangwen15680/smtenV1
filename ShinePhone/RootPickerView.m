//
//  RootPickerView.m
//  ShinePhone
//
//  Created by ZML on 15/6/10.
//  Copyright (c) 2015年 binghe168. All rights reserved.
//

#import "RootPickerView.h"

@interface RootPickerView()
@property(nonatomic,strong)NSString *selectPicker;
@property(nonatomic,strong)NSString *secSelectPicker;
@property(nonatomic,strong)NSArray *array;
@property(nonatomic,strong)NSArray *arrayTwo;
@property (nonatomic, strong) UIToolbar *toolBar;
@property(nonatomic)BOOL flag;
@end

@implementation RootPickerView

-(instancetype)initWithArray:(NSArray *)array{
    self=[super init];
    _flag=YES;
    self.frame=CGRectMake(0, SCREEN_Height+30, SCREEN_Width, 216);
    self.backgroundColor=[UIColor whiteColor];
    _array=array;
    self.dataSource=self;
    self.delegate=self;
    return self;
}


-(instancetype)initWithTwoArray:(NSArray *)arrayOne arrayTwo:(NSArray *)arrayTwo{
    self=[super init];
    _flag=YES;
    self.frame=CGRectMake(0, SCREEN_Height+30, SCREEN_Width, 216);
    self.backgroundColor=[UIColor whiteColor];
    _array=arrayOne;
    _arrayTwo=arrayTwo;
    self.dataSource=self;
    self.delegate=self;
    return self;
}


-(void)viewAppear{
    if (_flag) {
        [self resignMethod];
    }
    [self.superview bringSubviewToFront:self];
    if (!_toolBar) {
        _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, SCREEN_Height, SCREEN_Width, 30)];
        _toolBar.barStyle = UIBarStyleDefault;
        _toolBar.barTintColor = COLOR(39, 177, 159, 1);
        [self.superview addSubview:_toolBar];
        
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:@selector(cancelSelect)];
        cancelButton.tintColor=[UIColor whiteColor];
        
        UIBarButtonItem *spaceButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:root_Finish style:UIBarButtonItemStyleDone target:self action:@selector(completeSelect)];
        doneButton.tintColor = [UIColor whiteColor];
        self.toolBar.items = @[cancelButton, spaceButton, doneButton];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame=CGRectMake(0, SCREEN_Height-216-50, SCREEN_Width, 216);
        _toolBar.frame=CGRectMake(0, SCREEN_Height-246-50, SCREEN_Width, 30);
    }];
}

-(void)resignMethod{
    
    for (id someView in self.superview.subviews) {
        if ([someView class] == [UITextField class]) {
            [someView resignFirstResponder];
        }
        if ([someView class] == [UIScrollView class]) {
            UIScrollView *scrollView=someView;
            for (id otherView in scrollView.subviews){
                [otherView resignFirstResponder];
            }
        }
        if ([someView class] == [UIView class]) {
            UIView *view=someView;
            for (id otherView in view.subviews){
                [otherView resignFirstResponder];
            
            }
        }
    }
}

-(void)cancelSelect{
    [self viewDisappear];
}

-(void)completeSelect{
    [self viewDisappear];
    UITextField *textField=(UITextField *)[self.superview viewWithTag:1000];
    if (_selectPicker) {
        textField.text=_selectPicker;
    }else{
        textField.text=_array[0];
    }
    UITextField *secTextField=(UITextField *)[self.superview viewWithTag:5000];
    if (_secSelectPicker) {
        secTextField.text=_secSelectPicker;
    }else{
        secTextField.text=_arrayTwo[0];
    }
}

-(void)viewDisappear{
    [UIView animateWithDuration:0.3 animations:^{
        self.frame=CGRectMake(0, SCREEN_Height, SCREEN_Width, 216);
        _toolBar.frame=CGRectMake(0, SCREEN_Height, SCREEN_Width, 30);
    }];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (_arrayTwo) {
        return 2;
    }
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component==0) {
        return _array.count;
    }else if(component==1){
        return _arrayTwo.count;
    }else{
        return 0;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component==0) {
        NSString *string=_array[row];
        return string;
    }else if(component==1){
        NSString *string=_arrayTwo[row];
        return string;
    }else{
        return nil;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component==0) {
        _selectPicker=_array[row];
    }else if(component==1){
        _secSelectPicker=_arrayTwo[row];
    }
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSLog(@"textFieldShouldBeginEditing");
    if (textField.tag==1000||textField.tag==5000) {
        [self viewAppear];
        _flag=NO;
        return NO;
    }else{
        [self viewDisappear];
        _flag=NO;
        return YES;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"textFieldDidBeginEditing");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _flag=YES;
    });
    
}

@end
