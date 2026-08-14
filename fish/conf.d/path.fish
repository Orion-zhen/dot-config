fish_add_path --path --append $HOME/.local/bin

# cargo install
fish_add_path --path --append $HOME/.cargo/bin

fish_add_path --path --append /opt/cuda/bin

# for debian series
if test -d /usr/local/cuda
    set -gx CUDA_HOME /usr/local/cuda
    fish_add_path --path --append /usr/local/cuda/bin
    set -gx LD_LIBRARY_PATH $LD_LIBRARY_PATH /usr/local/cuda/lib64
end

fish_add_path --path --append /opt/rocm/bin

# 递归发现 ~/opt 下各软件包的 bin 和 lib 目录
begin
    set -l opt_bin_dirs
    set -l opt_lib_dirs

    for dir in $HOME/opt/*/**/{bin,lib}
        test -d $dir; or continue

        switch (path basename $dir)
            case bin
                set -a opt_bin_dirs $dir
            case lib
                set -a opt_lib_dirs $dir
        end
    end

    if set -q opt_bin_dirs[1]
        fish_add_path --path $opt_bin_dirs
    end

    set -l lib_path_var
    switch (uname)
        case Linux
            set lib_path_var LD_LIBRARY_PATH
        case Darwin
            set lib_path_var DYLD_LIBRARY_PATH
    end

    # 逆序 prepend，以保留递归 glob 的顺序，并避免重复添加
    if set -q lib_path_var[1]; and set -q opt_lib_dirs[1]
        for dir in $opt_lib_dirs[-1..1]
            contains -- $dir $$lib_path_var
            or set --global --export --prepend $lib_path_var $dir
        end
    end
end
