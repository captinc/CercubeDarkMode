#import <objc/runtime.h>
#import <substrate.h>
#import "Tweak.h"
//FYI: all of the RGB color values that I use are the same ones that stock YouTube uses

bool darkModeIsOn() { //Returns true if YouTube's built-in dark mode is currently on, false otherwise
    UIViewController *YTAppViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    YTPageStyleController *darkModeController = MSHookIvar<YTPageStyleController *>(YTAppViewController, "_pageStyleController"); //YTPageStyleController is an ivar of YTAppViewController, not a @property
    if ([darkModeController pageStyle] == 1) { //pageStyle of 0 means light mode, 1 means dark mode
        return true;
    }
    else {
        return false;
    }
}

//I wanted to do something like "%hook Class1, Class2, Class3" to apply the same replacement code to the same methods in multiple classes
//You can't do it automatically like that, but you can do it manually like this (also requires the stuff in %ctor at the bottom)
static void (* original_viewDidLoad)(id self, SEL _cmd);
void viewDidLoad_replacement(id self, SEL _cmd) {
    original_viewDidLoad(self, _cmd); //Equivalent to "%orig;"
    OneOfCercubesViewControllers *newSelf = (OneOfCercubesViewControllers *)self;
    newSelf.tableView.separatorColor = [UIColor clearColor]; //Always hide UITableView separators (to match how stock YouTube looks)
    
    if (darkModeIsOn()) {
        newSelf.view.backgroundColor = [UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1]; //Background color of each menu
        
        NSArray *classes = @[@"CATabBarConfigurationViewController", @"CAAboutViewController", @"CACreateAccountViewController", @"CAResetPasswordViewController"];
        if ([classes containsObject:NSStringFromClass([self class])]) { //Color of the text in UITableViewHeaderFooterView in these ^ menus
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ //For some reason, the text color wasn't changing, but putting it in dispatch_after fixed it
                CAFormTextFooterView *footer = (CAFormTextFooterView *)[newSelf.tableView footerViewForSection:0];
                footer.titleLabel.textColor = [UIColor colorWithRed:0.667 green:0.667 blue:0.667 alpha:1];
                footer.subtitleLabel.textColor = [UIColor colorWithRed:0.667 green:0.667 blue:0.667 alpha:1];
            });
        }
    }
}

static UITableViewCell *(* original_cellForRowAtIndexPath)(id self, SEL _cmd, UITableView *tableView, NSIndexPath *indexPath);
UITableViewCell *cellForRowAtIndexPath_replacement(id self, SEL _cmd, UITableView *tableView, NSIndexPath *indexPath) {
    OneOfCercubesCells *cell = (OneOfCercubesCells *)original_cellForRowAtIndexPath(self, _cmd, tableView, indexPath); //Equivalent to "cell = %orig;"
    if ([cell respondsToSelector:@selector(textField)]) {
        MDCTextField *field = cell.textField;
        field.underline.alpha = 0; //Always hide UITableView separators
        cell.textField = field;

        MDCTextInputControllerUnderline *ctrl = cell.textFieldController;
        ctrl.activeColor = [UIColor colorWithRed:0.26 green:0.42 blue:0.95 alpha:1]; //Always make the color of Cercube's text cursor match the stock YouTube one
        cell.textFieldController = ctrl;
    }
    if ([cell respondsToSelector:@selector(checkmarkImageView)]) { //Always make the color of the checkmark icon inside the "Download Quality" picker menu match the stock YouTube one. Also applies to similar menus
        UIImageView *view = cell.checkmarkImageView;
        view.tintColor = [UIColor colorWithRed:0.039 green:0.518 blue:1 alpha:1];
        cell.checkmarkImageView = view;
    }
    
    if (darkModeIsOn()) {
        cell.backgroundColor = [UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1]; //Background color of each cell

        if ([cell respondsToSelector:@selector(titleLabel)]) { //Color of the text in each cell
            UILabel *label = cell.titleLabel;
            label.textColor = [UIColor whiteColor];
            cell.titleLabel = label;
        }
        if ([cell respondsToSelector:@selector(subtitleLabel)]) {
            UILabel *label = cell.subtitleLabel;
            label.textColor = [UIColor colorWithRed:0.667 green:0.667 blue:0.667 alpha:1];
            cell.subtitleLabel = label;
        }
        if ([cell respondsToSelector:@selector(valueLabel)]) {
            UILabel *label = cell.valueLabel;
            label.textColor = [UIColor colorWithRed:0.667 green:0.667 blue:0.667 alpha:1];
            cell.valueLabel = label;
        }
        if ([cell respondsToSelector:@selector(textField)]) { //Text color in the Edit Profile, Login, Create account, and Reset password menus
            MDCTextField *field = cell.textField;
            field.textColor = [UIColor whiteColor]; //Actual content of each cell (such as your first name)
            field.keyboardAppearance = UIKeyboardAppearanceDark; //Dark keyboard
            cell.textField = field;
            
            MDCTextInputControllerUnderline *ctrl = cell.textFieldController;
            ctrl.floatingPlaceholderNormalColor = [UIColor colorWithRed:0.667 green:0.667 blue:0.667 alpha:1]; //The tiny label/title that's on top of each cell
            ctrl.floatingPlaceholderActiveColor = [UIColor colorWithRed:0.667 green:0.667 blue:0.667 alpha:1];
            ctrl.inlinePlaceholderColor = [UIColor colorWithRed:0.667 green:0.667 blue:0.667 alpha:1]; //The placeholder that's inside each cell
            cell.textFieldController = ctrl;
        }

        NSArray *classes = @[@"CAAdditionalPerksInteractor", @"CAAttributionsInteractor"];
        if ([classes containsObject:NSStringFromClass([self class])] && [cell respondsToSelector:@selector(_imageView)]) { //Color of the icons inside the "Additional perks" and "Open-Source Libraries" menus
            UIImageView *view = cell._imageView;
            view.tintColor = [UIColor whiteColor];
            cell._imageView = view;
        }
    }
    return cell;
}

