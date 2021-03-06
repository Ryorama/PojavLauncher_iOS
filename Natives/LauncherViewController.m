#import "LauncherViewController.h"

#include "utils.h"

@interface LauncherViewController () {
}

// - (void)method

@end

@implementation LauncherViewController

UITextField* versionTextField;

- (void)viewDidLoad
{
    [super viewDidLoad];

    FILE *configver_file = fopen("/var/mobile/Documents/minecraft/config_ver.txt", "rw");

    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGFloat screenScale = [[UIScreen mainScreen] scale];
    
    int width = (int) roundf(screenBounds.size.width);
    int height = (int) roundf(screenBounds.size.height);
    
    CGFloat widthSplit = width / 4.0;
    
    UIScrollView *scrollView = self.view = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"login_background.png"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];

    char configver[1024];
    if (!fgets(configver, 1024, configver_file)) {
        NSLog(@"Error: could not read config_ver.txt");
    }

    UILabel *versionTextView = [[UILabel alloc] initWithFrame:CGRectMake(4.0, 4.0, 0.0, 30.0)];
    versionTextView.text = @"Minecraft version:";
    versionTextView.numberOfLines = 0;
    [versionTextView sizeToFit];
    [scrollView addSubview:versionTextView];

    versionTextField = [[UITextField alloc] initWithFrame:CGRectMake(versionTextView.bounds.size.width + 4.0, 4.0, width - versionTextView.bounds.size.width - 8.0, versionTextView.bounds.size.height)];
    [versionTextField addTarget:versionTextField action:@selector(resignFirstResponder) forControlEvents:UIControlEventEditingDidEndOnExit];
    versionTextField.placeholder = @"Minecraft version";
    versionTextField.text = [NSString stringWithUTF8String:configver];
    fclose(configver_file);
    [scrollView addSubview:versionTextField];
    
    install_progress_bar = [[UIProgressView alloc] initWithFrame:CGRectMake(4.0, height - 58.0, width - 8.0, 6.0)];
    [scrollView addSubview:install_progress_bar];

    UIButton *button_play = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button_play setTitle:@"Play" forState:UIControlStateNormal];
    button_play.frame = CGRectMake(widthSplit + (width - widthSplit * 2.0) / 2.0 + 2.0 - 5.0, (height + 650.0) / 2.0 - 4.0 - 50.0, 120.0, 50.0);
    button_play.backgroundColor = [UIColor colorWithRed:54/255.0 green:176/255.0 blue:48/255.0 alpha:1.0];
    button_play.layer.cornerRadius = 5;
    [button_play setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button_play addTarget:self action:@selector(launchMinecraft:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:button_play];
    install_progress_text = [[UILabel alloc] initWithFrame:CGRectMake(120.0, height - 54.0, width - 124.0, 50.0)];
    [scrollView addSubview:install_progress_text];
    
    UIButton *button_change_version = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button_change_version setTitle:@"Play" forState:UIControlStateNormal];
    button_change_version.frame = CGRectMake(widthSplit + (width - widthSplit * 2.0) / 2.0 + 2.0 - 5.0, (height + 650.0) / 2.0 - 4.0 - 50.0, 120.0, 50.0);
    button_change_version.backgroundColor = [UIColor colorWithRed:54/255.0 green:176/255.0 blue:48/255.0 alpha:1.0];
    button_change_version.layer.cornerRadius = 5;
    [button_change_version setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button_change_version addTarget:self action:@selector(changeMinecraftVersion) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:button_change_version];
    install_progress_text = [[UILabel alloc] initWithFrame:CGRectMake(120.0, height - 54.0, width - 124.0, 50.0)];
    [scrollView addSubview:install_progress_text];
}

-(void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection API_AVAILABLE(ios(13.0)) {
}

- (void)launchMinecraft:(id)sender
{
    [(UIButton*) sender setEnabled:NO];

    [versionTextField.text writeToFile:@"/var/mobile/Documents/minecraft/config_ver.txt" atomically:NO encoding:NSUTF8StringEncoding error:nil];
    callback_LauncherViewController_installMinecraft();
}

- (void)changeMinecraftVersion
{
    self.tableView = [self makeTableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"minecraftVersions"];
    [self.view addSubview:self.tableView];
}

-(BOOL)prefersStatusBarHidden {
    return YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"minecraftVersions";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
//etc.
return cell;
}

 -(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}

@end
