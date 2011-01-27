//
//  AccountViewController.m
//  Vimeo Touch
//
//  Created by Felix Morgner on 26.01.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "AccountViewController.h"

@implementation AccountViewController

@synthesize consumer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
	{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	
	if (self)
		{
		[self setConsumer:[OAuthConsumer consumerWithKey:@"7ae96ae33601e4482b6bf6e76e442781" secret:@"b79d3ec05a464bd7"]];
		[self setTitle:@"Account"];
		}
	
	return self;
	}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

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

#pragma mark - Actions

- (IBAction)login:(id)sender
	{
	OAuthRequest* request = [[OAuthRequest alloc] initWithURL:[NSURL URLWithString:@"http://vimeo.com/oauth/request_token"]
	 																								 consumer:self.consumer
																									 		token:nil
																											realm:nil
																								signerClass:[OAuthSignerHMAC class]];
	[request prepare];
	NSHTTPURLResponse* response;
	NSError* error;
	NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	NSString* receivedString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	
	if([response statusCode] != 200)
		return;
		
	NSArray* parameterPairs = [receivedString componentsSeparatedByString:@"&"];
	NSMutableDictionary* parameters = [NSMutableDictionary dictionaryWithCapacity:[parameterPairs count]];
	
	for(NSString* parameterPair in parameterPairs)
		{
		[parameters setValue:[[parameterPair componentsSeparatedByString:@"="] objectAtIndex:1] forKey:[[parameterPair componentsSeparatedByString:@"="] objectAtIndex:0]];
		}
	
	request.token.key = [parameters objectForKey:@"oauth_token"];
	request.token.secret = [parameters objectForKey:@"oauth_token_secret"];
	
	UIWebView* oauthUserView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 360, 480)];
	[oauthUserView setDelegate:self];
	NSURL* authorizationURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://vimeo.com/oauth/authorize?oauth_token=%@&permission=read", request.token.key]];


	data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:authorizationURL] returningResponse:nil error:nil];
	[receivedString release];
	receivedString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	NSString* newString = [receivedString stringByReplacingOccurrencesOfString:@"content=\"width=1024,maximum-scale=1.0\"" withString:@"content=\"width=360,maximum-scale=1.0\""];

//	[oauthUserView loadRequest:[NSURLRequest requestWithURL:authorizationURL]];
	
	[oauthUserView loadHTMLString:newString baseURL:authorizationURL];
	
	UIViewController* oauthUserViewController = [[UIViewController alloc] init];
	[oauthUserViewController setView:oauthUserView];
	[self.tabBarController presentModalViewController:oauthUserViewController animated:YES];
	}

@end
