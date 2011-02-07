//
//  VimeoKeychainAccess.m
//  Vimeo Touch
//
//  Created by Felix Morgner on 07.02.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "VimeoKeychainAccess.h"

@implementation VimeoKeychainAccess

+ (OAuthToken*)fetchTokenForItemID:(NSData*)theItemID error:(NSError**)error
	{
	OAuthToken* token = nil;
	NSDictionary* keychainSearchQueryResult = nil;
	NSDictionary* keychainSearchQuery = [NSDictionary dictionaryWithObjectsAndKeys:(id)kSecClassGenericPassword, (id)kSecClass, theItemID, (id)kSecAttrGeneric, (id)kSecMatchLimitOne, (id)kSecMatchLimit, (id)kCFBooleanTrue, (id)kSecReturnAttributes, nil];

	OSStatus keychainSearchQueryStatus = noErr;
	keychainSearchQueryStatus = SecItemCopyMatching((CFDictionaryRef)keychainSearchQuery, (CFTypeRef*)&keychainSearchQueryResult);

	if(keychainSearchQueryStatus != noErr)
		{
		NSDictionary* userInfo = [NSDictionary dictionaryWithObject:@"Keychain item not found" forKey:NSLocalizedDescriptionKey];
		*error = [NSError errorWithDomain:kVimeoKeychainAccessErrorDomain code:-1 userInfo:userInfo];
		return nil;
		}

	NSMutableDictionary* keychainFetchQuery = [NSMutableDictionary dictionaryWithDictionary:keychainSearchQueryResult];
	[keychainFetchQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
	[keychainFetchQuery setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];

	OSStatus keychainFetchQueryStatus = noErr;
	NSData* keychainFetchQueryResult = nil;
	
	keychainFetchQueryStatus = SecItemCopyMatching((CFDictionaryRef)keychainFetchQuery, (CFTypeRef *)&keychainFetchQueryResult);

	if(keychainFetchQueryStatus != noErr)
		{
		NSDictionary* userInfo = [NSDictionary dictionaryWithObject:@"Keychain item could not be fetched" forKey:NSLocalizedDescriptionKey];
		*error = [NSError errorWithDomain:kVimeoKeychainAccessErrorDomain code:-2 userInfo:userInfo];
		return nil;
		}
	
	NSString* tokenString = [[[NSString alloc] initWithData:keychainFetchQueryResult encoding:NSUTF8StringEncoding] autorelease];
	NSArray* tokenStringComponents = [tokenString componentsSeparatedByString:@"&"];
	token = [OAuthToken tokenWithKey:[tokenStringComponents objectAtIndex:0] secret:[tokenStringComponents objectAtIndex:1] authorized:YES];
	
	return token;
	}

+ (BOOL)writeToken:(OAuthToken*)token itemID:(NSData*)theItemID error:(NSError**)error
	{
	NSString* tokenString = [NSString stringWithFormat:@"%@&%@", token.key, token.secret];
	NSData* tokenStringData = [NSData dataWithBytes:[tokenString cStringUsingEncoding:NSUTF8StringEncoding] length:[tokenString length]];

	NSDictionary* keychainSearchQueryResult = nil;
	NSDictionary* keychainSearchQuery = [NSDictionary dictionaryWithObjectsAndKeys:(id)kSecClassGenericPassword, (id)kSecClass, theItemID, (id)kSecAttrGeneric, (id)kSecMatchLimitOne, (id)kSecMatchLimit, (id)kCFBooleanTrue, (id)kSecReturnAttributes, nil];

	OSStatus keychainSearchQueryStatus = noErr;
	keychainSearchQueryStatus = SecItemCopyMatching((CFDictionaryRef)keychainSearchQuery, (CFTypeRef*)&keychainSearchQueryResult);
	
	if(keychainSearchQueryStatus == noErr)
		{
		NSMutableDictionary* keychainUpdateQuery = [NSMutableDictionary dictionaryWithDictionary:keychainSearchQueryResult];
		[keychainUpdateQuery setValue:(id)kSecClassGenericPassword forKey:(id)kSecClass];

		NSMutableDictionary* keychainItemData = [[NSMutableDictionary alloc] init];

		[keychainItemData setObject:@"Vimeo user token" forKey:(id)kSecAttrLabel];
		[keychainItemData setObject:@"This is the authorized token for the vimeo user" forKey:(id)kSecAttrDescription];
		[keychainItemData setObject:@"username" forKey:(id)kSecAttrAccount];
		[keychainItemData setObject:@"vimeo" forKey:(id)kSecAttrService];
		[keychainItemData setObject:@"" forKey:(id)kSecAttrComment];
		[keychainItemData setObject:tokenStringData forKey:(id)kSecValueData];
		[keychainItemData setValue:theItemID forKey:(id)kSecAttrGeneric];
		
		OSStatus keychainItemUpdateStatus = noErr;
		keychainItemUpdateStatus = SecItemUpdate((CFDictionaryRef)keychainUpdateQuery, (CFDictionaryRef)keychainItemData);
		
		if(keychainItemUpdateStatus != noErr)
			{
			NSDictionary* userInfo = [NSDictionary dictionaryWithObject:@"Keychain item could not be updated" forKey:NSLocalizedDescriptionKey];
			*error = [NSError errorWithDomain:kVimeoKeychainAccessErrorDomain code:-3 userInfo:userInfo];
			return NO;
			}
		
		}
	else
		{
		NSMutableDictionary* keychainItemData = [[NSMutableDictionary alloc] init];

		[keychainItemData setObject:@"Vimeo user token" forKey:(id)kSecAttrLabel];
		[keychainItemData setObject:@"This is the authorized token for the vimeo user" forKey:(id)kSecAttrDescription];
		[keychainItemData setObject:@"username" forKey:(id)kSecAttrAccount];
		[keychainItemData setObject:@"vimeo" forKey:(id)kSecAttrService];
		[keychainItemData setObject:@"" forKey:(id)kSecAttrComment];
		[keychainItemData setObject:tokenStringData forKey:(id)kSecValueData];
		[keychainItemData setValue:theItemID forKey:(id)kSecAttrGeneric];
		[keychainItemData setValue:(id)kSecClassGenericPassword forKey:(id)kSecClass];
		
		OSStatus keychainWriteQueryStatus = noErr;
		keychainWriteQueryStatus = SecItemAdd((CFDictionaryRef)keychainItemData, NULL);

		if(keychainWriteQueryStatus != noErr)
			{
			NSDictionary* userInfo = [NSDictionary dictionaryWithObject:@"Keychain item could not be written" forKey:NSLocalizedDescriptionKey];
			*error = [NSError errorWithDomain:kVimeoKeychainAccessErrorDomain code:-4 userInfo:userInfo];
			return NO;
			}

		}
	
	return YES;
	}

@end