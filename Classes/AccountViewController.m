//
//  AccountViewController.m
//  Vimeo Touch
//
//  Created by Felix Morgner on 26.01.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "AccountViewController.h"

@interface AccountViewController (Private)

- (NSArray*)parametersFromData:(NSData*)theData;

@end

@implementation AccountViewController

@synthesize vimeoController;
@synthesize appDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
	{
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
		{
		[self setAppDelegate:[[UIApplication sharedApplication] delegate]];
		[self setTabBarItem:[[UITabBarItem alloc] initWithTitle:@"Account" image:[UIImage imageNamed:@"111-user"] tag:0]];
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
	[super didReceiveMemoryWarning];
	}

#pragma mark - View lifecycle

- (void)viewDidLoad
	{
	[super viewDidLoad];
	}

- (void)viewDidUnload
	{
	[super viewDidUnload];
	}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
	{
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
	
	OAuthRequest* request = [OAuthRequest requestWithURL:[NSURL URLWithString:kVimeoAccessTokenRequestURL] consumer:appDelegate.consumer token:nil realm:nil signerClass:[OAuthSignerHMAC class]];
	[request prepare];
	NSHTTPURLResponse* response;
	NSError* error;
	NSData* receivedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	
	if([response statusCode] != 200)
		return;

	NSDictionary* parameters = [NSDictionary dictionaryWithOauthParameters:[self parametersFromData:receivedData]];
	
	appDelegate.vimeoUser.token.key = [parameters objectForKey:@"oauth_token"];
	appDelegate.vimeoUser.token.secret = [parameters objectForKey:@"oauth_token_secret"];
	
	VimeoAuthorizationViewController* authorizationViewController = [[VimeoAuthorizationViewController alloc] init];
	[authorizationViewController setToken:appDelegate.vimeoUser.token];
	[authorizationViewController setDelegate:self];
	
	[self.tabBarController presentModalViewController:authorizationViewController animated:YES];
	[authorizationViewController release];
	}

#pragma mark - Utility Methods
	
- (OAuthToken*)fetchAccessTokenWithVerifier:(NSString*)verifier
	{
	NSURL* accessTokenURL = [NSURL URLWithString:kVimeoAccessTokenVerificationURL];
	OAuthRequest* request = [OAuthRequest requestWithURL:accessTokenURL consumer:appDelegate.consumer token:appDelegate.vimeoUser.token realm:nil signerClass:nil];
	NSHTTPURLResponse* response;
	NSError* error;

	[request addParameter:[OAuthParameter parameterWithKey:@"oauth_verifier" andValue:verifier]];
	[request prepare];
	
	NSData* receivedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	NSDictionary* parameters = [NSDictionary dictionaryWithOauthParameters:[self parametersFromData:receivedData]];
	
	OAuthToken* newToken = [OAuthToken tokenWithKey:[parameters valueForKey:@"oauth_token"] secret:[parameters valueForKey:@"oauth_token_secret"] authorized:YES];
	[self.modalViewController dismissModalViewControllerAnimated:YES];
	return newToken;
	}

	
#pragma mark - Authorization View Controller Delegate

- (void)authorizationViewController:(VimeoAuthorizationViewController *)authViewController didReceiveVerifier:(NSString *)theVerifier
	{
	[self fetchAccessTokenWithVerifier:theVerifier];
	}

@end

@implementation AccountViewController (Private)

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


@end
