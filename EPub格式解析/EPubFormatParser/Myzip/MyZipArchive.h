//
//  ZipArchive.h
//  
//
//  Created by aish on 08-9-11.
//  acsolu@gmail.com
//  Copyright 2008  Inc. All rights reserved.
//
// History: 
//    09-11-2008 version 1.0    release
//    10-18-2009 version 1.1    support password protected zip files
//    10-21-2009 version 1.2    fix date bug

#import <UIKit/UIKit.h>

@interface MyZipArchive : NSObject {

}
-(BOOL) UnzipOpenFile:(NSString*) zipFile UnzipFileTo:(NSString*) path; //default remove zip file
-(BOOL) UnzipOpenFile:(NSString*) zipFile UnzipFileTo:(NSString*) path RemoveZip:(BOOL) isRemove;

-(BOOL) UnzipOpenFile:(NSString*) zipFile UnzipFileTo:(NSString*) path Password:(NSString*) password;
@end
