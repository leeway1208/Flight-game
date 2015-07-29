//
//  SKMainScene.m
//  SpriteKit
//
//  Created by Ray on 14-1-20.
//  Copyright (c) 2014年 CpSoft. All rights reserved.
//

#import "SKMainScene.h"

#import "SKSharedAtles.h"

#import "SKFoePlane.h"

#import "EAColourfulProgressView.h"

#import "SKViewController.h"

@class SKViewController;

SKViewController *skViewController;

// 角色类别
typedef NS_ENUM(uint32_t, SKRoleCategory){
    SKRoleCategoryBullet = 1,
    SKRoleCategoryFoePlane = 4,
    SKRoleCategoryPlayerPlane = 8,
    SKRoleCategoryBomb = 12,
    SKRoleCategoryDoubleBullet = 24
};


int doubleBulletTime = 0;

@implementation SKMainScene

- (instancetype)initWithSize:(CGSize)size{
    
    self = [super initWithSize:size];
    if (self) {
        _smallPlaneTime = 0;
        _mediumPlaneTime = 0;
        _bigPlaneTime = 0;
        _bombTime = 0;
        _doubleBulletTime = 0;
        [self initPhysicsWorld];
        [self initAction];
        //[self initGameEndView];
        [self initBackground];
        [self initScroe];
        [self initPlayerPlane];
        [self firingBullets];
        // [endView setHidden:YES];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(restart) name:@"restartNotification" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gameTimeAction:) name:@"game_time" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gameEndAction) name:@"game_end" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(FiftySeconds:) name:@"hard_game_seconds" object:nil];
        
        
    }
    return self;
}

#pragma mark - broadcast

-(void)FiftySeconds:(NSNotification *)notification{
     NSString *gameLevel = (NSString *)[notification object];
    
    if ([gameLevel isEqualToString:@"50"]) {
        _playerPlane.size = CGSizeMake(_playerPlane.frame.size.width * 1.5 , _playerPlane.frame.size.height * 1.5);
        
        _playerPlane.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_playerPlane.size];
        _playerPlane.physicsBody.categoryBitMask = SKRoleCategoryPlayerPlane;
        _playerPlane.physicsBody.collisionBitMask = 0;
        _playerPlane.physicsBody.contactTestBitMask = SKRoleCategoryFoePlane;
    }else if ([gameLevel isEqualToString:@"80"]){
        _playerPlane.size = CGSizeMake(_playerPlane.frame.size.width * 1.8 , _playerPlane.frame.size.height * 1.8);
        
        _playerPlane.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_playerPlane.size];
        _playerPlane.physicsBody.categoryBitMask = SKRoleCategoryPlayerPlane;
        _playerPlane.physicsBody.collisionBitMask = 0;
        _playerPlane.physicsBody.contactTestBitMask = SKRoleCategoryFoePlane;

    }
   

}

-(void)gameTimeAction:(NSNotification *)notification{
    NSString *gameTime = (NSString *)[notification object];
    
    NSLog(@"gameTime --> %@",gameTime);
    timeLabel.text = gameTime;
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"game_time" object:nil];
}

-(void)gameEndAction{
    [self playerPlaneCollisionAnimation:_playerPlane];

    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"game_end" object:nil];
    
}

- (void)restart{
    _smallPlaneTime = 0;
    _mediumPlaneTime = 0;
    _bigPlaneTime = 0;
    _bombTime = 0;
    _doubleBulletTime = 0;
    [self removeAllChildren];
    [self removeAllActions];
    [endView removeFromSuperview];
    [self initBackground];
    [self initScroe];
    [self initPlayerPlane];
    [self firingBullets];
    //[endView setHidden:YES];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"hard_game_seconds" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gameTimeAction:) name:@"game_time" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(FiftySeconds:) name:@"hard_game_seconds" object:nil];

}

#pragma mark - view logic

- (void)initPhysicsWorld{
    self.physicsWorld.contactDelegate = self;
    self.physicsWorld.gravity = CGVectorMake(0,0);
    
    
}

