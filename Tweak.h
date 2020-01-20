//Normal @interfaces
@interface YTAppViewController : UIViewController
@end

@interface YTPageStyleController : NSObject
- (NSInteger)pageStyle;
@end

@interface CAFormTextFooterView : UITableViewHeaderFooterView
@property UILabel *titleLabel;
@property UILabel *subtitleLabel;
@end

@interface MDCTextField : UITextField
@property UIView *underline;
@end

@interface MDCTextInputControllerUnderline : NSObject
@property UIColor *activeColor;
@property UIColor *floatingPlaceholderNormalColor;
@property UIColor *floatingPlaceholderActiveColor;
@property UIColor *inlinePlaceholderColor;
@end

@interface CATextContainerViewController : UIViewController
@property UITextView *textView;
- (void)viewDidLoad;
@end

@interface JTMaterialSwitch : UIControl
- (void)setTrackOnTintColor:(UIColor *)color;
- (void)setTrackOffTintColor:(UIColor *)color;
- (void)setTrackDisabledTintColor:(UIColor *)color;
- (void)setThumbOnTintColor:(UIColor *)color;
- (void)setThumbOffTintColor:(UIColor *)color;
- (void)setThumbDisabledTintColor:(UIColor *)color;
- (void)setRippleFillColor:(UIColor *)color;
@end

//These are needed for the multi-class-hooking thing. You can see a list of all the classes I hook in %ctor in Tweak.xm
@interface OneOfCercubesViewControllers : UIViewController
@property UITableView *tableView;
- (void)viewDidLoad;
@end

@interface OneOfCercubesInteractors : NSObject
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;;
@end

@interface OneOfCercubesCells : UITableViewCell
@property UILabel *titleLabel;
@property UILabel *subtitleLabel;
@property UILabel *valueLabel;
@property MDCTextField *textField;
@property MDCTextInputControllerUnderline *textFieldController;
@property UIImageView *checkmarkImageView;
@property UIImageView *_imageView;
@end
