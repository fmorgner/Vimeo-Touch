//
//  VimeoAuthorizationViewController.m
//  Vimeo Touch
//
//  Created by Felix Morgner on 27.01.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "VimeoAuthorizationViewController.h"
#import "NSURL+OAuthAdditions.h"

@implementation VimeoAuthorizationViewController

@synthesize webView;
@synthesize authorizationURL;
@synthesize token;
@synthesize verifier;

- (id)init
	{
	if ((self = [super init]))
		{
		self.authorizationURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://vimeo.com/oauth/authorize?oauth_token=%@&permission=read", token.key]];
		self.webView = nil;
		self.token = nil;
		self.verifier = @"";
		}
	return self;
	}

- (id)initWithToken:(OAuthToken*)aToken
	{
	if ((self = [super init]))
		{
		self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 360, 480)];
		self.token = aToken;
		self.authorizationURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://vimeo.com/oauth/authorize?oauth_token=%@&permission=read", token.key]];
		self.verifier = @"";
		[webView setDelegate:self];
		[webView loadRequest:[NSURLRequest requestWithURL:authorizationURL]];
		[self.view addSubview:webView];
		}
	return self;
	}


- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)theWebView
	{
	if([[[theWebView request] HTTPMethod] isEqualToString:@"POST"])
		{
		NSArray* parameters = [(NSMutableURLRequest*)[theWebView request] parameters];
		for(OAuthParameter* parameter in parameters)
			{
			if([[parameter key] isEqualToString:@"accept"] && [[parameter value] rangeOfString:@"Yes"].location != NSNotFound)
				{
				[self setVerifier:[theWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('span')[0].firstChild.data"]];
				}
			}
		}
	}

@end