- (void)initAction{
    _smallFoePlaneHitAction = [SKSharedAtles hitActionWithFoePlaneType:SKFoePlaneTypeSmall];
    _mediumFoePlaneHitAction = [SKSharedAtles hitActionWithFoePlaneType:SKFoePlaneTypeMedium];
    _bigFoePlaneHitAction = [SKSharedAtles hitActionWithFoePlaneType:SKFoePlaneTypeBig];
    _bombHitAction = [SKSharedAtles hitActionWithFoePlaneType:SKFoePlaneTypeBomb];
    
    _smallFoePlaneBlowupAction = [SKSharedAtles blowupActionWithFoePlaneType:SKFoePlaneTypeSmall];
    _mediumFoePlaneBlowupAction = [SKSharedAtles blowupActionWithFoePlaneType:SKFoePlaneTypeMedium];
    _bigFoePlaneBlowupAction = [SKSharedAtles blowupActionWithFoePlaneType:SKFoePlaneTypeBig];
    _bombBlowupAction = [SKSharedAtles blowupActionWithFoePlaneType:SKFoePlaneTypeBomb];
}

-(void) initGameEndView{
    
    
    
    
    
    if ([[self getCurrentSystemLanguage]isEqualToString:@"en"]) {
        
        
        
        endView = [[UIView alloc]initWithFrame:CGRectMake(0, Drive_Height / 2 - 180, CGRectGetWidth(self.view.frame), 173)];
        endView.backgroundColor = [UIColor colorWithRed:0.816 green:0.816 blue:0.816 alpha:1];
        [self.view addSubview:endView];
        
        //game over label
        GameOverlabel = [[UILabel alloc ]init];
        GameOverlabel.text = LOCALIZATION(@"text_game_over");
        GameOverlabel.textColor = [UIColor blackColor];
        GameOverlabel.frame = CGRectMake(Drive_Wdith / 2 - 100, 10, 200, 50);
        GameOverlabel.textAlignment = UITextAlignmentCenter;
        GameOverlabel.font = [UIFont fontWithName:@"AmericanTypewriter" size:30];
        GameOverlabel.font = [UIFont systemFontOfSize:30 weight:50];
        
        [endView addSubview:GameOverlabel];
        
        
        //your best time label
        insistLabel = [[UILabel alloc ]init];
        insistLabel.text = LOCALIZATION(@"text_you_carry_on");
        insistLabel.textColor = [UIColor blackColor];
        insistLabel.font = [UIFont systemFontOfSize:20 weight:20];
        insistLabel.textAlignment = NSTextAlignmentCenter;
        insistLabel.frame = CGRectMake(Drive_Wdith / 2 -120, 40, 240, 50);
        //insistLabel.center = self.view.center;
        insistLabel.font = [UIFont fontWithName:@"AmericanTypewriter" size:20];
        [endView addSubview:insistLabel];
        
        
        
        //your best time label
        timeLabel = [[UILabel alloc]init];
        
        timeLabel.textColor = [UIColor redColor];
        if ([[self getCurrentSystemLanguage]isEqualToString:@"en"]) {
            
            timeLabel.frame = CGRectMake(Drive_Wdith / 2 - Drive_Wdith /2, 80, Drive_Wdith, 40);
            timeLabel.font = [UIFont systemFontOfSize:40 weight:40];
        }else{
            timeLabel.frame = CGRectMake(Drive_Wdith / 2 - Drive_Wdith /2, 115, Drive_Wdith, 40);
            timeLabel.font = [UIFont systemFontOfSize:40 weight:40];
            
        }
        timeLabel.textAlignment = NSTextAlignmentCenter;
        [endView addSubview:timeLabel];
        
        
        
        //put money
        putMoneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(Drive_Wdith / 2 - Drive_Wdith /2, 105, Drive_Wdith, 40)];
        putMoneyLabel.text = LOCALIZATION(@"text_put_the_money");
        putMoneyLabel.font = [UIFont systemFontOfSize:20 weight:20];
        putMoneyLabel.textAlignment = NSTextAlignmentCenter;
        putMoneyLabel.font = [UIFont fontWithName:@"AmericanTypewriter" size:20];
        [endView addSubview:putMoneyLabel];
        
        
        putMoneyScoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(Drive_Wdith / 2 - Drive_Wdith /2, 135, Drive_Wdith, 40)];
        
        if(allMoney - 1000 <= 0){
            putMoneyScoreLabel.text = [NSString stringWithFormat:@"%d",0];
        }else{
            putMoneyScoreLabel.text = [NSString stringWithFormat:@"%d",allMoney - 1000];
        }
        
        putMoneyScoreLabel.font = [UIFont systemFontOfSize:40 weight:40];
        putMoneyScoreLabel.textAlignment = NSTextAlignmentCenter;
        putMoneyScoreLabel.textColor = [UIColor redColor];
        [endView addSubview:putMoneyScoreLabel];
        
        
        
    }else{
        
        endView = [[UIView alloc]initWithFrame:CGRectMake(0, Drive_Height / 2 - 200, CGRectGetWidth(self.view.frame), 190)];
        endView.backgroundColor = [UIColor colorWithRed:0.816 green:0.816 blue:0.816 alpha:1];
        [self.view addSubview:endView];
        
        //game over label
        GameOverlabel = [[UILabel alloc ]init];
        GameOverlabel.text = LOCALIZATION(@"text_game_over");
        GameOverlabel.textColor = [UIColor blackColor];
        GameOverlabel.frame = CGRectMake(Drive_Wdith / 2 - 100, 3, 200, 50);
        GameOverlabel.textAlignment = UITextAlignmentCenter;
        GameOverlabel.font = [UIFont systemFontOfSize:30 weight:50];
        GameOverlabel.font = [UIFont fontWithName:@"AmericanTypewriter" size:30];
        [endView addSubview:GameOverlabel];
        
        
        
        //your best time label
        insistLabel = [[UILabel alloc ]init];
        insistLabel.text = LOCALIZATION(@"text_you_carry_on");
        insistLabel.textColor = [UIColor blackColor];
        insistLabel.frame = CGRectMake(Drive_Wdith / 2 - 150 , 40, 300, 50);
        insistLabel.font = [UIFont systemFontOfSize:18 weight:18];
        insistLabel.textAlignment = UITextAlignmentCenter;
        insistLabel.font = [UIFont fontWithName:@"AmericanTypewriter" size:18];
        [endView addSubview:insistLabel];
        
        
        insistTwoLabel = [[UILabel alloc ]init];
        
        insistTwoLabel.text = LOCALIZATION(@"text_you_insist");
        insistTwoLabel.textColor = [UIColor blackColor];
        insistTwoLabel.frame = CGRectMake(0, 60, Drive_Wdith, 50);
        insistTwoLabel.font = [UIFont systemFontOfSize:18 weight:18];
        insistTwoLabel.font = [UIFont fontWithName:@"AmericanTypewriter" size:18];
        insistTwoLabel.textAlignment = UITextAlignmentCenter;
        [endView addSubview:insistTwoLabel];
        
        
        
        //your best time label
        timeLabel = [[UILabel alloc]init];
        
        timeLabel.textColor = [UIColor redColor];
        if ([[self getCurrentSystemLanguage]isEqualToString:@"en"]) {
            
            timeLabel.frame = CGRectMake(Drive_Wdith / 2 - Drive_Wdith / 2, 80, Drive_Wdith, 40);
            timeLabel.font = [UIFont systemFontOfSize:40 weight:40];
        }else{
            timeLabel.frame = CGRectMake(Drive_Wdith / 2 - Drive_Wdith /2, 93, Drive_Wdith, 40);
            timeLabel.font = [UIFont systemFontOfSize:40 weight:40];
            
        }
        timeLabel.textAlignment = NSTextAlignmentCenter;
        [endView addSubview:timeLabel];
        
        
        //put money
        putMoneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(Drive_Wdith / 2 - Drive_Wdith /2, 120, Drive_Wdith, 40)];
        putMoneyLabel.text = LOCALIZATION(@"text_put_the_money");
        putMoneyLabel.font = [UIFont systemFontOfSize:20 weight:20];
        putMoneyLabel.textAlignment = NSTextAlignmentCenter;
        putMoneyLabel.font = [UIFont fontWithName:@"AmericanTypewriter" size:20];
        
        [endView addSubview:putMoneyLabel];
        
        
        putMoneyScoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(Drive_Wdith / 2 - Drive_Wdith /2, 150, Drive_Wdith, 40)];
        
        if(allMoney - 1000 <= 0){
            putMoneyScoreLabel.text = [NSString stringWithFormat:@"%d",0];
        }else{
            putMoneyScoreLabel.text = [NSString stringWithFormat:@"%d",allMoney - 1000];
        }
        
        putMoneyScoreLabel.font = [UIFont systemFontOfSize:40 weight:40];
        putMoneyScoreLabel.textAlignment = NSTextAlignmentCenter;
        putMoneyScoreLabel.textColor = [UIColor redColor];
        [endView addSubview:putMoneyScoreLabel];
        
    }
    
}


