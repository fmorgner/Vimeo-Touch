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
		content = [[NSMutableDictionary alloc] init];
		xmlParser = [[NSXMLParser alloc] initWithData:theData];
		[xmlParser setDelegate:self];
		[xmlParser setShouldProcessNamespaces:NO];
		[xmlParser setShouldReportNamespacePrefixes:NO];
		[xmlParser setShouldResolveExternalEntities:NO];
		[xmlParser parse];
		}
	return self;
	}

#pragma mark - NSXMLParser delegate methods

- (void)parserDidEndDocument:(NSXMLParser *)parser
	{
	
	}

- (void)parserDidStartDocument:(NSXMLParser *)parser
	{
	
	}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
	{
	activeElement = elementName;
	
	if([activeElement isEqualToString:@"rsp"])
		{
		[self setGenerationTime:[NSNumber numberWithFloat:[[attributeDict valueForKey:@"generated_in"] floatValue]]];
		[self setStatus:[attributeDict valueForKey:@"stat"]];
		}
	else if([activeElement isEqualToString:@"oauth"])
		{
		[self setType:activeElement];
		}
	else if([attributeDict count])
		{
		[content setObject:attributeDict forKey:activeElement];
		}
	else
		{
		[content setObject:[NSNull null] forKey:activeElement];
		}
	}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
	{
	if([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""])
		return;
	[content setValue:string forKey:activeElement];
	}

@end
