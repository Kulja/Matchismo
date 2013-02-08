//
//  PlayingSetCard.h
//  Matchismo
//
//  Created by Marko Kuljanski on 2/8/13.
//  Copyright (c) 2013 Marko Kuljanski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlayingCard.h"

@interface PlayingSetCard : PlayingCard

@property (strong, nonatomic) NSString *shading;
@property (strong, nonatomic) NSString *color;

+ (NSArray *)validShadings;
+ (NSArray *)validColors;

@end
