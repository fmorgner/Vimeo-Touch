//
//  OAuthHMAC.h
//  Vimeo Touch
//
//  Created by Felix Morgner on 14.01.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonHMAC.h>

@interface OAuthHMAC : NSObject
	{

	}

+ (NSString*)signClearText:(NSString*)theClearText withSecret:(NSString*)theSecret;

@end
