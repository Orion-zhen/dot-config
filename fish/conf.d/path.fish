set -gx PATH $PATH $HOME/.local/bin

# cargo install
set -gx PATH $PATH $HOME/.cargo/bin

if test -d /opt/cuda
    set -gx PATH $PATH /opt/cuda/bin
end

# for debian series
if test -d /usr/local/cuda
    set -gx CUDA_HOME /usr/local/cuda
    set -gx PATH $PATH /usr/local/cuda/bin
    set -gx LD_LIBRARY_PATH $LD_LIBRARY_PATH /usr/local/cuda/lib64
end

if test -d /opt/rocm
    set -gx PATH $PATH /opt/rocm/bin
end

# 检查 $HOME/opt 是否存在
if test -d "$HOME/opt"
    # 遍历 $HOME/opt 下的所有一级子目录
    for sub in $HOME/opt/*
        # 确保 sub 是一个目录
        if test -d "$sub"
            # 如果存在 bin 子目录，则将其添加到 PATH 中
            if test -d "$sub/bin"
                set -gx PATH $sub/bin $PATH
            end
            # 如果存在 lib 子目录，则将其添加到 LD_LIBRARY_PATH 中
            if test -d "$sub/lib"
                if test (uname) = "Linux"
                    set -gx LD_LIBRARY_PATH $sub/lib $LD_LIBRARY_PATH
                else if test (uname) = "Darwin"
                    set -gx DYLD_LIBRARY_PATH $sub/lib $DYLD_LIBRARY_PATH
                end
            end
        end
    end
end
