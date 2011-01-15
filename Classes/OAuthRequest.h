//
//  OAuthRequest.h
//  Vimeo Touch
//
//  Created by Felix Morgner on 15.01.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAuthConsumer.h"
#import "OAuthToken.h"

@interface OAuthRequest : NSMutableURLRequest
	{
	OAuthConsumer* consumer;
	OAuthToken*	token;
	NSString* realm;
	NSString* signature;
	NSString* nonce;
	NSString* timestamp;
	}

- (id)initWithURL:(NSURL *)theURL consumer:(OAuthConsumer*)theConsumer token:(OAuthToken*)theToken realm:(NSString*)realm;

@end
