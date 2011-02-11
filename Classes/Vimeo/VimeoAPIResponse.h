//
//  VimeoAPIResponse.h
//  Vimeo Touch
//
//  Created by Felix Morgner on 07.02.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TouchXML.h"
#import "VimeoError.h"

@interface VimeoAPIResponse : NSObject
	{
	NSString* status;
	NSNumber* generationTime;
	NSMutableDictionary* content;
	NSString* type;
	VimeoError* error;
	}

- (id)initWithData:(NSData*)theData;
- (BOOL)parseResponseDocument:(CXMLDocument*)theXMLDocument;

@property(nonatomic, retain) NSString* status;
@property(nonatomic, assign) NSNumber* generationTime;
@property(nonatomic, retain) NSString* type;
@property(nonatomic, readonly) NSMutableDictionary* content;

@end