- (void)initBackground{
    NSLog(@" Drive_Wdith --> %d",(int)Drive_Wdith);
    if ((int)Drive_Height == 460) {
        _adjustmentBackgroundPosition = self.size.height;
        
        _background1 = [SKSpriteNode spriteNodeWithTexture:[SKSharedAtles textureWithType:SKTextureTypeBackground] size:CGSizeMake(Drive_Wdith, Drive_Height + 107)];
        _background1.position = CGPointMake(self.size.width / 2, 0);
        _background1.anchorPoint = CGPointMake(0.5 , 0);
        _background1.zPosition = 0;
        
        
        _background2 = [SKSpriteNode spriteNodeWithTexture:[SKSharedAtles textureWithType:SKTextureTypeBackground] size:CGSizeMake(Drive_Wdith, Drive_Height + 107)];
        
        _background2.anchorPoint = CGPointMake(0.5 , 0);
        _background2.position = CGPointMake(self.size.width / 2, _adjustmentBackgroundPosition - 1);
        _background2.zPosition = 0;
        
    }else{
        _adjustmentBackgroundPosition = self.size.height;
        
        _background1 = [SKSpriteNode spriteNodeWithTexture:[SKSharedAtles textureWithType:SKTextureTypeBackground] size:CGSizeMake(Drive_Wdith, Drive_Height + 20)];
        _background1.position = CGPointMake(self.size.width / 2, 0);
        _background1.anchorPoint = CGPointMake(0.5 , 0);
        _background1.zPosition = 0;
        
        
        _background2 = [SKSpriteNode spriteNodeWithTexture:[SKSharedAtles textureWithType:SKTextureTypeBackground] size:CGSizeMake(Drive_Wdith, Drive_Height + 20)];
        
        _background2.anchorPoint = CGPointMake(0.5 , 0);
        _background2.position = CGPointMake(self.size.width / 2, _adjustmentBackgroundPosition - 1);
        _background2.zPosition = 0;
        
    }
    
    
    
    
    
    
    [self addChild:_background1];
    [self addChild:_background2];
    
    //    [self runAction:[SKAction repeatActionForever:[SKAction playSoundFileNamed:@"game_music1.wav" waitForCompletion:YES]]];
}

