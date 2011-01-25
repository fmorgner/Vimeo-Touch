//
//  OAuthRequest.m
//  Vimeo Touch
//
//  Created by Felix Morgner on 15.01.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "OAuthRequest.h"
#import "OAuthToken.h"
#import "OAuthSignerHMAC.h"
#import "OAuthSignerProtocol.h"
#import "OAuthParameter.h"
#import "NSString+OAuthURLEncoding.h"
#import "NSMutableURLRequest+OAuthParameters.h"
#import "NSURL+BaseString.h"

@implementation OAuthRequest

#pragma mark -
#pragma mark Properties:

@synthesize consumer;
@synthesize token;
@synthesize nonce;
@synthesize realm;
@synthesize signature;
@synthesize timestamp;
@synthesize signerClass;
@synthesize extraParameters;

#pragma mark -
#pragma mark Allocation/Deallocation:

- (id)init
	{
	if ((self = [super init]))
		{
		
    }
    
	return self;
	}

- (id)initWithURL:(NSURL *)theURL consumer:(OAuthConsumer*)theConsumer token:(OAuthToken*)theToken realm:(NSString*)theRealm signerClass:(Class)theSignerClass
	{
	if ((self = [super initWithURL:theURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0]))
		{
		[self setConsumer:theConsumer];

		(theToken == nil) ? [self setToken:[OAuthToken token]] : [self setToken:theToken];
		(theRealm == nil) ? [self setRealm:[NSString stringWithString:@""]] : [self setRealm:theRealm];

		if([theSignerClass conformsToProtocol:@protocol(OAuthSigner)])
			{
			NSLog(@"Info: Using signer class '%@' to generate signature.", theSignerClass);
			NSLog(@"Info: The signer class '%@' provides a '%@' signature.", theSignerClass, [theSignerClass signatureType]);
			[self setSignerClass:theSignerClass];
			}
		else
			{
			NSLog(@"Warning: The supplied signer class '%@' does not conform to the 'OAuthSigner' protocol. Falling back to HMAC-SHA1!", theSignerClass);
			[self setSignerClass:[OAuthSignerHMAC class]];
			}

		[self setNonce:[self generateNonce]];
		[self setTimestamp:[self generateTimestamp]];
    }

	return self;
	}

- (void)dealloc
	{
	[consumer release];
	[token release];
	[nonce release];
	[realm release];
	[signature release];
	[timestamp release];
	[extraParameters release];
	[super dealloc];
	}

#pragma mark -
#pragma mark Utility methods:

- (NSString*)generateNonce
	{
	CFUUIDRef uuid = CFUUIDCreate(NULL);
	CFStringRef uuidString = CFUUIDCreateString(NULL, uuid);
	NSString* nonceString = (NSString*)uuidString;
	CFMakeCollectable(uuidString);
	CFRelease(uuid);
	
	return nonceString;
	}
	
- (NSString*)generateTimestamp
	{
	return [NSString stringWithFormat:@"%d", time(NULL)];
	}

- (NSString*)signatureBaseString
	{
	NSMutableArray* parameterPairs = [NSMutableArray array];
	
	[parameterPairs addObject:[[OAuthParameter parameterWithKey:@"oauth_consumer_key" andValue:consumer.key] OAuthURLEncodedKeyValuePair]];
	[parameterPairs addObject:[[OAuthParameter parameterWithKey:@"oauth_signature_method" andValue:[signerClass signatureType]] OAuthURLEncodedKeyValuePair]];
	[parameterPairs addObject:[[OAuthParameter parameterWithKey:@"oauth_timestamp" andValue:timestamp] OAuthURLEncodedKeyValuePair]];
	[parameterPairs addObject:[[OAuthParameter parameterWithKey:@"oauth_nonce" andValue:nonce] OAuthURLEncodedKeyValuePair]];
	[parameterPairs addObject:[[OAuthParameter parameterWithKey:@"oauth_version" andValue:@"1.0"] OAuthURLEncodedKeyValuePair]];
	
	if(![token.key isEqualToString:@""])
		{
		[parameterPairs addObject:[[OAuthParameter parameterWithKey:@"oauth_token" andValue:token.key] OAuthURLEncodedKeyValuePair]];
		}
	
	for(OAuthParameter* parameter in [self parameters])
		{
		[parameterPairs addObject:[parameter OAuthURLEncodedKeyValuePair]];
		}
	
	[parameterPairs sortUsingSelector:@selector(compare:)];
	NSString* parameterString = [parameterPairs componentsJoinedByString:@"&"];
	
	return [NSString stringWithFormat:@"%@&%@&%@", [self HTTPMethod], [[[self URL] URLStringWithoutQuery] stringUsingOAuthURLEncoding], [parameterString stringUsingOAuthURLEncoding]];
	}

#pragma mark -
#pragma mark Instance Methods

- (void)addParameter:(OAuthParameter*)aParameter
	{
	if(extraParameters == nil)
		{
		extraParameters = [NSMutableDictionary dictionary];
		}
	
	if(aParameter)
		{
		[extraParameters setObject:[aParameter value] forKey:[aParameter key]];
		}
	}

- (void)prepare
	{
	[self setSignature:[signerClass signClearText:[self signatureBaseString] withSecret:[NSString stringWithFormat:@"%@&%@", consumer.secret, token.secret]]];
	NSString* tokenString;
	([token.key isEqualToString:@""]) ? (tokenString = @"") : (tokenString = [NSString stringWithFormat:@"oauth_token=\"%@\", ", [token.key stringUsingOAuthURLEncoding]]);
	
	NSMutableString* extraParametersString = [NSMutableString string];
	
	[extraParameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
		[extraParametersString appendFormat:@", %@=\"%@\"", key, [obj stringUsingOAuthURLEncoding]];
	}];

	NSString *oauthHeader = [NSString stringWithFormat:@"OAuth realm=\"%@\", oauth_consumer_key=\"%@\", %@oauth_signature_method=\"%@\", oauth_signature=\"%@\", oauth_timestamp=\"%@\", oauth_nonce=\"%@\", oauth_version=\"1.0\"%@",
													[realm stringUsingOAuthURLEncoding],
													[consumer.key stringUsingOAuthURLEncoding],
													tokenString,
													[[signerClass signatureType] stringUsingOAuthURLEncoding],
													[signature stringUsingOAuthURLEncoding],
													timestamp,
													nonce,
													extraParametersString];
	[self setValue:oauthHeader forHTTPHeaderField:@"Authorization"];
	}

@end
