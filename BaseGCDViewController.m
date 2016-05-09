//
//  BaseGCDViewController.m
//  ReferenceCountDemo
//
//  Created by bruthlee on 16/5/4.
//  Copyright © 2016年 demo.study. All rights reserved.
//

#import "BaseGCDViewController.h"

@interface BaseGCDViewController () {
    int aa;
}
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation BaseGCDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)touchRunBaseGCD:(id)sender {
    aa = 0;
    __weak BaseGCDViewController *weakself = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        aa++;
        dispatch_async(dispatch_get_main_queue(), ^{
            weakself.textView.text = [weakself.textView.text stringByAppendingFormat:@"\n\n\nprint 1 aa = %d",aa];
        });
    });
    self.textView.text = [self.textView.text stringByAppendingFormat:@"\n\n\nprint 2 aa = %d",aa];
    
    [self randomRun];
}

- (void)randomRun {
    int index = arc4random() % 5;
    switch (index) {
        case 0:
            [self asyncAddTaskToParallelList];
            break;
        case 1:
            [self asyncAddTaskToSerialList];
            break;
        case 2:
            [self syncAddTaskToParallelList];
            break;
        case 3:
            [self syncAddTaskToSerialList];
            break;
            
        default:
            break;
    }
}

/**
 *  用异步函数往并发队列中添加任务
 */
- (void)asyncAddTaskToParallelList {
    //1.获得全局的并发队列
    dispatch_queue_t global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //2.添加任务到队列中，就可以执行任务
    //异步函数：具备开启新线程的能力
    dispatch_async(global, ^{
        NSLog(@"Thread 1 : %@",[NSThread currentThread]);
    });
    dispatch_async(global, ^{
        NSLog(@"Thread 2 : %@",[NSThread currentThread]);
    });
    dispatch_async(global, ^{
        NSLog(@"Thread 3 : %@",[NSThread currentThread]);
    });
    NSLog(@"Main thread : %@",[NSThread mainThread]);
}

/**
 *  用异步函数往串行队列中添加任务
 */
- (void)asyncAddTaskToSerialList {
    //打印主线程
    NSLog(@"主线程----%@",[NSThread mainThread]);
    
    //创建串行队列
    dispatch_queue_t  queue= dispatch_queue_create("wendingding", NULL);
    //第一个参数为串行队列的名称，是c语言的字符串
    //第二个参数为队列的属性，一般来说串行队列不需要赋值任何属性，所以通常传空值（NULL）
    
    //2.添加任务到队列中执行
    dispatch_async(queue, ^{
        NSLog(@"下载图片1----%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"下载图片2----%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"下载图片3----%@",[NSThread currentThread]);
    });
}

/**
 *  用同步函数往并发队列中添加任务
 */
- (void)syncAddTaskToParallelList {
    //打印主线程
    NSLog(@"主线程--视频--%@",[NSThread mainThread]);
    
    //创建串行队列
    dispatch_queue_t  queue= dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //2.添加任务到队列中执行
    dispatch_sync(queue, ^{
        NSLog(@"下载视频1----%@",[NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"下载视频2----%@",[NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"下载视频3----%@",[NSThread currentThread]);
    });
}

/**
 *  用同步函数往串行队列中添加任务
 */
- (void)syncAddTaskToSerialList {
    NSLog(@"用同步函数往串行队列中添加任务");
    //打印主线程
    NSLog(@"主线程--音乐--%@",[NSThread mainThread]);
    
    //创建串行队列
    dispatch_queue_t  queue= dispatch_queue_create("myqueue", NULL);
    
    //2.添加任务到队列中执行
    dispatch_sync(queue, ^{
        NSLog(@"下载音乐1----%@",[NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"下载音乐2----%@",[NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"下载音乐3----%@",[NSThread currentThread]);
    });
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