- (void)scrollBackground{
    _adjustmentBackgroundPosition--;
    
    if (_adjustmentBackgroundPosition <= 0)
    {
        _adjustmentBackgroundPosition = 568;
    }
    
    [_background1 setPosition:CGPointMake(self.size.width / 2, _adjustmentBackgroundPosition - 568)];
    [_background2 setPosition:CGPointMake(self.size.width / 2, _adjustmentBackgroundPosition - 1)];
}

- (void)initScroe{
    
    _scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"MarkerFelt-Thin" ];
    _scoreLabel.text = @"0000";
    _scoreLabel.zPosition = 5;
    _scoreLabel.fontColor = [SKColor blackColor];
    _scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    _scoreLabel.position = CGPointMake(170 , self.size.height -67);
    _scoreLabel.fontSize = 10;
    [self addChild:_scoreLabel];
    
    
}

- (void)initPlayerPlane{
    allPlane = [NSMutableArray new];
    
    
    
    _playerPlane = [SKSpriteNode spriteNodeWithTexture:[SKSharedAtles textureWithType:SKTextureTypePlayerPlane]];
    _playerPlane.position = CGPointMake(160, 50);
    _playerPlane.zPosition = 1;
    _playerPlane.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_playerPlane.size];
    _playerPlane.physicsBody.categoryBitMask = SKRoleCategoryPlayerPlane;
    _playerPlane.physicsBody.collisionBitMask = 0;
    _playerPlane.physicsBody.contactTestBitMask = SKRoleCategoryFoePlane;
    [self addChild:_playerPlane];
    [_playerPlane runAction:[SKSharedAtles playerPlaneAction]];
}



