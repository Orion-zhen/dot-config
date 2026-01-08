function tsp
    if type -q trash-put
        trash-put -v $argv
    else
        command rm -i $argv
    end
end