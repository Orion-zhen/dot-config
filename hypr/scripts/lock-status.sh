#!/bin/bash
# 存放路径：~/.config/hypr/scripts/lock_status.sh
# 特性：纯内存运算，无临时文件，50毫秒极速采样，完美绕过 TUN

# ---------------------------------------------------------
# 1. 网络状态 (Network)
# ---------------------------------------------------------
WIFI_IFACE=""
LAN_IFACE=""

# 遍历物理无线网卡
for iface in /sys/class/net/w*; do
  if [ -e "$iface" ]; then
    state=$(cat "$iface/operstate" 2>/dev/null)
    if [ "$state" = "up" ] || [ "$state" = "dormant" ]; then
      WIFI_IFACE=$(basename "$iface")
      break
    fi
  fi
done

if [ -n "$WIFI_IFACE" ]; then
  # 优先使用 iwgetid (极速)，备用 iw
  SSID=$(iwgetid "$WIFI_IFACE" -r 2>/dev/null)
  if [ -z "$SSID" ]; then
    SSID=$(iw dev "$WIFI_IFACE" link 2>/dev/null | awk '/SSID:/ {print $2}')
  fi

  if [ -n "$SSID" ]; then
    NET_INFO="󰖩 $SSID"
  else
    NET_INFO="󰖩 Wi-Fi"
  fi
else
  # 遍历物理有线网卡
  for iface in /sys/class/net/e*; do
    if [ -e "$iface" ]; then
      state=$(cat "$iface/operstate" 2>/dev/null)
      if [ "$state" = "up" ]; then
        LAN_IFACE=$(basename "$iface")
        break
      fi
    fi
  done

  if [ -n "$LAN_IFACE" ]; then
    NET_INFO="󰈀 LAN"
  else
    NET_INFO="󰖪 Offline"
  fi
fi

# ---------------------------------------------------------
# 2. CPU 占用 (CPU Usage)
# ---------------------------------------------------------
# 读取 $t_1$ 时刻的内核数据
read -r cpu a b c previdle rest < /proc/stat
prevtotal=$((a+b+c+previdle))

# 微小阻塞 0.05 秒
sleep 0.05

# 读取 $t_2$ 时刻的内核数据
read -r cpu a b c idle rest < /proc/stat
total=$((a+b+c+idle))

# 计算 $\Delta$ 差值
diff_idle=$((idle - previdle))
diff_total=$((total - prevtotal))

# 防止除零错误，计算百分比
if [ $diff_total -eq 0 ]; then diff_total=1; fi
CPU_USAGE=$((100 * (diff_total - diff_idle) / diff_total))
CPU_INFO="󰍛 ${CPU_USAGE}%"

# ---------------------------------------------------------
# 3. 内存占用 (RAM Usage)
# ---------------------------------------------------------
RAM_USED=$(LC_ALL=C free -h | awk '/^Mem:/ {print $3}' | sed 's/i//g')
if [ -z "$RAM_USED" ]; then
  RAM_USED=$(LC_ALL=C free -h | awk 'NR==2 {print $3}' | sed 's/i//g')
fi
RAM_INFO=" ${RAM_USED}"

# ---------------------------------------------------------
# 4. 电池电量 (Battery)
# ---------------------------------------------------------
BAT_INFO=""

# 使用原生 globbing 遍历，避免 ls 列出目录内容，且零外部命令调用
for bat_dir in /sys/class/power_supply/BAT*; do
  # 确保是目录且包含 capacity 文件
  if [ -d "$bat_dir" ] && [ -f "$bat_dir/capacity" ]; then
    BAT_CAP=$(cat "$bat_dir/capacity")
    BAT_STAT=$(cat "$bat_dir/status")

    if [ "$BAT_STAT" = "Charging" ]; then
      BAT_ICON="󰂄"
    else
      if [ "$BAT_CAP" -ge 90 ]; then BAT_ICON="󰁹"
      elif [ "$BAT_CAP" -ge 60 ]; then BAT_ICON="󰂀"
      elif [ "$BAT_CAP" -ge 30 ]; then BAT_ICON="󰁼"
      else BAT_ICON="󰁺"
      fi
    fi
    BAT_INFO="  |  $BAT_ICON ${BAT_CAP}%"

    # 找到第一个有效电池后跳出循环
    break
  fi
done

# ---------------------------------------------------------
# 5. 组装输出
# ---------------------------------------------------------
echo "$NET_INFO  |  $CPU_INFO  |  $RAM_INFO$BAT_INFO"