- (void)createFoePlane{
    
    _smallPlaneTime++;
    _mediumPlaneTime++;
    _bigPlaneTime++;
    _bombTime++;
    _doubleBulletTime++;
    
    SKFoePlane * (^create)(SKFoePlaneType) = ^(SKFoePlaneType type){
        
        int x = (arc4random() % 220) + 35;
        
        SKFoePlane *foePlane = nil;
        
        switch (type) {
            case 1:
                foePlane = [SKFoePlane createBigPlane];
                foePlane.zPosition = 1;
                foePlane.physicsBody.categoryBitMask = SKRoleCategoryFoePlane;
                foePlane.physicsBody.collisionBitMask = SKRoleCategoryBullet;
                foePlane.physicsBody.contactTestBitMask = SKRoleCategoryBullet;
                foePlane.position = CGPointMake(x, self.size.height);
                [foePlane runAction:[SKSharedAtles bigPlaneAction]];
                break;
            case 2:
                foePlane = [SKFoePlane createMediumPlane];
                foePlane.zPosition = 1;
                foePlane.physicsBody.categoryBitMask = SKRoleCategoryFoePlane;
                foePlane.physicsBody.collisionBitMask = SKRoleCategoryBullet;
                foePlane.physicsBody.contactTestBitMask = SKRoleCategoryBullet;
                foePlane.position = CGPointMake(x, self.size.height);
                break;
            case 3:
                foePlane = [SKFoePlane createSmallPlane];
                foePlane.zPosition = 1;
                foePlane.physicsBody.categoryBitMask = SKRoleCategoryFoePlane;
                foePlane.physicsBody.collisionBitMask = SKRoleCategoryBullet;
                foePlane.physicsBody.contactTestBitMask = SKRoleCategoryBullet;
                foePlane.position = CGPointMake(x, self.size.height);
                break;
            case 4:
                foePlane = [SKFoePlane createBomb];
                foePlane.zPosition = 3;
                foePlane.physicsBody.categoryBitMask = SKRoleCategoryBomb;
                foePlane.physicsBody.collisionBitMask = 0;
                foePlane.physicsBody.contactTestBitMask = SKRoleCategoryBomb;
                foePlane.position = CGPointMake(x, self.size.height);
                break;
                
            case 5:
                foePlane = [SKFoePlane createDoubleBullet];
                foePlane.zPosition = 3;
                foePlane.physicsBody.categoryBitMask = SKRoleCategoryDoubleBullet;
                foePlane.physicsBody.collisionBitMask = 0;
                foePlane.physicsBody.contactTestBitMask = SKRoleCategoryDoubleBullet;
                foePlane.position = CGPointMake(x, self.size.height);
                break;
            default:
                break;
        }
        
        
        [allPlane addObject:foePlane];
        //        NSLog(@"foePlane ----> %lu",(unsigned long)allPlane.count);
        return foePlane;
    };
    
    if (_smallPlaneTime > 25)
    {
        float speed = (arc4random() % 3) + 2;
        
        SKFoePlane *foePlane = create(SKFoePlaneTypeSmall);
        [self addChild:foePlane];
        [foePlane runAction:[SKAction sequence:@[[SKAction moveToY:0 duration:speed],[SKAction removeFromParent]]]];
        
        _smallPlaneTime = 0;
    }
    
    if (_mediumPlaneTime > 400)
    {
        float speed = (arc4random() % 3) + 4;
        
        SKFoePlane *foePlane = create(SKFoePlaneTypeMedium);
        [self addChild:foePlane];
        [foePlane runAction:[SKAction sequence:@[[SKAction moveToY:0 duration:speed],[SKAction removeFromParent]]]];
        
        _mediumPlaneTime = 0;
    }
    
    if (_bigPlaneTime > 1000)
    {
        float speed = (arc4random() % 3) + 6;
        
        SKFoePlane *foePlane = create(SKFoePlaneTypeBig);
        [self addChild:foePlane];
        [foePlane runAction:[SKAction sequence:@[[SKAction moveToY:0 duration:speed],[SKAction removeFromParent]]]];
        [self runAction:[SKAction playSoundFileNamed:@"enemy3_out2.wav" waitForCompletion:NO]];
        
        _bigPlaneTime = 0;
    }
    
    if(_bombTime > 1500){
        float speed = (arc4random() % 3) + 4;
        
        SKFoePlane *foePlane = create(SKFoePlaneTypeBomb);
        [self addChild:foePlane];
        [foePlane runAction:[SKAction sequence:@[[SKAction moveToY:0 duration:speed],[SKAction removeFromParent]]]];
        [self runAction:[SKAction playSoundFileNamed:@"bomb.wav" waitForCompletion:NO]];
        
        _bombTime = 0;
        
    }
    
    
    if(_doubleBulletTime > 800){
        float speed = (arc4random() % 3) + 4;
        
        SKFoePlane *foePlane = create(SKFoePlaneTypeDoubleBullet);
        [self addChild:foePlane];
        CGPoint point = CGPointMake(arc4random() % (int)Drive_Wdith, 0.0f);
        
        [foePlane runAction:[SKAction sequence:@[[SKAction moveTo:point duration:speed],[SKAction removeFromParent]]]];
        // [self runAction:[SKAction playSoundFileNamed:@"enemy2_out.mp3" waitForCompletion:NO]];
        
        _doubleBulletTime = 0;
        
    }
    
}

