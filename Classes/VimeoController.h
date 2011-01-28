//
//  Vimeo.h
//  Vimeo Touch
//
//  Created by Felix Morgner on 26.01.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VimeoChannel.h"
#import "OAuth.h"

#define kVimeoChannelMethodGetAll @"vimeo.channels.getAll"

@interface VimeoController : NSObject
	{
	@private
	OAuthConsumer* consumer;
	OAuthRequest* request;
	}

@property(nonatomic, retain) OAuthConsumer* consumer;
@property(nonatomic, retain) OAuthRequest* request;

@end
