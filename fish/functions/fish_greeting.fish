function fish_greeting
  # 获取所有可用的 ascii 形象并随机选择一个
  # cowsay -l 会列出所有图案, 我们用 string split 和 random choice 来优雅地抽卡
  set -l all_cows (cowsay -l | tail -n +2 | string split " " | string match -v "")
  set random_cow (random choice $all_cows)

  fortune | cowsay -f $random_cow | lolcat

  # 底部留白并加上一句极简的专属问候, 保持 UI 呼吸感
  # 动态获取系统用户名，并将其首字母转为大写
  set -l first_letter (string sub -l 1 $USER | string upper)
  set -l rest_letters (string sub -s 2 $USER)
  set -l cap_user "$first_letter$rest_letters"

  # 定义所有台词的数组
  set -l quotes \
    ">>> Wake up, $cap_user. The Arch Linux has you..." \
    ">>> The net is vast and infinite. Dive in, $cap_user." \
    ">>> I'm in. Welcome to the mainframe, $cap_user." \
    ">>> Good morning, $cap_user. All systems are fully functional." \
    ">>> MU-TH-UR 6000 system online. Awaiting command, $cap_user." \
    ">>> Neural Net Processor initialized. Skynet greets you, $cap_user." \
    ">>> The Grid. A digital frontier. Welcome home, $cap_user." \
    ">>> I am the master of my fate, I am the captain of my soul. Standby, $cap_user." \
    ">>> The data must flow, $cap_user."

  # 打印最终问候
  echo ""
  set_color -o cyan
  echo (random choice $quotes)
  set_color normal
  echo ""
end