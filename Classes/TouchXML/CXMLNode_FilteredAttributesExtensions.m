#import "CXMLNode_FilteredAttributesExtensions.h"

@implementation CXMLNode (CXMLNode_FilteredAttributesExtensions)

- (NSArray *)childrenOfKind:(CXMLNodeKind)theKind
	{
	NSAssert(_node != NULL, @"CXMLNode does not have attached libxml2 _node.");
	
	NSMutableArray *theChildren = [NSMutableArray array];
	
	if (_node->type != CXMLAttributeKind) // NSXML Attribs don't have children.
		{
		xmlNodePtr theCurrentNode = _node->children;

		while (theCurrentNode != NULL)
			{
			while(theCurrentNode && theCurrentNode->type != theKind)
				theCurrentNode = theCurrentNode->next;
				
			if(!theCurrentNode)
				break;

			CXMLNode *theNode = [CXMLNode nodeWithLibXMLNode:theCurrentNode freeOnDealloc:NO];
			[theChildren addObject:theNode];
			theCurrentNode = theCurrentNode->next;
			}
		}
	return(theChildren);      
	}

@end