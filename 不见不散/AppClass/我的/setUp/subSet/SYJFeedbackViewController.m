//
//  SYJFeedbackViewController.m
//  不见不散
//
//  Created by soso on 2018/1/6.
//  Copyright © 2018年 soso. All rights reserved.
//

#import "SYJFeedbackViewController.h"

@interface SYJFeedbackViewController ()
@property (nonatomic, strong) UITextView *textView;
@end

@implementation SYJFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"意见反馈";
    self.textView=[[UITextView alloc]initWithFrame:CGRectMake(0, 20, ScreenWidth, 250)];
    self.textView.text=@"";
    self.textView.font=[UIFont systemFontOfSize:18];
    self.textView.textColor=SYJColor(122, 122, 122, 1);
    [self.view addSubview:self.textView];
    UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(finish)];
    self.navigationItem.rightBarButtonItem=right;
    //页面手势
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.view addGestureRecognizer:singleTap];
}
-(void)finish
{
    if (self.textView.text.length<10)
    {
        [SYJProgressHUD showMessage:@"请输入不少于10字的意见" inView:self.view afterDelayTime:1];
        return;
    }
    else if (self.textView.text.length>100)
    {
        [SYJProgressHUD showMessage:@"请输入少于100字的意见" inView:self.view afterDelayTime:1];
        return;
    }
    
    NSDictionary *parameters = @{@"title":@"反馈",
                                 @"content":self.textView.text
                                 };
//    NSString *value=[NSString stringWithFormat:@"Bearer %@",[SYJTool getforkey:@"accessToken"]];
    [HttpTool postWithPath:API_feedback params:parameters hearder:nil success:^(id json) {
        [SYJProgressHUD showMessage:@"提交成功" inView:self.view afterDelayTime:1];
            [self performSelector:@selector(popNext) withObject:nil afterDelay:1.0f];
            
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
-(void)popNext
{
    [self.navigationController popViewControllerAnimated:YES];
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
