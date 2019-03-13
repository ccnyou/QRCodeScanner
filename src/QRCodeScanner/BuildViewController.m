//
//  BuildViewController.m
//  QRCodeScanner
//
//  Created by ervinchen on 2019/3/13.
//  Copyright © 2019年 ccnyou. All rights reserved.
//

#import "BuildViewController.h"
#import "SystemCodeZipper.h"
#import "TOCropViewController.h"
#import "UIView+Toast.h"
#import "WSLNativeScanTool.h"

@interface BuildViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, TOCropViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UIButton *buildButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIImageView *resultImageView;
@property (nonatomic, strong) UIImage *selectedImage;
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
    NSString *text = self.textView.text;
    if (text.length <= 0) {
        self.saveButton.enabled = NO;
        return;
    }
    
    self.saveButton.enabled = YES;
    CGSize size = self.resultImageView.frame.size;
    self.resultImageView.image = [WSLNativeScanTool createQRCodeImageWithString:self.textView.text
                                                                      andSize:size
                                                                 andBackColor:[UIColor whiteColor]
                                                                andFrontColor:[UIColor blackColor]
                                                               andCenterImage:self.selectedImage];
}

- (IBAction)onSaveTouched:(id)sender {
    UIImage *image = self.resultImageView.image;
    if (!image) {
        return;
    }
    
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
{
    if (!error) {
        [self.view makeToast:@"保存成功!"];
    } else {
        [self.view makeToast:@"保存失败！"];
    }
}

- (IBAction)onSelectTouched:(id)sender {
    if (self.selectedImage) {
        self.selectedImage = nil;
        [self.selectButton setImage:[UIImage imageNamed:@"select_pic_normal"]
                           forState:UIControlStateNormal];
    } else {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.delegate = self;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

- (void)_presentCropViewController:(UIImage *)image {
    TOCropViewController *cropViewController = [[TOCropViewController alloc] initWithImage:image];
    cropViewController.delegate = self;
    [self presentViewController:cropViewController animated:YES completion:nil];
}

#pragma mark - TOCropViewController

- (void)cropViewController:(TOCropViewController *)cropViewController
            didCropToImage:(UIImage *)image
                  withRect:(CGRect)cropRect
                     angle:(NSInteger)angle
{
    self.selectedImage = image;
    self.selectButton.contentMode = UIViewContentModeScaleAspectFit;
    self.selectButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.selectButton setImage:image forState:UIControlStateNormal];
    [cropViewController dismissViewControllerAnimated:YES
                                           completion:nil];
}

#pragma mark - Image Picker

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        NSString *key = nil;
        if (picker.allowsEditing) {
            key = UIImagePickerControllerEditedImage;
        } else {
            key = UIImagePickerControllerOriginalImage;
        }
        
        UIImage *image = [info objectForKey:key];
        [picker dismissViewControllerAnimated:NO completion:nil];
        [self _presentCropViewController:image];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
