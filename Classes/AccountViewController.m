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
@synthesize userInformation;

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

- (void)viewDidAppear:(BOOL)animated
	{
	VimeoController* vController = [[VimeoController alloc] initWithConsumer:appDelegate.consumer user:appDelegate.vimeoUser delegate:self];
	[vController verifyUserToken];
	[super viewDidAppear:animated];
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
	[appDelegate.vimeoUser setToken:newToken];
	
	static const UInt8 kKeychainItemIdentifier[] = "ch.felixmorgner.Vimeo_Touch\0";
	NSData* itemID = [NSData dataWithBytes:kKeychainItemIdentifier length:strlen((const char*)kKeychainItemIdentifier)];
	[appDelegate.vimeoUser writeToKeychainWithItemID:itemID];

	[self.modalViewController dismissModalViewControllerAnimated:YES];
	return newToken;
	}

	
#pragma mark - Authorization View Controller Delegate

- (void)authorizationViewController:(VimeoAuthorizationViewController *)authViewController didReceiveVerifier:(NSString *)theVerifier
	{
	[self fetchAccessTokenWithVerifier:theVerifier];
	}

#pragma mark - Vimeo Controller Delegate

- (void)vimeoController:(VimeoController *)aController didFetchResponse:(VimeoAPIResponse *)theResponse
	{
	if([theResponse.type isEqualToString:kVimeoOAuthResponseType] && !theResponse.error)
		{
		[appDelegate.vimeoUser setUsername:[theResponse.content valueForKeyPath:@"user.username"]];
		[appDelegate.vimeoUser setDisplayName:[theResponse.content valueForKeyPath:@"user.display_name"]];
		[appDelegate.vimeoUser setUserID:[[theResponse.content valueForKeyPath:@"user.id"] intValue]];
		[appDelegate.vimeoUser writeToKeychainWithItemID:appDelegate.keychainItemID];
		}
	}

- (void)vimeoController:(VimeoController *)aController didFailFetchingWithError:(NSError *)theError
	{
	
	}

#pragma mark - Table View Data Source
	
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
	{
	return 2;
	}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
	{
	return 2;
	}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
	{
	static NSString *cellIdentifier = @"cell";

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil)
		{
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:cellIdentifier] autorelease];
		}

	return cell;
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
