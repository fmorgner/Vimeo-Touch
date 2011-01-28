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

- (id)init
	{
	if((self = [super init]))
		{
		self.token = [[OAuthToken alloc] init];
		}
	return self;
	}

+ (VimeoUser*)user
	{
	return [[[VimeoUser alloc] init] autorelease];
	}

@end
