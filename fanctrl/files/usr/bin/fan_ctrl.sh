#!/bin/bash

# 读取UCI配置
CONFIG_FILE="/etc/config/fan_ctrl"
get_uci() {
    uci -q get "${CONFIG_FILE}.settings.$1" || echo "$2"
}

detect_pwm_path() {
    local fallback_path="/sys/devices/platform/pwm-fan/hwmon/hwmon0/pwm1"
    detected_path=$(find /sys/devices/platform/pwm-fan/hwmon/hwmon*/pwm1 2>/dev/null | head -1)
    echo "${detected_path:-$fallback_path}"
}

validate_hardware() {
    if [ ! -w "$PWM_CTRL" ]; then
        logger -t FAN_CTRL "PWM路径不可写: $PWM_CTRL"
        logger -t FAN_CTRL "尝试自动修复权限..."
        chmod 666 "$PWM_CTRL" 2>/dev/null || {
            logger -t FAN_CTRL "权限修复失败，请手动检查硬件路径"
            exit 1
        }
    fi

    if [ ! -r "$TEMP_SENSOR" ]; then
        logger -t FAN_CTRL "温度传感器不可读: $TEMP_SENSOR"
        TEMP_SENSOR="/sys/class/thermal/thermal_zone0/temp"
        logger -t FAN_CTRL "尝试使用备用传感器: $TEMP_SENSOR"
    fi
}

# 动态获取硬件路径
PWM_CTRL=$(get_uci pwm_ctrl "$(detect_pwm_path)")
TEMP_SENSOR=$(get_uci temp_sensor "/sys/class/thermal/thermal_zone0/temp")
START_TEMP=$(get_uci start_temp 35)
FULL_TEMP=$(get_uci full_temp 45)
MIN_PWM=$(get_uci min_pwm 30)
CHECK_INTERVAL=$(get_uci check_interval 20)

init_pwm() {
    validate_hardware
    echo 1 > "${PWM_CTRL}_enable" 2>/dev/null || {
        logger -t FAN_CTRL "无法初始化PWM控制器"
        exit 1
    }
}

get_temp() {
    temp_raw=$(cat $TEMP_SENSOR 2>/dev/null | tr -cd '0-9')
    [ -z "$temp_raw" ] && {
        logger -t FAN_CTRL "温度传感器异常！启用安全模式"
        echo 255 > $PWM_CTRL
        exit 2
    }
    echo $((temp_raw / 1000))
}

calc_pwm() {
    local temp=$1
    [ $temp -le $START_TEMP ] && echo $MIN_PWM && return
    [ $temp -ge $FULL_TEMP ] && echo 255 && return
    
    local temp_range=$((FULL_TEMP - START_TEMP))
    local pwm_range=$((255 - MIN_PWM))
    local pwm=$(( MIN_PWM + (temp - START_TEMP) * pwm_range / temp_range ))
    echo $pwm
}

main() {
    init_pwm
    local last_pwm=$MIN_PWM
    
    while true; do
        temp=$(get_temp)
        target_pwm=$(calc_pwm $temp)
        
        delta=$((target_pwm - last_pwm))
        if [ ${delta#-} -gt 25 ]; then
            target_pwm=$((last_pwm + 25*(delta > 0 ? 1 : -1)))
        fi
        
        echo $target_pwm > $PWM_CTRL
        last_pwm=$target_pwm
        
        logger -t FAN_CTRL "温度:${temp}℃ → PWM:${target_pwm}"
        sleep $CHECK_INTERVAL
    done
}

case "$1" in
    start)  main & ;;
    stop)   killall $(basename "$0"); echo 0 > $PWM_CTRL ;;
    *)      echo "Usage: $0 {start|stop}"; exit 3 ;;
esac
