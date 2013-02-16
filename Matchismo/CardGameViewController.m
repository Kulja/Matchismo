//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Marko Kuljanski on 1/27/13.
//  Copyright (c) 2013 Marko Kuljanski. All rights reserved.
//

#import "CardGameViewController.h"

@interface CardGameViewController () <UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UICollectionView *cardCollectionView;
@property (weak, nonatomic) IBOutlet UIView *lastFlipStatusView;
@end

@implementation CardGameViewController

- (CardMatchingGame *)game
{
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:self.startingCardCound
                                                  usingDeck:[self createDeck]];
        self.game.numberOfCardsToMatch = self.numberOfCardsToMatch;
        self.game.matchBonus = self.matchBonus;
        self.game.mismatchPenalty = self.mismatchPenalty;
        self.game.flipCost = self.flipCost;
    }
    return _game;
}

- (Deck *)createDeck
{
    return nil; // abstract
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.game.cards count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Card" forIndexPath:indexPath];
    Card *card = [self.game cardAtIndex:indexPath.item];
    [self updateCell:cell usingCard:card];
    return cell;
}

- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card
{
    // abstract
}

- (void)updateLastFlipStatusView:(UIView *)view usingLastFlipResult:(NSArray *)flipResult andInfoLabel:(UILabel *)infoLabel
{
    // abstract
}

- (void)deleteCards:(NSArray *)cards
{
    [self.cardCollectionView deleteItemsAtIndexPaths:[self.game getIndexPathsForDeletedCards:cards]];
}

- (void)updateUI
{
    for (UICollectionViewCell *cell in [self.cardCollectionView visibleCells]) {
        NSIndexPath *indexPath = [self.cardCollectionView indexPathForCell:cell];
        Card *card = [self.game cardAtIndex:indexPath.item];
        [self updateCell:cell usingCard:card];
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    [self updateLastFlipStatusView:self.lastFlipStatusView usingLastFlipResult:[self.game.flipResultHistory lastObject] andInfoLabel:self.infoLabel];
}

- (IBAction)flipCard:(UITapGestureRecognizer *)gesture
{
    CGPoint tapLocation = [gesture locationInView:self.cardCollectionView];
    NSIndexPath *indexPath = [self.cardCollectionView indexPathForItemAtPoint:tapLocation];
    if (indexPath) {
        [self.game flipCardAtIndex:indexPath.item];
        [self updateUI];
    }
}

- (IBAction)plusButtonClicked
{
    NSArray *indexPaths = [self.game getIndexPathsForInsertedCards:self.numberOfCardsToGetOnHitMeClick];
    if ([indexPaths count] != 0) {
        [self.cardCollectionView insertItemsAtIndexPaths:indexPaths];
        [self.cardCollectionView scrollToItemAtIndexPath:[indexPaths lastObject] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    } else {
        self.infoLabel.text = @"No cards available";
    }
}

- (IBAction)startNewGame:(UIButton *)sender
{
    self.game = nil;
    [self.cardCollectionView reloadData];
    [self updateUI];
}

- (void)viewDidUnload {
    [self setLastFlipStatusView:nil];
    [self setScoreLabel:nil];
    [self setInfoLabel:nil];
    [self setCardCollectionView:nil];
    [super viewDidUnload];
}
@end
