//
//  SexPickerTool.m
//  PickerView
//
//  Created by  zengchunjun on 2017/4/20.
//  Copyright © 2017年  zengchunjun. All rights reserved.
//

#import "CityPickerTool.h"

@interface CityPickerTool ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;


@property(assign,nonatomic)long provinceindex;

@end

@implementation CityPickerTool

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"CityPickerTool" owner:nil options:nil]firstObject];
    }
    self.frame = frame;
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.pickerView.showsSelectionIndicator = YES;
    
    //self.provincePick = @"不限";//self.dataSource[0];
    //self.provincePick=@"不限";
    //self.cityPick=@"不限";
}

- (IBAction)pickDone:(UIButton *)sender {
    self.callBlock(self.provincePick,self.cityPick);
}


- (IBAction)pickCancel:(UIButton *)sender {
    self.callBlock(nil,nil);
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component==0) {
        return self.dataSource.count;
    }
    else{
        NSDictionary *dic=self.dataSource[self.provinceindex];
        return [dic[@"city"] count];
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    //return self.dataSource[row];
    if (component==0) {
        NSDictionary *dic=self.dataSource[row];
        return dic[@"province"];
    }
    else{
        NSDictionary *dic=self.dataSource[self.provinceindex];
        NSArray *cities=dic[@"city"];
        return cities[row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component==0) {
        self.provinceindex=row;
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:NO];
        self.provincePick = self.dataSource[self.provinceindex][@"province"];
        self.cityPick=self.dataSource[self.provinceindex][@"city"][0];
    }
    else
    {
        self.cityPick= self.dataSource[self.provinceindex][@"city"][row];
    }
}

@end
