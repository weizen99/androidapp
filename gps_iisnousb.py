from flask import Flask, request, jsonify, send_file
import subprocess, time, threading, os, math, random

# --- [環境設定] ---
ADB_PATH = r"C:\QtScrcpy-win-x64-v2.1.2\adb.exe"
# 無線 ADB 通常使用預設 5037 埠
os.environ["ANDROID_ADB_SERVER_PORT"] = "5037"

app = Flask(__name__)

# --- [全域控制變數] ---
target_lat, target_lng = 25.0339, 121.5644
current_active_lat, current_active_lng = None, None
current_mode = "teleport"
move_param = 12
angle = 0
DEVICE_ID = None

def get_wireless_device():
    """ 🚀 核心修正：精準抓取無線 IP 裝置，避開 mDNS (adb-tls) 雜訊 """
    try:
        subprocess.run([ADB_PATH, 'start-server'], capture_output=True)
        res = subprocess.run([ADB_PATH, 'devices'], capture_output=True, text=True)
        lines = res.stdout.strip().split('\n')[1:]
        # 尋找包含 '.' (IP) 且後綴是 'device' 的項目，排除 'adb-tls'
        valid = [l.split('\t')[0] for l in lines if '\tdevice' in l and '.' in l and 'adb-tls' not in l]
        return valid[0] if valid else None
    except: return None

def init_provider():
    global DEVICE_ID
    DEVICE_ID = get_wireless_device()
    if not DEVICE_ID:
        print("❌ [無線] 找不到連線的手機！請先在手機開啟無線偵錯並執行 adb connect")
        return False

    print(f"🎯 [無線模式] 已鎖定裝置: {DEVICE_ID}")
    # 賦予模擬權限
    subprocess.run(f'"{ADB_PATH}" -s {DEVICE_ID} shell appops set com.android.shell android:mock_location allow', shell=True)
    
    # 🚀 深度清理：同時清除 gps, network, fused 預防「兩地跳」
    for p in ["gps", "network", "fused"]:
        subprocess.run(f'"{ADB_PATH}" -s {DEVICE_ID} shell cmd location providers remove-test-provider {p}', shell=True, capture_output=True)
        subprocess.run(f'"{ADB_PATH}" -s {DEVICE_ID} shell cmd location providers add-test-provider {p} --requiresSatellite true --supportsAltitude true --supportsSpeed true --supportsBearing true --powerRequirement 1 --accuracy 1', shell=True, capture_output=True)
        subprocess.run(f'"{ADB_PATH}" -s {DEVICE_ID} shell cmd location providers set-test-provider-enabled {p} true', shell=True, capture_output=True)
    
    print("✨ 無線環境初始化完成。")
    return True

def location_locking_thread():
    global target_lat, target_lng, current_active_lat, current_active_lng, current_mode, move_param, angle
    while True:
        if DEVICE_ID and target_lat:
            if current_active_lat is None:
                current_active_lat, current_active_lng = target_lat, target_lng

            # --- 移動邏輯計算 ---
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

            # --- 注入座標 (每 0.5 秒一次，無線模式建議不要太快以防封包遺失) ---
            ts = int(time.time() * 1000)
            f_lat = current_active_lat + random.uniform(-0.000001, 0.000001)
            f_lng = current_active_lng + random.uniform(-0.000001, 0.000001)
            subprocess.run(f'"{ADB_PATH}" -s {DEVICE_ID} shell cmd location providers set-test-provider-location gps --location {f_lat},{f_lng} --time {ts} --accuracy 10.0', shell=True, capture_output=True)
        time.sleep(0.5)

# --- [API 路由介面] ---

@app.route('/')
def home():
    return f"<h1>無線定位服務已啟動</h1><p>目標裝置: {DEVICE_ID}</p><p>目前模式: {current_mode}</p>"

@app.route('/get_status', methods=['GET', 'POST'])
def get_status():
    return jsonify({"lat": current_active_lat, "lng": current_active_lng, "mode": current_mode})

@app.route('/teleport', methods=['GET', 'POST'])
def teleport():
    global target_lat, target_lng, current_mode, move_param, current_active_lat
    
    # 🚀 1. Key 密鑰驗證 (與有線版一致)
    user_key = request.form.get('key') or request.args.get('key')
    if user_key != "1234":
        return "Unauthorized", 401

    # 🚀 2. 取得參數
    lat = request.form.get('lat') or request.args.get('lat')
    lng = request.form.get('lng') or request.args.get('lng')
    mode = request.form.get('mode') or request.args.get('mode') or 'teleport'
    param = request.form.get('param') or request.args.get('param') or '12'

    if lat and lng:
        try:
            target_lat = float(lat)
            target_lng = float(lng)
            current_mode = mode
            move_param = float(param)
            
            # 如果是瞬移，強制更新目前座標防止緩衝
            if current_mode == "teleport":
                current_active_lat, current_active_lng = target_lat, target_lng
            
            print(f"✅ 無線同步成功: {current_mode} -> {target_lat}")
            return "SUCCESS"
        except: return "Invalid Data", 400
            
    return "WAITING_DATA", 200

if __name__ == '__main__':
    if init_provider():
        threading.Thread(target=location_locking_thread, daemon=True).start()
        # 🚀 監聽 9000 埠 (配合您 IIS 的 web.config 轉發)
        app.run(host='127.0.0.1', port=9000)