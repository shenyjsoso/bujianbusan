//
//  SexPickerTool.m
//  PickerView
//
//  Created by  zengchunjun on 2017/4/20.
//  Copyright © 2017年  zengchunjun. All rights reserved.
//

#import "doublePickerTool.h"

@interface doublePickerTool ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property(assign,nonatomic)long provinceindex;
@end

@implementation doublePickerTool

//- (NSMutableArray *)dataSource
//{
//    if (_dataSource == nil) {
//        //_dataSource = [NSMutableArray arrayWithObjects:@"男",@"女", nil];
//        _dataSource=[[NSMutableArray alloc]init];
//
//    }
//    return _dataSource;
//}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"doublePickerTool" owner:nil options:nil]firstObject];
    }
    self.frame = frame;
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.pickerView.showsSelectionIndicator = YES;
    
    //self.minPick = @"不限";//self.dataSource[0];
    //self.maxPick=@"不限";
}

- (IBAction)pickDone:(UIButton *)sender {
    self.callBlock(self.minPick,self.maxPick);
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
//    if (component==0) {
//        return [self.dataSource[0] count];
//    }
//    else{
//        NSDictionary *dic=self.dataSource[self.provinceindex];
//        return [dic[@"city"] count];
//    }
    return [self.dataSource[component] count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.dataSource[component][row];
//    if (component==0) {
//        NSDictionary *dic=self.dataSource[row];
//        return dic[@"province"];
//    }
//    else{
//        NSDictionary *dic=self.dataSource[self.provinceindex];
//        NSArray *cities=dic[@"city"];
//        return cities[row];
//    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
//    NSLog(@"%@",self.dataSource[row]);
   // self.sexPick = self.dataSource[row];
    if (component==0) {
        self.provinceindex=row;
        //self.firstPick=self.dataSource[component][row];
        [pickerView reloadComponent:1];
        //self.sexPick = self.dataSource[self.provinceindex][@"province"];
        [pickerView selectRow:row inComponent:1 animated:NO];
        self.maxPick=self.dataSource[1][row];
        self.minPick=self.dataSource[component][row];
    }
    else
    {
        if (row<self.provinceindex) {
            [pickerView selectRow:row inComponent:0 animated:NO];
            self.provinceindex=row;
            
        }
//        if ([self.dataSource[0][self.provinceindex] isEqualToString:self.dataSource[component][row]]||[self.dataSource[0][self.provinceindex] isEqualToString:@"不限"]) {
//            self.maxPick=self.dataSource[component][row];
//        }
        else{
        //self.sexPick=[NSString stringWithFormat:@"%@-%@",self.dataSource[0][self.provinceindex],self.dataSource[component][row]];
            self.minPick=self.dataSource[0][self.provinceindex];
            self.maxPick=self.dataSource[component][row];
        }
    }
}

@end
