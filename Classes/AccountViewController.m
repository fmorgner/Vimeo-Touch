//
//  AccountViewController.m
//  Vimeo Touch
//
//  Created by Felix Morgner on 26.01.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "AccountViewController.h"

@implementation AccountViewController

@synthesize vimeoController;
@synthesize appDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
	{
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
		{
		self.appDelegate = [[UIApplication sharedApplication] delegate];
		self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Account" image:[UIImage imageNamed:@"111-user"] tag:0];
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
	
	if([appDelegate.vimeoUser.token isAuthorized])
		{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Vimeo Touch" message:@"Allready authorized!" 
		delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
		}
	
	OAuthRequest* request = [OAuthRequest requestWithURL:[NSURL URLWithString:@"http://vimeo.com/oauth/request_token"]
	 																								 consumer:appDelegate.consumer
																									 		token:nil
																											realm:nil
																								signerClass:[OAuthSignerHMAC class]];
	[request prepare];
	NSHTTPURLResponse* response;
	NSError* error;
	NSData* receivedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	
	if([response statusCode] != 200)
		return;
	
	NSArray* parameterPairs = [[[[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding] autorelease] componentsSeparatedByString:@"&"];
	NSMutableDictionary* parameters = [NSMutableDictionary dictionaryWithCapacity:[parameterPairs count]];
	
	for(NSString* parameterString in parameterPairs)
		{
		[parameters setValue:[[parameterString componentsSeparatedByString:@"="] objectAtIndex:1] forKey:[[parameterString componentsSeparatedByString:@"="] objectAtIndex:0]];
		}

	appDelegate.vimeoUser.token.key = [parameters objectForKey:@"oauth_token"];
	appDelegate.vimeoUser.token.secret = [parameters objectForKey:@"oauth_token_secret"];
	
	VimeoAuthorizationViewController* authorizationViewController = [[VimeoAuthorizationViewController alloc] initWithToken:appDelegate.vimeoUser.token];
	[authorizationViewController addObserver:self forKeyPath:@"verifier" options:NSKeyValueObservingOptionNew context:NULL];
	
	[self.tabBarController presentModalViewController:authorizationViewController animated:YES];
	[authorizationViewController release];
	}

#pragma mark - Utility Methods
	
- (NSDictionary*)getAccessTokenWithVerifier:(NSString*)verifier
	{
	NSURL* accessTokenURL = [NSURL URLWithString:@"http://vimeo.com/oauth/access_token"];
	OAuthRequest* request = [OAuthRequest requestWithURL:accessTokenURL consumer:appDelegate.consumer token:appDelegate.vimeoUser.token realm:nil signerClass:nil];
	NSHTTPURLResponse* response;
	NSError* error;

	[request addParameter:[OAuthParameter parameterWithKey:@"oauth_verifier" andValue:verifier]];
	[request prepare];
	
	NSData* receivedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	NSArray* parameters = [self parametersFromData:receivedData];
	NSMutableDictionary* parameterDict = [NSMutableDictionary dictionaryWithCapacity:[parameters count]];
	
	for(OAuthParameter* parameter in parameters)
		{
		[parameterDict setValue:parameter.value forKey:parameter.key];
		}
	
	[self.tabBarController dismissModalViewControllerAnimated:YES];
	[appDelegate.vimeoUser writeKeychainItem];
	return parameterDict;
	}

- (NSArray*)parametersFromData:(NSData*)theData
	{
	NSMutableArray* parameters = [NSMutableArray array];
	NSArray* parameterPairs = [[[[NSString alloc] initWithData:theData encoding:NSUTF8StringEncoding] autorelease] componentsSeparatedByString:@"&"];
	
	for(NSString* parameterString in parameterPairs)
		{
		NSString* key = [[parameterString componentsSeparatedByString:@"="] objectAtIndex:0];
		NSString* value = [[parameterString componentsSeparatedByString:@"="] objectAtIndex:1];
		[parameters addObject:[OAuthParameter parameterWithKey:key andValue:value]];
		}
	
	return [NSArray arrayWithArray:parameters];
	}

#pragma mark - Key Value Observing

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
	{
	if([keyPath isEqualToString:@"verifier"] && [object isKindOfClass:[VimeoAuthorizationViewController class]])
		{
		[self getAccessTokenWithVerifier:[change valueForKey:NSKeyValueChangeNewKey]];
		}
	}

@end
