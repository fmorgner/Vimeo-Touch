//
//  VimeoUser.h
//  Vimeo Touch
//
//  Created by Felix Morgner on 27.01.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAuth.h"

@interface VimeoUser : NSObject
	{
	OAuthToken* token;
	}

+ (VimeoUser*)user;

@property(nonatomic, retain) OAuthToken* token;

@end
