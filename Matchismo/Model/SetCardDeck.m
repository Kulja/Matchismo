//
//  PlayingSetCardDeck.m
//  Matchismo
//
//  Created by Marko Kuljanski on 2/8/13.
//  Copyright (c) 2013 Marko Kuljanski. All rights reserved.
//

#import "SetCardDeck.h"

@implementation SetCardDeck

- (id)init
{
    self = [super init];
    
    if (self) {
        for (NSString *symbol in [SetCard validSymbol]) {
            for (NSInteger number = 1; number <= [SetCard maxNumber]; number++) {
                for (NSString *shading in [SetCard validShadings]) {
                    for (NSString *color in [SetCard validColors]) {
                        SetCard *card = [[SetCard alloc] init];
                        card.number = number;
                        card.symbol = symbol;
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
