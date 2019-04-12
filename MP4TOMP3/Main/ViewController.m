//
//  ViewController.m
//  MP4TOMP3
//
//  Created by iOS on 2019/3/20.
//  Copyright © 2019 iOS. All rights reserved.
//

#import "ViewController.h"
#import "AXWebViewController.h"
#import "HistyViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIView *img;
@property (weak, nonatomic) IBOutlet UIView *video;
@property (weak, nonatomic) IBOutlet UIView *about;

@end

@implementation ViewController

-(void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setViews];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(send) name:@"LOADDATASUCCESS" object:nil];
    
}
- (IBAction)histyOnCLick:(id)sender {
    UIViewController *histy = [HistyViewController new];
    [self.navigationController pushViewController:histy animated:YES];
}

- (void)send {
    NSLog(@"数据请求成功");
    NSString *op = [AppManager shareInstance].userof;
    if ([op isEqualToString:@"1"]) {
        AXWebViewController *VC = [[AXWebViewController alloc] initWithAddress:[AppManager shareInstance].useropen];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:VC];
        [self presentViewController:nav animated:YES completion:^{
            [VC doneHidden];
        }];
        VC.showsToolBar = YES;
        VC.navigationType = 1;
        
    }else {
        NSLog(@"nothing");
    }
}


- (void)setViews {
    self.img.layer.cornerRadius  =5.0f;
    self.img.clipsToBounds = YES;
    self.img.backgroundColor = [UIColor flatPowderBlueColor];
    
    self.video.layer.cornerRadius  =5.0f;
    self.video.clipsToBounds = YES;
    self.video.backgroundColor = [UIColor flatSandColor];
    
    self.about.layer.cornerRadius  =5.0f;
    self.about.clipsToBounds = YES;
    self.about.backgroundColor = [UIColor flatMintColor];
    
}



@end
