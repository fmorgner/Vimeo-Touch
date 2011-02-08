//
//  VimeoUser.h
//  Vimeo Touch
//
//  Created by Felix Morgner on 27.01.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>
#import "OAuth.h"
#import "VimeoKeychainAccess.h"

@interface VimeoUser : NSObject
	{
	OAuthToken* token;
	NSString* displayName;
	NSString* username;
	NSUInteger userID;
	}

+ (VimeoUser*)user;
+ (VimeoUser*)userWithKeychainItemID:(NSData*)itemID;

- (id)initWithKeychainItemID:(NSData*)itemID;
- (void)writeToKeychainWithItemID:(NSData*)itemID;

@property(nonatomic, retain) OAuthToken* token;
@property(nonatomic, retain) NSString* displayName;
@property(nonatomic, retain) NSString* username;
@property(nonatomic, assign) NSUInteger userID;

@end
