//
//  FFQuickKey.h
//  GameBox
//
//  Created by 燚 on 2018/8/13.
//  Copyright © 2018年 Sans. All rights reserved.
//

#ifndef FFQuickKey_h
#define FFQuickKey_h


// Get weak reference object.
#define kWeakObject(object) __weak __typeof(object) weakObject = object;

// Get weak reference object.
#define kWeak(caller, object) __weak __typeof(object) caller = object;

// Get strong reference object.
#define kStrongObject(object) __strong __typedef(object) strongObject = object;

// Get dispatch_get_main_queue()
#define kMainThread (dispatch_get_main_queue())

// Get default dispatch_get_global_queue
#define kGlobalThread dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

// Radians convert to degress.
#define kRadiansToDegrees(radians) ((radians) * (180.0 / M_PI))

// Degrees convert to randians.
#define kDegreesToRadians(angle) ((angle) / 180.0 * M_PI)

// Fast to get iOS system version
#define kIOSVersion ([UIDevice currentDevice].systemVersion.floatValue)

// More fast way to get app delegate
#define kAppDelegate ((AppDelegate *)[[UIApplication  sharedApplication] delegate])

#pragma mark - Device Frame
// Get the screen's height.
#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)

// Get the screen's width.
#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)

// Get the screen's bounds.
#define kScreenBounds ([UIScreen mainScreen].bounds)

#pragma mark - Generate Color

// color
///< format：0xFFFFFF
#define k16RGBColor(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 \
blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:1.0]

///< format：22,22,22
#define kRGBColor(r, g, b) ([UIColor colorWithRed:(r) / 255.0  \
green:(g) / 255.0  \
blue:(b) / 255.0  \
alpha:1])

///< format：22,22,22,0.5
#define kRGBAColor(r, g, b, a) ([UIColor colorWithRed:(r) / 255.0  \
green:(g) / 255.0  \
blue:(b) / 255.0  \
alpha:(a)])

// More easy way to use hex color to generate color.
#define kHexRGB(rgb) k16RGBColor(rgb)

// More easy way to generate a color object.
#define kRGB(r,g,b) kRGBColor(r,g,b)

// More easy way to generate a color object with rgb and alpha.
#define kRGBA(r,g,b,a) kRGBAColor(r, g, b, a)

#pragma mark - Load Font
// Generate font with size
#define kFontWithSize(size) [UIFont systemFontOfSize:size]

// Generate bold font with size.
#define kBoldFontWithSize(size) [UIFont boldSystemFontOfSize:size]

#pragma mark - Load Image

// More easy way to load an image.
#define kImage(Name) ([UIImage imageNamed:Name])

// More easy to load an image from file.
#define kImageOfFile(Name) ([UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:Name ofType:nil]])

#pragma mark - System Singletons

// More easy way to get user default object.
#define kUserDefaults [NSUserDefaults standardUserDefaults]

// More easy way to get NSNotificationCenter object.
#define kNotificationCenter  [NSNotificationCenter defaultCenter]

// More easy way to get [NSFileManager defaultManager]
#define kFileManager [NSFileManager defaultManager]

// More easy way to post a notification from notification center.
#define kPostNotificationWithName(notificationName) \
[kNotificationCenter postNotificationName:notificationName object:nil userInfo:nil]

// More easy way to post a notification with user info from notification center.
#define kPostNotificationWithNameAndUserInfo(notificationName, userInfo) \
[kNotificationCenter postNotificationName:notificationName object:nil userInfo:userInfo]

#pragma mark - Judge

// Judge whether it is an empty string.
#define kIsEmptyString(s) (s == nil || [s isKindOfClass:[NSNull class]] || ([s isKindOfClass:[NSString class]] && s.length == 0))

// Judge whether it is a nil or null object.
#define kIsEmptyObject(obj) (obj == nil || [obj isKindOfClass:[NSNull class]])

// Judge whether it is a vaid dictionary.
#define kIsDictionary(objDict) (objDict != nil && [objDict isKindOfClass:[NSDictionary class]])

// Judge whether it is a valid array.
#define kIsArray(objArray) (objArray != nil && [objArray isKindOfClass:[NSArray class]])

// Judge whether the device it is ipad.
#define kIsIPad \
([[UIDevice currentDevice] respondsToSelector:@selector(userInterfaceIdiom)]\
&& [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)

// Judge whether current orientation is landscape.
#define kIsLandscape (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]))

#pragma makr - Color
/**
 *
 *    The following macros are system colors.
 */
#define kBlackColor       [UIColor blackColor]
#define kDarkGrayColor    [UIColor darkGrayColor]
#define kLightGrayColor   [UIColor lightGrayColor]
#define kWhiteColor       [UIColor whiteColor]
#define kRedColor         [UIColor redColor]
#define kBlueColor        [UIColor blueColor]
#define kGreenColor       [UIColor greenColor]
#define kCyanColor        [UIColor cyanColor]
#define kYellowColor      [UIColor yellowColor]
#define kMagentaColor     [UIColor magentaColor]
#define kOrangeColor      [UIColor orangeColor]
#define kPurpleColor      [UIColor purpleColor]
#define kBrownColor       [UIColor brownColor]
#define kClearColor       [UIColor clearColor]

// Black opaque color, with rgba: 0, 0, 0, 0.5
#define kBlackOpaqueColor kHexColor(0, 0, 0, 0.5)



#endif /* FFQuickKey_h */
