#!/bin/sh

# 硬件路径（需根据实际设备验证）
PWM_CTRL="/sys/devices/platform/pwm-fan/hwmon/hwmon0/pwm1"
TEMP_SENSOR="/sys/class/thermal/thermal_zone0/temp"

# 控制参数
START_TEMP=35    # 最低有效温度(℃)
FULL_TEMP=45     # 全速温度(℃)
MIN_PWM=30       # 最低转速（防止停转）
CHECK_INTERVAL=20 # 检测间隔(秒)

init_pwm() {
    [ -w "$PWM_CTRL" ] || {
        logger -t FAN_CTRL "错误：PWM设备不可写，请执行 chmod 666 $PWM_CTRL"
        exit 1
    }
    echo 1 > "${PWM_CTRL}_enable" 2>/dev/null
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
    temp=$1
    [ $temp -le $START_TEMP ] && echo $MIN_PWM && return
    [ $temp -ge $FULL_TEMP ] && echo 255 && return
    
    temp_range=$((FULL_TEMP - START_TEMP))
    pwm_range=$((255 - MIN_PWM))
    pwm=$(( MIN_PWM + (temp - START_TEMP) * pwm_range / temp_range ))
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
