
//  Created by Futao on 11-3-1.
//  Copyright 2011 ftkey@qq.com All rights reserved.

#import "EPubModel.h"
#import "TouchXML.h"
#import "MyZipArchive.h"

#define kLibraryCacheFolder				[NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"] 


#define kUserBooksFolder				[kLibraryCacheFolder stringByAppendingPathComponent:@"lib_books"] 
#define kFileExistsAtPath(S)			[[NSFileManager defaultManager] fileExistsAtPath:S]

@interface EPubModel  (Private)

- (void)unzip:(NSString *)thePath;
- (void)opfPathParser:(NSString *)thePath;
- (void)dcmetadataParser:(NSString *)thePath;
- (void)opfContentParser:(NSString *)thePath;
- (void)ncxPathParser:(NSString *)thePath idref:(NSString *)theidref;
@end	

@implementation EPubModel




- (id)initWithPath:(NSString *)thePath;
{
	if ((self = [super init]))
	{	

		_path=[[thePath lastPathComponent] copy];
		_fullpath=[[kUserBooksFolder stringByAppendingPathComponent:_path] copy];

		
//		if (kFileExistsAtPath(thePath)==NO && kFileExistsAtPath(_fullpath)==NO)
//		{
//			_isValid=NO;
//
//			return self;
//		}
		if (kFileExistsAtPath(thePath)==YES && kFileExistsAtPath(_fullpath)==NO)
		{
			[self unzip:thePath];
		}
		if (kFileExistsAtPath(_fullpath)==YES)
		{
			_sectionsText=[[NSMutableArray alloc] init]; // 章节名称
			_sectionsPath=[[NSMutableArray alloc] init]; 
			_mimetype=@"application/epub+zip";
			_catalogText=@"目录";
			_titlepageText=@"封面";
			
			
			[self opfPathParser:_fullpath];
			[self dcmetadataParser:_fullpath];
			[self opfContentParser:_fullpath];
			_isValid=YES;
		}
		else {
			_isValid=NO;

		}



	}
	return(self);
	
}
- (void)unzip:(NSString *)thePath
{
	
	[[NSFileManager defaultManager] createDirectoryAtPath:_fullpath
							  withIntermediateDirectories:YES
											   attributes:nil
													error:NULL];

	
	MyZipArchive* za = [[MyZipArchive alloc] init];
	[za UnzipOpenFile:thePath UnzipFileTo:_fullpath RemoveZip:NO];
	[za release];
}

- (void)opfPathParser:(NSString *)thePath
{
	
	NSError *theError = nil;
	
	NSString *containerPath=[thePath stringByAppendingPathComponent:@"META-INF/container.xml"];
	NSData* containerData = [NSData dataWithContentsOfFile: containerPath];
	
	CXMLDocument *theDocument = [[[CXMLDocument alloc] initWithData:containerData 
															options:0 
															  error:&theError] autorelease];
	
	NSDictionary *theMappings = [NSDictionary dictionaryWithObjectsAndKeys:
								 @"urn:oasis:names:tc:opendocument:xmlns:container", 
								 @"NS",
								 nil];
	
	NSArray *theNodes = [theDocument nodesForXPath:@"/NS:container/NS:rootfiles/NS:rootfile" 
								 namespaceMappings:theMappings 
											 error:&theError];
	
	
	for (CXMLElement *theElement in theNodes)
	{
		NSString *thePathComponent = [[theElement attributeForName:@"full-path"] stringValue];
		_opfPath=[thePathComponent copy];
		_opfDelExtPath=[[[thePathComponent pathComponents] objectAtIndex:0] copy];
		break;
	}
}

