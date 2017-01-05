//
//  WDTailoringImageController.h
//  WDImagePickerManagerDemo
//
//  Created by cehae on 17/1/5.
//  Copyright © 2017年 WD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WDTailoringImageController;

@protocol WDTailoringImageControllerDelegate <NSObject>
-(void)TailoringImageController:(WDTailoringImageController *) controller TailoringImage:(UIImage *)image;
@end

@interface WDTailoringImageController : UIViewController
@property (nonatomic,weak)id<WDTailoringImageControllerDelegate> delegate;
@property (nonatomic,assign) CGSize clipSize;
@property (nonatomic,strong) UIImage * img;
@end
