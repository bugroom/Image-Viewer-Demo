//
//  UserInfoController.m
//  Image viewer
//
//  Created by ZC on 2016/9/27.
//  Copyright © 2016年 zc. All rights reserved.
//

#import "UserInfoController.h"

@interface UserInfoController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>

@end

@implementation UserInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.headerImageButton.layer.cornerRadius = 75;
    NSData *data = [[NSUserDefaults standardUserDefaults] valueForKey:@"userImageData"];
    [_headerImageButton setBackgroundImage:[UIImage imageWithData:data] forState:UIControlStateNormal];

 
}

- (IBAction)saveButtonClick:(UIButton *)sender
{
    if (self.userNameTextField.text.length > 0) {
        [[[UIAlertView alloc]initWithTitle:@"提醒" message:@"保存成功" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil] show];
        
    }
    else {
        [[[UIAlertView alloc]initWithTitle:@"提醒" message:@"用户名不能为空" delegate:nil cancelButtonTitle:@"返回" otherButtonTitles:nil, nil] show];
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
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"userImageData"];
    //修改头像
    [_headerImageButton setBackgroundImage:editImage forState:UIControlStateNormal];
    
    //隐藏控制器
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
