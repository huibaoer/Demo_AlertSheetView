//
//  RootViewController.m
//  AlertSheetView
//
//  Created by zhanght on 16/5/20.
//  Copyright © 2016年 zhanght. All rights reserved.
//

#import "RootViewController.h"
#import "AlertSheetView.h"

@interface RootViewController () <UITableViewDataSource, UITabBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) AlertSheetView *customSheet;
@property (strong, nonatomic) IBOutlet UIView *customSheetView;

@property (strong, nonatomic) AlertSheetView *customAlert;
@property (strong, nonatomic) IBOutlet UIView *customAlertView;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"normalCell"];
}

#pragma mark - tableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"normalCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"show alert";
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"show custom alert";
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"show actionSheet";
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"show custom actionSheet";
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            AlertSheetView *alert = [[AlertSheetView alloc] init];
            [alert showAlertWithMessage:@"这是一个通用的alert这是一个通用的alert这是一个通用的alert这是一个通用的alert" ok:@"好的" cancel:@"取消吧" handler:^(NSUInteger tapButtonIndex) {
                if (tapButtonIndex == 0) {
                    NSLog(@"-- ht log -- 点击了ok");
                } else if (tapButtonIndex == 1) {
                    NSLog(@"-- ht log -- 点击了取消");
                }
                [alert dismiss];
            }];
        } else if (indexPath.row == 1) {
            self.customAlert = [[AlertSheetView alloc] init];
            self.customAlert.tapBackgroundDismiss = YES;
            [self.customAlert showWithCustomView:self.customAlertView style:AlertSheetStyleAlert];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            AlertSheetView *sheet = [[AlertSheetView alloc] init];
            [sheet showSheetWithCancelTitle:@"取消吧" otherTitles:@[@"btn1", @"btn2", @"btn3", @"btn4"] handler:^(NSUInteger tapButtonIndex) {
                NSLog(@"-- ht log -- %lu", (unsigned long)tapButtonIndex);
                [sheet dismiss];
            }];
            
        } else if (indexPath.row == 1) {
            self.customSheet = [[AlertSheetView alloc] init];
            self.customSheet.tapBackgroundDismiss = YES;
            [self.customSheet showWithCustomView:self.customSheetView style:AlertSheetStyleSheet];
        }
    }
}
- (IBAction)customSheetAction:(UIButton *)sender {
    if (sender.tag == 100) {
        NSLog(@"--zhanght-- customSheet cancel action");
    } else if (sender.tag == 101) {
        NSLog(@"--zhanght-- customSheet ok action");
    }
    [self.customSheet dismiss];
}
- (IBAction)customAlertAction:(id)sender {
    NSLog(@"--zhanght-- you tap the customAlert button");
    [self.customAlert dismiss];
}



@end
