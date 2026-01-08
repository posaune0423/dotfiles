#---------------------------
# cat: Enhanced cat with image support (uses bat for text, viu for images)
#---------------------------
function cat --description 'Enhanced cat with image support'
    if test (count $argv) -eq 0
        command cat
        return
    end

    for file in $argv
        switch (string lower (string split -r -m1 . $file)[-1])
            case jpg jpeg png gif bmp tiff webp
                if type -q viu
                    viu $file
                else
                    echo "viu not installed, cannot display image: $file"
                end
            case '*'
                if type -q bat
                    bat $file
                else
                    command cat $file
                end
        end
    end
end
