//
//  ZipArchive.mm
//  
//
//  Created by aish on 08-9-11.
//  acsolu@gmail.com
//  Copyright 2008  Inc. All rights reserved.
//

#import  "MyZipArchive.h"
#include "myzip/unzip.h"
#include  "ZipArchive.h"



@implementation MyZipArchive
-(id) init
{
	if( self=[super init] )
	{
	}
	return self;
}

-(void) dealloc
{
	[super dealloc];
}
-(BOOL) UnzipOpenFile:(NSString*) zipFile UnzipFileTo:(NSString*) path //default remove zip file
{
	return	[self UnzipOpenFile:zipFile UnzipFileTo:path RemoveZip:YES];	
}
-(BOOL) UnzipOpenFile:(NSString*) zipFile UnzipFileTo:(NSString*) path RemoveZip:(BOOL) isRemove
{
	ZipArchive* za = [[ZipArchive alloc] init];
	if( [za UnzipOpenFile:zipFile] )
	{
		BOOL ret = [za UnzipFileTo:path overWrite:YES];
		if( NO==ret )
		{
			// error handler here
		}
		[za UnzipCloseFile];
	}
	
	[za release];
	
	if (isRemove) {
		[[NSFileManager defaultManager] removeItemAtPath:zipFile error:nil];
	}
	return YES;
}
-(BOOL) UnzipOpenFile:(NSString*) zipFile UnzipFileTo:(NSString*) path Password:(NSString*) password
{
	
	const char* zipFileUTF8 = [zipFile UTF8String];
	const char* zipFileToUTF8 = [path UTF8String];
	const char* zipFilePasswordUTF8 = [password UTF8String];
	
	HZIP hz = OpenZip(zipFileToUTF8,zipFileUTF8,zipFilePasswordUTF8); //∂‡ƒø¬ºΩ‚—π≤‚ ‘
	int numitems = GetNumberOfEntries(hz);
	// -1 gives overall information about the zipfile
	ZRESULT ret;
	for (int zi=0; zi<numitems; zi++)
	{ 
		ZIPENTRY ze;
		ret= GetZipItem(hz,zi,&ze); // fetch individual details
		if (ret != ZR_OK) {
			//printf("≤ª’˝»∑µƒ∏Ò Ω\n");//ZR_CORRUPT
		} else {
			ret = 7;
			ret = UnzipItem(hz, zi, ze.name);         // e.g. the item's name.
			if (ret != ZR_OK) {
				//printf("%x\r\n",ret);
			}
		}
	}
	CloseZip(hz);
	
	return YES;
}


@end


