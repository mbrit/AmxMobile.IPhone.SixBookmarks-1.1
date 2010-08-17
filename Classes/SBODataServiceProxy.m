//
//  ODataServiceProxy.m
//  SixBookmarks
//
//  Created by Matthew Baxter-Reynolds on 11/08/2010.
//  Copyright (c) 2010 AMX Software Ltd. All rights reserved.
//

#import <libxml/encoding.h>
#import <libxml/xmlwriter.h>
#import "SBODataServiceProxy.h"
#import "MyClasses.h"

@implementation SBODataServiceProxy

@synthesize entityType;
@synthesize callback;

-(id)initWithTypeAndServiceName:(Class)theType serviceName:(NSString *)theServiceName;
{
	if(self = [super initWithServiceName:theServiceName])
	{
		[self setEntityType:[SBEntityType getEntityType:theType]];
	}
	
	// return...
	return self;
}

-(NSString *)getServiceUrl:(SBEntityType *)et
{
	return [NSString stringWithFormat:@"%@/%@", [self resolvedServiceUrl], et.nativeName];
}

-(void)getAll:(SBODataFetchCallback *)theCallback
{
	// store the callback...
	self.callback = theCallback;
	
	// get the url...
	NSString *url = [self getServiceUrl:self.entityType];
	
	// run...
	SBDownloadSettings *settings = [self getDownloadSettings];
	[SBHttpHelper download:url settings:settings callback:(SBDownloadCallback *)self opCode:OPCODE_ODATAFETCHALL];
}

-(void)downloadComplete:(SBDownloadBucket *)bucket
{
	// did we fail - i.e. not 200 and not 204 (OK, but nothing to say), and not 201 (created)...
	if(bucket.statusCode != 200 && bucket.statusCode != 204 && bucket.statusCode != 201)
	{
		// create an error...
		NSString *message = [NSString stringWithFormat:@"An OData request returned HTTP status '%d'.", bucket.statusCode];
		NSString *html = bucket.dataAsString;
		NSLog(@"%@ --> %@", message, html);
		NSError *err = [SBErrorHelper error:self message:message];
		
		// flip back...
		[self.callback odataFetchFailed:err opCode:bucket.opCode];
	}
	else
	{
		// ok...
		if(bucket.opCode == OPCODE_ODATAFETCHALL)
			[self handleFetchAllComplete:bucket];
		else if(bucket.opCode == OPCODE_ODATACHANGE)
			[self handleODataChangeComplete:bucket];
		else
			@throw [NSException exceptionWithName:[[self class] description] reason:[NSString stringWithFormat:@"An op code of '%d' was not recognised.", [bucket opCode]] userInfo:nil];
	}	
}

-(void)handleFetchAllComplete:(SBDownloadBucket *)bucket
{
	// parse it...
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:[bucket data]];
	[parser setShouldProcessNamespaces:TRUE];
	
	// new...
	SBEntityXmlBucket *entities = [[SBEntityXmlBucket alloc] initWithEntityType:[self entityType]];
	[parser setDelegate:entities];
	[parser parse];
	
	// at this point we have a populated bucket, so send it back to the caller...
	[self.callback odataFetchOk:entities opCode:[bucket opCode]];
}

