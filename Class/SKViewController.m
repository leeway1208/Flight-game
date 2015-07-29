//
//  SKViewController.m
//  SpriteKit
//
//  Created by Ray on 14-1-20.
//  Copyright (c) 2014年 CpSoft. All rights reserved.
//

#import "SKViewController.h"
#import "SKMainScene.h"
#import "EAColourfulProgressView.h"
#import <QuartzCore/QuartzCore.h>
#import <GameKit/GameKit.h>
#import "GameCenterManager.h"

@import AVFoundation;

@interface SKViewController ()<GKGameCenterControllerDelegate,GameCenterManagerDelegate>{
    int startGameSecondsCountDown;
    int wholeGameTime;
}

@property (strong,nonatomic) EAColourfulProgressView *scoreProgressView;

@property (strong,nonatomic) NSTimer *scoreTimer;

@property (strong,nonatomic) NSTimer *startGameCountDownTimer;

@property (strong,nonatomic) NSTimer *gameTimer;

@property (strong,nonatomic) UIView *pauseView;

@property (strong,nonatomic) UILabel *continueGameLabel;

@property (strong,nonatomic) UIView *backgroundView;

@property (strong,nonatomic) UILabel *progressHintLabel;

@property (nonatomic) AVAudioPlayer * backgroundMusicPlayer;

@property (strong,nonatomic) SKViewController *sKViewController;

@property NSInteger newCurrentValue;
@end

@implementation SKViewController




#pragma mark - system function
- (void)viewDidLoad
{
    [super viewDidLoad];

//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"gamecenter:"]];
//    [self authenticateLocalUser];
//    [self authenticateLocalPlayer];
   
    
    
    [self loadParameter];
    [self loadWidget];
    [self playBackgroundMusic];
    
    [[GameCenterManager sharedManager] setDelegate:self];
    
    
}

-(void)viewDidDisappear:(BOOL)animated{
    //start timer stop
    if (self.startGameCountDownTimer != nil){
        [self.startGameCountDownTimer invalidate];
        self.startGameCountDownTimer = nil;
        NSLog(@"timer stop...");
    }

}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    //can cancel swipe gesture
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}
#pragma mark - init view


-(void)loadParameter{
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gameOver) name:@"gameOverNotification" object:nil];
    
    wholeGameTime = 0;
    
    _newCurrentValue = 0;
//    NSUserDefaults *saveGameTime = [NSUserDefaults standardUserDefaults];
//    [saveGameTime setObject:[NSString stringWithFormat:@"%d",wholeGameTime] forKey:@"game_time"];
//    [saveGameTime synchronize];
}

-(void)loadWidget{

    [self initWorldView];
    //init score
    [self initScroe];
    [self pauseV];
    [self gameOverView];
    [self continueScoreView];
    

}

-(void)playBackgroundMusic{
    NSError *error;
    NSURL * backgroundMusicURL = [[NSBundle mainBundle] URLForResource:@"game_music1" withExtension:@"wav"];
    self.backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
    self.backgroundMusicPlayer.numberOfLoops = -1;
    [self.backgroundMusicPlayer prepareToPlay];
    [self.backgroundMusicPlayer play];
    
}

