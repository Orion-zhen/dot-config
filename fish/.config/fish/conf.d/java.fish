if test -d /usr/lib/jvm/default
    set -x JAVA_HOME /usr/lib/jvm/default
    set -x JNI_HOME /usr/lib/jvm/default/include
end

if test -d /opt/homebrew/opt/openjdk
    # 前置以覆盖 Mac 默认的 java
    fish_add_path --path --prepend /opt/homebrew/opt/openjdk/bin
    set -x JAVA_HOME /opt/homebrew/opt/openjdk
    set -x JNI_HOME /opt/homebrew/opt/openjdk/include
end
