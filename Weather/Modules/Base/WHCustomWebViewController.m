//
//  WHCustomWebViewController.m
//  Weather
//
//  Created by shoujian on 2021/3/18.
//

#import "WHCustomWebViewController.h"
#import <WebKit/WebKit.h>
@interface WHCustomWebViewController ()
@property (weak, nonatomic) IBOutlet WKWebView *webView;
@property (nonatomic,copy) NSString *url;
@end

@implementation WHCustomWebViewController

- (instancetype)initWithUrl:(NSString *)url title:(NSString *)title{
    if (self = [super init]) {
        _url = url;
        self.title = title;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
}


@end