- (void)pauseV{

    
    
    
    

    _pauseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 93)];
    _pauseView.backgroundColor = [UIColor colorWithRed:0.816 green:0.816 blue:0.816 alpha:1];
    
    
    
    UIButton *button1 = [[UIButton alloc]init];
    [button1 setFrame:CGRectMake(CGRectGetWidth(self.view.frame) / 2 - 150,3,300,40)];
    [button1 setTitle:LOCALIZATION(@"text_continue") forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor colorWithRed:0.118 green:0.125 blue:0.157 alpha:1] forState:UIControlStateNormal];
    button1.font = [UIFont systemFontOfSize:30 weight:50];
    [button1.layer setBorderWidth:2.0];
    [button1.layer setCornerRadius:15.0];
    [button1.layer setBorderColor:[[UIColor colorWithRed:0.118 green:0.125 blue:0.157 alpha:1] CGColor]];
    [button1 addTarget:self action:@selector(continueGame:) forControlEvents:UIControlEventTouchUpInside];
    [_pauseView addSubview:button1];
    
    UIButton *button2 = [[UIButton alloc]init];
    [button2 setFrame:CGRectMake(CGRectGetWidth(self.view.frame) / 2 - 150,53,300,40)];
    button2.font = [UIFont systemFontOfSize:30 weight:50];
    [button2 setTitle:LOCALIZATION(@"text_play_again") forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor colorWithRed:0.118 green:0.125 blue:0.157 alpha:1] forState:UIControlStateNormal];
    [button2.layer setBorderWidth:2.0];
    [button2.layer setCornerRadius:15.0];
    [button2.layer setBorderColor:[[UIColor colorWithRed:0.118 green:0.125 blue:0.157 alpha:1] CGColor]];
    [button2 addTarget:self action:@selector(restart:) forControlEvents:UIControlEventTouchUpInside];
    [_pauseView addSubview:button2];
    
    _pauseView.center = self.view.center;
    
    [self.view addSubview:_pauseView];
    
    [_pauseView setHidden:YES];
}

-(void)initWorldView{
    // Configure the view.
   // SKView * skView = (SKView *)self.view;
 
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    SKView *skView = [[SKView alloc] initWithFrame:applicationFrame];
    self.view = skView;
    skView.showsFPS = NO;
    skView.showsNodeCount = NO;
    // Create and configure the scene.
    SKScene * scene = [SKMainScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    //scene.inputViewController = self;
 
    // Present the scene.
    [skView presentScene:scene];
    
    UIImage *image = [UIImage imageNamed:@"pause_1"];
    UIButton *button = [[UIButton alloc]init];
    [button setFrame:CGRectMake(10, 25, 40 ,40)];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(pause) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

-(void)continueScoreView{
    //continue label
    _continueGameLabel = [[UILabel alloc]init];
    _continueGameLabel.frame = CGRectMake( Drive_Wdith / 2 - 18,  Drive_Height /2 - 100 , 200,200);
    _continueGameLabel.text = @"3";
    _continueGameLabel.hidden = YES;
    [_continueGameLabel setFont:[UIFont systemFontOfSize:50.0f weight:50.0f]];
    //[_continueGameLabel setCenter:self.view.center];
    [self.view addSubview:_continueGameLabel];
}

- (void)initScroe{
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(killPlaneChangeScore:) name:@"killPlane" object:nil];
    
    [self startScoreTimer];
    [self startGameTimer];
    
    _scoreProgressView  = [[EAColourfulProgressView alloc]initWithFrame:CGRectMake(60, 27, self.view.frame.size.width - 60 - 10, 40)];
    _scoreProgressView.cornerRadius = 5.0f;
    _scoreProgressView.borderLineWidth = 3;
    _scoreProgressView.currentValue = 0;
    _scoreProgressView.containerColor = [UIColor colorWithRed:0.612 green:0.627 blue:0.631 alpha:1];

    
    _scoreProgressView.labelTextColor = [UIColor blackColor];
    _scoreProgressView.maximumValue = 100;
    _scoreProgressView.showLabels = YES;
    
    [_scoreProgressView setupView];
    [self.view addSubview: _scoreProgressView];
    
    
    //come on progressHintLabel
    
    _progressHintLabel  = [[UILabel alloc]initWithFrame:CGRectMake(60 + (self.view.frame.size.width - 60 - 10) / 2,  27 , 100, 30)];
    _progressHintLabel.text = LOCALIZATION(@"text_come_on");
    _progressHintLabel.hidden = YES;
     [self.view addSubview: _progressHintLabel];
}



#pragma mark - broadcast
-(void)killPlaneChangeScore:(NSNotification *)notification{
    NSString *planeType = (NSString *)[notification object];
    
    if ([planeType isEqualToString:@"1"]) {
        
        _scoreProgressView.currentValue = _scoreProgressView.currentValue - 1;
    }else if ([planeType isEqualToString:@"2"]){
        _scoreProgressView.currentValue = _scoreProgressView.currentValue - 2;
        
    }else if ([planeType isEqualToString:@"3"]){
        _scoreProgressView.currentValue = _scoreProgressView.currentValue - 4;
        
    }
    
    
}


#pragma mark - action

- (void)forwardAction{
    
    NSArray *activityItems;
    

    activityItems = @[     [NSString stringWithFormat:@"%@%d%@",LOCALIZATION(@"text_share_info_one"),wholeGameTime - 1,   LOCALIZATION(@"text_share_info_two") ]];
    //    }

    UIActivityViewController *activityController =
    [[UIActivityViewController alloc] initWithActivityItems:activityItems
                                      applicationActivities:nil];
    
    [self presentViewController:activityController
                       animated:YES completion:nil];
}


- (void)gameOver{
    //stop timer
    [self stopScoreTimer];
    [self stopGameTimer];
    [_backgroundView setHidden:NO];
    
    
    //save game time
//    NSUserDefaults *saveGameTime = [NSUserDefaults standardUserDefaults];
//    
//    if (wholeGameTime > [[saveGameTime objectForKey:@"game_time"]integerValue]) {
//        [saveGameTime setObject:[NSString stringWithFormat:@"%d",wholeGameTime] forKey:@"game_time"];
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"game_time" object:[NSString stringWithFormat:@"%d",wholeGameTime - 3]];
//        
//    }
//    [saveGameTime synchronize];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"game_time" object:[NSString stringWithFormat:@"%d",wholeGameTime - 1]];
    
//    [self reportScore:wholeGameTime - 1 forCategory:@"StockMarketRanking"];
    BOOL isAvailable = [[GameCenterManager sharedManager] checkGameCenterAvailability];
    
    if(isAvailable){
        
        [[GameCenterManager sharedManager] saveAndReportScore:wholeGameTime - 1 leaderboard:@"StockMarketRanking"  sortOrder:GameCenterSortOrderHighToLow];
        
    }

    
}

