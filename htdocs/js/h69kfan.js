function updateStatus() {
    fetch('/admin/services/hk69fan/status')
        .then(r => r.json())
        .then(data => {
            // 温度显示
            document.getElementById('current_temp').innerHTML = 
                data.temp.toFixed(1) + '℃';

            // PWM显示
            const pwm = data.pwm || 0;
            const percent = Math.round((pwm / 255) * 100);
            document.getElementById('pwm_bar').style.width = percent + '%';
            document.getElementById('pwm_value').innerHTML = 
                `PWM: ${pwm} (${percent}%)`;
            
            // 转速范围
            document.getElementById('pwm_range').innerHTML = 
                `范围: ${data.cfg.min}-${data.cfg.max}`;
        });
}

// 初始加载
updateStatus();
setInterval(updateStatus, 2000);