- (void)dcmetadataParser:(NSString *)thePath
{
	NSError *theError = nil;
	
	NSString *containerPath=[thePath stringByAppendingPathComponent:_opfPath];
	NSData* containerData = [NSData dataWithContentsOfFile: containerPath];
	
	CXMLDocument *theDocument = [[[CXMLDocument alloc] initWithData:containerData 
															options:0 
															  error:&theError] autorelease];
	
	NSDictionary *theMappings = [NSDictionary dictionaryWithObjectsAndKeys:
								 @"http://www.idpf.org/2007/opf", 
								 @"NS",
								 @"http://purl.org/dc/elements/1.1/",
								 @"dc",
								 @"http://purl.org/dc/terms/",
								 @"dcterms",
								 nil];
	
	NSArray *theNodes = [theDocument nodesForXPath:@"/NS:package/NS:metadata/NS:dc-metadata" 
								 namespaceMappings:theMappings 
											 error:&theError];
	for (CXMLElement *theElement in theNodes)
	{
		
		_dctitle =[[[[theElement elementsForName:@"title"] lastObject]stringValue] copy]; 
		_dccreator =[[[[theElement elementsForName:@"creator"] lastObject]stringValue] copy]; 
		_dcsubject =[[[[theElement elementsForName:@"subject"] lastObject]stringValue] copy]; 
		_dcdescription =[[[[theElement elementsForName:@"description"] lastObject]stringValue] copy]; 
		_dccontributor =[[[[theElement elementsForName:@"contributor"] lastObject]stringValue] copy]; 
		_dcpublisher =[[[[theElement elementsForName:@"publisher"] lastObject]stringValue] copy]; 
		_dcdate =[[[[theElement elementsForName:@"date"] lastObject]stringValue] copy]; 
		_dctype =[[[[theElement elementsForName:@"type"] lastObject]stringValue] copy]; 
		_dcformat =[[[[theElement elementsForName:@"format"] lastObject]stringValue] copy];  
		_dcidentifier =[[[[theElement elementsForName:@"identifier"] lastObject]stringValue] copy]; 
		_dcsource =[[[[theElement elementsForName:@"source"] lastObject]stringValue] copy]; 
		_dclanguage =[[[[theElement elementsForName:@"language"] lastObject]stringValue] copy]; 
		_dcrelation =[[[[theElement elementsForName:@"relation"] lastObject]stringValue] copy];  
		_dccoverage =[[[[theElement elementsForName:@"coverage"] lastObject]stringValue] copy];  
		_dcrights =[[[[theElement elementsForName:@"rights"] lastObject]stringValue] copy]; 
		
		break;
	}	
}



- (void)opfContentParser:(NSString *)thePath
{
	
	NSError *theError = nil;
	
	NSString *containerPath=[thePath stringByAppendingPathComponent:_opfPath];
	NSData* containerData = [NSData dataWithContentsOfFile: containerPath];
	
	CXMLDocument *theDocument = [[[CXMLDocument alloc] initWithData:containerData 
															options:0 
															  error:&theError] autorelease];
	
	NSDictionary *theMappings = [NSDictionary dictionaryWithObjectsAndKeys:@"http://www.idpf.org/2007/opf", @"NS",nil];
	NSArray *theNodes = [theDocument nodesForXPath:@"/NS:package/NS:manifest/NS:item" 
								 namespaceMappings:theMappings 
											 error:&theError];
	for (CXMLElement *theElement in theNodes)
	{
		NSString *thePathComponent=[[[theElement attributeForName:@"id"] stringValue] lowercaseString];
		
		if ([thePathComponent isEqualToString:@"css"]) {
			NSString *val=[[theElement attributeForName:@"href"] stringValue];
			if (val) 
				_cssPath=[[_opfDelExtPath stringByAppendingPathComponent:val] copy];
			
			
		}
		else if ([thePathComponent isEqualToString:@"ncx"]) {
			NSString *val=[[theElement attributeForName:@"href"] stringValue];
			if (val) 
				_ncxPath=[[_opfDelExtPath stringByAppendingPathComponent:val] copy];
			
			
		}
		else if ([thePathComponent isEqualToString:@"cover"]) {
			NSString *val=[[theElement attributeForName:@"href"] stringValue];
			if (val) 
				_coverIconPath=[[_opfDelExtPath stringByAppendingPathComponent:val] copy];
			
			
		}
		else if ([thePathComponent isEqualToString:@"titlepage"]) {
			NSString *val=[[theElement attributeForName:@"href"] stringValue];
			if (val) 
				_titlepagePath=[[_opfDelExtPath stringByAppendingPathComponent:val] copy];
			
		}
		else if ([thePathComponent isEqualToString:@"catalog"]) {
			NSString *val=[[theElement attributeForName:@"href"] stringValue];
			if (val) 
				_catalogPath=[[_opfDelExtPath stringByAppendingPathComponent:val] copy];
			
		}
		else
		{
			// 目录列表
			NSString *theXPath = [NSString stringWithFormat:@"/NS:package/NS:spine/NS:itemref[@idref='%@']", thePathComponent];
			
			NSArray *theItemNodes = [theDocument nodesForXPath:theXPath 
											 namespaceMappings:theMappings 
														 error:&theError];
			if ([theItemNodes count]>0) {
				NSString *val=[[theElement attributeForName:@"href"] stringValue];
				if (val) 
				{
					[_sectionsPath addObject:[_opfDelExtPath stringByAppendingPathComponent:val]];
					// 取得目录名称
					[self ncxPathParser:thePath idref:thePathComponent];
				}
			}
			
		}
	}		
}
- (void)ncxPathParser:(NSString *)thePath idref:(NSString *)theidref{
	
	NSError *theError = nil;
	
	NSString *containerPath=[thePath stringByAppendingPathComponent:_ncxPath];
	NSData* containerData = [NSData dataWithContentsOfFile: containerPath];
	
	CXMLDocument *theDocument = [[[CXMLDocument alloc] initWithData:containerData 
															options:0 
															  error:&theError] autorelease];
	NSDictionary *theMappings = [NSDictionary dictionaryWithObjectsAndKeys:
								 @"http://www.daisy.org/z3986/2005/ncx/", 
								 @"NS",
								 nil];
	
	NSString *theXPath = [NSString stringWithFormat:@"/NS:ncx/NS:navMap/NS:navPoint[@id='%@']/NS:navLabel", theidref];
	
	
	NSArray *theNodes = [theDocument nodesForXPath:theXPath 
								 namespaceMappings:theMappings 
											 error:&theError];
	if ([theNodes count]==0) {
		[_sectionsText addObject:[NSString stringWithFormat:@"Current Chapter  : %d",[_sectionsText count]+1]];
		
	}
	else {
		for (CXMLElement *theElement in theNodes)
		{
			if([[theElement elementsForName:@"text"] count]>0)
			{
				NSString *thePathComponent=[[[theElement elementsForName:@"text"] objectAtIndex:0]stringValue];
				[_sectionsText addObject:thePathComponent];
				
			}
			
		}
	}
}
@synthesize isValid = _isValid;

