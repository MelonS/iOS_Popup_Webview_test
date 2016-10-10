//
//  SVModalWebViewController.m
//
//  Created by Oliver Letterer on 13.08.11.
//  Copyright 2011 Home. All rights reserved.
//
//  https://github.com/samvermette/SVWebViewController

#import "SVWebViewController.h"

@interface SVWebViewController () <UIWebViewDelegate>

@property (nonatomic, strong) NSArray<UIBarButtonItem*> *backBarButtonItem; // 뒤로가기
@property (nonatomic, strong) NSArray<UIBarButtonItem*> *doneBarButtonItem; // 닫기

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSURLRequest *request;

@end


@implementation SVWebViewController

#pragma mark - Initialization

- (void)dealloc {
    [self.webView stopLoading];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    self.webView.delegate = nil;
    self.delegate = nil;
}

- (instancetype)initWithAddress:(NSString *)urlString {
    return [self initWithURL:[NSURL URLWithString:urlString]];
}

- (instancetype)initWithURL:(NSURL*)pageURL {
    return [self initWithURLRequest:[NSURLRequest requestWithURL:pageURL]];
}

- (instancetype)initWithURLRequest:(NSURLRequest*)request {
    self = [super init];
    if (self) {
        self.request = request;
    }
    return self;
}

- (void)loadRequest:(NSURLRequest*)request {
    [self.webView loadRequest:request];
}

#pragma mark - View lifecycle

- (void)loadView {
    self.view = self.webView;
    [self loadRequest:self.request];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateToolbarItems];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.webView = nil;
    
    _backBarButtonItem = nil;
    _doneBarButtonItem = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    NSAssert(self.navigationController, @"SVWebViewController needs to be contained in a UINavigationController. If you are presenting SVWebViewController modally, use SVModalWebViewController instead.");
    
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return YES;
    
    return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

#pragma mark - Getters

- (UIWebView*)webView {
    if(!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _webView.delegate = self;
        _webView.scalesPageToFit = YES;
    }
    return _webView;
}

- (NSArray<UIBarButtonItem*> *)backBarButtonItem {
    if (!_backBarButtonItem) {
        UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"webview_icon.bundle/ic_nb_arrow_back_48dp@2x"]
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(goBackTapped:)];
        buttonItem.tintColor = [UIColor whiteColor];
        
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        space.width = -10.0f;
        
        _backBarButtonItem = @[space, buttonItem];
    }
    return _backBarButtonItem;
}

- (NSArray<UIBarButtonItem*> *)doneBarButtonItem {
    if (!_doneBarButtonItem) {
        UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"webview_icon.bundle/ic_nb_close_48dp@2x"]
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(doneButtonTapped:)];
        buttonItem.tintColor = [UIColor whiteColor];
        
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        space.width = -10.0f;
        
        _doneBarButtonItem = @[space, buttonItem];
    }
    return _doneBarButtonItem;
}

#pragma mark - Toolbar

- (void)updateToolbarItems {
    
    if (self.webView.canGoBack) {
        self.navigationItem.leftBarButtonItems = [self backBarButtonItem];
        self.navigationItem.rightBarButtonItems = [self doneBarButtonItem];
    }else{
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItems = [self doneBarButtonItem];
    }
    
//    self.backBarButtonItem.enabled = self.self.webView.canGoBack;
//    self.forwardBarButtonItem.enabled = self.self.webView.canGoForward;
//    
//    UIBarButtonItem *refreshStopBarButtonItem = self.self.webView.isLoading ? self.stopBarButtonItem : self.refreshBarButtonItem;
//    
//    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//        CGFloat toolbarWidth = 250.0f;
//        fixedSpace.width = 35.0f;
//        
//        NSArray *items = [NSArray arrayWithObjects:
//                          fixedSpace,
//                          refreshStopBarButtonItem,
//                          fixedSpace,
//                          self.backBarButtonItem,
//                          fixedSpace,
//                          self.forwardBarButtonItem,
//                          fixedSpace,
//                          self.actionBarButtonItem,
//                          nil];
//        
//        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, toolbarWidth, 44.0f)];
//        toolbar.items = items;
//        toolbar.barStyle = self.navigationController.navigationBar.barStyle;
//        toolbar.tintColor = self.navigationController.navigationBar.tintColor;
//        self.navigationItem.rightBarButtonItems = items.reverseObjectEnumerator.allObjects;
//    }
//    
//    else {
//        NSArray *items = [NSArray arrayWithObjects:
//                          fixedSpace,
//                          self.backBarButtonItem,
//                          flexibleSpace,
//                          self.forwardBarButtonItem,
//                          flexibleSpace,
//                          refreshStopBarButtonItem,
//                          flexibleSpace,
//                          self.actionBarButtonItem,
//                          fixedSpace,
//                          nil];
//        
//        self.navigationController.toolbar.barStyle = self.navigationController.navigationBar.barStyle;
//        self.navigationController.toolbar.tintColor = self.navigationController.navigationBar.tintColor;
//        self.toolbarItems = items;
//    }
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self updateToolbarItems];
    
    if ([self.delegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [self.delegate webViewDidStartLoad:webView];
    }
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    if (self.navigationItem.title == nil) {
        self.navigationItem.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
    
    [self updateToolbarItems];
    
    if ([self.delegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [self.delegate webViewDidFinishLoad:webView];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self updateToolbarItems];
    
    if ([self.delegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [self.delegate webView:webView didFailLoadWithError:error];
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([self.delegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
        return [self.delegate webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    }
    
    return YES;
}

#pragma mark - Target actions

- (void)goBackTapped:(UIBarButtonItem *)sender {
    [self.webView goBack];
}

- (void)goForwardTapped:(UIBarButtonItem *)sender {
    [self.webView goForward];
}

- (void)reloadTapped:(UIBarButtonItem *)sender {
    [self.webView reload];
}

- (void)stopTapped:(UIBarButtonItem *)sender {
    [self.webView stopLoading];
    [self updateToolbarItems];
}

- (void)doneButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:NO completion:NULL];
}

@end
