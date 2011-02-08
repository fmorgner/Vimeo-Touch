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

- (id)initWithData:(NSData*)theData
	{
	if((self = [super init]))
		{
		
		}
	return self;
	}

#pragma mark - NSXMLParser delegate methods



@end
