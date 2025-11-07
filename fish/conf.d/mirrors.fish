# CN 镜像源设置，根据时区判断（CST 时区时设置）
if test (date +%Z) = CST
    # 镜像来自 Xget 项目: https://github.com/xixu-me/Xget
    set -gx HF_ENDPOINT "https://hf-mirror.com"
    set -gx PUB_HOSTED_URL "https://mirrors.cernet.edu.cn/dart-pub"
    set -gx FLUTTER_STORAGE_BASE_URL "https://mirrors.cernet.edu.cn/flutter"
    set -gx NODE_MIRROR "https://mirrors.cernet.edu.cn/nodejs-release"
    set -gx NVM_NODEJS_ORG_MIRROR "https://mirrors.cernet.edu.cn/nodejs-release"
    set -gx RUSTUP_UPDATE_ROOT "https://mirrors.cernet.edu.cn/rustup/rustup"
    set -gx RUSTUP_DIST_SERVER "https://mirrors.cernet.edu.cn/rustup"
    if test (uname) = "Darwin"
        # Homebrew 相关设置
        set -gx HOMEBREW_BREW_GIT_REMOTE "https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
        set -gx HOMEBREW_CORE_GIT_REMOTE "https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
        set -gx HOMEBREW_API_DOMAIN "https://mirrors.cernet.edu.cn/homebrew-bottles/api"
        set -gx HOMEBREW_BOTTLE_DOMAIN "https://mirrors.cernet.edu.cn/homebrew-bottles"
        set -gx HOMEBREW_PIP_INDEX_URL "https://mirrors.cernet.edu.cn/pypi/web/simple"
    end
end
