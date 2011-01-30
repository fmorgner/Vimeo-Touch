//
//  OAuthConsumer.m
//  Vimeo Touch
//
//  Created by Felix Morgner on 14.01.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "OAuthConsumer.h"


@implementation OAuthConsumer

@synthesize key, secret;

- (id)init
	{
	if((self = [super init]))
		{
		self.key = nil;
		self.secret = nil;
		}
	
	return self;
	}

- (id)initWithKey:(NSString*)theKey secret:(NSString*)theSecret
	{
	if((self = [super init]))
		{
		self.key = theKey;
		self.secret = theSecret;
		}
	
	return self;	
	}

+ (OAuthConsumer*)consumerWithKey:(NSString*)theKey secret:(NSString*)theSecret
	{
	return [[[OAuthConsumer alloc] initWithKey:theKey secret:theSecret] autorelease];
	}

- (void)dealloc
	{
	[key release];
	[secret release];
	[super dealloc];
	}

@end
