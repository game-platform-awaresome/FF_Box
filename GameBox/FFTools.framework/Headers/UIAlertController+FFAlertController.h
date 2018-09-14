//
//  UIAlertController+FFAlertController.h
//
//  Created by 燚 on 2018/1/17.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^FF_AlertCallBackBlock)(NSInteger btnIndex);
typedef void(^FF_DismissBlock)(void);

@interface UIAlertController (FFAlertController)


/**
 *  Show alert message with UIApplication delegate root viewcontroller.
 *
 *  Dismiss time default 0.7 second
 */
void ff_showAlertMessage(NSString * message);
/**
 *  Show alert message with UIApplication delegate root viewcontroller.
 *
 *  @param time             dismis time
 */
void ff_showAlertMessageWithDismissTime(NSString * message, float time);
/**
 *  Show alert message with UIApplication delegate root viewcontroller.
 *
 *  @param btnTitle         Button title
 *  @param block            Click button call back block
 */
void ff_showAlertMessageWithButton(NSString *message, NSString *btnTitle,FF_AlertCallBackBlock block);
/**
 *  Show alert message with UIApplication delegate root viewcontroller.
 *
 *  @param cancelBtnTitle   Cancel button title.
 *  @param sureBtnTitle     Sucre button title.
 *  @param block            Click button call back block.
 */
void ff_showAlertMessageWith2Button(NSString *message, NSString *cancelBtnTitle, NSString *sureBtnTitle, FF_AlertCallBackBlock block);
/**
 *  Unfinished method
 */
UIAlertController * ff_showAlert(UIViewController *controller,
                                 UIAlertControllerStyle alertControllerStyle,
                                 NSString * title,
                                 NSString * message,
                                 NSString * cancelBtnTitle,
                                 NSString * destructiveBtnTitle,
                                 FF_AlertCallBackBlock block,
                                 NSString * otherBtnTitles,...)__attribute__((deprecated("Not doing well")));


/**
 *  @param viewController       presrent view controller
 *  @param alertControllerStyle UIAlertControllerStyle
 *  @param title                title
 *  @param message              message
 *  @param block                call back block
 *  @param cancelBtnTitle       cancel button title
 *  @param destructiveBtnTitle  destructivew button title
 *  @param otherBtnTitles       other button title
 */
+ (UIAlertController *)showAlertControllerWithViewController:(UIViewController*)viewController
                                        alertControllerStyle:(UIAlertControllerStyle)alertControllerStyle
                                                       title:(NSString*)title
                                                     message:(NSString*)message
                                           cancelButtonTitle:(NSString *)cancelBtnTitle
                                      destructiveButtonTitle:(NSString *)destructiveBtnTitle
                                               CallBackBlock:(FF_AlertCallBackBlock)block
                                           otherButtonTitles:(NSString *)otherBtnTitles,...NS_REQUIRES_NIL_TERMINATION;

/**
 *  @param viewController       presrent view controller
 *  @param alertControllerStyle UIAlertControllerStyle
 *  @param title                title
 *  @param message              message
 *  @param block                call back block
 *  @param cancelBtnTitle       cancel button title
 *  @param otherArray           other button title
 *  @param destructiveBtnTitle  destructivew button title
 */
+ (UIAlertController *)showAlertControllerWithViewController:(UIViewController*)viewController
                                        alertControllerStyle:(UIAlertControllerStyle)alertControllerStyle
                                                       title:(NSString*)title
                                                     message:(NSString*)message
                                           cancelButtonTitle:(NSString *)cancelBtnTitle
                                      destructiveButtonTitle:(NSString *)destructiveBtnTitle
                                           otherButtonTitles:(NSArray *)otherArray
                                               CallBackBlock:(FF_AlertCallBackBlock)block;

/**
 *  Simple show alert
 *  @param   title   title
 *  @param   message message
 *  @param   second  if second is greater than zero , do not deal with alertControler
 */
+ (void)showAlertWithTitle:(NSString *)title
                   Message:(NSString *)message
               dismissTime:(CGFloat)second
              dismissBlock:(FF_DismissBlock)block;


+ (void)showAlertMessage:(NSString *)message
             dismissTime:(CGFloat)second
            dismissBlock:(FF_DismissBlock)block;




@end
