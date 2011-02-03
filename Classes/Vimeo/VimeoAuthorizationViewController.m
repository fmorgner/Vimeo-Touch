//
//  VimeoAuthorizationViewController.m
//  Vimeo Touch
//
//  Created by Felix Morgner on 27.01.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "VimeoAuthorizationViewController.h"

@interface VimeoAuthorizationViewController (Private)

- (void)announceNewVerifier:(NSString*)aVerifier;

@end

@implementation VimeoAuthorizationViewController

@synthesize webView;
@synthesize authorizationURL;
@synthesize token;
@synthesize delegate;

- (id)init
	{
	if ((self = [super init]))
		{
		authorizationURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://vimeo.com/oauth/authorize?oauth_token=%@&permission=read", token.key]];
		webView = nil;
		token = nil;
		}
	return self;
	}

- (id)initWithToken:(OAuthToken*)aToken
	{
	if ((self = [super init]))
		{
		webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 360, 480)];
		token = aToken;
		authorizationURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://vimeo.com/oauth/authorize?oauth_token=%@&permission=read", token.key]];
		}
	return self;
	}

- (void)dealloc
	{
	[super dealloc];
	}

+ (VimeoAuthorizationViewController*)authorizationViewControllerWithToken:(OAuthToken*)aToken
	{
	return [[[VimeoAuthorizationViewController alloc] initWithToken:aToken] autorelease];
	}

- (void)didReceiveMemoryWarning
	{
	[super didReceiveMemoryWarning];
	}

#pragma mark - View lifecycle

- (void)loadView
	{
	[webView setDelegate:self];
	[webView loadRequest:[NSURLRequest requestWithURL:authorizationURL]];
	self.view = webView;
	}

- (void)viewDidUnload
	{
	[super viewDidUnload];
	}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
	{
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
				NSString* verifier = [theWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('span')[0].firstChild.data"];
				[self announceNewVerifier:verifier];
				}
			}
		}
	}

@end

@implementation VimeoAuthorizationViewController (Private)

- (void)announceNewVerifier:(NSString *)aVerifier
	{
	if(delegate && [delegate conformsToProtocol:@protocol(VimeoAuthorizationViewControllerDelegate)])
		{
		[delegate authorizationViewController:self didReceiveVerifier:aVerifier];
		}
	
	NSDictionary* userInformation = [NSDictionary dictionaryWithObject:aVerifier forKey:kVimeoVerifierKey];
	NSNotification* verifierNotification = [NSNotification notificationWithName:kVimeoAuthorizationVerifierNotification object:nil userInfo:userInformation];
	[[NSNotificationCenter defaultCenter] postNotification:verifierNotification];
	}

@end
