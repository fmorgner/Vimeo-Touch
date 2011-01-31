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

#pragma mark - Object Lifecycle

- (id)init
	{
	if((self = [super init]))
		{
		token = [[OAuthToken alloc] init];
		
		keychainQuery = nil;		
		}
	return self;
	}

- (id)initWithKeychainItemID:(NSData*)itemID
	{
	if((self = [super init]))
		{
		token = [[OAuthToken alloc] init];
		keychainQuery = [[NSMutableDictionary alloc] init];
		keychainQueryResult = nil;
		
		[self setKeychainItemID:itemID];
		
		[keychainQuery setValue:(id)kSecClassGenericPassword forKey:(id)kSecClass];
		[keychainQuery setValue:keychainItemID forKey:(id)kSecAttrGeneric];
		[keychainQuery setValue:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
		[keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnAttributes];
		
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

- (void)dealloc
	{
	[keychainQuery release];
	[keychainQueryResult release];
	[keychainData release];
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

#pragma mark - Utility methods

- (void)setTokenFromKeychainQueryResult
	{
	NSMutableDictionary* resultDictionary = [NSMutableDictionary dictionaryWithDictionary:keychainQueryResult];
	[resultDictionary setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
	[resultDictionary setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
	
	OSStatus keychainError = noErr;
	NSData* tokenData = NULL;
	
	keychainError = SecItemCopyMatching((CFDictionaryRef)resultDictionary, (CFTypeRef *)&tokenData);
	
	NSString* tokenString = [[[NSString alloc] initWithData:tokenData encoding:NSUTF8StringEncoding] autorelease];
	NSArray* tokenStringComponents = [tokenString componentsSeparatedByString:@"&"];
	token.key = [tokenStringComponents objectAtIndex:0];
	token.secret = [tokenStringComponents objectAtIndex:1];
	token.authorized = YES;
	}

- (void)prepareKeychainItem
	{
	if(!keychainData)
		keychainData = [[NSMutableDictionary alloc] init];
	
	[keychainData setObject:@"Vimeo user token" forKey:(id)kSecAttrLabel];
  [keychainData setObject:@"This is the authorized token for the vimeo user" forKey:(id)kSecAttrDescription];
  [keychainData setObject:@"username" forKey:(id)kSecAttrAccount];
  [keychainData setObject:@"vimeo" forKey:(id)kSecAttrService];
  [keychainData setObject:@"" forKey:(id)kSecAttrComment];
  [keychainData setObject:@"" forKey:(id)kSecValueData];
	[keychainData setValue:keychainItemID forKey:(id)kSecAttrGeneric];
	[keychainData setValue:(id)kSecClassGenericPassword forKey:(id)kSecClass];
	}

- (BOOL)writeKeychainItem
	{
	if([[keychainData valueForKey:(id)kSecValueData] isEqualToString:@""])
		{
		NSString* tokenString = [NSString stringWithFormat:@"%@&%@", token.key, token.secret];
		NSData* tokenData = [tokenString dataUsingEncoding:NSUTF8StringEncoding];
  	[keychainData setObject:tokenData forKey:(id)kSecValueData];
		}
	
	NSAssert(SecItemAdd((CFDictionaryRef)keychainData, NULL) == noErr, @"Couldn't add the Keychain Item." );
	
	return YES;
	}

@end
