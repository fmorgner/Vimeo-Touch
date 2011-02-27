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

- (void)encodeWithCoder:(NSCoder *)aCoder
	{
	[aCoder encodeInteger:ID forKey:@"ID"];
	[aCoder encodeBool:featured forKey:@"featured"];
	[aCoder encodeBool:sponsored forKey:@"sponsored"];
	
	[aCoder encodeObject:name forKey:@"name"];
	[aCoder encodeObject:desc forKey:@"desc"];
	[aCoder encodeObject:createdOn forKey:@"createdOn"];
	[aCoder encodeObject:modifiedOn forKey:@"modifiedOn"];
	
	[aCoder encodeInt:videoCount forKey:@"videoCount"];
	[aCoder encodeInt:subscriberCount forKey:@"subscriberCount"];
	
	[aCoder encodeObject:logoURL forKey:@"logoURL"];
	[aCoder encodeObject:badgeURL forKey:@"badgeURL"];
	[aCoder encodeObject:url forKey:@"url"];
	}

- (id)initWithCoder:(NSCoder *)aDecoder
	{
	if((self = [super init]))
		{
		[self setID:[aDecoder decodeIntegerForKey:@"ID"]];
		[self setFeatured:[aDecoder decodeBoolForKey:@"featured"]];
		[self setSponsored:[aDecoder decodeBoolForKey:@"sponsored"]];
		
		[self setName:[aDecoder decodeObjectForKey:@"name"]];
		[self setDesc:[aDecoder decodeObjectForKey:@"desc"]];
		[self setCreatedOn:[aDecoder decodeObjectForKey:@"createdOn"]];
		[self setModifiedOn:[aDecoder decodeObjectForKey:@"modifiedOn"]];
		
		[self setVideoCount:[aDecoder decodeIntegerForKey:@"videoCount"]];
		[self setSubscriberCount:[aDecoder decodeIntegerForKey:@"subscriberCount"]];
		
		[self setLogoURL:[aDecoder decodeObjectForKey:@"logoURL"]];
		[self setBadgeURL:[aDecoder decodeObjectForKey:@"badgeURL"]];
		[self setUrl:[aDecoder decodeObjectForKey:@"url"]];
		}
	return self;
	}
@end
