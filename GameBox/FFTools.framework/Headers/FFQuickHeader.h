//
//  FFQuickHeader.h
//  FFTools
//
//  Created by Sans on 2018/8/28.
//  Copyright © 2018年 Sans. All rights reserved.
//

#ifndef FFQuickHeader_h
#define FFQuickHeader_h


// Fast to get iOS system version
#define fIOSVersion ([UIDevice currentDevice].systemVersion.floatValue)

// More fast way to get app delegate
#define fAppDelegate ((AppDelegate *)[[UIApplication  sharedApplication] delegate])

#pragma mark - Device Frame
// Get the screen's height.
#define fScreenHeight ([UIScreen mainScreen].bounds.size.height)

// Get the screen's width.
#define fScreenWidth ([UIScreen mainScreen].bounds.size.width)

// Get the screen's bounds.
#define fScreenBounds ([UIScreen mainScreen].bounds)


//========================= color =======================//
#define fBlackColor       [UIColor blackColor]
#define fDarkGrayColor    [UIColor darkGrayColor]
#define fLightGrayColor   [UIColor lightGrayColor]
#define fWhiteColor       [UIColor whiteColor]
#define fRedColor         [UIColor redColor]
#define fBlueColor        [UIColor blueColor]
#define fGreenColor       [UIColor greenColor]
#define fCyanColor        [UIColor cyanColor]
#define fYellowColor      [UIColor yellowColor]
#define fMagentaColor     [UIColor magentaColor]
#define fOrangeColor      [UIColor orangeColor]
#define fPurpleColor      [UIColor purpleColor]
#define fBrownColor       [UIColor brownColor]
#define fClearColor       [UIColor clearColor]
//========================= color =======================//










#endif /* FFQuickHeader_h */
