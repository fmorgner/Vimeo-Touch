//
//  VimeoError.m
//  Vimeo Touch
//
//  Created by Felix Morgner on 11.02.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "VimeoError.h"


@implementation VimeoError

@synthesize code;
@synthesize explanation;
@synthesize name;

- (id) initWithCode:(NSUInteger)theCode explanation:(NSString*)theExplanation name:(NSString*)theName
	{
	if((self = [super init]))
		{
		(theCode == 305) ? (code = 303) : (code = theCode);
		explanation = [theExplanation copy];
		name = [theName copy];
		}
	return self;
	}

- (NSString*) description
	{
	return([NSString stringWithFormat:@"<%@ [%p]> code=%i, error name=%@, error explanation=%@",NSStringFromClass([self class]), self, [self code] , [self name], [self explanation]]);
	}

@end
