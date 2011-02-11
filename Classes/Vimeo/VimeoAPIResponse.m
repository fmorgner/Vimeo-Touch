//
//  VimeoAPIResponse.m
//  Vimeo Touch
//
//  Created by Felix Morgner on 07.02.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "VimeoAPIResponse.h"
#import "TouchXML.h"

@implementation VimeoAPIResponse

#pragma mark - Properties

@synthesize status;
@synthesize generationTime;
@synthesize type;
@synthesize content;

- (id)initWithData:(NSData*)theData
	{
	if((self = [super init]))
		{
		content = [NSMutableDictionary new];
		NSString* xmlString = [[NSString alloc] initWithBytes:[theData bytes] length:[theData length] encoding:NSASCIIStringEncoding];
		CXMLDocument* xmlDoc = [[CXMLDocument alloc] initWithXMLString:xmlString options:CXMLDocumentTidyXML error:nil];
		[xmlDoc release];
		}
	return self;
	}

@end