@synthesize mimetype = _mimetype;
@synthesize dctitle = _dctitle;
@synthesize dccreator = _dccreator;
@synthesize dcsubject = _dcsubject;
@synthesize dcdescription = _dcdescription;
@synthesize dccontributor = _dccontributor;
@synthesize dcpublisher = _dcpublisher;
@synthesize dcdate = _dcdate;
@synthesize dctype = _dctype;
@synthesize dcformat = _dcformat;
@synthesize dcidentifier = _dcidentifier;
@synthesize dcsource = _dcsource;
@synthesize dclanguage = _dclanguage;
@synthesize dcrelation = _dcrelation;
@synthesize dccoverage = _dccoverage;
@synthesize dcrights = _dcrights;
@synthesize path = _path;
@synthesize fullpath = _fullpath;
@synthesize cssPath = _cssPath;
@synthesize opfPath = _opfPath;
@synthesize opfDelExtPath = _opfDelExtPath;
@synthesize ncxPath = _ncxPath;
@synthesize coverIconPath = _coverIconPath;
@synthesize titlepageText = _titlepageText;
@synthesize titlepagePath = _titlepagePath;
@synthesize catalogText = _catalogText;
@synthesize catalogPath = _catalogPath;
@synthesize sectionsText = _sectionsText;
@synthesize sectionsPath = _sectionsPath;

//=========================================================== 
// dealloc
//=========================================================== 
- (void)dealloc
{
	[_mimetype release];
	[_dctitle release];
	[_dccreator release];
	[_dcsubject release];
	[_dcdescription release];
	[_dccontributor release];
	[_dcpublisher release];
	[_dcdate release];
	[_dctype release];
	[_dcformat release];
	[_dcidentifier release];
	[_dcsource release];
	[_dclanguage release];
	[_dcrelation release];
	[_dccoverage release];
	[_dcrights release];
	[_path release];
	[_fullpath release];
	[_cssPath release];
	[_opfPath release];
	[_opfDelExtPath release];
	[_ncxPath release];
	[_coverIconPath release];
	[_titlepageText release];
	[_titlepagePath release];
	[_catalogText release];
	[_catalogPath release];
	[_sectionsText release];
	[_sectionsPath release];
	
	[super dealloc];
}

@end
