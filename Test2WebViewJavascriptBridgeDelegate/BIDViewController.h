//
//  BIDViewController.h
//  Test2WebViewJavascriptBridgeDelegate
//
//  Created by 曾長歡 on 13-3-18.
//  Copyright (c) 2013年 曾長歡. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebViewJavascriptBridge.h"

@interface BIDViewController : UIViewController<UIWebViewDelegate>
//@property (strong, nonatomic) WebViewJavascriptBridge *javascriptBridge;

- (void)renderButtons:(UIWebView*)webView;
- (void)loadExamplePage:(UIWebView*)webView;

@end
