//
//  ViewController.m
//  PoupWebViewTest
//
//  Created by Inc.MelonS on 2016. 10. 5..
//  Copyright © 2016년 MelonS. All rights reserved.
//

#import "ViewController.h"

#import "SVModalWebViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
 
}

-(void)viewDidAppear:(BOOL)animated {
    [self showWebView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showWebView {
    NSURL *URL = [NSURL URLWithString:@"http://www.google.com"];
    
    SVModalWebViewController *svWebController = [[SVModalWebViewController alloc] initWithURL:URL];
    svWebController.modalPresentationStyle = UIModalPresentationFullScreen;
    
    [self presentViewController:svWebController animated:NO completion:NULL];
}

@end
