# SakaiClientiOS

## About
This repo is for a mobile client for Rutgers Sakai on iOS (Android: https://github.com/SChakravorti21/SakaiClientAndroid). Under active development.

## Current App Status: 
Available for Download: https://itunes.apple.com/us/app/rutgers-sakai-mobile/id1435278106?mt=8

### Screenshots
<span>
    <img src="https://github.com/PRAN1999/SakaiClientiOS/blob/master/repo/Sakai-Home.png" height="600">
    <img src="https://github.com/PRAN1999/SakaiClientiOS/blob/master/repo/Sakai-Gradebook.png" height="600">
    <img src="https://github.com/PRAN1999/SakaiClientiOS/blob/master/repo/Sakai-Announcements.png" height="600">
    <img src="https://github.com/PRAN1999/SakaiClientiOS/blob/master/repo/Sakai-Assignments.png" height="600">
    <img src="https://github.com/PRAN1999/SakaiClientiOS/blob/master/repo/Sakai-Resources.png" height="600">
    <img src="https://github.com/PRAN1999/SakaiClientiOS/blob/master/repo/Sakai-Assignment-Page.png" height="600">
</span>

## Current App Features
<ul>
    <li>View All your Courses in a centralized location</li>
    <li>View All your Grades at once</li>
    <li>See all your Announcements as an email feed</li>
    <li>Page through your Assignments and submit from the app</li>
    <li>Easily flip through and download your resources</li>
    <li>Use the native inline submission editor to easily edit your Assignment submissions</li>
</ul>

## Setting up Dev Environment
If you'd like to compile and run the source code yourself, you can do so on any Mac machine. The dependencies are already included in the repo.

Run the following commands:

    git clone https://github.com/PRAN1999/SakaiClientiOS.git
    cd SakaiClientiOS
    open -a XCode SakaiClientiOS.xcworkspace
        
This should open the project in XCode. If you do not see "SakaiClientiOS" as a target in the top left of the screen, click on the target list and then click "New Scheme". Then add "SakaiClientiOS" as a target and run Cmd-B to build the target.

If there are any issues with building the project, try reinstalling the CocoaPods:

    pod clean
    pod install
      
from your root directory in Terminal. If issues persist after that, shoot us an email at rutgerssakaiapp@gmail.com and we'll do our best to help you out.

## Contributing
As an open-sourced app, the Rutgers Sakai App team welcomes pull requests for features and bugs. A CONTRIBUTING.md guide will be published soon.

## LICENSE
SakaiClientiOS is licensed under the GPL v3.0 license. See [LICENSE.md](https://github.com/PRAN1999/SakaiClientiOS/blob/master/LICENSE)
