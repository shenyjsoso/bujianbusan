//
//  DatePickerTool.m
//  PickerView
//
//  Created by  zengchunjun on 2017/4/20.
//  Copyright © 2017年  zengchunjun. All rights reserved.
//

#import "DatePickerTool.h"

@interface DatePickerTool ()

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (nonatomic,copy)NSString *pickDate;


@end

@implementation DatePickerTool

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"DatePickerTool" owner:nil options:nil]firstObject];
    }
    self.frame = frame;
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    NSLocale *locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
    self.datePicker.locale = locale;
    [self.datePicker addTarget:self action:@selector(pickTime:) forControlEvents:UIControlEventValueChanged];
    self.datePicker.maximumDate=[NSDate date];
    self.pickDate = [self stringFromDate:[NSDate date]];
}

- (void)pickTime:(UIDatePicker *)pick
{
    NSDate *date = pick.date;
    
    self.pickDate = [self stringFromDate:date];
}
- (NSString *)stringFromDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy年MM月dd日";
    formatter.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
    NSString *dateStr = [formatter stringFromDate:date];
    
    return dateStr;
}

- (IBAction)pickDone:(UIButton *)sender {
    
    self.callBlock(self.pickDate);
}

- (IBAction)pickCancel:(UIButton *)sender {
    self.callBlock(nil);
}




@end
