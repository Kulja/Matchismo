//
//  PlayingSetCardDeck.m
//  Matchismo
//
//  Created by Marko Kuljanski on 2/8/13.
//  Copyright (c) 2013 Marko Kuljanski. All rights reserved.
//

#import "SetCardDeck.h"

@implementation PlayingSetCardDeck

- (id)init
{
    self = [super init];
    
    if (self) {
        for (NSString *symbol in [PlayingSetCard validSuits]) {
            for (NSInteger number = 1; number <= [PlayingSetCard maxRank]; number++) {
                for (NSString *shading in [PlayingSetCard validShadings]) {
                    for (NSString *color in [PlayingSetCard validColors]) {
                        PlayingSetCard *card = [[PlayingSetCard alloc] init];
                        card.suit = symbol;
                        card.rank = number;
                        card.shading = shading;
                        card.color = color;
                        [self addCard:card atTop:YES];
                    }
                }
            }
        }
    }
    
    return self;
}

@end
