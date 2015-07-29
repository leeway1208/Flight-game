//
//  SKMainScene.h
//  SpriteKit
//
//  Created by Ray on 14-1-20.
//  Copyright (c) 2014年 CpSoft. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SKMainScene : SKScene<SKPhysicsContactDelegate>{
    
    int _smallPlaneTime;
    int _mediumPlaneTime;
    int _bigPlaneTime;
    int _bombTime;
    int _doubleBulletTime;
    
    BOOL isBomb;
    
    int _adjustmentBackgroundPosition;
    
    SKLabelNode *_scoreLabel;
    SKSpriteNode *_playerPlane;
    SKSpriteNode *_background1;
    SKSpriteNode *_background2;

    SKAction *_smallFoePlaneHitAction;
    SKAction *_mediumFoePlaneHitAction;
    SKAction *_bigFoePlaneHitAction;
    SKAction *_bombHitAction;
    SKAction *_doubleBulletHitAction;
    
    SKAction *_smallFoePlaneBlowupAction;
    SKAction *_mediumFoePlaneBlowupAction;
    SKAction *_bigFoePlaneBlowupAction;
    SKAction *_bombBlowupAction;
    SKAction *_doubleBulletBlowupAction;
    
    NSMutableArray *allPlane;
    UIView *endView;
    UILabel *timeLabel;
    UILabel *GameOverlabel;
    UILabel *insistLabel;
    UILabel *insistTwoLabel;
    UILabel *putMoneyLabel;
    UILabel *putMoneyScoreLabel;
    
    int allMoney;
}

@property (strong,nonatomic) NSTimer *doubleBulletTimer;

@end
