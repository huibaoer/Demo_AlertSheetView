//
//  AlertSheetView.h
//  AlertSheetView
//
//  Created by zhanght on 16/5/20.
//  Copyright © 2016年 zhanght. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, AlertSheetStyle) {
    AlertSheetStyleAlert,//!< 从中间弹出的方式显示自定义view，不改变view的大小
    AlertSheetStyleSheet,//!< 从下面推出的方式显示自定义view，添加约束修改view的宽度为屏幕宽
};

typedef void(^AlertSheetViewHandler)(NSUInteger tapButtonIndex);

/**
 *  AlertSheetView用来以Alert和Sheet两种方式弹出自定义的视图，自定义视图内需要使用自动布局。
 */
@interface AlertSheetView : UIView
@property (nonatomic, assign) BOOL tapBackgroundDismiss;// 点击背景是否dismiss，默认为NO

/**
 *  显示通用alert
 *
 *  @param message 消息文本
 *  @param ok      确认
 *  @param cancel  取消
 *  @param handler
 */
- (void)showAlertWithMessage:(NSString *)message ok:(NSString *)ok cancel:(NSString *)cancel handler:(AlertSheetViewHandler)handler;

/**
 *  显示通用sheet
 *
 *  @param cancel  取消button
 *  @param titles  其他button
 *  @param handler
 */
- (void)showSheetWithCancelTitle:(NSString *)cancel otherTitles:(NSArray *)titles handler:(AlertSheetViewHandler)handler;

/**
 *  用指定的方式弹出自定义视图
 *
 *  @param customView 自定义视图，一般是VC内的xib view
 *  @param style   弹出方式
 */
- (void)showWithCustomView:(UIView *)customView style:(AlertSheetStyle)style;

/**
 *  解散弹出视图
 */
- (void)dismiss;
@end
