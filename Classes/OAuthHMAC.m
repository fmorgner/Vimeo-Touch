//
//  OAuthHMAC.m
//  Vimeo Touch
//
//  Created by Felix Morgner on 14.01.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "OAuthHMAC.h"
#import "NSData+Base64.h"


@implementation OAuthHMAC

+ (NSString*)signClearText:(NSString*)theClearText withSecret:(NSString*)theSecret
	{
	NSData* secretData = [theSecret dataUsingEncoding:NSUTF8StringEncoding];
	NSData* clearTextData = [theClearText dataUsingEncoding:NSUTF8StringEncoding];
	
	unsigned char HMACResult[20];
	
	CCHmac(kCCHmacAlgSHA1, [secretData bytes], [secretData length], [clearTextData bytes], [clearTextData length], HMACResult);
	
	NSData* signedData = [NSData dataWithBytes:HMACResult length:20];
	
	return [signedData base64EncodedString];
	}

@end
