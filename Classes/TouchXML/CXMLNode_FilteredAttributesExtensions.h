//
//  CXMLNode_FilteredAttributesExtensions.h
//  Vimeo Touch
//
//  Created by Felix Morgner on 11.02.11.
//  Copyright 2011 Felix Morgner. All rights reserved.
//

#import "CXMLNode.h"
#import "CXMLNode_PrivateExtensions.h"

@interface CXMLNode (CXMLNode_FilteredAttributesExtensions)

- (NSArray *)childrenOfKind:(CXMLNodeKind)theKind;

@end
