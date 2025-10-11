adb forward tcp:8090 tcp:8090
Start-Process chrome.exe '--new-window http://127.0.0.1:8090'