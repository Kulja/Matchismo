//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Marko Kuljanski on 1/27/13.
//  Copyright (c) 2013 Marko Kuljanski. All rights reserved.
//

#import "CardGameViewController.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) PlayingCardDeck *playingCardDeck;
@end

@implementation CardGameViewController

- (PlayingCardDeck *)playingCardDeck
{
    if (!_playingCardDeck) _playingCardDeck = [[PlayingCardDeck alloc] init];
    return _playingCardDeck;
}

- (void)setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

- (IBAction)flipCard:(UIButton *)sender
{
    sender.selected = !sender.isSelected;
    if (sender.isSelected) {
        Card *drawnCard = self.playingCardDeck.drawRandomCard;
        if (drawnCard) {
            [sender setTitle:drawnCard.contents forState:UIControlStateSelected];
            self.flipCount++;
        } else {
            [sender setTitle:@"" forState:UIControlStateSelected];
        }
    }
}

@end
