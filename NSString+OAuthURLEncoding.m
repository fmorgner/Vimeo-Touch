//
//  NSString+OAuthURLEncoding.m
//  Vimeo Touch
//
//  Created by Felix Morgner on 14.01.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "NSString+OAuthURLEncoding.h"


@implementation NSString (OAuthURLEncoding)

- (NSString*)stringUsingOAuthURLEncoding
	{
	NSString *encodedString = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, NULL, CFSTR("!*'();:@&=+$,/?%#[]"), kCFStringEncodingUTF8);
	return [encodedString autorelease];
	}

@end
