//
//  ViewController.m
//  LPImagePickerSample
//
//  Created by litt1e-p on 2017/7/12.
//  Copyright © 2017年 litt1e-p. All rights reserved.
//

#import "ViewController.h"
#import "LPImageGridView.h"
#import "LPImagePicker.h"
#import <LPPhotoViewer.h>

@interface ViewController ()<LPImageGridViewDelegate>

@property (nonatomic, strong) NSArray *imgArr;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imgArr = @[@"http://ww2.sinaimg.cn/thumbnail/904c2a35jw1emu3ec7kf8j20c10epjsn.jpg",
                        @"http://ww2.sinaimg.cn/thumbnail/98719e4agw1e5j49zmf21j20c80c8mxi.jpg",
                        @"http://ww2.sinaimg.cn/thumbnail/67307b53jw1epqq3bmwr6j20c80axmy5.jpg",
                        @"http://ww2.sinaimg.cn/thumbnail/9ecab84ejw1emgd5nd6eaj20c80c8q4a.jpg",
                        @"http://ww2.sinaimg.cn/thumbnail/642beb18gw1ep3629gfm0g206o050b2a.gif",
                        @"http://www.megghy.com/gif_animate/alfabeti_2/dondolo/images/A.gif",
                        @"https://d13yacurqjgara.cloudfront.net/users/3460/screenshots/1667332/pickle.png",
                        @"https://d13yacurqjgara.cloudfront.net/users/610286/screenshots/2012918/eggplant.png",
                        @"https://d13yacurqjgara.cloudfront.net/users/514774/screenshots/1985501/ill_2-01.png",
                        @"http://wx1.sinaimg.cn/large/bfc243a3gy1febm7n9eorj20i60hsann.jpg",
                        @"http://wx3.sinaimg.cn/large/bfc243a3gy1febm7nzbz7j20ib0iek5j.jpg",
                        @"http://wx1.sinaimg.cn/large/bfc243a3gy1febm7orgqfj20i80ht15x.jpg",
                        @"http://wx2.sinaimg.cn/large/bfc243a3gy1febm7pmnk7j20i70jidwo.jpg",
                        @"http://wx3.sinaimg.cn/large/bfc243a3gy1febm7qjop4j20i00hw4c6.jpg",
                        @"http://wx4.sinaimg.cn/large/bfc243a3gy1febm7rncxaj20ek0i74dv.jpg",
                        @"http://wx2.sinaimg.cn/large/bfc243a3gy1febm7sdk4lj20ib0i714u.jpg",
                        @"http://wx4.sinaimg.cn/large/bfc243a3gy1febm7tekewj20i20i4aoy.jpg",
                        @"http://wx3.sinaimg.cn/large/bfc243a3gy1febm7usmc8j20i543zngx.jpg",
                        @"https://img3.doubanio.com/view/photo/albumcover/public/p2472871172.webp",
                    @"https://img3.doubanio.com/view/photo/albumcover/public/p2489013025.webp",
                    @"https://img3.doubanio.com/view/photo/albumcover/public/p2454969362.webp",
                    @"https://img1.doubanio.com/view/photo/albumcover/public/p2433324478.webp",
                    @"https://upload-images.jianshu.io/upload_images/2312324-8497cd2fe6c72b90.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1080/q/50",
                    @"http://pic1.win4000.com/wallpaper/c/596734f46b2bd_270_185.jpg",
                    @"https://img3.doubanio.com/view/group_topic/llarge/public/p78882901.webp",
                    @"https://img1.doubanio.com/view/group_topic/llarge/public/p78882908.webp",
                    @"https://img3.doubanio.com/view/group_topic/llarge/public/p78882895.webp",
                    @"https://img3.doubanio.com/view/group_topic/llarge/public/p78882896.webp",
                    @"https://img3.doubanio.com/view/group_topic/llarge/public/p78882890.webp",
                    @"https://img1.doubanio.com/view/group_topic/llarge/public/p78882897.webp",
                        ];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    [self showGridView];
    [self showPickerView];
}

- (void)showPickerView
{
    LPImagePicker *pk     = [[LPImagePicker alloc] init];
    pk.images             = [self.imgArr copy];
    pk.pickerTintColor    = [UIColor redColor];
    pk.funcBtnTitle       = @"export";
    __weak typeof(pk)wspk = pk;
    __weak typeof(self)ws = self;
    pk.funcBtnClosure     = ^(NSArray *selectedIndexes) {
        NSLog(@"selectedIndexes: %zi", selectedIndexes.count);
        [ws updateImagesWithExclusiveIndexes:selectedIndexes];
        wspk.images = [ws.imgArr copy];
    };
    pk.leftBtnClosure = ^{
        [ws dismissViewControllerAnimated:wspk completion:nil];
    };
    [self presentViewController:pk animated:YES completion:nil];
}

- (void)showGridView
{
    LPImageGridView *pc = [[LPImageGridView alloc] initWithImages:self.imgArr];
    pc.btnTintColor     = [UIColor blackColor];
    pc.enableEditState  = NO;
    pc.delegate         = self;
    [self.navigationController pushViewController:pc animated:YES];
}

- (void)updateImagesWithExclusiveIndexes:(NSArray *)indexes
{
    NSMutableArray *tempImgArr = (NSMutableArray *)[self.imgArr mutableCopy];
    NSMutableArray *tempArr = [NSMutableArray array];
    for (int i = 0; i < indexes.count; i++) {
        [tempArr addObject:[self.imgArr objectAtIndex:[indexes[i] integerValue]]];
    }
    [tempImgArr removeObjectsInArray:tempArr];
    self.imgArr = tempImgArr;
}

#pragma mark - LPImagePickerControllerDelegate 📌

- (void)didPickedImagesWithIndexs:(NSArray *)indexs
{
    NSLog(@"%@", indexs);
}

- (void)didSelectedImageWithIndex:(NSInteger)index
{
    //show photoViewer
    LPPhotoViewer *viewer = [[LPPhotoViewer alloc] init];
    viewer.imgArr         = [self.imgArr copy];
    viewer.currentIndex   = index;
    viewer.indicatorType  = IndicatorTypeNumLabel;
    [viewer showFromViewController:self sender:nil];
}

@end
