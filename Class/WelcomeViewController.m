//
//  WelcomeViewController.m
//  StockMarketAndLargeAircraft
//
//  Created by liwei wang on 17/7/15.
//  Copyright (c) 2015 CpSoft. All rights reserved.
//

#import "WelcomeViewController.h"
#import "SKViewController.h"
#import <SpriteKit/SpriteKit.h>
#import <QuartzCore/QuartzCore.h>
@import AVFoundation;
@interface WelcomeViewController ()
@property (strong,nonatomic) UIView *backgroundImage;
@property (strong,nonatomic) UIImageView *logoImage;
@property (strong,nonatomic) UIView *logoView;
@property (nonatomic) AVAudioPlayer * backgroundMusicPlayer;

@property (strong,nonatomic) NSTimer *nextViewTimer;


@end
float nextViewTime;
@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    nextViewTime = 0;
    [self startNextViewTimer];
    [self playBackgroundMusic];
    
    [self loadWidget];
}

-(void)playBackgroundMusic{
    NSError *error;
    NSURL * backgroundMusicURL = [[NSBundle mainBundle] URLForResource:@"welcome" withExtension:@"wav"];
    self.backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
    self.backgroundMusicPlayer.numberOfLoops = 0;
    [self.backgroundMusicPlayer prepareToPlay];
    [self.backgroundMusicPlayer play];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    //can cancel swipe gesture
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
}


- (void)loadWidget{
    _backgroundImage = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Drive_Wdith, Drive_Height + 20)];
    _backgroundImage.backgroundColor = [UIColor colorWithRed:0.816 green:0.816 blue:0.816 alpha:1];
    
    [self.view addSubview:_backgroundImage];
    
    _logoImage = [[UIImageView alloc]initWithFrame:CGRectMake(Drive_Wdith / 2 - 100, Drive_Height / 2 - 150, 200,300)];
    
    _logoImage.image = [UIImage imageNamed:@"hero"];
    
    [_backgroundImage addSubview:_logoImage];
    
    //_logoView = [UIView alloc]ini
    
    
    _logoImage.center = self.view.center;
 
    _logoImage.transform = CGAffineTransformIdentity;
    /* Begin the animation */
    [UIView beginAnimations:nil context:NULL];
    /* Make the animation 5 seconds long */
    [UIView setAnimationDuration:1.5f];

    _logoImage.transform = CGAffineTransformMakeScale(0.5f, 0.5f);
    /* Commit the animation */
    [UIView commitAnimations];
    
    
    UILabel *bigPlaneLbl = [[UILabel alloc]initWithFrame:CGRectMake(0 , Drive_Height - 80, Drive_Wdith, 80)];
    bigPlaneLbl.textColor = [UIColor blackColor];
    bigPlaneLbl.font = [UIFont systemFontOfSize:60 weight:60];
    bigPlaneLbl.font = [UIFont fontWithName:@"AmericanTypewriter" size:60];
    bigPlaneLbl.textAlignment = NSTextAlignmentCenter;
    bigPlaneLbl.text = LOCALIZATION(@"text_big_plane");
    [_backgroundImage addSubview:bigPlaneLbl];

}

#pragma mark - timer
-(void)startNextViewTimer{
    [[NSRunLoop mainRunLoop] addTimer:self.nextViewTimer forMode:NSRunLoopCommonModes];
    NSLog(@"NextView timer start...");
}

-(NSTimer *) nextViewTimer{
    if (!_nextViewTimer) {
        _nextViewTimer = [NSTimer scheduledTimerWithTimeInterval:0.5f
                                                       target:self
                                                     selector:@selector(nextViewAciton:)
                                                     userInfo:nil
                                                      repeats:YES];
    }
    return _nextViewTimer;
    
}

-(void)stopNextViewTimer{
    if (self.nextViewTimer != nil){
        [self.nextViewTimer invalidate];
        self.nextViewTimer = nil;
        NSLog(@"NextView timer stop...");
    }
    
}


- (void)nextViewAciton:(NSTimer *)timer{
    nextViewTime = nextViewTime + 0.5;
    NSLog(@"%f",nextViewTime);
    if(nextViewTime == 1.5){
        [self stopNextViewTimer];
        SKViewController *skView = [[SKViewController alloc]init];
        [self.navigationController pushViewController:skView animated:NO];
        
    }
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
