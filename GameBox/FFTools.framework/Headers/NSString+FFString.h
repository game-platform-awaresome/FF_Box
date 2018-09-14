//
//  NSString+FFString.h
//  FFTools
//
//  Created by 燚 on 2018/8/29.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (FFString)

/**
 *  Convert the string to 32bit md5 string.
 *
 *  @return 32bit md5
 */
- (NSString *)ff_to32MD5;

/**
 *  Convert the string to 16bit md5 string.
 *
 *  @return 16bit md5
 */
- (NSString *)ff_to16MD5;

/**
 *  Encrypt the string with sha1 argorithm.
 *
 *  @return The sha1 string.
 */
- (NSString *)ff_sha1;

/**
 *  Encrypt the string with sha256 argorithm.
 *
 *  @return The sha256 string.
 */
- (NSString *)ff_sha256;

/**
 *  Encrypt the string with sha512 argorithm.
 *
 *  @return The sha512 string.
 */
- (NSString *)ff_sha512;

#pragma mark - Data convert to string or string to data.
/**
 *  Convert the current string to data.
 *
 *  @return data object if convert successfully, otherwise nil.
 */
- (NSData *)ff_toData;
/**
 *  Convert a data object to string.
 *
 *  @param data    The data will be converted.
 *
 *  @return string object if convert successfully, otherwise nil.
 */
+ (NSString *)ff_StringWithData:(NSData *)data;

#pragma mark - URL
/**
 *  Try to convert the string to a NSURL object.
 */
- (NSURL *)ff_toURL;

/**
 *  Try to do a url encode.
 */
- (NSString *)ff_URLEncode;

#pragma mark - path
/** @return document path */
NSString * ff_documentPath(void);
/** @return library path*/
NSString * ff_libraryPath(void);
/** @return cache path*/
NSString * ff_cachePath(void);
/** @return tem path*/
NSString * ff_temPath(void);

#pragma mark - Check email, phone, tel, or persion id.
/**
 *  Check whether the string is a valid kind of email format.
 *
 *  @return YES if it is a valid format, otherwise false.
 */
+ (BOOL)ff_isEmail:(NSString *)email;
- (BOOL)ff_isEmail;

/**
 *  Check whether the string is a valid kind of mobile phone format.
 *  Now only check 11 numbers and begin with 1.
 *
 *  @return YES if passed, otherwise false.
 */
+ (BOOL)ff_isMobilePhone:(NSString *)moblie;
- (BOOL)ff_isMobilePhone;

/**
 *  Check whether it is a valid kind of Chinese Persion ID
 *
 *  @return YES if it is valid kind of PID, otherwise false.
 */
+ (BOOL)ff_isPersonID:(NSString *)PID;
- (BOOL)ff_isPersonID;




@end














