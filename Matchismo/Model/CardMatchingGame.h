//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Marko Kuljanski on 2/2/13.
//  Copyright (c) 2013 Marko Kuljanski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"
#import "Deck.h"

@interface CardMatchingGame : NSObject

// designated initializer
- (id)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck;

- (void)flipCardAtIndex:(NSUInteger)index;

- (Card *)cardAtIndex:(NSUInteger)index;

@property (readonly, nonatomic) int score;
@property (strong, nonatomic) NSMutableArray *flipResultHistory;
@property (nonatomic) int numberOfMatchesRequired;

@end
