//
//  Vimeo_TouchAppDelegate.m
//  Vimeo Touch
//
//  Created by Felix Morgner on 10.01.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "AppDelegate.h"
#import "APIKey.h"
#import "ChannelsList.h"
#import "AccountViewController.h"
#import "OAuth.h"
#import "VimeoController.h"

@implementation AppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize vimeoUser;
@synthesize consumer;
@synthesize keychainItemID;
@synthesize vimeoController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
	{
	NSData* itemID = [NSData dataWithBytes:kKeychainItemIdentifier length:strlen((const char*)kKeychainItemIdentifier)];
	keychainItemID = [itemID copy];
	
	[self setVimeoUser:[VimeoUser userWithKeychainItemID:keychainItemID]];
	[self setConsumer:[OAuthConsumer consumerWithKey:apiKey secret:apiSecret authorized:NO]];
	
	vimeoController = [[VimeoController alloc] initWithConsumer:consumer user:vimeoUser];
	
	NSMutableArray* viewControllers = [NSMutableArray arrayWithCapacity:1];
	UINavigationController* localNavigationController;
	
	ChannelsList* channelsListController = [[ChannelsList alloc] init];	
	localNavigationController = [[UINavigationController alloc] initWithRootViewController:channelsListController];
	[channelsListController release];
	[viewControllers addObject:localNavigationController];
	[localNavigationController release];

	AccountViewController* accountViewController = [[AccountViewController alloc] initWithNibName:@"AccountViewController" bundle:[NSBundle mainBundle]];
	[viewControllers addObject:accountViewController];
	[accountViewController release];

	tabBarController = [[UITabBarController alloc] init];
	[tabBarController setViewControllers:viewControllers];
	
	[window addSubview:tabBarController.view];
	[window makeKeyAndVisible];
    return YES;
	}

- (void)applicationWillTerminate:(UIApplication *)application
	{
	}

- (void)dealloc
	{
	[window release];
	[tabBarController release];
	[vimeoUser release];
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
