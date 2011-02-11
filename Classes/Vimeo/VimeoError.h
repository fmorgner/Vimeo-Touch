//
//  VimeoError.h
//  Vimeo Touch
//
//  Created by Felix Morgner on 11.02.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface VimeoError : NSObject
	{
	NSUInteger code;
	NSString* explanation;
	NSString* name;
	}

@property(nonatomic, assign) NSUInteger code;
@property(nonatomic, retain) NSString* explanation;
@property(nonatomic, retain) NSString* name;


@end
