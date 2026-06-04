https://weizen99.github.io/androidapp/excelsql.html 
1.可自己輸入ms sqlserver select類的查詢,有提供範本(頁面上有範本查詢)讓你編輯
2.自己建置的股票資料,提供給大家參考測試使用
3.html+aspx.vb,前端是html,後端是asp.net的後置程式碼(Ai整合得很棒!)
4.上面的導航頁 webapi彙總(https://zen2965.duckdns.org:8888/androidapp/basicinfotable2.html) 所提供的藝廊查詢,使用html+webapi,前端是html串接webapi
5.資料庫如果有圖片也可以自動顯示出來(欄位:photo)
6.含有一些關鍵字會報錯,資料庫只有查詢權限
7.要變更資料庫會提醒,請按提醒操作,提醒備註可不用刪除
8.顯示結果可進行:分頁(可選分頁筆數) 凍結表頭 搜尋
9.圖片有再放大功能
10.預存程式功能再另一版
11.不要顯示欄位可進行程式碼刪除,除了有些特別分群等的不行,尤其是手機畫面比較小更須使用

https://weizen99.github.io/androidapp/excelsql2.html
1.整合預存程序查詢功能(比較複雜)
2.提醒要先刪除才能執行(選範本,改資料庫,改日期(改為最新日期,股權為週為單位,原則為週五有放假除外),刪除提醒,最後執行
3.有些自選股筆數較多,要執行比較久
4.選擇範本 => 專家實戰總分(五種查詢),由Ai 給出的選股權數,
--(五日乖離:盤中成交價-前一日的價五日均線)/前一日的價五日均線(今天還沒出來)
--量倍數:盤中總量 / 前一日的二十日均量(今天還沒出來)
--OBV分:obv黃金交叉次數*2 (使用obv多空淨額法)
--價均分: 均價黃金交叉次數*1
--技術分:(k9-d9 + 週k9- 週d9  + 月k9-月d9) / 5.0 + macd紅綠棒值 /盤中成交價 * 200 (5%*200就是10分)
--籌碼分: 三大法人黃金交叉次數 * 1.5 + [(三週庫存比率-六週庫存比率)+(四週庫存比率-七週庫存比率)]/2 * 1.5 + [(集中度1日 * 0.4 + 集中度5日 * 0.4 + 集中度20日 * 0.2)] / 5
--量能分:(成交量五日交叉的增量 /五日均量) * 5.0 + 站均量 * 1
--專家實戰總分: OBV分+價均分+技術分 + 籌碼分+量能分
--★追高(五日乖離):(盤中成交價 - 五日均線)/五日均線 8%~18%
--🔥量價齊揚:站上成交量均線個數>= 7 AND 盤中漲幅 > 3%
--💎大戶鎖碼:較長期時間太短可能只是當沖等比較不準 ((集保庫存3週比率-集保庫存6週比率)+ (集保庫存4週比率-集保庫存7週比率))/2 > 2% 用兩個區段來平均比較不會錯過

https://weizen99.github.io/androidapp/message4.html:
1.專業的留言系統
2.除了可留言,重要提醒或留備註等也都可以
3.新增 編輯 刪除 分頁(可選分頁筆數) 凍結表頭 搜尋 都有支援

https://weizen99.github.io/androidapp/googlesheet.html
讀取Google試算表的內容固定的一些欄位 photo欄放圖片的連結(要按表頭結構,文字或圖片)

https://weizen99.github.io/androidapp/map.html:
可以將目前定位資料或任一點座標建檔到資料庫中,按同步將座標送到Somee資料庫建檔

https://weizen99.github.io/androidapp/message5.html
播放系統:我的電腦檔案mp4檔 nas檔案mp4檔 youtube連結,有撥放清單按序撥放,可新增youtube連結

https://weizen99.github.io/androidapp/message6.html message6s.html:
同上電腦版,版面等更好看,目前都會用到本機電腦,關機時便無法使用後置程式碼

https://weizen99.github.io/androidapp/message6_1.html : 
youtube連結播放專用

https://weizen99.github.io/androidapp/tour.html:
Ai聊天,可自動切換模型,到 https://aistudio.google.com/app/apikey 申請Api key

https://weizen99.github.io/androidapp/voiceinput.html  voiceinput1.html : 
網頁版語音輸入或自動朗讀,可由Ai潤稿,複製到剪貼簿,任意地方按貼上(省打字)

https://weizen99.github.io/androidapp/image_api2.html: 
照片輸播,直接抓取ds215圖片,增加每100張為一組,方便跳轉檔案

https://zen2965.duckdns.org:8888/gps_by_adb/map.html
gps_iis.py+map_iis.html: 
在asp.net架構下電腦發送定位座給手機並完成跳轉至定位,手機跟電腦同步會看到藍色定位點移動的軌跡,也有瞬移 走路 繞圈的設定,可以使用adb有線連接或adb無線連接,不需模擬位置跟Root,但開啓寶可夢只能移動無法抓寶,網路執行https://zen2965.duckdns.org:8888/gps_by_adb/map_iis.html
網頁便能控制手機的定位,但手機要執行gps_iis.py

https://weizen99.github.io/androidapp/mylink.html:
手機大小專用,連結SQLserver可儲存超連結,crud及排序,排序分三種:自訂按輸入權重,按加入順序,按點擊次數,上方有導覽列等等








