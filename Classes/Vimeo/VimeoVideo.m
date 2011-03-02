//
//  VimeoVideo.m
//  Vimeo Touch
//
//  Created by Felix Morgner on 14.01.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "VimeoVideo.h"

@implementation VimeoVideo

@synthesize ID;
@synthesize HD;
@synthesize title;

- (id)initWithXMLElement:(CXMLElement*)aElement
	{
	if((self = [super init]))
		{
		ID = [[[aElement attributeForName:@"id"] stringValue] intValue];
		HD = [[[aElement attributeForName:@"is_hd"] stringValue] boolValue];
		[self setTitle:[[aElement attributeForName:@"title"] stringValue]];
		}
	return self;
	}

- (void)generateURL:(NSTimer*)theTimer
	{
	NSString* videoString = [loadingWebView stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"video_holder\").attributes[2].nodeValue"];
	
	if([[loadingWebView stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"play_button\").attributes[1].nodeValue"] isEqualToString:@"na"])
		{
		[urlFetchTimer invalidate];
		return;
		}
	
	if(![videoString length])
		{
		return;
		}
	else
		{
		[urlFetchTimer invalidate];
		}
	
	
	NSString* videoURL = [videoString stringByReplacingOccurrencesOfString:@"vimeo.playVideo('" withString:@""];
	videoURL = [videoURL stringByReplacingOccurrencesOfString:@"')" withString:@""];
	return;
	}

- (void)loadMobileVideoURL
	{
	loadingWebView = [[UIWebView alloc] init];

	NSURL* mobilePageURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://vimeo.com/m/#/%i", ID]];
	[loadingWebView setDelegate:self];
	[loadingWebView loadRequest:[NSURLRequest requestWithURL:mobilePageURL]];
	}

- (void)webViewDidFinishLoad:(UIWebView *)webView
	{
	urlFetchTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(generateURL:) userInfo:nil repeats:YES];
	[[NSRunLoop mainRunLoop] addTimer:urlFetchTimer forMode:NSDefaultRunLoopMode];
	}
@end
