//
//  SKSharedAtles.h
//  SpriteKit
//
//  Created by Ray on 14-1-20.
//  Copyright (c) 2014年 CpSoft. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#import "SKFoePlane.h"

typedef NS_ENUM(int, SKTextureType) {
    SKTextureTypeBackground = 1,
    SKTextureTypeBullet = 2,
    SKTextureTypePlayerPlane = 3,
    SKTextureTypeSmallFoePlane = 4,
    SKTextureTypeMediumFoePlane = 5,
    SKTextureTypeBigFoePlane = 6,
    SKTextureTypeBomb = 7,
    SKTextureTypeDoubleBullet = 8

};


@interface SKSharedAtles : SKTextureAtlas

+ (SKTexture *)textureWithType:(SKTextureType)type;

+ (SKAction *)bigPlaneAction;

+ (SKAction *)playerPlaneAction;

+ (SKAction *)playerPlaneBlowupAction;

+ (SKAction *)hitActionWithFoePlaneType:(SKFoePlaneType)type;

+ (SKAction *)blowupActionWithFoePlaneType:(SKFoePlaneType)type;

+ (void)setDoubleBullet:(NSString*)type;

@end
