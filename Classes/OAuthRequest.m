//
//  OAuthRequest.m
//  Vimeo Touch
//
//  Created by Felix Morgner on 15.01.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "OAuthRequest.h"
#import "OAuthSignerProtocol.h"


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

	if([theSignerClass conformsToProtocol:@protocol(OAuthSigner)])
		{
		NSLog(@"Info: Using signer class '%@' to generate signature.", theSignerClass);
		NSLog(@"Info: The signer class '%@' provides a '%@' signature.", theSignerClass, [theSignerClass signatureType]);
		}
	else
		{
		NSLog(@"Warning: The supplied signer class '%@' does not conform to the 'OAuthSigner' protocol. Falling back to HMAC-SHA1!", theSignerClass);
		}

	return self;
	}


- (void)dealloc
	{
	[consumer release];
	[token release];
	[nonce release];
	[realm dealloc];
	[signature dealloc];
	[timestamp dealloc];
	[super dealloc];
	}

@end
