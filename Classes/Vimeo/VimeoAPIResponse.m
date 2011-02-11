//
//  VimeoAPIResponse.m
//  Vimeo Touch
//
//  Created by Felix Morgner on 07.02.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "VimeoAPIResponse.h"

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
		[self parseResponseDocument:xmlDoc];
		[xmlDoc release];
		}
	return self;
	}

- (BOOL)parseResponseDocument:(CXMLDocument*)theXMLDocument
	{
	if(!theXMLDocument)
		return NO;

	NSArray* attributes;
	CXMLElement* responseElement = [theXMLDocument rootElement];
	
	if([[responseElement attributes] count])
		{
		attributes = [responseElement attributes];
		for(CXMLElement* attribute in attributes)
			{
			if([[attribute name] isEqualToString:@"generated_in"])
				{
				[self setGenerationTime:[NSNumber numberWithFloat:[[attribute stringValue] floatValue]]];
				}
			else if([[attribute name] isEqualToString:@"stat"])
				{
				[self setStatus:[attribute stringValue]];
				}
			}
		}
		
	CXMLElement* contentElement = [[responseElement childrenOfKind:CXMLElementKind] objectAtIndex:0];
	if(!contentElement)
		return NO;
	
	[self setType:[contentElement name]];
	
	if([self.type isEqualToString:@"err"])
		{
		[[contentElement attributes] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
			[content setValue:[obj stringValue] forKey:[obj name]];
		}];
		return YES;
		}
	
	NSArray* contentElementChildren = [contentElement childrenOfKind:CXMLElementKind];
	
	if([self.type isEqualToString:@"oauth"])
		{
		for(CXMLElement* element in contentElementChildren)
			{
			if([[element attributes] count])
				{
				NSMutableDictionary* attributesDictionary = [NSMutableDictionary dictionary];
				[[element attributes] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
					[attributesDictionary setValue:[obj stringValue] forKey:[obj name]];
				}];
				[content setObject:attributesDictionary forKey:[element name]];
				}
			else
				{
				[content setValue:[element stringValue] forKey:[element name]];
				}
			}
		}
	
	return YES;
	}

@end
