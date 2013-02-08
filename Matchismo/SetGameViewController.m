//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Marko Kuljanski on 2/8/13.
//  Copyright (c) 2013 Marko Kuljanski. All rights reserved.
//

#import "SetGameViewController.h"

@interface SetGameViewController ()
@property (strong, nonatomic) CardMatchingGame *game;
@end

@implementation SetGameViewController

- (CardMatchingGame *)game
{
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                  usingDeck:[[PlayingSetCardDeck alloc] init]];
        self.game.numberOfCardsToMatch = 3;
    }
    return _game;
}

- (void)setCardButtons:(NSArray *)cardButtons
{
    super.cardButtons = cardButtons;
    for (UIButton *cardButton in self.cardButtons) {
        [cardButton setBackgroundImage:nil forState:UIControlStateNormal];
        [cardButton setBackgroundImage:nil forState:UIControlStateSelected];
        [cardButton setBackgroundImage:nil forState:UIControlStateSelected|UIControlStateDisabled];
    }
    [self updateUI];
}

- (NSDictionary *)getAttributesForACard:(PlayingSetCard *)playingSetCard
{
    if ([playingSetCard.shading isEqualToString:@"open"]) {
        return @{ NSForegroundColorAttributeName : [UIColor clearColor],
                  NSStrokeWidthAttributeName : @-5,
                  NSStrokeColorAttributeName : [UIColor valueForKey:playingSetCard.color] };
    } else if ([playingSetCard.shading isEqualToString:@"striped"]) {
        return @{ NSForegroundColorAttributeName : [[UIColor valueForKey:playingSetCard.color] colorWithAlphaComponent:0.2],
                  NSStrokeWidthAttributeName : @-5,
                  NSStrokeColorAttributeName : [UIColor valueForKey:playingSetCard.color]};
    } else if ([playingSetCard.shading isEqualToString:@"solid"]) {
        return @{ NSForegroundColorAttributeName : [UIColor valueForKey:playingSetCard.color] };
    } else {
        return @{};
    }
}

- (void)reportMatchMismatchOrFlippedUpCard:(NSArray *)history
{
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc]initWithString:@""];
    if ([history count] == 1) {
        
        PlayingSetCard *card = [history lastObject];
        [mutableAttributedString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"Flipped up "]];
        [mutableAttributedString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:card.contents attributes:[self getAttributesForACard:card]]];
        
    } else if ([history count] > 1){
        if ([[history objectAtIndex:1] doubleValue] > 0) {
            
            [mutableAttributedString appendAttributedString:[[NSMutableAttributedString alloc]initWithString:@"Matched "]];
            
            for (PlayingSetCard *playingSetCard in [history objectAtIndex:0]) {
                [mutableAttributedString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:playingSetCard.contents attributes:[self getAttributesForACard:playingSetCard]]];
            }
            
            [mutableAttributedString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" for %i points", [[history objectAtIndex:1] intValue]]]];
        } else {
            
            for (PlayingSetCard *playingSetCard in [history objectAtIndex:0]) {
                [mutableAttributedString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:playingSetCard.contents attributes:[self getAttributesForACard:playingSetCard]]];
            }
            
            [mutableAttributedString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" don't match (%i points)", [[history objectAtIndex:1] intValue]]]];
        }
    } else {
        self.infoLabel.attributedText = [[NSMutableAttributedString alloc]initWithString:@""];
    }
    
    [mutableAttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, mutableAttributedString.length)];
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = NSTextAlignmentCenter;
    [mutableAttributedString addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, mutableAttributedString.length)];
     self.infoLabel.attributedText = mutableAttributedString;
}

- (void)updateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        PlayingSetCard *card = (PlayingSetCard *)[self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        cardButton.selected = card.faceUp;
        cardButton.backgroundColor = (card.faceUp ? [UIColor grayColor] : [UIColor whiteColor]);
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = (card.isUnplayable ? 0.3 : 1.0);
        [cardButton setAttributedTitle:[[NSMutableAttributedString alloc] initWithString:card.contents attributes:[self getAttributesForACard:card]] forState:UIControlStateNormal];
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    [self reportMatchMismatchOrFlippedUpCard:[self.game.flipResultHistory lastObject]];
}

@end
