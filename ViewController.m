//
//  ViewController.m
//  ReferenceCountDemo
//
//  Created by bruthlee on 16/5/4.
//  Copyright © 2016年 demo.study. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIButton *gcdButton;
@property (weak, nonatomic) IBOutlet UIImageView *gcdImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *indicatorViewCenterYConstraint;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.indicatorView.hidden = YES;
    
    [self.view layoutIfNeeded];
    self.indicatorViewCenterYConstraint.constant = self.imageView.frame.origin.y;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)touchDownloadImageWithGCD {
    [self.view layoutIfNeeded];
    self.indicatorViewCenterYConstraint.constant = self.gcdImageView.frame.origin.y;
    
    self.indicatorView.hidden = NO;
    [self.indicatorView startAnimating];
    
    __weak ViewController *weakself = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url = [NSURL URLWithString:@"http://a2.att.hudong.com/71/04/300224654811132504044925945_950.jpg"];
        NSData *data = [NSData dataWithContentsOfURL:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                weakself.gcdImageView.image = [UIImage imageWithData:data];
                [weakself.indicatorView stopAnimating];
                weakself.indicatorView.hidden = YES;
            }
            else {
                [[[UIAlertView alloc] initWithTitle:@"下载失败" message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil] show];
            }
        });
    });
}

- (IBAction)touchDownloadContent {
    self.indicatorView.hidden = NO;
    [self.indicatorView startAnimating];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(downContent) object:nil];
    [queue addOperation:operation];
}

- (void)downContent {
    NSURL *url = [NSURL URLWithString:@"http://g.hiphotos.baidu.com/image/h%3D200/sign=08b7f2fe8094a4c21523e02b3ef51bac/3812b31bb051f819582710bbddb44aed2f73e7c5.jpg"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    if (data) {
        [self performSelectorOnMainThread:@selector(showNetData:) withObject:data waitUntilDone:NO];
    }
    else {
        [[[UIAlertView alloc] initWithTitle:@"下载失败" message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil] show];
    }
}

- (void)showNetData:(NSData *)data {
    [self.indicatorView stopAnimating];
    self.indicatorView.hidden = YES;
    self.imageView.image = [UIImage imageWithData:data];
}

- (void)arcLeakTest {
    NSMutableArray *list1 = [NSMutableArray array];
    NSMutableArray *list2 = [NSMutableArray array];
    [list1 addObject:list2];
    [list2 addObject:list1];
}

@end
