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
	NSXMLParser* xmlParser;
	NSMutableDictionary* content;
	NSString* type;

	@private
	NSString* activeElement;
	NSString* previousElement;
	}

- (id)initWithData:(NSData*)theData;

@property(nonatomic, retain) NSString* status;
@property(nonatomic, retain) NSNumber* generationTime;
@property(nonatomic, retain) NSString* type;
@property(nonatomic, readonly) NSMutableDictionary* content;

@end