- (void)createBullets{
    SKSpriteNode *bullet = [SKSpriteNode spriteNodeWithTexture:[SKSharedAtles textureWithType:SKTextureTypeBullet]];
    bullet.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:bullet.size];
    bullet.physicsBody.categoryBitMask = SKRoleCategoryBullet;
    bullet.physicsBody.collisionBitMask = SKRoleCategoryBullet;
    bullet.physicsBody.contactTestBitMask = SKRoleCategoryFoePlane;
    bullet.zPosition = 1;
    bullet.position = CGPointMake(_playerPlane.position.x, _playerPlane.position.y + (_playerPlane.size.height / 2));
    [self addChild:bullet];
    
    SKAction *actionMove = [SKAction moveTo:CGPointMake(_playerPlane.position.x,self.size.height) duration:0.5];
    SKAction *actionMoveDone = [SKAction removeFromParent];
    
    [bullet runAction:[SKAction sequence:@[actionMove,actionMoveDone]]];
    
    [self runAction:[SKAction playSoundFileNamed:@"bullet.mp3" waitForCompletion:NO]];
}

- (void)firingBullets{
    
    SKAction *action = [SKAction runBlock:^{
        [self createBullets];
    }];
    SKAction *interval = [SKAction waitForDuration:0.2];
    [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[action,interval]]]];
}

- (void)changeScore:(SKFoePlaneType)type{
    
    int score = 0;
    switch (type) {
        case SKFoePlaneTypeBig:
            score = 10000;
            break;
        case SKFoePlaneTypeMedium:
            score = 5000;
            break;
        case SKFoePlaneTypeSmall:
            score = 1000;
            break;
        default:
            break;
    }
    
    [_scoreLabel runAction:[SKAction runBlock:^{
        
        _scoreLabel.text = [NSString stringWithFormat:@"%d",_scoreLabel.text.intValue + score];
        
        allMoney = _scoreLabel.text.intValue + score;
    }]];
}

