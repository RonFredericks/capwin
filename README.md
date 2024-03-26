 capwin
 Capture multiple window images using Z Shell

 Info from top of capwin.sh

 File:            capwin.sh
 Title:           Capture Windows Utility 
 Purpose:         Manually capture many windowed images from monitors quickly.
 Dependencies:    capwin_help.sh (part of this package)
                  UNLICENSE.txt (opensource license)
                  screencapture (part of Z Shell distribution)
                  sips (part of Z Shell distribution)
 Type:            zsh script
 Creation date:   3/08/24
 Platforms tested: 
                  Apple M1 Ultra, 
                       MacOS: Sonoma 14.4, and 
                       zsh: 5.9
                  Apple iMac (21.5-inch, Late 2013) i5, 
                       MacOS: Sierra 10.12.6, and 
                       zsh: 5.2
 Developer:       BiophysicsLab.com
 License:         The Unlicense https://unlicense.org



 Usage Option 1:
 ---------------

 Use script from the terminal with support for image control arguments.
   Preparation:
       Copy script (capwin.sh and capwin_help.sh) to /usr/local/bin
       Make script executable from terminal.
           chmod +x /usr/local/bin/capwin.sh
   Execution:
       Execute script with default arguments from any directory on terminal, 
           type: capwin.sh
       For help on available control arguments, 
           type: capwin.sh --help

 Usage Option 2:
 ---------------

 Use finder to click and launch script with default options.
   Preparation:
       Copy script (capwin.sh and capwin_help.sh) to ~/Desktop
       Note: Using the desktop is my preference for a visual experience, 
           but any path will work.
       Make script executable from terminal.
           chmod +x /users/ronfred/Desktop/capwin.sh
           Notes: ronfred is an example, your user name will be different.
                  Don't use tilde (~) as part of path for chmod, 
                  it may not work.
       Make script executable from finder/desktop.
           Right Mouse Click over capwin.sh
           Use Get Info utility menu option to change 
               default launch application.
               Get Info -> Open with -> 
                   Other -> All Applications -> 
                   Utilities -> Terminal.app
               Note: Do not click "Change All..." button,
                     as other scripts with extension .sh would then 
                     be affected.
   Execution:
       Execute script by double clicking on capwin.sh from finder or desktop.

