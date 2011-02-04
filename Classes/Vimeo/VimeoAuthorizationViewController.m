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
@synthesize loadingOverlay;
@synthesize token;
@synthesize delegate;

- (id)init
	{
	if ((self = [super init]))
		{
		webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
		loadingOverlay = [[VimeoLoadingOverlay alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
		token = nil;
		delegate = nil;
		}
	return self;
	}

- (id)initWithToken:(OAuthToken*)aToken delegate:(id)aDelegate
	{
	if ((self = [super init]))
		{
		webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
		loadingOverlay = [[VimeoLoadingOverlay alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
		token = aToken;
		delegate = aDelegate;
		}
	return self;
	}

- (void)dealloc
	{
	[webView release];
	[super dealloc];
	}

+ (VimeoAuthorizationViewController*)authorizationViewControllerWithToken:(OAuthToken*)aToken delegate:(id)aDelegate
	{
	return [[[VimeoAuthorizationViewController alloc] initWithToken:aToken delegate:(id)aDelegate] autorelease];
	}

- (void)didReceiveMemoryWarning
	{
	[super didReceiveMemoryWarning];
	}

#pragma mark - View lifecycle

- (void)loadView
	{
	NSURL* authURL = [NSURL URLWithString:[NSString stringWithFormat:kVimeoUserAuthorizationURL, token.key, kVimeoPermissionRead]];
	[webView setDelegate:self];
	[webView loadRequest:[NSURLRequest requestWithURL:authURL]];
	self.view = webView;
	
	[self.view addSubview:loadingOverlay];
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
	[loadingOverlay setHidden:YES];
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
	NSDictionary* userInformation = [NSDictionary dictionaryWithObject:aVerifier forKey:kVimeoVerifierKey];
	NSNotification* verifierNotification = [NSNotification notificationWithName:kVimeoAuthorizationVerifierNotification object:nil userInfo:userInformation];
	[[NSNotificationCenter defaultCenter] postNotification:verifierNotification];

	if(delegate && [delegate conformsToProtocol:@protocol(VimeoAuthorizationViewControllerDelegate)])
		{
		[delegate authorizationViewController:self didReceiveVerifier:aVerifier];
		}
	}

@end
