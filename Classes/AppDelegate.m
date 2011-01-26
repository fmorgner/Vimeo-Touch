//
//  Vimeo_TouchAppDelegate.m
//  Vimeo Touch
//
//  Created by Felix Morgner on 10.01.11.
//  Copyright 2011 Bühler AG. All rights reserved.
//

#import "AppDelegate.h"
#import "ChannelsList.h"

#import "OAuthRequest.h"

@implementation AppDelegate


@synthesize window;

@synthesize tabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
	{
	OAuthConsumer* consumer = [OAuthConsumer consumerWithKey:@"7ae96ae33601e4482b6bf6e76e442781" secret:@"b79d3ec05a464bd7"];
	OAuthRequest* request = [[OAuthRequest alloc] initWithURL:[NSURL URLWithString:@"http://vimeo.com/oauth/request_token"] consumer:consumer token:nil realm:nil signerClass:nil];
	[request addParameter:[OAuthParameter parameterWithKey:@"oauth_callback" andValue:@"oob"]];
	[request prepare];
	
	NSURLResponse* response;
	NSError* error;
	NSData* fetchedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	char* data = malloc([fetchedData length]);
	memcpy(data, [fetchedData bytes], [fetchedData length]);
	
	NSMutableArray* viewControllers = [NSMutableArray arrayWithCapacity:1];
	
	UINavigationController* localNavigationController;
	
	ChannelsList* channelsListController = [[ChannelsList alloc] init];	
	localNavigationController = [[UINavigationController alloc] initWithRootViewController:channelsListController];
	[channelsListController release];
	[viewControllers addObject:localNavigationController];
	[localNavigationController release];
	tabBarController = [[UITabBarController alloc] init];
	[tabBarController setViewControllers:viewControllers];
	
	[window addSubview:tabBarController.view];
	[window makeKeyAndVisible];
    return YES;
	}

- (void)applicationWillTerminate:(UIApplication *)application {

	// Save data if appropriate.
}

- (void)dealloc {

	[window release];
	[tabBarController release];
    [super dealloc];
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
}
*/

@end