-(void)gameOverView{
    _backgroundView =  [[UIView alloc]initWithFrame:self.view.bounds];
    
    UIButton *playAgainBtn = [[UIButton alloc]init];
    [playAgainBtn setBounds:CGRectMake(0,0,200,30)];
    [playAgainBtn setCenter:_backgroundView.center];
    [playAgainBtn setTitle:LOCALIZATION(@"text_play_again") forState:UIControlStateNormal];
    [playAgainBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [playAgainBtn setFont:[UIFont systemFontOfSize:20 weight:20]];
    [playAgainBtn.layer setBorderWidth:2.0];
    [playAgainBtn.layer setCornerRadius:15.0];
    [playAgainBtn.layer setBorderColor:[[UIColor grayColor] CGColor]];
    [playAgainBtn addTarget:self action:@selector(restart:) forControlEvents:UIControlEventTouchUpInside];
    [_backgroundView addSubview:playAgainBtn];
    
    
    UIButton *forwardBtn = [[UIButton alloc]init];
    [forwardBtn setFrame:CGRectMake(Drive_Wdith / 2 - 100, Drive_Height / 2 + 30,200,30)];
    //[forwardBtn setCenter:_backgroundView.center];
    [forwardBtn setTitle:LOCALIZATION(@"text_share") forState:UIControlStateNormal];
    [forwardBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [forwardBtn setFont:[UIFont systemFontOfSize:20 weight:20]];
    [forwardBtn.layer setBorderWidth:2.0];
    [forwardBtn.layer setCornerRadius:15.0];
    [forwardBtn.layer setBorderColor:[[UIColor grayColor] CGColor]];
    [forwardBtn addTarget:self action:@selector(forwardAction) forControlEvents:UIControlEventTouchUpInside];
    [_backgroundView addSubview:forwardBtn];

    
    [_backgroundView setCenter:self.view.center];
    _backgroundView.hidden = YES;
    [self.view addSubview:_backgroundView];
    
    
    
}

- (void)pause{
    //stop score
    [self stopScoreTimer];
    [self stopGameTimer];
    ((SKView *)self.view).paused = YES;
    [_pauseView setHidden:NO];
    
}

- (void)restart:(UIButton *)button{
    _scoreProgressView.currentValue = 0;
    wholeGameTime = 0;
    
    [self startScoreTimer];
    [self startGameTimer];
    
    [_pauseView setHidden:YES];
    [_backgroundView setHidden:YES];
    ((SKView *)self.view).paused = NO;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"restartNotification" object:nil];
}

- (void)continueGame:(UIButton *)button{
    //start timer
    [_pauseView setHidden:YES];
    [_continueGameLabel setHidden:NO];
 
    
    startGameSecondsCountDown = 3;
    _startGameCountDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startGameScoreTimer) userInfo:nil repeats:YES];
    
}






