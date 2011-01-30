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
@synthesize keychainQuery;
@synthesize keychainQueryResult;
@synthesize keychainItemID;
@synthesize keychainData;

- (id)init
	{
	if((self = [super init]))
		{
		self.token = [[OAuthToken alloc] init];
		
		self.keychainQuery = nil;		
		}
	return self;
	}

- (id)initWithKeychainItemID:(NSData*)itemID
	{
	if((self = [super init]))
		{
		self.token = [[OAuthToken alloc] init];
		self.keychainQuery = [[NSMutableDictionary alloc] init];
		self.keychainQueryResult = nil;
		
		[self setKeychainItemID:itemID];
		
		[self.keychainQuery setValue:(id)kSecClassGenericPassword forKey:(id)kSecClass];
		[self.keychainQuery setValue:itemID forKey:(id)kSecAttrGeneric];
		[self.keychainQuery setValue:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
		[self.keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnAttributes];
		
		OSErr keychainError = noErr;
		keychainError = SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef*)&keychainQueryResult);
		
		if(keychainError == noErr)
			{
			[self setTokenFromKeychainQueryResult];
			}
		else if(keychainError == errSecItemNotFound)
			{
			[self prepareKeychainItem];
			}
		}
	return self;
	}

+ (VimeoUser*)user
	{
	return [[[VimeoUser alloc] init] autorelease];
	}

+ (VimeoUser*)userWithKeychainItemID:(NSData*)itemID
	{
	return [[[VimeoUser alloc] initWithKeychainItemID:itemID] autorelease];
	}

- (void)dealloc
	{
	[self.keychainQuery release];
	[self.keychainQueryResult release];
	[self.token release];
	[super dealloc];
	}

- (void)setTokenFromKeychainQueryResult
	{
	
	}

- (void)prepareKeychainItem
	{
	if(!keychainData)
		self.keychainData = [[NSMutableDictionary alloc] init];
	
	[keychainData setObject:@"label" forKey:(id)kSecAttrLabel];
  [keychainData setObject:@"description" forKey:(id)kSecAttrDescription];
  [keychainData setObject:@"username" forKey:(id)kSecAttrAccount];
  [keychainData setObject:@"vimeo" forKey:(id)kSecAttrService];
  [keychainData setObject:@"comment" forKey:(id)kSecAttrComment];
  [keychainData setObject:@"token" forKey:(id)kSecValueData];
	}

@end
