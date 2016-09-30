//
//  UserInfoController.m
//  Image viewer
//
//  Created by ZC on 2016/9/27.
//  Copyright © 2016年 zc. All rights reserved.
//

#import "UserInfoController.h"
#import "SVProgressHUD.h"
#import "TMCache.h"
#import "UIView+ZCFrame.m"
#import "Masonry.h"

@interface UserInfoController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,UITextViewDelegate,UITextFieldDelegate>
{
    NSData *_headerImageData;
    CGFloat _keyboardHeight;
}
@end

@implementation UserInfoController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    
}


- (void)setUI
{
    
    self.headerImageButton.layer.cornerRadius = 75;
    self.headerImageButton.backgroundColor = [UIColor clearColor];
    UIImage *image = [[TMCache sharedCache] objectForKey:@"headImage"];
    if (image) {
        [_headerImageButton setImage:image forState:UIControlStateNormal];
    }

    
    
    
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userImageData"];
    if (dict) {
        NSString *name = dict[@"userName"];
        NSString *desc = dict[@"userDesc"];
        if (name) {
            self.userNameTextField.text = name;
        }
        if (desc.length > 0) {
            self.descriptionTextView.text = desc;
            self.morenLabel.hidden = YES;
            self.descHeight.constant = [self sizeForText:desc].height + 10;
        }

    }
    
    
    
    self.descriptionTextView.delegate = self;
    self.descriptionTextView.layer.cornerRadius = 5;
    
    self.userNameTextField.delegate =self;
    
}




- (IBAction)saveButtonClick:(UIButton *)sender
{
    if (self.userNameTextField.text.length > 0) {
        
        NSDictionary *dict = @{@"userName":_userNameTextField.text,@"userDesc":_descriptionTextView.text};
        [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"userImageData"];
        
        [[TMCache sharedCache] setObject:self.headerImageButton.imageView.image forKey:@"headImage" block:^(TMCache *cache, NSString *key, id object) {
            [SVProgressHUD setMinimumDismissTimeInterval:1.5];
            [SVProgressHUD showSuccessWithStatus:@"保存成功"];
        }];
        
        [self.navigationController popViewControllerAnimated:YES];
        
        
       
    }
    else {
        
        [SVProgressHUD setMinimumDismissTimeInterval:0.8];
        [SVProgressHUD showErrorWithStatus:@"用户名不能为空"];
        
    }
    

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)headerButtonClick:(UIButton *)sender
{
    
    [self selectHeadImageFromPhoto];
}


- (void)selectHeadImageFromPhoto
{
    //列表
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择头像" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    /**
     *  从相册中选取
     */
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"从相册中选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self imageFromPhoto];
    }];
    
    /**
     *  拍摄获取
     */
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self imageFromCamera];
    }];
    
    /**
     *  取消
     */
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    //添加按钮
    [alertController addAction:photoAction];
    [alertController addAction:cameraAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)imageFromCamera
{
    //判断拍摄能不能用
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"拍照功能不能用" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil] show];
        
        return;
    }
    
    /**
     *  从相册获取摄像头获取
     */
    [self initImagePickerControllerWithSourceType:UIImagePickerControllerSourceTypeCamera];
    
}

- (void)imageFromPhoto
{
    /**
     *  从相册获取摄像头获取
     */
    [self initImagePickerControllerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];;
}

- (void)initImagePickerControllerWithSourceType:(UIImagePickerControllerSourceType)sourceType
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = sourceType;
    imagePickerController.delegate = self;
    //允许编辑
    imagePickerController.allowsEditing = YES;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSLog(@"%@",info);
    
#if 0
    //获取原始图片
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
#endif
    //获取编辑后的图片
    UIImage *editImage = info[UIImagePickerControllerEditedImage];
    NSData *data = nil;
    if (UIImagePNGRepresentation(editImage) == nil) {
        
        data = UIImageJPEGRepresentation(editImage, 1);
        
    } else {
        
        data = UIImagePNGRepresentation(editImage);
    }
    
    //修改头像
    [_headerImageButton setImage:editImage forState:UIControlStateNormal];
    
    //隐藏控制器
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    
    self.descHeight.constant = [self sizeForText:textView.text].height + 10;
    
    
    
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder]; //［要实现的方法］
        self.view.zcTop = 0;
        return NO;
        
    }
    if (textView.text.length > 0) {
        self.morenLabel.hidden = YES;
    }
    else {self.morenLabel.hidden = NO;}
    return YES;
    
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    self.view.zcTop = 0;
    return YES;
}

- (CGSize)sizeForText:(NSString *)string
{
    return [string boundingRectWithSize:CGSizeMake(self.descWidth.constant - 10  , MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]} context:nil].size;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

-(void)dealloc
{
    NSLog(@"UserInfoController dealloc");
}

@end
