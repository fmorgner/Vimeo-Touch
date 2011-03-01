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
#import "VimeoController.h"

static const UInt8 kKeychainItemIdentifier[] = "ch.felixmorgner.Vimeo_Touch\0";

@interface AppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate>
	{
	UIWindow *window;
	UITabBarController *tabBarController;
	
	NSData* keychainItemID;
	
	VimeoUser* vimeoUser;
	OAuthConsumer* consumer;
	VimeoController* vimeoController;
	}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@property (nonatomic, retain) IBOutlet NSData* keychainItemID;

@property (nonatomic, retain) VimeoUser* vimeoUser;
@property (nonatomic, retain) OAuthConsumer* consumer;
@property (nonatomic, retain) VimeoController* vimeoController;

@end
