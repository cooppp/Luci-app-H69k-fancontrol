document.addEventListener('DOMContentLoaded', function() {
    var updateInterval = 2000;
    var tempElement = document.getElementById('current-temp');
    var pwmElement = document.getElementById('current-pwm');
    var statusElement = document.getElementById('service-status');

    function updateStatus() {
        fetch('<%=url("admin/services/fan_ctrl/status")%>')
            .then(response => response.json())
            .then(data => {
                tempElement.textContent = data.temp ? data.temp + ' °C' : 'N/A';
                pwmElement.textContent = data.pwm || 'N/A';
                statusElement.textContent = data.running ? '<%:Running%>' : '<%:Stopped%>';
                statusElement.style.color = data.running ? 'green' : 'red';
            });
    }

    document.getElementById('btn-start').addEventListener('click', function() {
        fetch('<%=url("admin/services/fan_ctrl/control")%>', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'cmd=start'
        }).then(updateStatus);
    });

    document.getElementById('btn-stop').addEventListener('click', function() {
        fetch('<%=url("admin/services/fan_ctrl/control")%>', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'cmd=stop'
        }).then(updateStatus);
    });

    setInterval(updateStatus, updateInterval);
    updateStatus();
});
