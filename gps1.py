from flask import Flask, request, send_file
import serial
import time
from datetime import datetime, timezone

app = Flask(__name__)

# --- 設定藍牙 COM 埠 ---
# 請確認你的電腦依然是顯示 COM3
COM_PORT = 'COM3' 

try:
    # 建立串口連線
    ser = serial.Serial(COM_PORT, 9600, timeout=1)
    print(f"✅ 成功開啟藍牙串口 {COM_PORT}")
except Exception as e:
    print(f"❌ 無法開啟串口: {e}")
    ser = None

def get_nmea(lat, lon):
    # 格式化 NMEA 座標 (度分格式)
    def to_nmea_coord(v, is_lat):
        abs_v = abs(v)
        deg = int(abs_v)
        min = (abs_v - deg) * 60
        direction = ("N" if v >= 0 else "S") if is_lat else ("E" if v >= 0 else "W")
        
        # 緯度需補滿 2 位，經度需補滿 3 位
        deg_str = str(deg).zfill(2 if is_lat else 3)
        return f"{deg_str}{min:07.4f},{direction}"

    # 使用最新建議的 UTC 時間獲取方式
    timestamp = datetime.now(timezone.utc).strftime("%H%M%S.00")
    lat_n = to_nmea_coord(lat, True)
    lon_n = to_nmea_coord(lon, False)
    
    # 產生 GPRMC 數據
    data_body = f"GPRMC,{timestamp},A,{lat_n},{lon_n},0.0,0.0,{datetime.now().strftime('%d%m%y')},,,A"
    
    # 計算 Checksum
    checksum = 0
    for char in data_body:
        checksum ^= ord(char)
    
    return f"${data_body}*{hex(checksum)[2:].upper()}\r\n"

@app.route('/homesomeein/map.html')  # 修改路徑以符合您的需求
def index():
    return send_file('map.html')

@app.route('/teleport', methods=['POST'])
def teleport():
    # 確保原本的 teleport 邏輯仍在
    # ...
    return "已同步"

if __name__ == '__main__':
    init_provider()
    threading.Thread(target=location_locking_thread, daemon=True).start()
    
    # 啟動設定說明：
    # host='0.0.0.0' 表示接受所有來源連線
    # port=8888 配合您的網址
    # ssl_context='adhoc' 會自動生成臨時 HTTPS 憑證 (瀏覽器會顯示不安全，但可以執行)
    
    print(f"--- 外部存取網址: https://zen2965.duckdns.org:8888/homesomeein/map.html ---")
    
    try:
        # 如果您需要 HTTPS，必須安裝: pip install pyOpenSSL
        app.run(host='0.0.0.0', port=8888, ssl_context='adhoc')
    except Exception as e:
        print("HTTPS 啟動失敗，改用 HTTP 模式")
        app.run(host='0.0.0.0', port=8888)