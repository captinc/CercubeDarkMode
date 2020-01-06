@interface CASettingsViewController : UIViewController
@property UITableView *tableView;
@end

%hook CASettingsViewController
- (void)viewDidLoad { //Background color of the Settings screen
    %orig;
    self.view.backgroundColor = [UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1];
    self.tableView.backgroundColor = [UIColor clearColor];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath { //Background color of cells
    UITableViewCell *cell = %orig;
    cell.backgroundColor = [UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1];
    return cell;
}
- (void)addSeparatorToCell:(id)arg1 { //Hide UITableView separators
    return;
}
%end

@interface CASettingsPickerCell : UITableViewCell
@end

%hook CASettingsPickerCell //Picker-menu cells
- (void)setTitleLabel:(UILabel *)label {
    label.textColor = [UIColor whiteColor];
    %orig(label);
}
- (void)setValueLabel:(UILabel *)label {
    label.textColor = [UIColor whiteColor];
    %orig(label);
}
%end

@interface CASettingsSwitchCell : UITableViewCell
@end

%hook CASettingsSwitchCell //Toggle cells
- (void)setTitleLabel:(UILabel *)label {
    label.textColor = [UIColor whiteColor];
    %orig(label);
}
- (void)setSubtitleLabel:(UILabel *)label {
    label.textColor = [UIColor whiteColor];
    %orig(label);
}
%end

@interface CASettingsLinkCell : UITableViewCell
@end

%hook CASettingsLinkCell //Cells that have an arrow on their right side
- (void)setTitleLabel:(UILabel *)label {
    label.textColor = [UIColor whiteColor];
    %orig(label);
}
%end

@interface CASettingsFooterCell : UITableViewCell
@end

%hook CASettingsFooterCell //Message at the bottom of the Tab Bar Layout and About screens
- (void)setTitleLabel:(UILabel *)label {
    self.contentView.subviews.lastObject.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    %orig(label);
}
- (void)setSubtitleLabel:(UILabel *)label {
    label.textColor = [UIColor whiteColor];
    %orig(label);
}
%end

@interface CASettingsSpacerCell : UITableViewCell
@end

%hook CASettingsSpacerCell //Spacer cell that's visible in the Edit Profile and Tab Bar Layout screens
- (void)setAlpha:(CGFloat)alpha {
    %orig(0);
}
%end

@interface CASettingsInfoCell : UITableViewCell
@end

%hook CASettingsInfoCell //Name, Email, Username, and Country cells under My Account
- (void)setTitleLabel:(UILabel *)label {
    label.textColor = [UIColor whiteColor];
    %orig(label);
}
- (void)setSubtitleLabel:(UILabel *)label {
    label.textColor = [UIColor whiteColor];
    %orig(label);
}
%end

@interface MDCTextField : UITextField
@property UILabel *placeholderLabel;
@property UIView *underline;
@end

%hook MDCTextField //Edit Profile, Log in, Create account, and Forgot password screens
- (void)setTextColor:(UIColor *)color {
    self.placeholderLabel.textColor = [UIColor colorWithWhite:1 alpha:0.6];
    self.underline.alpha = 0;
    %orig([UIColor whiteColor]);
}
- (void)setCursorColor:(UIColor *)color {
    %orig([UIColor whiteColor]);
}
- (void)setKeyboardAppearance:(NSInteger)appearance { //Dark keyboard
    %orig(UIKeyboardAppearanceDark);
}
%end

@interface CATextContainerViewController : UIViewController
@property UITextView *textView;
@end

%hook CATextContainerViewController //Privacy Policy, Terms of Service, and Help & Feedback screens
- (void)viewDidLoad {
    %orig;
    self.textView.backgroundColor = [UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1];
    self.textView.textColor = [UIColor whiteColor];
}
%end

@interface JTMaterialSwitch : NSObject
@end

%hook JTMaterialSwitch //Make Cercube's toggles look like the stock YouTube ones
- (void)setTrackOnTintColor:(UIColor *)color {
    %orig([UIColor colorWithRed:0.243 green:0.651 blue:1 alpha:0.5]);
}
- (void)setTrackOffTintColor:(UIColor *)color {
    %orig([UIColor colorWithWhite:1 alpha:0.3]);
}
- (void)setTrackDisabledTintColor:(UIColor *)color {
    %orig([UIColor colorWithWhite:1 alpha:0.1]);
}
- (void)setThumbOnTintColor:(UIColor *)color {
    %orig([UIColor colorWithRed:0.243 green:0.651 blue:1 alpha:1]);
}
- (void)setThumbDisabledTintColor:(UIColor *)color {
    %orig([UIColor colorWithRed:0.259 green:0.259 blue:0.259 alpha:1]);
}
- (void)setRippleFillColor:(UIColor *)color {
    %orig([UIColor colorWithRed:0.243 green:0.651 blue:1 alpha:1]);
}
%end
