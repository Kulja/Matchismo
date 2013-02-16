//
//  PlayingSetCard.h
//  Matchismo
//
//  Created by Marko Kuljanski on 2/8/13.
//  Copyright (c) 2013 Marko Kuljanski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface SetCard : Card

@property (nonatomic) NSUInteger number;
@property (strong, nonatomic) NSString *symbol;
@property (strong, nonatomic) NSString *shading;
@property (strong, nonatomic) NSString *color;

+ (NSUInteger)maxNumber;
+ (NSArray *)numberStrings;
+ (NSArray *)validSymbol;
+ (NSArray *)validShadings;
+ (NSArray *)validColors;

@end
