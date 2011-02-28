//
//  VimeoVideo.m
//  Vimeo Touch
//
//  Created by Felix Morgner on 14.01.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "VimeoVideo.h"

@implementation VimeoVideo

@synthesize ID;

- (id)initWithXMLElement:(CXMLElement*)aElement
	{
	if((self = [super init]))
		{
		ID = [[[aElement attributeForName:@"ID"] stringValue] intValue];
		HD = [[[aElement attributeForName:@"is_hd"] stringValue] boolValue];
		
		[self setTitle:[[aElement attributeForName:@"title"] stringValue]];
		}
	return self;
	}


@end
