//
//  ViewController.m
//  DHConcurrentAnimation
//
//  Created by Huang Hongsen on 9/7/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "ViewController.h"

#import "DHTextureLoader.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
//    imageView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, -M_PI / 6);
//    imageView.image = [UIImage imageNamed:@"1.jpg"];
//    
//    [DHTextureLoader loadTextureWithView:imageView];
//    [self.view addSubview:imageView];
//    
//    [DHTextureLoader loadTextureWithImage:[UIImage imageNamed:@"2.jpg"]];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"y it Out" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:32]}];
    NSAttributedString *anotherAttrString = [[NSAttributedString alloc] initWithString:@"谢谢你" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:50]}];
    [attrString appendAttributedString:anotherAttrString];
    [DHTextureLoader loadTextureWithAttributedString:attrString];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
