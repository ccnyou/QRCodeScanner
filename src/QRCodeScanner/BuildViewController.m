//
//  BuildViewController.m
//  QRCodeScanner
//
//  Created by ervinchen on 2019/3/13.
//  Copyright © 2019年 ccnyou. All rights reserved.
//

#import "BuildViewController.h"
#import "SystemCodeZipper.h"

@interface BuildViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UIButton *buildButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIImageView *resultImageView;
@end

@implementation BuildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.textView.layer.borderWidth = GetPixelPoint(1);
    
    self.resultImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.resultImageView.layer.borderWidth = GetPixelPoint(1);
}

- (IBAction)onBuildTouched:(id)sender {
}

- (IBAction)onSaveTouched:(id)sender {
}

@end
