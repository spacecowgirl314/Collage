//
//  ORImaageView.h
//  GIFs
//
//  Created by orta therox on 12/01/2013.
//  Copyright (c) 2013 Orta Therox. All rights reserved.
//

#import <Quartz/Quartz.h>

@interface ORImageView : IKImageView {
}

-(void)setImageWithURL:(NSURL *)url collectionLayout:(NSCollectionViewLayout*)collectionLayout;

@end

extern NSMutableDictionary *imageCache;
extern NSMutableDictionary<NSString *, CAKeyframeAnimation *> *animationCache;
extern NSMutableDictionary<NSString *, NSValue *> *sizeCache;
