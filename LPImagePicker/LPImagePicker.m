// The MIT License (MIT)
//
// Copyright (c) 2017-2018 litt1e-p ( https://github.com/litt1e-p )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#import "LPImagePicker.h"
#import "LPImageGridView.h"
#import "LPPhotoViewer.h"

#define kLPImagePickerTintColor [UIColor colorWithRed:31/255.f green:185/255.f blue:34/255.f alpha:1.f]
#define kLPImagePickerLightTintColor [UIColor colorWithRed:31/255.f green:185/255.f blue:34/255.f alpha:0.5f]

@interface LPImagePicker ()<LPImageGridViewDelegate>

@property (nonatomic, strong) UIButton *funcBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) NSArray *selectedIndexes;
@end

@implementation LPImagePicker

- (instancetype)init
{
    LPImageGridView *gv = [[LPImageGridView alloc] init];
    if (self = [super initWithRootViewController:gv]) {
        
    }
    return self;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    LPImageGridView *gv                   = (LPImageGridView *)self.topViewController;
    gv.btnTintColor                       = self.pickerTintColor;
    gv.removeDiskCacheWhenSelectImage     = self.removeDiskCacheWhenSelectImage;

    UIBarButtonItem *leftBtn              = [[UIBarButtonItem alloc] initWithTitle:[self locStr:@"Done"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBtnEvent)];
    leftBtn.tintColor                     = self.pickerTintColor ? : kLPImagePickerTintColor;
    gv.navigationItem.leftBarButtonItem   = leftBtn;

    self.rightBtn.frame                   = CGRectMake(0, 0, 70, 44);
    [self.rightBtn setTitleColor:self.pickerTintColor ? : kLPImagePickerTintColor forState:UIControlStateNormal];
    UIBarButtonItem *rightBarBtn          = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
    UIBarButtonItem *spaceFixBtn          = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceFixBtn.width                     = -16;
    gv.navigationItem.rightBarButtonItems = @[spaceFixBtn, rightBarBtn];

    self.selectedIndexes                  = nil;
    self.rightBtn.hidden                  = self.images.count <= 0;
}

