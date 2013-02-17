//
//  PlayingCardGameViewController.m
//  Matchismo
//
//  Created by Marko Kuljanski on 2/13/13.
//  Copyright (c) 2013 Marko Kuljanski. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "PlayingCardCollectionViewCell.h"

@interface PlayingCardGameViewController ()

@end

@implementation PlayingCardGameViewController

- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

- (NSUInteger) startingCardCound
{
    return 22;
}

- (NSUInteger) numberOfCardsToMatch
{
    return 2;
}

- (NSUInteger) matchBonus
{
    return 4;
}

- (NSUInteger) mismatchPenalty
{
    return 2;
}

- (NSUInteger) flipCost
{
    return 1;
}

- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card
{
    if ([cell isKindOfClass:[PlayingCardCollectionViewCell class]]) {
        PlayingCardView *playingCardView = ((PlayingCardCollectionViewCell *)cell).playingCardView;
        if ([card isKindOfClass:[PlayingCard class]]) {
            PlayingCard *playingCard = (PlayingCard *)card;
            playingCardView.rank = playingCard.rank;
            playingCardView.suit = playingCard.suit;
            playingCardView.faceUp = playingCard.isFaceUp;
            playingCardView.alpha = playingCard.isUnplayable ? 0.3 : 1.0;
        }
    }
}

- (void)updateLastFlipStatusView:(UIView *)view usingLastFlipResult:(NSArray *)flipResult andInfoLabel:(UILabel *)infoLabel
{
    CGFloat xOffset = 0;
    
    for (UIView *subView in [view subviews]) {
        [subView removeFromSuperview];
    }
    
    for (Card *card in [flipResult objectAtIndex:0]) {
        if ([card isKindOfClass:[PlayingCard class]]) {
            PlayingCardView *playingCardView = [[PlayingCardView alloc] initWithFrame:CGRectMake(xOffset, 0, 50, view.bounds.size.height)];
            playingCardView.opaque = NO;
            [playingCardView setBackgroundColor:[UIColor clearColor]];
            PlayingCard *playingCard = (PlayingCard *)card;
            playingCardView.rank = playingCard.rank;
            playingCardView.suit = playingCard.suit;
            playingCardView.faceUp = YES;
            [view addSubview:playingCardView];
            xOffset += playingCardView.bounds.size.width + 10;
        }
    }
    
    if ([flipResult count] == 1) {
        if ([[flipResult objectAtIndex:0] count] == 0) {
            infoLabel.text = @" ";
        } else {
            infoLabel.text = @"Flipped up";
        }
    } else if ([flipResult count] == 2){
        if ([[flipResult objectAtIndex:1] doubleValue] > 0) {
            infoLabel.text = [NSString stringWithFormat:@"Matched! (%i points)", [[flipResult objectAtIndex:1] intValue]];
        } else {
            infoLabel.text = [NSString stringWithFormat:@"No match! (%i points)", [[flipResult objectAtIndex:1] intValue]];
        }
    } else {
        infoLabel.text = @" ";
    }
}

@end
