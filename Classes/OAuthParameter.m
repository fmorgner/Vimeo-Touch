//
//  OAuthParameter.m
//  Vimeo Touch
//
//  Created by Felix Morgner on 14.01.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "OAuthParameter.h"

@implementation OAuthParameter

@synthesize key, value;

- (id)initWithKey:(NSString*)theKey andValue:(NSString*)theValue
	{
	if((self = [super init]))
		{
		[self setValue:theValue];
		[self setKey:theKey];
		}
	
	return self;
	}
	
+ (id)parameterWithKey:(NSString*)theKey andValue:(NSString*)theValue
	{
	return [[[OAuthParameter alloc] initWithKey:theKey andValue:theValue] autorelease];
	}

- (void)dealloc
	{
	[key release];
	[value release];
	[super dealloc];
	}
	
- (NSString*)OAuthURLEncodedKey
	{
	return [key stringUsingOAuthURLEncoding];
	}
	
- (NSString*)OAuthURLEncodedValue
	{
	return [value stringUsingOAuthURLEncoding];
	}

- (NSString*)OAuthURLEncodedKeyValuePair
	{
	NSString* keyValuePair = [NSString stringWithFormat:@"%@=%@", key, value];
	return [keyValuePair stringUsingOAuthURLEncoding];
	}

@end
