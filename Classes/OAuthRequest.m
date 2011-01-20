//
//  OAuthRequest.m
//  Vimeo Touch
//
//  Created by Felix Morgner on 15.01.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "OAuthRequest.h"


@implementation OAuthRequest

@synthesize consumer, token, nonce, realm, signature, timestamp;

- (id)init
	{
	if ((self = [super init]))
		{
		
    }
    
	return self;
	}

- (id)initWithURL:(NSURL *)theURL consumer:(OAuthConsumer*)theConsumer token:(OAuthToken*)theToken realm:(NSString*)theRealm signerClass:(Class)theSignerClass
	{
	if ((self = [super init]))
		{
		[self setConsumer:theConsumer];
		[self setToken:theToken];
		[self setRealm:theRealm];
    }
	
	return self;
	}


- (void)dealloc
	{
    
	[super dealloc];
	}

@end
