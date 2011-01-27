//
//  Vimeo_TouchAppDelegate.m
//  Vimeo Touch
//
//  Created by Felix Morgner on 10.01.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "AppDelegate.h"

#import "ChannelsList.h"
#import "AccountViewController.h"

#import "OAuth.h"
#import "VimeoController.h"

@implementation AppDelegate


@synthesize window;

@synthesize tabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
	{
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
