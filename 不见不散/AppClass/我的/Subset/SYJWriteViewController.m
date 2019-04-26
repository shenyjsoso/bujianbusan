//
//  SYJWriteViewController.m
//  不见不散
//
//  Created by soso on 2017/12/13.
//  Copyright © 2017年 soso. All rights reserved.
//

#import "SYJWriteViewController.h"

@interface SYJWriteViewController ()<UITextViewDelegate>

@end

@implementation SYJWriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textView=[[UITextView alloc]initWithFrame:CGRectMake(0, 20, ScreenWidth, 200)];
    self.textView.delegate=self;
    self.textView.text=self.String;
    self.textView.font=[UIFont systemFontOfSize:18];
    self.textView.textColor=SYJColor(122, 122, 122, 1);
    [self.view addSubview:self.textView];
    UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(finish)];
    self.navigationItem.rightBarButtonItem=right;
    //页面手势
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.view addGestureRecognizer:singleTap];
}

-(instancetype)initWithString:(NSString*)Str Length:(NSInteger)len Par: (NSString*)parameters
{
    if (self = [super init]) {
        self.String = Str;
        self.length=len;
        self.parameters=parameters;
    }
    return self;
}
-(void)finish
{

    //NSLog(@"长度%ld",self.textView.text.length);
    if (self.textView.text.length>self.length||[self.textView.text isEqualToString:self.String]) {
        [SYJProgressHUD  showMessage:self.String inView:self.view afterDelayTime:1];
    }
    else
    {
        NSDictionary *parameters = @{self.parameters:self.textView.text};
//        NSString *value=[NSString stringWithFormat:@"Bearer %@",[SYJTool getforkey:@"accessToken"]];
        [HttpTool putWithPath:API_MyInfo params:parameters hearder:nil success:^(id json) {
            //NSLog(@"修改成功%@",json);
            if ([self.navigationItem.title isEqualToString:@"昵称"]) {
                [UserCacheManager updateMyNick:self.textView.text];
            }
            if (self.block) {
                self.block();
            }
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError *error) {
            if (error.code==-1011) {
                NSDictionary *errorDict=[SYJTool code1011:error];
                [SYJProgressHUD showMessage:errorDict[@"message"] inView:self.view afterDelayTime:1];
            }
            else if (error.localizedDescription)
            {
                [SYJProgressHUD showMessage:error.localizedDescription inView:self.view afterDelayTime:1];
            }
            else{
                [SYJProgressHUD showMessage:@"错误" inView:self.view afterDelayTime:1];
            }
        }];
    }
    
    
}
#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView.text.length < 1){
        textView.text = self.String;
       // textView.textColor = [UIColor grayColor];
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:self.String]){
        textView.text=@"";
       // textView.textColor=[UIColor blackColor];
    }
}
#pragma 手势
-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
