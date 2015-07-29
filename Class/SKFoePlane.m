//
//  SKFoePlane.m
//  SpriteKit
//
//  Created by Ray on 14-1-20.
//  Copyright (c) 2014年 CpSoft. All rights reserved.
//

#import "SKFoePlane.h"

#import "SKSharedAtles.h"

@implementation SKFoePlane


+ (instancetype)createBigPlane{
   

    SKFoePlane *foePlane = (SKFoePlane *)[SKFoePlane spriteNodeWithTexture:[SKSharedAtles textureWithType:SKTextureTypeBigFoePlane]];
    foePlane.hp = 7;
    foePlane.type = SKFoePlaneTypeBig;
    foePlane.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:foePlane.size];
  
    return foePlane;
}

+ (instancetype)createMediumPlane{
    SKFoePlane *foePlane = (SKFoePlane *)[SKFoePlane spriteNodeWithTexture:[SKSharedAtles textureWithType:SKTextureTypeMediumFoePlane]];
    foePlane.hp = 5;
    foePlane.type = SKFoePlaneTypeMedium;
    foePlane.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:foePlane.size];

    return foePlane;
}

+ (instancetype)createSmallPlane{
    SKFoePlane *foePlane = (SKFoePlane *)[SKFoePlane spriteNodeWithTexture:[SKSharedAtles textureWithType:SKTextureTypeSmallFoePlane]];
    foePlane.hp = 1;
    foePlane.type = SKFoePlaneTypeSmall;
    foePlane.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:foePlane.size];

    return foePlane;
}

+ (instancetype)createBomb{
    SKFoePlane *bombPlane = (SKFoePlane *)[SKFoePlane spriteNodeWithTexture:[SKSharedAtles textureWithType:SKTextureTypeBomb]];
    bombPlane.hp = 1;
    bombPlane.type = SKTextureTypeBomb;
    bombPlane.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:bombPlane.size];

    
    return bombPlane;
}

+ (instancetype)createDoubleBullet{
    SKFoePlane *doubleBullet = (SKFoePlane *)[SKFoePlane spriteNodeWithTexture:[SKSharedAtles textureWithType:SKTextureTypeDoubleBullet] size:CGSizeMake(40,  70)];
    doubleBullet.hp = 1;
    doubleBullet.type = SKTextureTypeDoubleBullet;
    doubleBullet.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:doubleBullet.size];
    
    
    return doubleBullet;
}

@end