//--------------------------------------------------------------------------------------------------------------------------
%hook CATextContainerViewController //Privacy Policy, Terms of Service, and Help & Feedback menus
- (void)viewDidLoad {
    %orig;
    if (darkModeIsOn()) {
        self.textView.backgroundColor = [UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1];
        self.textView.textColor = [UIColor whiteColor];
    }
}
%end

%hook JTMaterialSwitch //Make Cercube's toggles look like the stock YouTube ones
- (void)setTrackOnTintColor:(UIColor *)color {
    if (darkModeIsOn()) {
        color = [UIColor colorWithRed:0.243 green:0.651 blue:1 alpha:0.5];
    }
    else {
        color = [UIColor colorWithRed:0.024 green:0.373 blue:0.831 alpha:0.5];
    }
    %orig(color);
}
- (void)setTrackOffTintColor:(UIColor *)color {
    if (darkModeIsOn()) {
        color = [UIColor colorWithWhite:1 alpha:0.3];
    }
    else {
        color = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.26];
    }
    %orig(color);
}
- (void)setTrackDisabledTintColor:(UIColor *)color {
    if (darkModeIsOn()) {
        color = [UIColor colorWithWhite:1 alpha:0.1];
    }
    else {
        color = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.12];
    }
    %orig(color);
}
- (void)setThumbOnTintColor:(UIColor *)color {
    if (darkModeIsOn()) {
        color = [UIColor colorWithRed:0.243 green:0.651 blue:1 alpha:1];
    }
    else {
        color = [UIColor colorWithRed:0.024 green:0.373 blue:0.831 alpha:1];
    }
    %orig(color);
}
- (void)setThumbOffTintColor:(UIColor *)color {
    if (darkModeIsOn()) {
        color = [UIColor colorWithRed:0.741 green:0.741 blue:0.741 alpha:1];
    }
    else {
        color = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1];
    }
    %orig(color);
}
- (void)setThumbDisabledTintColor:(UIColor *)color {
    if (darkModeIsOn()) {
        color = [UIColor colorWithRed:0.259 green:0.259 blue:0.259 alpha:1];
    }
    else {
        color = [UIColor colorWithRed:0.741 green:0.741 blue:0.741 alpha:1];
    }
    %orig(color);
}
- (void)setRippleFillColor:(UIColor *)color {
    if (darkModeIsOn()) {
        color = [UIColor colorWithRed:0.243 green:0.651 blue:1 alpha:1];
    }
    else {
        color = [UIColor colorWithRed:0.024 green:0.373 blue:0.831 alpha:0.5];
    }
    %orig(color);
}
%end

//--------------------------------------------------------------------------------------------------------------------------
%ctor {
    %init;
    //Apply the "viewDidLoad" hook to these classes
    NSArray *classes = @[@"CASettingsViewController2", @"CASelectionMenuViewController", @"CATabBarConfigurationViewController", @"CAAboutViewController", @"CAAttributionsViewController", @"CAAccountDetailsViewController", @"CAEditAccountViewController", @"CALoginViewController", @"CACreateAccountViewController", @"CAResetPasswordViewController", @"CAAdditionalPerksViewController"];
    for (int x = 0; x < [classes count]; x++) {
        MSHookMessageEx(objc_getClass([[classes objectAtIndex:x] UTF8String]), @selector(viewDidLoad), (IMP)viewDidLoad_replacement, (IMP *)&original_viewDidLoad);
    }
    
    //Apply the "tableView:cellForRowAtIndexPath:" hook to these classes
    classes = @[@"CASettingsInteractor", @"CASelectionMenuInteractor", @"CATabBarConfigurationInteractor", @"CAAboutInteractor", @"CAAttributionsInteractor", @"CAAccountDetailsInteractor", @"CAEditAccountInteractor", @"CALoginInteractor", @"CACreateAccountInteractor", @"CAResetPasswordInteractor", @"CAAdditionalPerksInteractor"];
    for (int x = 0; x < [classes count]; x++) {
        MSHookMessageEx(objc_getClass([[classes objectAtIndex:x] UTF8String]), @selector(tableView:cellForRowAtIndexPath:), (IMP)cellForRowAtIndexPath_replacement, (IMP *)&original_cellForRowAtIndexPath);
    }
}
