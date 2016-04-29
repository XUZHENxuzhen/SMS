//
//  ViewController.m
//  短信验证码＋环信
//
//  Created by angelwin on 16/4/28.
//  Copyright © 2016年 com@angelwin. All rights reserved.
//

#import "ViewController.h"
#import <SMS_SDK/SMSSDK.h>

#import <SMS_SDK/Extend/SMSSDKResultHanderDef.h>
#import <SMS_SDK/Extend/SMSSDKUserInfo.h>
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
}
- (IBAction)sendEvent:(UIButton *)sender {
    
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.phoneTF.text
                                   zone:@"86"
                       customIdentifier:nil
                                 result:^(NSError *error){
                                     if (!error) {
                                        self.phoneTF.text = @"";
                                     } else {
                                         NSLog(@"错误信息：%@",error);
                                     
                                     }
                                     }];
                                     
    //GCD定时器不受RunLoop约束，比NSTimer更加准时
    __block int timeout=30; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(timer);
            dispatch_async(dispatch_get_main_queue(), ^{
              
                [_btn setTitle:@"发送验证码" forState:UIControlStateNormal];
                _btn.backgroundColor = [UIColor orangeColor];
                _btn.userInteractionEnabled = YES;

            });
        }else{
           
            int seconds = timeout % 59;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
            [_btn setTitle:strTime forState:UIControlStateNormal];
                _btn.backgroundColor = [UIColor grayColor];
                _btn.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(timer);
}



@end
