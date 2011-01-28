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
	OAuthRequest* request = [[OAuthRequest alloc] initWithURL:[NSURL URLWithString:@"http://vimeo.com/oauth/request_token"]
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
	
	NSMutableDictionary* parameters = [NSMutableDictionary dictionaryWithCapacity:[[request parameters] count]];
	
	for(OAuthParameter* parameter in [request parameters])
		{
		[parameters setValue:parameter.value forKey:parameter.key];
		}
	
	appDelegate.vimeoUser.token.key = [parameters objectForKey:@"oauth_token"];
	appDelegate.vimeoUser.token.secret = [parameters objectForKey:@"oauth_token_secret"];
	
	VimeoAuthorizationViewController* authorizationViewController = [[VimeoAuthorizationViewController alloc] init];
	
	[self.tabBarController presentModalViewController:authorizationViewController animated:YES];
	}

#pragma mark - Utility Methods 
@end
