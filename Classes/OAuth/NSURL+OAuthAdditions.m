//
//  NSURL+OAuthAdditions.m
//  Vimeo Touch
//
//  Created by Felix Morgner on 22.01.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "NSURL+OAuthAdditions.h"


@implementation NSURL (OAuthAdditions)

- (NSString*)URLStringWithoutQuery
	{
	return [[[self absoluteString] componentsSeparatedByString:@"?"] objectAtIndex:0];
	}

@end
