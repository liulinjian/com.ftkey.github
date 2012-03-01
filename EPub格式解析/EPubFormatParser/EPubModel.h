
//  Created by Futao on 11-3-1.
//  Copyright 2011 ftkey@qq.com All rights reserved.

#import <Foundation/Foundation.h>


@interface EPubModel : NSObject {

@private

	BOOL _isValid;

	NSString *_mimetype; // 文件格式

	NSString *_dctitle; // 标题
	NSString *_dccreator; // 作者
	NSString *_dcsubject; // 主题
	NSString *_dcdescription; // 描述
	NSString *_dccontributor; // 贡献者或其它次要责任者
	NSString *_dcpublisher; //出版社
	NSString *_dcdate; // 时间
	NSString *_dctype; // "电子图书"
	NSString *_dcformat;  // "Image/Djvu(.djvu;wap)"
	NSString *_dcidentifier; // 识别码 "bookid: 1392"
	NSString *_dcsource; // 来源
	NSString *_dclanguage; // 语言
	NSString *_dcrelation; // 相关信息
	NSString *_dccoverage; // 履盖范围
	NSString *_dcrights; // 版权 "xx出版社版权所有"
	
	
	NSString *_path; // 文件名
	NSString *_fullpath; // 文件全路径
	
	NSString *_cssPath;
	NSString *_opfPath;
	NSString *_opfDelExtPath;
	NSString *_ncxPath; 
	NSString *_coverIconPath; 
	
	NSString *_titlepageText;		//
	NSString *_titlepagePath;
	NSString *_catalogText;		
	NSString *_catalogPath;
	NSMutableArray *_sectionsText; // 章节名称
	NSMutableArray *_sectionsPath; // 章节路径

	

}
@property (nonatomic, assign, getter=isValid) BOOL isValid;


@property (nonatomic, readonly) NSString *mimetype;
@property (nonatomic, readonly) NSString *dctitle;
@property (nonatomic, readonly) NSString *dccreator;
@property (nonatomic, readonly) NSString *dcsubject;
@property (nonatomic, readonly) NSString *dcdescription;
@property (nonatomic, readonly) NSString *dccontributor;
@property (nonatomic, readonly) NSString *dcpublisher;
@property (nonatomic, readonly) NSString *dcdate;
@property (nonatomic, readonly) NSString *dctype;
@property (nonatomic, readonly) NSString *dcformat;
@property (nonatomic, readonly) NSString *dcidentifier;
@property (nonatomic, readonly) NSString *dcsource;
@property (nonatomic, readonly) NSString *dclanguage;
@property (nonatomic, readonly) NSString *dcrelation;
@property (nonatomic, readonly) NSString *dccoverage;
@property (nonatomic, readonly) NSString *dcrights;
@property (nonatomic, readonly) NSString *path;
@property (nonatomic, readonly) NSString *fullpath;
@property (nonatomic, readonly) NSString *cssPath;
@property (nonatomic, readonly) NSString *opfPath;
@property (nonatomic, readonly) NSString *opfDelExtPath;
@property (nonatomic, readonly) NSString *ncxPath;
@property (nonatomic, readonly) NSString *coverIconPath;
@property (nonatomic, readonly) NSString *titlepageText;
@property (nonatomic, readonly) NSString *titlepagePath;
@property (nonatomic, readonly) NSString *catalogText;
@property (nonatomic, readonly) NSString *catalogPath;
@property (nonatomic, readonly) NSMutableArray *sectionsText;
@property (nonatomic, readonly) NSMutableArray *sectionsPath;







- (id)initWithPath:(NSString *)thePath;


@end