#pragma mark - timer
-(void)startGameScoreTimer{
    startGameSecondsCountDown--;
    NSLog(@"startGameSecondsCountDown --> %d",startGameSecondsCountDown);
    if(startGameSecondsCountDown==0){
        
        [_continueGameLabel setHidden:YES];
        
        [self startScoreTimer];
        [self startGameTimer];
        
        startGameSecondsCountDown = 3;
        ((SKView *)self.view).paused = NO;
        
        

        [_startGameCountDownTimer invalidate];
        _startGameCountDownTimer = nil;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [_continueGameLabel setText:[NSString stringWithFormat:@"%d",startGameSecondsCountDown]];
        
        
    });
    
    
    
    NSLog(@"startGameSecondsCountDown --> %d",startGameSecondsCountDown);
}


-(void)startScoreTimer{
    [[NSRunLoop mainRunLoop] addTimer:self.scoreTimer forMode:NSRunLoopCommonModes];
    NSLog(@"repeat timer start...");
}


-(NSTimer *) scoreTimer{
    if (!_scoreTimer) {
        _scoreTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                       target:self
                                                     selector:@selector(updateProgressView:)
                                                     userInfo:nil
                                                      repeats:YES];
    }
    return _scoreTimer;
    
}

-(void)stopScoreTimer{
    if (self.scoreTimer != nil){
        [self.scoreTimer invalidate];
        self.scoreTimer = nil;
        NSLog(@"scoreTimer timer stop...");
    }
    
}


- (void)updateProgressView:(NSTimer *)timer
{
   
    
    //    if (_scoreProgressView.currentValue == 0) {
    //        newCurrentValue = _scoreProgressView.maximumValue;
    //    } else {
    //        newCurrentValue = _scoreProgressView.currentValue - 1;
    //    }
    //
    if (_newCurrentValue < 0) {
        
        _newCurrentValue = 0;
        _scoreProgressView.currentValue = 0;
    }
    _newCurrentValue = _scoreProgressView.currentValue + 4;
    
    NSLog(@"newCurrentValue -> (%ld)",(long)_newCurrentValue);
    
    
    [_scoreProgressView updateToCurrentValue:_newCurrentValue animated:YES];
    
    if (_scoreProgressView.currentValue >= 70) {
         _progressHintLabel.hidden = NO;
    }else if (_scoreProgressView.currentValue < 70){
        _progressHintLabel.hidden = YES;
    }
    
    //game end
    if(_scoreProgressView.currentValue >= 100){
        [[NSNotificationCenter defaultCenter]postNotificationName:@"game_end" object:nil];
    }
    
    //NSLog(@"newCurrentValue --> %ld",(long)newCurrentValue);

}


// ----------

-(void)startGameTimer{
    [[NSRunLoop mainRunLoop] addTimer:self.gameTimer forMode:NSRunLoopCommonModes];
    NSLog(@"gameTimer timer start...");

}