- (void)foePlaneCollisionAnimation:(SKFoePlane *)sprite{
    
    if (![sprite actionForKey:@"dieAction"]) {
        
        SKAction *hitAction = nil;
        SKAction *blowupAction = nil;
        NSString *soundFileName = nil;
        switch (sprite.type) {
            case SKFoePlaneTypeBig:
            {
                sprite.hp--;
                hitAction = _bigFoePlaneHitAction;
                blowupAction = _bigFoePlaneBlowupAction;
                soundFileName = @"enemy2_down.mp3";
                isBomb = NO;
                [[NSNotificationCenter defaultCenter]postNotificationName:@"killPlane" object:@"3"];
            }
                break;
            case SKFoePlaneTypeMedium:
            {
                sprite.hp--;
                hitAction = _mediumFoePlaneHitAction;
                blowupAction = _mediumFoePlaneBlowupAction;
                soundFileName = @"enemy3_down.mp3";
                isBomb = NO;
                [[NSNotificationCenter defaultCenter]postNotificationName:@"killPlane" object:@"2"];
            }
                break;
            case SKFoePlaneTypeSmall:
            {
                sprite.hp--;
                hitAction = _smallFoePlaneHitAction;
                blowupAction = _smallFoePlaneBlowupAction;
                soundFileName = @"enemy1_down.mp3";
                isBomb = NO;
                [[NSNotificationCenter defaultCenter]postNotificationName:@"killPlane" object:@"1"];
            }
                break;
            case SKFoePlaneTypeBomb:
            {
                //sprite.hp--;
                //hitAction = _bombHitAction;
                //blowupAction = _bombBlowupAction;
                isBomb = YES;
            }
                break;
            case SKFoePlaneTypeDoubleBullet:
            {
                
            }
                break;
                
            default:
                break;
        }
        if (!sprite.hp) {
            [sprite removeAllActions];
            [sprite runAction:blowupAction withKey:@"dieAction"];
            [self changeScore:sprite.type];
            [self runAction:[SKAction playSoundFileNamed:soundFileName waitForCompletion:NO]];
            
            //            for (int i = 0; i < allPlane.count ; i ++) {
            //                SKFoePlane *sprite = [allPlane objectAtIndex:i];
            //                //if (sprite.hp == 0) {
            //                    [allPlane removeObjectAtIndex:i];
            //                //}
            //            }
        }else{
            [sprite runAction:hitAction];
        }
    }
}

- (void)playerPlaneCollisionAnimation:(SKSpriteNode *)sprite{
    
    [self removeAllActions];
    [sprite runAction:[SKSharedAtles playerPlaneBlowupAction] completion:^{
        
        
        [self runAction:[SKAction sequence:@[[SKAction playSoundFileNamed:@"hero_down.wav" waitForCompletion:YES],[SKAction runBlock:^{
            
            
            [self initGameEndView];
            //[endView setHidden:NO];
            
            
            
            
            
        }]]] completion:^{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"gameOverNotification" object:nil];
        }];
    }];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    for (UITouch *touch in touches) {
        
        CGPoint location = [touch locationInNode:self];
        
        if (location.x >= self.size.width - (_playerPlane.size.width / 2)) {
            
            location.x = self.size.width - (_playerPlane.size.width / 2);
            
        }else if (location.x <= (_playerPlane.size.width / 2)) {
            
            location.x = _playerPlane.size.width / 2;
            
        }
        
        if (location.y >= self.size.height - (_playerPlane.size.height / 2)) {
            
            location.y = self.size.height - (_playerPlane.size.height / 2);
            
        }else if (location.y <= (_playerPlane.size.height / 2)) {
            
            location.y = (_playerPlane.size.height / 2);
            
        }
        
        SKAction *action = [SKAction moveTo:CGPointMake(location.x, location.y) duration:0];
        
        [_playerPlane runAction:action];
    }
}

- (void)update:(NSTimeInterval)currentTime{
    [self createFoePlane];
    [self scrollBackground];
}

