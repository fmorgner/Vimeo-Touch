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

@interface VimeoUser : NSObject
	{
	OAuthToken* token;
	NSMutableDictionary* keychainQuery;
	NSMutableDictionary* keychainQueryResult;
	NSMutableDictionary* keychainItemData;
	NSData* keychainItemID;
	}

+ (VimeoUser*)user;
+ (VimeoUser*)userWithKeychainItemID:(NSData*)itemID;

- (id)initWithKeychainItemID:(NSData*)itemID;

- (void)fetchTokenFromKeychain;
- (void)prepareKeychainItem;
- (BOOL)writeKeychainItem;

@property(nonatomic, retain) OAuthToken* token;
@property(nonatomic, retain) NSMutableDictionary* keychainQuery;
@property(nonatomic, retain) NSMutableDictionary* keychainQueryResult;
@property(nonatomic, retain) NSMutableDictionary* keychainItemData;
@property(nonatomic, retain) NSData* keychainItemID;

@end
