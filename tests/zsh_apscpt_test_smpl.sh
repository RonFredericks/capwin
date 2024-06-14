#!/bin/zsh

# Test case: 
#   Capture screen images with screencapture,
#   then display each of them with an increasing offset. 
#   Script calls builtin functions - screencapture, preview, applescript.
#   

declare -i offset_x=10
declare -i offset_y=10
max_images=4
firstPreview=true
# Include a safe base file name for auto-crearted images.
test_image="./base_image_4968f9bb-5007-47a6-92d5-bdcd1a81e4_"


# Create and display some test images using screencapture and preview.
for ((i=1; i<=$max_images; i++)); do

    # Create test image if not already available.
    if [[ ! -e $test_image$i.png ]]; then
        screencapture -R 100,100,50,50 $test_image$i.png
    fi

    # Open each test image in upper left corner of display
    open -a preview $test_image$i.png

    # Avoid system event error (-1719) on first reference to "Preview" 
    # in applescript.
    # Consider using applescript repeat feature with "System Events"
    if $firstPreview; then
        sleep 1
        firstPreview=false
    fi

    # Cascade/nudge each previewed image down and to left using applescript.
    osascript -  "$offset_x" "$offset_y"  <<EOF
    on run argv 
    tell application "System Events"
        tell process "Preview"
        set position of front window to {item 1 of argv, item 2 of argv}
        end tell
    end tell
    end run
EOF

    offset_x+=40
    offset_y+=40

done

# References
# https://apple.stackexchange.com/questions/422677/how-to-pass-variable-in-bash-script-to-osascript
