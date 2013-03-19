//
//  BIDViewController.m
//  Test2WebViewJavascriptBridgeDelegate
//
//  Created by 曾長歡 on 13-3-18.
//  Copyright (c) 2013年 曾長歡. All rights reserved.
//

#import "BIDViewController.h"
#import "WebViewJavascriptBridge.h"
@interface BIDViewController ()
{
    WebViewJavascriptBridge *_bridge;
    
}
@end

@implementation BIDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:webView];
    [WebViewJavascriptBridge enableLogging];
    
        _bridge = [WebViewJavascriptBridge bridgeForWebView:webView handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"Received message from javascript:%@",data);
        responseCallback (@"Right back atcha");     
    }];
    
    [_bridge send:@"well hello there"];
    [_bridge send:[NSDictionary dictionaryWithObject:@"Foo" forKey:@"Bar"]];
    [_bridge send:@"Give me a response,will you?" responseCallback:^(id responseData) {
        NSLog(@"ObjC got its response! %@",responseData);
    }];
    
    
//    _bridge = [WebViewJavascriptBridge bridgeForWebView:webView handler:^(id data, WVJBResponseCallback responseCallback) {
//        NSLog(@"ObjC received message from JS: %@", data);
//        responseCallback(@"Response for message from ObjC");
//    }];
//    
//    [_bridge registerHandler:@"testObjcCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
//        NSLog(@"testObjcCallback called: %@", data);
//        responseCallback(@"Response from testObjcCallback");
//    }];
//    
//    [_bridge send:@"A string sent from ObjC before Webview has loaded." responseCallback:^(id responseData) {
//        NSLog(@"objc got response! 发消息 %@", responseData);
//    }];
//    
//    [_bridge callHandler:@"testJavascriptHandler" data:[NSDictionary dictionaryWithObject:@"before ready" forKey:@"foo"]];
    
    
    [self renderButtons:webView];
    [self loadExamplePage:webView];
    
    [_bridge send:@"A string sent from ObjC after Webview has loaded."];


}

- (void)renderButtons:(UIWebView*)webView
{
    UIButton *messageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[messageButton setTitle:@"Send message" forState:UIControlStateNormal];
	[messageButton addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
	[self.view insertSubview:messageButton aboveSubview:webView];
//    [webView addSubview:messageButton];
	messageButton.frame = CGRectMake(20, 414, 130, 45);
    
    UIButton *callbackButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [callbackButton setTitle:@"Call handler" forState:UIControlStateNormal];
    [callbackButton addTarget:self action:@selector(callHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:callbackButton aboveSubview:webView];
	callbackButton.frame = CGRectMake(170, 414, 130, 45);
}

- (void)loadExamplePage:(UIWebView*)webView
{
    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"Test2WebViewJavascriptBridge" ofType:@"html"];
    NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    [webView loadHTMLString:appHtml baseURL:nil];
}

#pragma mark - Button Methods
//发消息
- (void)sendMessage:(id)sender {
    [_bridge send:@"A string sent from ObjC to JS" responseCallback:^(id response) {
        NSLog(@"sendMessage got response: %@", response);
    }];
}

- (void)callHandler:(id)sender {
    NSDictionary* data = [NSDictionary dictionaryWithObject:@"Hi there, JS!" forKey:@"greetingFromObjC"];
    [_bridge callHandler:@"testJavascriptHandler" data:data responseCallback:^(id response) {
        NSLog(@"testJavascriptHandler responded: %@", response);
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
