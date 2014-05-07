/*
 
 Erica Sadun, http://ericasadun.com
 Auto Layout Demystified
 Use at your own risk. Do no harm.
 
 All sizing must be internal to draggable views
 
 To make a custom object eligible to participate in UIKit Dynamics, adopt the UIDynamicItem protocol in the object’s class.
 Starting in iOS 7, the UIView and UICollectionViewLayoutAttributes classes implement this protocol.
 
*/

@import UIKit;
@import ObjectiveC;

extern NSString *const DraggableViewDidMove;

@interface UIView (DraggingUtility)
@property (nonatomic) BOOL draggingEnabled;

// No op if dragging isn't enabled
@property (nonatomic) BOOL sendDragNotifications; // Default no.
@property (nonatomic) BOOL constrainDragsToSuperview; // Default yes.
@property (nonatomic) CGFloat constrainedInset; // Default 8

// To support snapping back
@property (nonatomic, readonly) CGPoint preferredCenter;
@end