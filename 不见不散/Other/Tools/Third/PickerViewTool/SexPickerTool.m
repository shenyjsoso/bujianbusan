//
//  SexPickerTool.m
//  PickerView
//
//  Created by  zengchunjun on 2017/4/20.
//  Copyright © 2017年  zengchunjun. All rights reserved.
//

#import "SexPickerTool.h"

@interface SexPickerTool ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic,strong)NSMutableArray *dataSource;

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property (nonatomic,copy)NSString *sexPick;


@end

@implementation SexPickerTool

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray arrayWithObjects:@"男",@"女", nil];
    }
    return _dataSource;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"SexPickerTool" owner:nil options:nil]firstObject];
    }
    self.frame = frame;
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.pickerView.showsSelectionIndicator = YES;
    
    self.sexPick = self.dataSource[0];
}

- (IBAction)pickDone:(UIButton *)sender {
    self.callBlock(self.sexPick);
}


- (IBAction)pickCancel:(UIButton *)sender {
    self.callBlock(nil);
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.dataSource.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.dataSource[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
//    NSLog(@"%@",self.dataSource[row]);
    self.sexPick = self.dataSource[row];
}

@end
