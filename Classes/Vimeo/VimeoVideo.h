//
//  VimeoVideo.h
//  Vimeo Touch
//
//  Created by Felix Morgner on 14.01.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TouchXML.h"

@interface VimeoVideo : NSObject
	{
	NSUInteger ID;
	NSString* title;
	BOOL HD; 
	}

- (id)initWithXMLElement:(CXMLElement*)aElement;

@property(nonatomic,assign) NSUInteger ID;
@property(nonatomic,copy) NSString* title;
@property(nonatomic,assign,getter = isHD) BOOL HD; 
@end