-(void)stopGameTimer{
    if (self.gameTimer != nil){
        [self.gameTimer invalidate];
        self.gameTimer = nil;
        NSLog(@"gameTimer timer stop...");
    }
    
}

-(NSTimer *) gameTimer{
    if (!_gameTimer) {
        _gameTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                       target:self
                                                     selector:@selector(gameWholeTime:)
                                                     userInfo:nil
                                                      repeats:YES];
    }
    return _gameTimer;
    
}


- (void)gameWholeTime:(NSTimer *)timer
{
    wholeGameTime++;
    //NSLog(@"wholeGameTime --> %d",wholeGameTime);
    if (wholeGameTime == 50) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"hard_game_seconds" object:@"50"];

    }else if (wholeGameTime == 88){
        [[NSNotificationCenter defaultCenter]postNotificationName:@"hard_game_seconds" object:@"80"];
    }

}

#pragma mark - game center
//是否支持GameCenter
- (BOOL) isGameCenterAvailable
{
    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
    NSString *reqSysVer = @"4.1";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);
    
    return (gcClass && osVersionSupported);
}


- (void) authenticateLocalPlayer
{
    [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:^(NSError *error){
        if (error == nil) {
            //成功处理
            NSLog(@"成功");
            NSLog(@"1--alias--.%@",[GKLocalPlayer localPlayer].alias);
            NSLog(@"2--authenticated--.%d",[GKLocalPlayer localPlayer].authenticated);
            NSLog(@"3--isFriend--.%d",[GKLocalPlayer localPlayer].isFriend);
            NSLog(@"4--playerID--.%@",[GKLocalPlayer localPlayer].playerID);
            NSLog(@"5--underage--.%d",[GKLocalPlayer localPlayer].underage);
        }else {
            //错误处理
            NSLog(@"失败  %@",error);
        }
    }];
}

-(void)authenticateLocalUser{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
        if (viewController != nil) {
            [self presentViewController:viewController animated:YES completion:nil];
        }
        else{
            if ([GKLocalPlayer localPlayer].authenticated) {
                // Get the default leaderboard identifier.
                
                [[GKLocalPlayer localPlayer] loadDefaultLeaderboardIdentifierWithCompletionHandler:^(NSString *leaderboardIdentifier, NSError *error) {
                    
                    if (error != nil) {
                        NSLog(@"%@", [error localizedDescription]);
                    }
                    else{
                        
                    }
                }];
            }
            
            else{
                
            }
        }
    };
    
}


- (void) reportScore: (int64_t) score forCategory: (NSString*) category{
    GKScore *scoreReporter = [[GKScore alloc] initWithCategory:category];
    
    scoreReporter.value = score;
    [scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
        if(error != nil){
            NSData *saveSocreData = [NSKeyedArchiver archivedDataWithRootObject:scoreReporter];
            
            //未能提交得分，需要保存下来后继续提交
            [self storeScoreForLater:saveSocreData];
        }else{
            NSLog(@"提交成功");
        }
    }];
}

- (void)storeScoreForLater:(NSData *)scoreData{
    NSMutableArray *savedScoresArray = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"savedScores"]];
    
    [savedScoresArray addObject:scoreData];
    [[NSUserDefaults standardUserDefaults] setObject:savedScoresArray forKey:@"savedScores"];
}


- (void)gameCenterManager:(GameCenterManager *)manager authenticateUser:(UIViewController *)gameCenterLoginController
{
    //We inherit the rootView from our view.window and then pass it to the presentViewController,
    //since presentViewController only accepts a ViewController and not a scene
    UIViewController *vc = self.view.window.rootViewController;
    [vc presentViewController:gameCenterLoginController animated:YES completion:^{
        
        //You can comment this line, it's simply so we know that we are currently authenticating the user and presenting the controller
        NSLog(@"Finished Presenting Authentication Controller");
        
    }];
}

@end