- (UIButton *)rightBtn
{
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setTitle:[self locStr:@"Edit"] forState:UIControlStateNormal];
        [_rightBtn setTitle:[self locStr:@"Cancel"] forState:UIControlStateSelected];
        [_rightBtn addTarget:self action:@selector(rightBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

- (void)showToolBar:(BOOL)show
{
    if (!show) {
        [self setToolbarHidden:YES animated:YES];
    } else {
        LPImageGridView *gv = (LPImageGridView *)self.topViewController;
        [self setToolbarHidden:NO animated:YES];
        
        CGFloat titleW = 65;
        UIFont *funcBtnFont = self.funcBtnTitleFont ? : [UIFont systemFontOfSize:16.f];
        if (self.funcBtnTitle) {
            //            titleW = [self.funcBtnTitle sizeWithAttributes:@{NSFontAttributeName:funcBtnFont}].width + 6;
            titleW = [self.funcBtnTitle boundingRectWithSize:CGSizeMake(MAXFLOAT, 30)
                                                     options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                  attributes:@{NSFontAttributeName:funcBtnFont}
                                                     context:nil].size.width + 6;
        }
        
        self.tipLabel               = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, gv.view.bounds.size.width - titleW - 16 - 16, 40)];
        //    _tipLabel.textColor     = [UIColor colorWithRed:51/255.f green:51/255.f blue:51/255.f alpha:1.f];
        self.tipLabel.textColor = self.pickerTintColor ? : kLPImagePickerTintColor;
        self.tipLabel.textAlignment = NSTextAlignmentLeft;
        self.tipLabel.font          = [UIFont systemFontOfSize:18.f];
        self.tipLabel.text          = [NSString stringWithFormat:@"0 %@", [self locStr:@"chose"]];
        UIBarButtonItem *tipBtn =[[UIBarButtonItem alloc] initWithCustomView:self.tipLabel];
        
        self.funcBtn                     = [UIButton buttonWithType:UIButtonTypeCustom];
        self.funcBtn.layer.cornerRadius  = 5.f;
        self.funcBtn.layer.masksToBounds = YES;
        self.funcBtn.titleEdgeInsets     = UIEdgeInsetsMake(3, 3, 3, 3);
        [self.funcBtn setTitle:self.funcBtnTitle ? : [self locStr:@"Delete"] forState:UIControlStateNormal];
        [self.funcBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.funcBtn.titleLabel.font = funcBtnFont;
        [self.funcBtn setBackgroundColor:self.pickerTintColor ? : kLPImagePickerTintColor];
        [self.funcBtn addTarget:self action:@selector(funcBtnEvent) forControlEvents:UIControlEventTouchUpInside];
        self.funcBtn.frame           = CGRectMake(0, 0, titleW, 30);
        UIBarButtonItem *funcBtn = [[UIBarButtonItem alloc] initWithCustomView:self.funcBtn];
        [gv setToolbarItems:@[tipBtn, funcBtn] animated:YES];
    }
}

- (void)leftBtnEvent
{
    __weak typeof(self)ws = self;
    [self dismissViewControllerAnimated:YES completion:^{
        if (ws.leftBtnClosure) {
            ws.leftBtnClosure();
        }
    }];
}

- (void)rightBtnEvent
{
    [self reactRightBtnState:!self.rightBtn.selected];
}

- (void)reactRightBtnState:(BOOL)selected
{
    self.rightBtn.hidden   = self.images.count <= 0;
    self.rightBtn.selected = selected;
    LPImageGridView *gv    = (LPImageGridView *)self.topViewController;
    gv.enableEditState     = self.rightBtn.selected;
    gv.title               = gv.enableEditState ? [self locStr:@"Choose"] : nil;
    [self showToolBar:gv.enableEditState];
}

- (void)setSelectedIndexes:(NSArray *)selectedIndexes
{
    _selectedIndexes     = selectedIndexes;
    self.funcBtn.enabled = selectedIndexes.count > 0;
    UIColor *nColor      = self.pickerTintColor ? : kLPImagePickerTintColor;
    UIColor *lColor      = self.pickerTintColor ? [self.pickerTintColor colorWithAlphaComponent:0.5] : kLPImagePickerLightTintColor;
    [self.funcBtn setBackgroundColor:selectedIndexes.count > 0 ? nColor : lColor ];
    self.tipLabel.alpha  = selectedIndexes.count > 0 ? 1.f : 0.8f;
}

- (void)setImages:(NSArray *)images
{
    _images             = images;
    LPImageGridView *gv = (LPImageGridView *)self.topViewController;
    gv.images           = [_images copy];
    gv.delegate         = self;
    [self reactRightBtnState:NO];
}

- (void)funcBtnEvent
{
    if (self.funcBtnClosure) {
        self.funcBtnClosure(self, [self.selectedIndexes copy]);
    }
}

- (NSString *)locStr:(NSString *)str
{
    NSBundle *resourceBundle = nil;
    NSBundle *classBundle = [NSBundle bundleForClass:[self class]];
    NSURL *resourceBundleURL = [classBundle URLForResource:@"LPImagePickerBundle" withExtension:@"bundle"];
    if (resourceBundleURL) {
        resourceBundle = [[NSBundle alloc] initWithURL:resourceBundleURL];
    } else {
        resourceBundle = classBundle;
    }
    return NSLocalizedStringFromTableInBundle(str, @"LPImagePickerLocalizable", resourceBundle, nil);
}

#pragma mark - LPImageGridViewDelegate 📌
- (void)imageGridView:(LPImageGridView *)imageGridView didPickedImagesWithIndexes:(NSArray *)indexes
{
    self.selectedIndexes = indexes;
    self.tipLabel.text   = [NSString stringWithFormat:@"%zi %@", indexes.count, [self locStr:@"chose"]];
}

- (void)imageGridView:(LPImageGridView *)imageGridView didSelectedImageWithIndex:(NSInteger)index
{
    //show photoViewer
    LPPhotoViewer *viewer = [[LPPhotoViewer alloc] init];
    viewer.imgArr         = [self.images copy];
    viewer.currentIndex   = index;
    viewer.indicatorType  = IndicatorTypeNumLabel;
    [viewer showFromViewController:self sender:nil];
}

@end
