//
//  VimeoAPIResponse.h
//  Vimeo Touch
//
//  Created by Felix Morgner on 07.02.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface VimeoAPIResponse : NSObject <NSXMLParserDelegate>
	{
	NSString* status;
	NSNumber* generationTime;
	}

@property(nonatomic, retain) NSString* status;
@property(nonatomic, retain) NSNumber* generationTime;


@end
