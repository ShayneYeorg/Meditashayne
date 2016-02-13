//
//  MDSConstant.h
//  Meditashayne
//
//  Created by 杨淳引 on 16/2/3.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "AppDelegate.h"
#import "MDSTool.h"

//NSLog
#ifdef DEBUG
#define MDSLog(format, ...) NSLog( @"<%@:(%d)> %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(format),  ##__VA_ARGS__] )
#else
#define MDSLog(format, ...)
#endif

//color
#define RGB(r, g, b) [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

//App
#define kAppTextCoclor RGB(50,50,50)
#define kApp ((AppDelegate *)[UIApplication sharedApplication].delegate)
#define kManagedObjectContext (((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext)

//设备屏幕尺寸
#define kScreen_Height ([UIScreen mainScreen].bounds.size.height)
#define kScreen_Width ([UIScreen mainScreen].bounds.size.width)

//应用尺寸(不包括状态栏,通话时状态栏高度不是20，所以需要知道具体尺寸)
#define kContent_Height ([UIScreen mainScreen].applicationFrame.size.height)
#define kContent_Width ([UIScreen mainScreen].applicationFrame.size.width)
#define kContent_CenterX kContent_Width/2
#define kContent_CenterY kContent_Height/2