#pragma mark -
- (void)didBeginContact:(SKPhysicsContact *)contact{
    //    NSLog(@"contact.bodyA.categoryBitMask--> %d",contact.bodyA.categoryBitMask);
    //    NSLog(@"contact.bodyB.categoryBitMask--> %d",contact.bodyB.categoryBitMask);
    
    if ((contact.bodyA.categoryBitMask == 1 && contact.bodyB.categoryBitMask == 4) || (contact.bodyA.categoryBitMask == 4 && contact.bodyB.categoryBitMask == 1)) {
        SKFoePlane *sprite = (contact.bodyA.categoryBitMask & SKRoleCategoryFoePlane) ? (SKFoePlane *)contact.bodyA.node : (SKFoePlane *)contact.bodyB.node;
        SKSpriteNode *bullet = (contact.bodyA.categoryBitMask & SKRoleCategoryFoePlane) ? (SKFoePlane *)contact.bodyB.node : (SKFoePlane *)contact.bodyA.node;
        [bullet removeFromParent];
        [self foePlaneCollisionAnimation:sprite];
    }else if((contact.bodyA.categoryBitMask == 12 && contact.bodyB.categoryBitMask == 8) || (contact.bodyA.categoryBitMask == 8 && contact.bodyB.categoryBitMask == 12)){
        
        if (contact.bodyA.categoryBitMask == 12) {
            SKSpriteNode *bomb = (SKFoePlane *)contact.bodyA.node;
            [bomb removeFromParent];
        } else {
            SKSpriteNode *bomb = (SKFoePlane *)contact.bodyB.node;
            [bomb removeFromParent];
        }
        
        for (int i = 0; i < allPlane.count ; i ++) {
            SKFoePlane *sprite = [allPlane objectAtIndex:i];
            [self foePlaneCollisionAnimation:sprite];
        }
        
    }else if ((contact.bodyA.categoryBitMask == 4 && contact.bodyB.categoryBitMask == 8) || (contact.bodyA.categoryBitMask == 8 && contact.bodyB.categoryBitMask == 4)){
        if (contact.bodyA.categoryBitMask == 8) {
            SKSpriteNode *playerPlane = (SKSpriteNode *)contact.bodyA.node;
            [self playerPlaneCollisionAnimation:playerPlane];
            
        } else {
            SKSpriteNode *playerPlane = (SKSpriteNode *)contact.bodyB.node;
            [self playerPlaneCollisionAnimation:playerPlane];
            
        }
        
    }else if ((contact.bodyA.categoryBitMask == 8 && contact.bodyB.categoryBitMask == 24) || (contact.bodyA.categoryBitMask == 24 && contact.bodyB.categoryBitMask == 8)) {
        
        
        if (contact.bodyA.categoryBitMask == 24) {
            SKSpriteNode *doubleBullet = (SKFoePlane *)contact.bodyA.node;
            [doubleBullet removeFromParent];
        } else {
            SKSpriteNode *doubleBullet = (SKFoePlane *)contact.bodyB.node;
            [doubleBullet removeFromParent];
        }
        //        [[NSNotificationCenter defaultCenter]postNotificationName:@"doubleBullet" object:@"2"];
        
        [SKSharedAtles setDoubleBullet:@"2"];
        [self startDoubleBulletTimer];
        
    }
    
    
    
    
    
    
    
    
}

- (void)didEndContact:(SKPhysicsContact *)contact{
    
}




#pragma mark - timer
-(void)startDoubleBulletTimer{
    [[NSRunLoop mainRunLoop] addTimer:self.doubleBulletTimer forMode:NSRunLoopCommonModes];
    NSLog(@"doubleBulletTimer timer start...");
}

-(NSTimer *) doubleBulletTimer{
    if (!_doubleBulletTimer) {
        _doubleBulletTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                              target:self
                                                            selector:@selector(doubleBulletAction:)
                                                            userInfo:nil
                                                             repeats:YES];
    }
    return _doubleBulletTimer;
    
}

-(void)stopDoubleBulletTimer{
    if (_doubleBulletTimer != nil){
        [_doubleBulletTimer invalidate];
        _doubleBulletTimer = nil;
        NSLog(@"doubleBulletTimer timer stop...");
    }
    
}

- (void)doubleBulletAction:(NSTimer *)timer{
    doubleBulletTime ++;
    
    NSLog(@"doubleBulletTime -> %d",doubleBulletTime);
    if (doubleBulletTime == 8) {
        doubleBulletTime = 0;
        [SKSharedAtles setDoubleBullet:@"1"];
        [self stopDoubleBulletTimer];
    }
}

#pragma mark - getCurrentSystemLanguage
- (NSString *)getCurrentSystemLanguage
{
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    
    return currentLanguage;
}



@end
