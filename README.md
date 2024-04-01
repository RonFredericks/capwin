# capwin - Mac Windows Capture

Z Shell script to easily capture multiple windowed images using Mac built-in tools screencapture and sips.

## Description

The Mac built-in tools screencapture and Scriptable image processing system (sips) are poorly documented and have several gotcha's resulting in time delays to effective use. This script uses a subset of these tools for window capture and image manipulation, requiring only one click for each image captured. 

Example as used from the command line: `capwin.sh`:

![capwin.sh example as launched from the command line](http://www.biophysicslab.com/wp-content/uploads/2024/03/capwin_launched_from_terminal.jpg)

Example as used from the command line: `capwin.sh --help`:

![capwin.sh example as launched from the command line](http://www.biophysicslab.com/wp-content/uploads/2024/03/capwin_options_from_terminal.jpg)

Other options for window capture are available to the Mac user, including command key combinations that are hard for me to remember, and the screenshot utility, which has many options for multiple steps to save a captured window to a file in a desired format.

capwin script has built-in defaults that can be overridden from the command line or by editing the module capwin_vars.sh. Here are some tested combinations:

 - Image Format - jpeg,  jpg [default],, tiff, tif, pdf, png, psd
 - Image Compression - low, medium, high, normal [default], lzw, packbits, default
 - Image Density -  72, 144 [default], 300
 - Image Shadow true false [default]
 - Path Where Images Are Saved  - ~/DeskTop [default]
 - Image Prefix - screen_ [default]

There are many other image formats available. See the **Help** section below.

## Getting Started
Download code and unzip as needed from github

### Usage Option 1 (command line)

**Preparation:**

 - Copy script (`capwin.sh` and `capwin_support directory`) to   
   `/usr/local/bin`

 - Make the script executable from the terminal.
      `chmod +x /usr/local/bin/capwin.sh`    

          
**Execution examples:**

 - Execute script with default arguments from any directory on the
   terminal, 
         type: `capwin.sh` 

 - Execute script after replacing default dots-per-inch and image
   format,
         type: `capwin.sh -d 72 -i tiff`
         
 - For help on available control arguments, 
         type: `capwin.sh --help`

### Usage Option 2 (mouse click from desktop or finder)

**Preparation:**

 - Copy script (`capwin.sh` and `capwin_support directory`) to   
   ~/Desktop
   Note: I prefer Using the desktop for a visual experience, but any path will work.
   
 - Make the script executable from the terminal. 
    `       chmod +x /users/ronfred/Desktop/capwin.sh` 
Where `/users//ronfred/` is just an example representing your home path.
 
 - Make the script executable from the finder/desktop.
     - Right Mouse Click over `capwin.sh`
     - Use the *Get Info* menu option to change the default launch application.
     `Get Info -> Open with -> Other -> All Applications -> Utilities -> Terminal.app`
    
     - Note: Do not click *Change All...* button, as other scripts with the extension `.sh` would then be affected.

**Execution:**

 - Execute the script by double-clicking on `capwin.sh` from the finder or desktop.
 - Optionally change default control parameters by editing
    `./capwin_support/capwin_vars.sh`

### Dependencies

 - `capwin_help.sh` (part of this package: used to display command line options)
 - `capwin_vars.sh` (part of this package: easy access to default variables)
 - screencapture (part of MacOS distribution)
 - sips (part of MacOS distribution)

### Test Platforms

 - Apple M1 Ultra,
     - MacOS: Sonoma 14.4, and 
     - zsh: 5.2
 - Apple iMac (21.5-inch, Late 2013) i5,
     - MacOS: Sierra 10.12.6, and 
     - zsh: 5.2

## Help

For help on available control arguments, type:
 `capwin.sh --help`
         
See the man pages for:

 - [screencapture man page on ss64.com](https://ss64.com/mac/screencapture.html)
 - [sips man page on ss64.com](https://ss64.com/mac/sips.html)

## Authors

Ron Fredericks 
[BiophysicsLab.com](https://www.biophysicslab.com/)

## Version History

* 03/30/2024
    * Initial Release

## License

This project is licensed under the [UNLICENSE] License - see the UNLICENSE.txt file for details

## Acknowledgments

Inspiration, code snippets, etc.
* [The Z Shell Manual by Paul Falstad, 2022](https://zsh.sourceforge.io/Doc/Release/)
* [macOS image manipulation with sips (SmittyTone ,2019)](https://blog.smittytone.net/2019/10/24/macos-image-manipulation-with-sips/)
* [Passing Arguments to a Bash/Zsh Script, Rowan C Nicholls, Google Scholar](https://rowannicholls.github.io/bash/intro/passing_arguments.html)
* [Robert C. Martin, Clean Code: A Handbook of Agile Software Craftsmanship, 2009](https://github.com/martinmurciego/good-books/tree/master) -> Clean Code...
