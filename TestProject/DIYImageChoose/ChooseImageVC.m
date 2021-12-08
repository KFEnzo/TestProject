//
//  ChooseImageVC.m
//  TestProject
//
//  Created by fandeng on 2018/8/17.
//  Copyright © 2018年 Jia. All rights reserved.
//

#import "ChooseImageVC.h"
//#import "RHPhotoAlbumDetailViewController.h"
#import "DIYTakePhotoViewController.h"

@interface ChooseImageVC ()
@property(nonatomic, strong) UIImageView *imageView;
@end

@implementation ChooseImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"选择图片";
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    button.center = CGPointMake(self.view.center.x, 40);
    [button setTitle:@"选择图片" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickChooseImage:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    self.imageView.frame = CGRectMake(10, 60, self.view.frame.size.width - 20, (self.view.frame.size.width - 20)*4.0/3);
    self.imageView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.imageView];
}

- (void)clickChooseImage:(UIButton *)bt{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    __weak typeof(self) weakSelf = self;
    [alertC addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        DIYTakePhotoViewController *takePhotoVC = [[DIYTakePhotoViewController alloc] init];
        takePhotoVC.takePhotoBlock = ^(UIImage *photoImage) {
            //保存图片
            weakSelf.imageView.image = photoImage;
        };
        [self presentViewController:takePhotoVC animated:YES completion:nil];
    }]];
//    [alertC addAction:[UIAlertAction actionWithTitle:@"相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        RHPhotoAlbumDetailViewController *vc = [[RHPhotoAlbumDetailViewController alloc] init];
//        vc.maxNum = @(0);
//        vc.EditPhotoBlock = ^(UIImage *photoImage) {
//            //保存图片
//            weakSelf.imageView.image = photoImage;
//        };
//        UINavigationController *navVc = [[UINavigationController alloc] initWithRootViewController:vc];
//        [self presentViewController:navVc animated:YES completion:nil];
//    }]];
    
    [self presentViewController:alertC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Set And Get
- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
