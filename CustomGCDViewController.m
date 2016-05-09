//
//  CustomGCDViewController.m
//  ReferenceCountDemo
//
//  Created by bruthlee on 16/5/4.
//  Copyright © 2016年 demo.study. All rights reserved.
//

#import "CustomGCDViewController.h"

@interface CustomGCDViewController () {
    int times;
    int others;
}
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation CustomGCDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)touchRunCustomGCD:(id)sender {
    //清零
    times = 0;
    others = 0;
    //创建串行线程
    dispatch_queue_t myqueue = dispatch_queue_create("myFirstQueue", NULL);
    //弱引用
    __weak CustomGCDViewController *weakself = self;
//    while (times < 5) {
//        times++;
//        self.textView.text = [self.textView.text stringByAppendingFormat:@"\n\nprint 1 times = %d , others = %d",times,others];
//        dispatch_async(myqueue, ^{
//            others++;
//            dispatch_async(dispatch_get_main_queue(), ^{
//                weakself.textView.text = [weakself.textView.text stringByAppendingFormat:@"\n\nprint 2 times = %d , others = %d",times,others];
//                NSLog(@"thread 2 : %@",[NSThread currentThread]);
//                NSLog(@"text 2 : %d , %d",times,others);
//            });
//            NSLog(@"thread 1 : %@",[NSThread currentThread]);
//            NSLog(@"text 1 : %d , %d",times,others);
//        });
//        dispatch_async(dispatch_get_main_queue(), ^{
//            weakself.textView.text = [weakself.textView.text stringByAppendingFormat:@"\n\nprint 3 times = %d , others = %d",times,others];
//            NSLog(@"thread 3 : %@",[NSThread currentThread]);
//            NSLog(@"text 3 : %d , %d",times,others);
//        });
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            dispatch_async(dispatch_get_main_queue(), ^{
//                weakself.textView.text = [weakself.textView.text stringByAppendingFormat:@"\n\nprint 4 times = %d , others = %d",times,others];
//                NSLog(@"thread 4 : %@",[NSThread currentThread]);
//                NSLog(@"text 4 : %d , %d",times,others);
//            });
//            NSLog(@"thread 5 : %@",[NSThread currentThread]);
//            NSLog(@"text 5 : %d , %d",times,others);
//        });
//    }
    //异步执行线程
    dispatch_async(myqueue, ^{
        while (times < 5) {
            times++;
            NSLog(@"times : %d",times);
            //主线程打印
            dispatch_async(dispatch_get_main_queue(), ^{
                weakself.textView.text = [weakself.textView.text stringByAppendingFormat:@"\n\nprint 1 times = %d...",times];
            });
        }
        //主线程打印
        dispatch_async(dispatch_get_main_queue(), ^{
            weakself.textView.text = [weakself.textView.text stringByAppendingFormat:@"\n\nprint 2 times = %d...",times];
        });
    });
    //主线程打印
    self.textView.text = [self.textView.text stringByAppendingFormat:@"\n\nprint 3 times = %d...",times];
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
