//
//  Vimeo_TouchAppDelegate.h
//  Vimeo Touch
//
//  Created by Felix Morgner on 10.01.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Vimeo.h"
#import "OAuth.h"

@interface AppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate>
	{
	UIWindow *window;
	UITabBarController *tabBarController;
	
	NSData* keychainItemID;
	
	VimeoUser* vimeoUser;
	OAuthConsumer* consumer;
	}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@property (nonatomic, retain) IBOutlet NSData* keychainItemID;

@property (nonatomic, retain) VimeoUser* vimeoUser;
@property (nonatomic, retain) OAuthConsumer* consumer;

@end
