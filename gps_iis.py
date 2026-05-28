from flask import Flask, request, jsonify
import subprocess, time, threading, os, math, random

# --- [設定區] ---
ADB_PATH = r"C:\QtScrcpy-win-x64-v2.1.2\adb.exe"
DEVICE_ID = "e9854038" # 有線 ID
os.environ["ANDROID_ADB_SERVER_PORT"] = "5038" # 有線專用埠

app = Flask(__name__)
target_lat, target_lng = 25.0339, 121.5644 # 給個預設值避免藍點消失
current_active_lat, current_active_lng = None, None
current_mode = "teleport"
move_param = 12
angle = 0

def init_provider():
    print(f"🧹 正在初始化有線環境 (ID: {DEVICE_ID})...")
    subprocess.run(f'"{ADB_PATH}" start-server', shell=True)
    time.sleep(1)
    # 權限
    subprocess.run(f'"{ADB_PATH}" -s {DEVICE_ID} shell appops set com.android.shell android:mock_location allow', shell=True)
    # 徹底清理並重置
    for p in ["gps", "network", "fused"]:
        subprocess.run(f'"{ADB_PATH}" -s {DEVICE_ID} shell cmd location providers remove-test-provider {p}', shell=True, capture_output=True)
        subprocess.run(f'"{ADB_PATH}" -s {DEVICE_ID} shell cmd location providers add-test-provider {p} --requiresSatellite true --supportsAltitude true --supportsSpeed true --supportsBearing true --powerRequirement 1 --accuracy 1', shell=True, capture_output=True)
        subprocess.run(f'"{ADB_PATH}" -s {DEVICE_ID} shell cmd location providers set-test-provider-enabled {p} true', shell=True, capture_output=True)
    print("✅ 系統已清空，僅由 Python 接管。")
    return True

def location_locking_thread():
    global target_lat, target_lng, current_active_lat, current_active_lng, current_mode, move_param, angle
    while True:
        if target_lat:
            if current_active_lat is None:
                current_active_lat, current_active_lng = target_lat, target_lng
            
            # 模式計算邏輯 (瞬移/走路/繞圈)
            if current_mode == "teleport":
                current_active_lat, current_active_lng = target_lat, target_lng
            elif current_mode == "walk":
                speed_deg = (move_param / 3600) / 111 
                dist = math.sqrt((target_lat-current_active_lat)**2 + (target_lng-current_active_lng)**2)
                if dist > speed_deg:
                    current_active_lat += ((target_lat-current_active_lat)/dist) * speed_deg
                    current_active_lng += ((target_lng-current_active_lng)/dist) * speed_deg
                else: current_active_lat, current_active_lng = target_lat, target_lng
            elif "circle" in current_mode:
                r = 15 if "s" in current_mode else (40 if "m" in current_mode else 100)
                r_deg = r / 111000
                angle += (2.5 / r)
                current_active_lat = target_lat + r_deg * math.cos(angle)
                current_active_lng = target_lng + r_deg * math.sin(angle)

            # 🚀 執行注入：給予最新時間戳，藍點才會顯示
            ts = int(time.time() * 1000)
            f_lat = current_active_lat + random.uniform(-0.000001, 0.000001)
            f_lng = current_active_lng + random.uniform(-0.000001, 0.000001)
            # 同時注入 GPS 來源
            subprocess.run(f'"{ADB_PATH}" -s {DEVICE_ID} shell cmd location providers set-test-provider-location gps --location {f_lat},{f_lng} --time {ts} --accuracy 5.0', shell=True, capture_output=True)
        time.sleep(0.5)

# 🚀 增加一個根目錄，解決 404 並方便除錯
@app.route('/')
def home():
    return f"""
    <h1>Python 定位服務運行中</h1>
    <p><b>目標裝置:</b> {DEVICE_ID}</p>
    <p><b>目前座標:</b> {current_active_lat}, {current_active_lng}</p>
    <p><b>目前模式:</b> {current_mode}</p>
    <p>請由 IIS 網頁操作: <a href="https://zen2965.duckdns.org:8888/homesomeein/map_iis.html">開啟地圖</a></p>
    """


@app.route('/teleport', methods=['GET', 'POST']) # 🚀 核心修正：加入 'GET'
def teleport():     

    global target_lat, target_lng, current_mode, move_param

    # 1. 取得網頁傳過來的 key
    user_key = request.form.get('key') or request.args.get('key')
    
    # 2. 🚀 [關鍵檢查] 如果 key 不符合，立刻回傳錯誤，不准往下執行
    if user_key != "1234":
        print(f"❌ 攔截到未經授權的存取！Key 為: {user_key}")
        return "Unauthorized: Wrong Key", 401

    # --- 只有 Key 對了，才會執行下面的座標更新 ---
    lat = request.form.get('lat') or request.args.get('lat')
    lng = request.form.get('lng') or request.args.get('lng')
    # ... 其餘代碼 ...
    if lat and lng:
        target_lat = float(lat)
        target_lng = float(lng)
        # ...
        return "SUCCESS"
    
    
    # 🚀 同時嘗試從 網址(args) 和 表單(form) 抓取資料
    lat = request.args.get('lat') or request.form.get('lat')
    lng = request.args.get('lng') or request.form.get('lng')
    mode = request.args.get('mode') or request.form.get('mode') or 'teleport'
    param = request.args.get('param') or request.form.get('param') or '12'

    if lat and lng:
        try:
            target_lat = float(lat)
            target_lng = float(lng)
            current_mode = mode
            move_param = float(param)
            print(f"✅ 座標已同步({request.method}): {current_mode} -> {target_lat}, {target_lng}")
            return "SUCCESS"
        except Exception as e:
            return f"Error: {str(e)}", 400
            
    return "WAITING_DATA", 200

@app.route('/get_status', methods=['GET', 'POST']) # 🚀 狀態查詢也建議加上 GET

def get_status():
    return jsonify({
        "lat": current_active_lat, 
        "lng": current_active_lng, 
        "mode": current_mode
    })

if __name__ == '__main__':
    if init_provider():
        threading.Thread(target=location_locking_thread, daemon=True).start()
        app.run(host='127.0.0.1', port=9000)