-(void)pushUpdate:(SBEntity *)entity serverId:(int)theServerId callback:(SBODataFetchCallback *)theCallback
{
	// create...
	xmlBufferPtr buffer = xmlBufferCreate();
    xmlTextWriterPtr writer = xmlNewTextWriterMemory(buffer, 0);
	
	// start the document...
	xmlTextWriterStartDocument(writer, "1.0", "UTF-8", NULL);
	
	// bring forward...
	const char *atomUri = [[SBEntityXmlBucket atomNamespace] cStringUsingEncoding:NSUTF8StringEncoding];
	const char *atomPrefix = nil;
	const char *metadataUri = [[SBEntityXmlBucket msMetadataNamespace] cStringUsingEncoding:NSUTF8StringEncoding];
	const char *metadataPrefix = "m";
	const char *dataUri = [[SBEntityXmlBucket msDataNamespace] cStringUsingEncoding:NSUTF8StringEncoding];
	const char *dataPrefix = "d";
	
	// start entry and content and properties...
	xmlTextWriterStartElementNS(writer, BAD_CAST atomPrefix, BAD_CAST "entry", BAD_CAST atomUri);
	xmlTextWriterStartElementNS(writer, BAD_CAST atomPrefix, BAD_CAST "content", BAD_CAST atomUri);
	xmlTextWriterWriteAttribute(writer, BAD_CAST "type", BAD_CAST "application/xml");
	xmlTextWriterStartElementNS(writer, BAD_CAST metadataPrefix, BAD_CAST "properties", BAD_CAST metadataUri);
	
	// fields...
	SBEntityType *et = entity.entityType;
	for(SBEntityField *field in et.fields)
	{
		if(!(field.isKey) && field.isOnServer)
		{
			xmlTextWriterStartElementNS(writer, BAD_CAST dataPrefix, BAD_CAST [field.nativeName cStringUsingEncoding:NSUTF8StringEncoding], BAD_CAST dataUri);
			NSObject *value = [entity getValue:field];
			if(field.type == SBDT_STRING)
				xmlTextWriterWriteString(writer, BAD_CAST [(NSString *)value cStringUsingEncoding:NSUTF8StringEncoding]);
			else if(field.type == SBDT_INT32)
				xmlTextWriterWriteString(writer, BAD_CAST [[NSString stringWithFormat:@"%d", [(NSNumber *)value intValue]] cStringUsingEncoding:NSUTF8StringEncoding]);
			else
				@throw [NSException exceptionWithName:[[self class] description] reason:@"Unhandled data type." userInfo:nil];
			xmlTextWriterEndElement(writer);
		}
	}
	
	// end content and entry...
	xmlTextWriterEndElement(writer);
	xmlTextWriterEndElement(writer);
	xmlTextWriterEndElement(writer);
	
	// end the document...
	xmlTextWriterEndDocument(writer);
	
	// get the data out...
    xmlFreeTextWriter(writer);
    NSData *xmlData = [NSData dataWithBytes:(buffer->content) length:(buffer->use)];
    xmlBufferFree(buffer);
	NSString *xml = [[NSString alloc] initWithData:xmlData encoding:NSUTF8StringEncoding];
	
	// dump the data...
	NSLog(@"%@", xml);
	
	// now we can send it...
	NSString *url = nil;
	SBODataOperation opType;
	if(theServerId == 0)
	{
		url = [self getServiceUrl:et];
		opType = SBODOInsert;
	}
	else 
	{
		url = [self getEntityUrlForPush:entity serverId:theServerId];
		opType = SBODOUpdate;
	}
	
	// call...
	[self executeODataOperation:opType url:url xml:xml callback:theCallback];
}

-(NSString *)getEntityUrlForPush:(SBEntity *)theEntity serverId:(int)theServerId
{
	return [NSString stringWithFormat:@"%@(%d)", [self getServiceUrl:theEntity.entityType], theServerId];
}

-(void)pushDelete:(SBEntity *)entity serverId:(int)theServerId callback:(SBODataFetchCallback *)theCallback
{
	// get...
	NSString *url = [self getEntityUrlForPush:entity serverId:theServerId];
	[self executeODataOperation:SBODODelete url:url xml:nil callback:theCallback];
}

-(void)pushInsert:(SBEntity *)entity callback:(SBODataFetchCallback *)theCallback
{
	// an insert is an update but with a different url...
	[self pushUpdate:entity serverId:0 callback:theCallback];
}

-(void)executeODataOperation:(SBODataOperation)opType url:(NSString*)theUrl xml:(NSString *)theXml callback:(SBODataFetchCallback *)theCallback
{
	// store the callback...
	self.callback = theCallback;
	
	// create a request...
	NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:theUrl]];
	[request setValue:@"application/atom+xml" forHTTPHeaderField:@"Content-type"];
	
	// what method?
	if(opType == SBODOInsert)
		[request setHTTPMethod:@"POST"];
	else if(opType == SBODOUpdate)
		[request setHTTPMethod:@"MERGE"];
	else if(opType == SBODODelete)
		[request setHTTPMethod:@"DELETE"];
	else
		@throw [NSException exceptionWithName:[[self class] description] reason:@"Unhandled operation type." userInfo:nil];
	
	// get the settings...
	SBDownloadSettings *settings = [self getDownloadSettings];
	for(NSString *name in settings.extraHeaders)
	{
		NSString * value = [settings.extraHeaders objectForKey:name];
		[request addValue:value forHTTPHeaderField:name];
	}
	[settings release];
	
	// set the body...
	if(theXml != nil && theXml.length > 0)
		[request setHTTPBody:[theXml dataUsingEncoding:NSUTF8StringEncoding]];	
	
	// create the connection with the request and start loading the data
	SBDownloadBucket *bucket = [[SBDownloadBucket alloc] initWithCallback:(SBDownloadCallback *)self opCode:OPCODE_ODATACHANGE];
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:bucket];
	if(connection != nil)
		NSLog(@"Connection started...");
}

-(void)handleODataChangeComplete:(SBDownloadBucket *)bucket
{
	// good, tell the callback that we did it...
	[self.callback odataFetchOk:nil opCode:bucket.opCode];
}

-(void)dealloc
{
	[callback release];
	[entityType release];
	[super dealloc];
}

@end
