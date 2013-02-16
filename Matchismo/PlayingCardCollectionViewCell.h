//
//  PlayingCardCollectionViewCell.h
//  Matchismo
//
//  Created by Marko Kuljanski on 2/13/13.
//  Copyright (c) 2013 Marko Kuljanski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayingCardView.h"

@interface PlayingCardCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet PlayingCardView *playingCardView;

@end
