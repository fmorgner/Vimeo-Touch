//
//  Vimeo.h
//  Vimeo Touch
//
//  Created by Felix Morgner on 26.01.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAuth.h"

#import "VimeoUser.h"
#import "VimeoControllerDelegate.h"
#import "VimeoConstants.h"
#import "VimeoAPIResponse.h"

@interface VimeoController : NSObject
	{
	OAuthConsumer* consumer;
	VimeoUser* user;
	OAuthRequestFetcher* requestFetcher;

	id<VimeoControllerDelegate> delegate;
	}

- (id)initWithConsumer:(OAuthConsumer*)aConsumer user:(VimeoUser*)aUser delegate:(id<VimeoControllerDelegate>)aDelegate;
- (void)verifyUserToken;

@property(nonatomic, readonly) OAuthConsumer* consumer;
@property(nonatomic, readonly) VimeoUser* user;
@end
