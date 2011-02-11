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

- (id) initWithCode:(NSUInteger)theCode explanation:(NSString*)theExplanation name:(NSString*)theName;

@property(nonatomic, readonly) NSUInteger code;
@property(nonatomic, readonly) NSString* explanation;
@property(nonatomic, readonly) NSString* name;

@end
