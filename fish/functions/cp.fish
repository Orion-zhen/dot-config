function cp --wraps cp
    if type -q rsync
        rsync --archive --copy-links --human-readable --partial --info=progress2 $argv
    else
        command cp $argv
    end
end