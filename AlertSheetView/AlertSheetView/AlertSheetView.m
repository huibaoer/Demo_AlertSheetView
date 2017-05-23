//
//  AlertSheetView.m
//  AlertSheetView
//
//  Created by zhanght on 16/5/20.
//  Copyright © 2016年 zhanght. All rights reserved.
//

#import "AlertSheetView.h"

#define bgViewAlpha 0.6

@interface AlertSheetView ()
@property (nonatomic, assign) AlertSheetStyle style;
@property (nonatomic, copy) AlertSheetViewHandler handler;
@property (nonatomic, strong) UIWindow *backWindow;
@property (nonatomic, strong) UIView *bgView;
@property (strong, nonatomic) IBOutlet UIView *normalAlertView;
@property (strong, nonatomic) IBOutlet UIView *normalSheetView;

@property (nonatomic, strong) UIView *customView;

@property (nonatomic, strong) NSLayoutConstraint *sheetBottomConstraint;
@end

static UIWindow *alertSheetWindow = nil;
@implementation AlertSheetView

- (UIWindow *)backWindow {
    @synchronized (self) {
        if (!alertSheetWindow) {
            alertSheetWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            alertSheetWindow.windowLevel = UIWindowLevelStatusBar+1;
            alertSheetWindow.backgroundColor = [UIColor clearColor];
            alertSheetWindow.hidden = YES;
        }
    }
    return alertSheetWindow;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        
        //window
        [self.backWindow addSubview:self];
        
        //bgView
        self.bgView = [[UIView alloc] init];
        self.bgView.translatesAutoresizingMaskIntoConstraints = NO;
        self.bgView.backgroundColor = [UIColor blackColor];
        self.bgView.alpha = bgViewAlpha;
        [self addSubview:self.bgView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgViewAction)];
        [self.bgView addGestureRecognizer:tap];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //添加self与 window的约束关系
    NSLayoutConstraint *cs = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.backWindow attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    [self.backWindow addConstraint:cs];
    cs = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.backWindow attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    [self.backWindow addConstraint:cs];
    cs = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.backWindow attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    [self.backWindow addConstraint:cs];
    cs = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.backWindow attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    [self.backWindow addConstraint:cs];

    //添加bgView 和 self的约束关系
    cs = [NSLayoutConstraint constraintWithItem:self.bgView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    [self addConstraint:cs];
    cs = [NSLayoutConstraint constraintWithItem:self.bgView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    [self addConstraint:cs];
    cs = [NSLayoutConstraint constraintWithItem:self.bgView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    [self addConstraint:cs];
    cs = [NSLayoutConstraint constraintWithItem:self.bgView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    [self addConstraint:cs];
}

- (void)bgViewAction {
    if (self.tapBackgroundDismiss) {
        [self dismiss];
    }
}

- (void)showAlertWithMessage:(NSString *)message ok:(NSString *)ok cancel:(NSString *)cancel handler:(AlertSheetViewHandler)handler {
    self.handler = handler;
    
    [[NSBundle mainBundle] loadNibNamed:@"AlertSheetView" owner:self options:nil];
    UILabel *label = [self.normalAlertView viewWithTag:102];
    label.text = message;
    UIButton *cancelBtn = [self.normalAlertView viewWithTag:101];
    [cancelBtn setTitle:cancel forState:UIControlStateNormal];
    UIButton *okBtn = [self.normalAlertView viewWithTag:100];
    [okBtn setTitle:ok forState:UIControlStateNormal];
    [self showWithCustomView:self.normalAlertView style:AlertSheetStyleAlert];
}

- (IBAction)alertAction:(UIButton *)sender {
    if (sender.tag == 100) { //确定
        self.handler(0);
    } else if (sender.tag == 101) { //取消
        self.handler(1);
    }
}


- (void)showSheetWithCancelTitle:(NSString *)cancel otherTitles:(NSArray *)titles handler:(AlertSheetViewHandler)handler {
    self.handler = handler;
    
    [[NSBundle mainBundle] loadNibNamed:@"AlertSheetView" owner:self options:nil];
    self.normalSheetView.frame = CGRectMake(0, 0, self.normalSheetView.frame.size.width, (titles.count+1)*50+10);
    UIButton *cancelBtn = [self.normalSheetView viewWithTag:200];
    [cancelBtn setTitle:cancel forState:UIControlStateNormal];
    
    NSLayoutConstraint *cs = nil;
    for (int i = 0; i < titles.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.translatesAutoresizingMaskIntoConstraints = NO;
        btn.tag = 201+i;
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(sheetAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor whiteColor];
        [self.normalSheetView addSubview:btn];
        
        cs = [NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.normalSheetView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
        [self.normalSheetView addConstraint:cs];
        cs = [NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.normalSheetView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
        [self.normalSheetView addConstraint:cs];
        cs = [NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:50];
        [btn addConstraint:cs];
        
        if (i == 0) {
            cs = [NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.normalSheetView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
            [self.normalSheetView addConstraint:cs];
        } else {
            UIButton *lastBtn = [self.normalSheetView viewWithTag:201+i-1];
            cs = [NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:lastBtn attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
            [self.normalSheetView addConstraint:cs];
        }
    }
    [self showWithCustomView:self.normalSheetView style:AlertSheetStyleSheet];
}

- (IBAction)sheetAction:(UIButton *)sender {
    self.handler(sender.tag-200);
}

- (void)showWithCustomView:(UIView *)customView style:(AlertSheetStyle)style {
    self.style = style;
    self.backWindow.hidden = NO;
    self.customView = customView;
    [self addSubview:self.customView];
    self.customView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *cs = nil;
    if (style==AlertSheetStyleAlert) {
        //将subView 按原样大小居中显示
        cs = [NSLayoutConstraint constraintWithItem:self.customView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.customView.frame.size.width];
        [self.customView addConstraint:cs];
        cs = [NSLayoutConstraint constraintWithItem:self.customView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.customView.frame.size.height];
        [self.customView addConstraint:cs];
        cs = [NSLayoutConstraint constraintWithItem:self.customView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
        [self addConstraint:cs];
        cs = [NSLayoutConstraint constraintWithItem:self.customView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
        [self addConstraint:cs];
        
        [UIView animateWithDuration:0 animations:^{
            self.customView.transform = CGAffineTransformMakeScale(0.9, 0.9);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                self.customView.transform = CGAffineTransformMakeScale(1.0, 1.0);
            } completion:^(BOOL finished) {
            }];
        }];
    }else{
        //将subView 按屏幕宽，和原始高 居下显示
        cs = [NSLayoutConstraint constraintWithItem:self.customView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
        [self addConstraint:cs];
        cs = [NSLayoutConstraint constraintWithItem:self.customView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.customView.frame.size.height];
        [self.customView addConstraint:cs];
        cs = [NSLayoutConstraint constraintWithItem:self.customView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
        [self addConstraint:cs];
        cs = [NSLayoutConstraint constraintWithItem:self.customView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
        [self addConstraint:cs];
        
        self.sheetBottomConstraint = [NSLayoutConstraint constraintWithItem:self.customView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
        [self addConstraint:self.sheetBottomConstraint];
        [self layoutIfNeeded];
        
        [UIView animateWithDuration:0 animations:^{
            self.sheetBottomConstraint.constant = 0;
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 animations:^{
                self.sheetBottomConstraint.constant = -self.customView.frame.size.height;
                [self layoutIfNeeded];
            }];
        }];
    }
}

- (void)dismiss {
    if (self.style == AlertSheetStyleAlert) {
        [UIView animateWithDuration:0.2 animations:^{
            self.customView.transform = CGAffineTransformMakeScale(0.1, 0.1);
            self.bgView.backgroundColor = [self.bgView.backgroundColor colorWithAlphaComponent:0.1];
        } completion:^(BOOL finished) {
            self.backWindow.hidden = YES;
            self.customView.transform = CGAffineTransformMakeScale(1, 1);
            [self removeFromSuperview];
        }];
    } else if (self.style == AlertSheetStyleSheet) {
        [UIView animateWithDuration:0.3 animations:^{
            self.sheetBottomConstraint.constant = self.customView.frame.size.height;
            self.bgView.backgroundColor = [self.bgView.backgroundColor colorWithAlphaComponent:0.1];
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.backWindow.hidden = YES;
            [self removeFromSuperview];
        }];
    }
}



@end
