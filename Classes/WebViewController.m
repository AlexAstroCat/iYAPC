//
//  WebViewController.m
//  iYAPC
//
//  Created by Michael Nachbaur on 11-02-10.
//  Copyright 2011 Decaf Ninja Software. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController (Private)

- (void)updateBarButtonItems;

@end


@implementation WebViewController
@synthesize webView = _webView;
@synthesize url = _url;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
}

- (void)viewDidUnload {
	self.webView = nil;
	
    [super viewDidUnload];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.webView stopLoading];
    self.webView.delegate = nil;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark -
#pragma mark UIWebViewDelegate methods

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	[self updateBarButtonItems];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	NSString *titleJs = @"document.title";
	NSString *pageTitle = [webView stringByEvaluatingJavaScriptFromString:titleJs];
	[self updateBarButtonItems];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[self updateBarButtonItems];
}

#pragma mark -
#pragma mark Actions

- (IBAction)close:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)goBack:(id)sender {
	[self.webView goBack];
}

- (IBAction)goForward:(id)sender {
	[self.webView goForward];
}

- (IBAction)reload:(id)sender {
	[self.webView reload];
}

- (IBAction)openAction:(id)sender {
	[[UIApplication sharedApplication] openURL:[self.webView.request URL]];
}

#pragma mark -
#pragma mark Private methods

- (void)updateBarButtonItems {
	_backItem.enabled = [self.webView canGoBack];
	_forwardItem.enabled = [self.webView canGoForward];
	_reloadItem.enabled = ![self.webView isLoading];
}

@end
