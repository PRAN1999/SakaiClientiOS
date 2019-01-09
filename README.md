# SakaiClientiOS

## About
This repo is for a mobile client for Rutgers Sakai on iOS (Android: https://github.com/SChakravorti21/SakaiClientAndroid). Currently in progress.

## Current App Status: 
Beta Testing

## Setting up Dev Environment
If you'd like to compile and run the source code yourself, you can do so on any Mac machine. The dependencies are included in the repo, however the API Key and Build Secret for Crashlytics are not included in the repo. If you would like to hook up your own Crashlytics account to the app, in the project root, add a file names config.txt and configure it according to config-example.txt. 

Otherwise, go into SakaiClientiOS/AppDelegate.swift and comment out the line:

    Fabric.with([Crashlytics.self])

Then, run the following commands:

    git clone https://github.com/PRAN1999/SakaiClientiOS.git
    cd SakaiClientiOS
    open -a XCode SakaiClientiOS.xcworkspace
        
This should open the project in XCode. If you do not see "SakaiClientiOS" as a target in the top left of the screen, click on the target list and then click "New Scheme". Then add "SakaiClientiOS" as a target and run Cmd-B to build the target.

If there are any issues with building the project, try reinstalling the CocoaPods:

    pod clean
    pod install
      
from your root directory in Terminal. If issues persist after that, shoot us an email at rutgerssakaiapp@gmail.com and we'll do our best to help you out.
