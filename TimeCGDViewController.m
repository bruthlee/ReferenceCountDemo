//
//  TimeCGDViewController.m
//  ReferenceCountDemo
//
//  Created by bruthlee on 16/5/4.
//  Copyright © 2016年 demo.study. All rights reserved.
//

#import "TimeCGDViewController.h"

@interface TimeCGDViewController () {
    int seconds;
    NSTimer *timer;
}
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation TimeCGDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)touchRunTimeGCD:(id)sender {
    //清零
    seconds = 0;
    //延迟秒数
    double delay = 3;
    //创建时间线程
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC);
    //
    __weak TimeCGDViewController *weakself = self;
    //延后执行（在主线程里面）：
    //类似于performSelector: withObject: afterDelay:
    //不过写在block里面感觉更好，有木有
    dispatch_after(time, dispatch_get_main_queue(), ^{
        seconds = 3;
        //如果是在非主线程，记得此处UI放到主线程里面
        weakself.textView.text = [weakself.textView.text stringByAppendingFormat:@"\n\nprint 2 seconds = %d",seconds];
        if (timer) {
            [timer invalidate];
            timer = nil;
        }
    });
    //主线程打印
    self.textView.text = [self.textView.text stringByAppendingFormat:@"\n\nprint 1 seconds = %d",seconds];
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(runTimer) userInfo:nil repeats:YES];
}

- (void)runTimer {
    if (seconds < 3) {
        seconds++;
        self.textView.text = [self.textView.text stringByAppendingFormat:@"\n\nprint 1 seconds = %d",seconds];
    }
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
