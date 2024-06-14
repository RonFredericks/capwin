# capwin - a Mac Windows capture script

_capwin_ is a Z Shell script that easily captures, displays, and manipulates multiple window images using Mac's built-in tools: *_screencapture_*, *_sips_*, *_Preview_*, and *_applescript_*.

## Description

Sadly, the Mac built-in command line tools *_screencapture_* and *_Scriptable Image Processing System_* (sips) are poorly documented because of the vast options available. They also have several bugs that result in time delays and workaround strategies for practical use. This *_capwin_* script uses a subset of these tools for window capture and image manipulation, requiring only one click for each image captured.

The captured images can be presented in a tiled layout on the monitor using the Preview app for display and AppleScript to tile each image for easy edits and final use in documentation projects.

## Usage

Launch the _capwin_ script from the terminal as a command or mouse click the capwin.sh file from the desktop. Example showing initial launch screen: `capwin.sh`:

![capwin.sh example as launched from the command line](http://www.biophysicslab.com/wp-content/uploads/2024/06/capwin_launched_from_terminal.jpg)

Example showing several screen images captured:

![capwin.sh example as launched from the command line](http://www.biophysicslab.com/wp-content/uploads/2024/06/capwin_captured-images.jpg)


Example of Preview and window tiling after capturing several images:
![capwin.sh example as launched from the command line](http://www.biophysicslab.com/wp-content/uploads/2024/06/capwin_previews_images.png)


Example as used from the command line: `capwin.sh --help`:

![capwin.sh example as launched from the command line](http://www.biophysicslab.com/wp-content/uploads/2024/06/capwin_options_from_terminal-1.jpg)

Other options for window capture are available to the Mac user as an alternative to the _capwin_ script. These pre-existing tools include: 
- Command key combinations that I need help remembering and,
- The screenshot utility takes on a time commitment as it has many options with multiple steps to save a single captured window to a file in the desired format.

The _capwin_ script has built-in defaults that the user can override from the command line or by editing the default parameters in the module capwin_vars.sh. Here are some tested combinations:

- Image Format - jpeg,  jpg [default], tiff, tif, pdf, png, psd

- Image Compression - low, medium, high, normal [jpeg default], lzw, packbits, default

- Image Density -  72, 144 [default], 300

- Image Shadow - true, false [default]

- Path Where Images Are Saved  - ~/Desktop [default]

- Image Prefix - screen_ _[default]_

There are many other image formats available. See the ****Help**** section below. 

## Getting Started

Download the code and unzip it as needed from GitHub.

  ### Install and Use Option 1 (command line)

****Preparation:****

- Copy script (`capwin.sh` and `capwin_support directory`) to:

`/usr/local/bin`

- Make the script executable from the terminal:

`chmod +x /usr/local/bin/capwin.sh`

****Execution examples:****

- Execute script with default arguments from any directory on the terminal:

type: `capwin.sh`

- Execute script after replacing default dots-per-inch, image format and compression:

type: `capwin.sh -d 72 -i tiff -c packbits`

- For help on all available parameters:

type: `capwin.sh --help`

### Install and Use Option 2 (mouse click from desktop or finder)

****Preparation:****

- Copy script (`capwin.sh` and `capwin_support directory`) to the desktop:

~/Desktop

Note: I prefer Using the desktop for a visual experience, but any path will work.

- Make the script executable from the terminal:

  ` chmod +x /users/ronfred/Desktop/capwin.sh`

  Where `/users/ronfred/` is just an example representing your home path.

- Then make the script executable from the finder/desktop:

  -- Right Mouse Click over `capwin.sh`

  -- Use the *_Get Info_* menu option to change the default launch application.

  `Get Info -> Open with -> Other -> All Applications -> Utilities -> Terminal.app`

  -- Note: Do not click the *_Change All..._* button, as this will affect other scripts with the extension `.sh`.

****Execution:****

- First time usage:

- Right-click the mouse to open the macOS security warning

- Select the "Open" button

- Otherwise, macOS reports a security warning with no option to use `capwin.sh` from finder/desktop

- After first time usage:

- execute the script by double-clicking on `capwin.sh` from the finder or desktop.

- Optionally change default control parameters by editing

  `./capwin_support/capwin_vars.sh`

#### Support image for Option 2 (mouse click from desktop or finder)

First-time use right-clicking mouse:

![First-time use will require a mouse double-click to get the "open" button](http://www.biophysicslab.com/wp-content/uploads/2024/04/Fix_First_Time_Use_Right_Mouse_Click.jpg)

 
### Dependencies

- `capwin_help.sh` (part of this package: used to display command line options)

- `capwin_vars.sh` (part of this package: easy access to default variables)

- `capwin_fcns.sh` (part of this package: reusable functions)

- screen capture (part of macOS distribution)

- sips (part of macOS distribution)

- Preview (image and PDF viewer with editing features: part of macOS distribution)

- AppleScript (cascade/tile images displayed with Preview: part of macOS distribution)

### Test Platforms

- Apple M1 Ultra,
  -- macOS: Sonoma 14.5, and
  -- zsh: 5.9

- Apple iMac (21.5-inch, Late 2013) i5,
  -- macOS: Sierra 10.12.6, and
  -- zsh: 5.2

#### Test Cases 

Test `capwin.sh` command line options:

./capwin_support/tests/Test_Cases.txt

## Help

For help on available control arguments, type:

`capwin.sh --help`

See the man pages for:

- [screencapture man page on ss64.com](https://ss64.com/mac/screencapture.html)

- [sips man page on ss64.com](https://ss64.com/mac/sips.html)

- [Preview guide on Apple support site](https://support.apple.com/en-gb/guide/preview/welcome/mac)  

## Authors

Ron Fredericks

[BiophysicsLab.com](https://www.biophysicslab.com/)

## Version History

  - 06/14/2024
  -- New version format: version 1.2.1
  -- New features (add preview option and image tiling with AppleScript
  -- Separate reusable functions to a new file capwin_fcns.sh
  -- Demonstrate applescript image tiling with two scripts in the tests subdirectory of this GitHub distribution
  -- Improve code documentation
  -- And more nits fixed
  
- 04/01/2024
  -- Fix some nits

- 03/30/2024
  -- Initial Release

## License

This project is licensed under the [UNLICENSE] License - see the UNLICENSE.txt file for details

  

## Acknowledgments

Inspiration, code snippets, etc.

* [Take screenshots or screen recordings on Mac](https://support.apple.com/en-gb/guide/mac-help/mh26782/mac) -> _capwin_ screen capture utility alternatives

* [The Z Shell Manual by Paul Falstad, 2022](https://zsh.sourceforge.io/Doc/Release/)

* [Preview User Guide on Apple support site](https://support.apple.com/en-gb/guide/preview/welcome/mac)

* [AppleScript Language Guide](https://applescriptlibrary.wordpress.com/wp-content/uploads/2013/11/applescriptlanguageguide-2013.pdf)

* [Capture an image (screen capture) man page on ss64.com site](https://ss64.com/mac/screencapture.html)

* [Scriptable image processing system (sips) man page on ss64.com site(https://ss64.com/mac/sips.html)

* [macOS image manipulation with sips (SmittyTone ,2019)](https://blog.smittytone.net/2019/10/24/macos-image-manipulation-with-sips/)

* [Passing Arguments to a Bash/Zsh Script, Rowan C Nicholls, Google Scholar](https://rowannicholls.github.io/bash/intro/passing_arguments.html)

* [Robert C. Martin, Clean Code: A Handbook of Agile Software Craftsmanship, 2009](https://github.com/martinmurciego/good-books/tree/master) -> Clean Code...