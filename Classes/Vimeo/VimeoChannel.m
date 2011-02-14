//
//  VimeoChannel.m
//  Vimeo Touch
//
//  Created by Felix Morgner on 26.01.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "VimeoChannel.h"


@implementation VimeoChannel

@synthesize ID;
@synthesize featured;
@synthesize sponsored;

@synthesize name;
@synthesize desc;
@synthesize createdOn;
@synthesize modifiedOn;

@synthesize videoCount;
@synthesize subscriberCount;

@synthesize logoURL;
@synthesize badgeURL;
@synthesize url;

- (id)initWithXMLElement:(CXMLElement*)aElement
	{
	if((self = [super init]))
		{
		NSError* error = nil;
		self.ID = [[[aElement nodeForXPath:@"attribute::id" error:nil] stringValue] intValue];
		self.featured = [[[aElement nodeForXPath:@"attribute::is_featured" error:nil] stringValue] boolValue];
		self.sponsored = [[[aElement nodeForXPath:@"attribute::is_sponsored" error:nil] stringValue] boolValue];
		
		[self setName:[[aElement nodeForXPath:@"name" error:nil] stringValue]];
		[self setDesc:[[aElement nodeForXPath:@"description" error:nil] stringValue]];
		[error release];
		}
	return self;
	}


@end
