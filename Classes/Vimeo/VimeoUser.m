//
//  VimeoUser.m
//  Vimeo Touch
//
//  Created by Felix Morgner on 27.01.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "VimeoUser.h"

@implementation VimeoUser

@synthesize token;

#pragma mark - Object Lifecycle

- (id)init
	{
	if((self = [super init]))
		{
		token = [[OAuthToken alloc] init];
		}
	return self;
	}

- (id)initWithKeychainItemID:(NSData*)itemID
	{
	if((self = [super init]))
		{
		NSError* error = nil;
		[self setToken:[VimeoKeychainAccess fetchTokenForItemID:itemID error:&error]];
		}
	return self;
	}

- (void)dealloc
	{
	[token release];
	[super dealloc];
	}

#pragma mark - Convenience Allocators

+ (VimeoUser*)user
	{
	return [[[VimeoUser alloc] init] autorelease];
	}

+ (VimeoUser*)userWithKeychainItemID:(NSData*)itemID
	{
	return [[[VimeoUser alloc] initWithKeychainItemID:itemID] autorelease];
	}

- (void)writeToKeychainWithItemID:(NSData*)itemID
	{
	NSError* error = nil;
	[VimeoKeychainAccess writeToken:token itemID:itemID error:&error];
	NSLog(@"%@", error);
	}

@end
