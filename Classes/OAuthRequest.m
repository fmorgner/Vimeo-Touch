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
@synthesize oauthParameters;

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
			[self setSignerClass:theSignerClass];
			}
		else
			{
			[self setSignerClass:[OAuthSignerHMAC class]];
			}

		[self setNonce:[self generateNonce]];
		[self setTimestamp:[self generateTimestamp]];
		
		self.oauthParameters = [[NSMutableArray alloc] init];
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
	[oauthParameters release];
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
	[oauthParameters addObject:[OAuthParameter parameterWithKey:@"oauth_consumer_key" andValue:consumer.key]];
	[oauthParameters addObject:[OAuthParameter parameterWithKey:@"oauth_signature_method" andValue:[signerClass signatureType]]];
	[oauthParameters addObject:[OAuthParameter parameterWithKey:@"oauth_timestamp" andValue:timestamp]];
	[oauthParameters addObject:[OAuthParameter parameterWithKey:@"oauth_nonce" andValue:nonce]];
	[oauthParameters addObject:[OAuthParameter parameterWithKey:@"oauth_version" andValue:@"1.0"]];
	
	if(![token.key isEqualToString:@""])
		{
		[oauthParameters addObject:[[OAuthParameter parameterWithKey:@"oauth_token" andValue:token.key] concatenatedKeyValuePair]];
		}
	
	for(OAuthParameter* parameter in [self parameters])
		{
		[oauthParameters addObject:[parameter concatenatedKeyValuePair]];
		}
	
	[oauthParameters sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
		return [[obj1 key] compare:[obj2 key]];
	}];
	
	NSMutableArray* keyValuePairStrings = [NSMutableArray arrayWithCapacity:[oauthParameters count]];
	
	for(OAuthParameter* parameter in oauthParameters)
		{
		[keyValuePairStrings addObject:[parameter concatenatedKeyValuePair]];
		}
	
	NSString* baseString = [keyValuePairStrings componentsJoinedByString:@"&"];
	
	return [NSString stringWithFormat:@"%@&%@&%@", [self HTTPMethod], [[[self URL] URLStringWithoutQuery] stringUsingOAuthURLEncoding], [baseString stringUsingOAuthURLEncoding]];
	}

#pragma mark -
#pragma mark Instance Methods

- (void)addParameter:(OAuthParameter*)aParameter
	{
	if(aParameter)
		{
		[oauthParameters addObject:aParameter];
		}
	}

- (void)prepare
	{
	NSString* sigKey = [NSString stringWithFormat:@"%@&%@", consumer.secret, token.secret];
	NSString* sigBase = [self signatureBaseString];
	[self setSignature:[signerClass signClearText:sigBase withSecret:sigKey]];
	NSString* tokenString;
	([token.key isEqualToString:@""]) ? (tokenString = @"") : (tokenString = [NSString stringWithFormat:@"oauth_token=%@, ", [token.key stringUsingOAuthURLEncoding]]);

	NSString *oauthHeader = [NSString stringWithFormat:@"OAuth realm=%@, oauth_consumer_key=%@, %@oauth_signature_method=%@, oauth_signature=%@, oauth_timestamp=%@, oauth_nonce=%@, oauth_version=1.0%@",
													[realm stringUsingOAuthURLEncoding],
													[consumer.key stringUsingOAuthURLEncoding],
													tokenString,
													[[signerClass signatureType] stringUsingOAuthURLEncoding],
													[signature stringUsingOAuthURLEncoding],
													timestamp,
													nonce,
													@""];
	[self setValue:oauthHeader forHTTPHeaderField:@"Authorization"];
	}

@end
