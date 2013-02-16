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
- (NSArray *)getIndexPathsForDeletedCards:(NSArray *)cards;
- (NSArray *)getIndexPathsForInsertedCards:(NSUInteger)numberOfCards;

@property (readonly, strong, nonatomic) NSMutableArray *cards; // of Card
@property (readonly, nonatomic) int score;
@property (readonly, strong, nonatomic) NSMutableArray *flipResultHistory;
@property (nonatomic) int numberOfCardsToMatch;
@property (nonatomic) int matchBonus;
@property (nonatomic) int mismatchPenalty;
@property (nonatomic) int flipCost;

@end
