<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="excelimport2.aspx.vb" Inherits="excelimport.excelimport2" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>excel(SQL)</title>
     <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css" integrity="sha384-WskhaSGFgHYWDcbwN70/dfYBj47jz9qbsMId/iRN3ewGhXQFZCSftd1LZCfmhktB" crossorigin="anonymous"/>
   <!-- 引入核心樣式: Bootstrap 5 + DataTables -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.1/dist/css/bootstrap.min.css" rel="stylesheet"/>
<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css"/>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script type="text/javascript" src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
<script type="text/javascript" src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
    
    <style>

        .table, th, td {
          border: 1px solid;
        }


                 .auto-style1 {
                     margin-bottom: 0px;
                 }


                 .auto-style2 {
                     color: #0026ff;
                 }


    * {
  box-sizing: border-box;
}
        * {
    text-shadow: none !important;
    box-shadow: none !important;
  }
  
  *,
  *::before,
  *::after {
    text-shadow: none !important;
    box-shadow: none !important;
  }
  
*,
*::before,
*::after {
  box-sizing: border-box;
}


        .auto-style3 {
            color: #FF0000;
            font-weight: bold;
        }
        .auto-style4 {
            color: #0000FF;
        }
        .auto-style5 {
            color: #800000;
        }
        .auto-style6 {
            color: #FF0000;
        }


        .auto-style7 {
            color: #CC0000;
        }


    </style>

      <script>
          // --- 範本資料庫 ---
          const sqlTemplateLibrary = [

              //{ cat: "類", title: "關", sql: `top 100 * FROM favor1 WHERE word1 LIKE '%deepseek%' ORDER BY 時間戳記 DESC` },
              //{ cat: "搜尋類", title: "關鍵字搜尋我的最愛", sql: `top 100 * FROM favor1 WHERE word1 LIKE '%deepseek%' ORDER BY 時間戳記 DESC` },

              {
                  cat: "【主力監控】", title: "🚩 AI 精銳雷達 (自選 26-29 綜合看板)", sql: `/*資料庫:stockchangedate*/
* FROM View_AI_Elite_Radar
ORDER BY [分組] ASC, [日線分] DESC

/*用途： 監控 26 區 (目標)、27 區 (大資金)、28 區 (100%勝率)、29 區 (伏兵)。
🚩先執行 sp_RefreshAIWatchlist 自動更新三區自選股名單,View_AllMyWatchlists 所有自選股名單
*/` }, 

              {
                  cat: "【主力監控】", title: "🚩 AI 精銳雷達 (自選 26-29 綜合看板) 最新行情", sql: `/*資料庫:stockchangedate*/
V.名稱, 
V.代號, 
MAX(B.成交價) AS [盤中價], 
MAX(B.漲幅) AS [今日漲幅%], 
MAX(B.總量) AS [盤中總量],
MAX(CAST(M.專家實戰總分 AS DECIMAL(10,2))) AS [昨日分],
MAX(M.實戰標籤) AS [實戰標籤],
MAX(V.equityinfo) AS [操作筆記], -- 重複時取其中一個筆記顯示
MAX(P.最高勝率) AS [勝率%],
MAX(P.最佳天數) AS [抱幾天],
MAX(CASE 
    WHEN B.成交價 > A.price_ma5 THEN N'🟢☀️ 站上5日'
    WHEN B.成交價 < A.price_ma5 THEN N'🔴⛈️ 跌破5日'
    ELSE N'🟡偏弱' 
END) AS [即時動能],
MAX(CASE 
    WHEN B.成交價 > A.price_ma5 AND M.專家實戰總分 BETWEEN 5 AND 30 THEN N'🔔伏兵異動，請按F10搬移60M'
    WHEN B.成交價 < A.price_ma5 AND M.專家實戰總分 > 30 THEN N'⚠️警報！高分股跌破5日線'
    ELSE '' 
END) AS [VoiceScript],
MAX(M.具體概念) AS [具體概念]
FROM View_AllMyWatchlists AS V
-- 1. 關聯盤中即時表
INNER JOIN [stockchange].[dbo].[basicinfo] AS B ON RTRIM(V.代號) = RTRIM(B.代號)
-- 2. 關聯歷史大寬表
INNER JOIN [dbo].[MasterStockAnalysis] AS M ON RTRIM(V.代號) = RTRIM(M.代號) 
-- 3. 關聯股性 DNA 表
INNER JOIN [dbo].[StockPersonality] AS P ON RTRIM(V.代號) = RTRIM(P.代號)
-- 4. 關聯昨日均線
INNER JOIN [dbo].[allcross] AS A ON RTRIM(V.代號) = RTRIM(A.代號) AND A.日期 = M.日期
WHERE V.來源標籤 IN ('自選股26','自選股27','自選股28','自選股29')
  AND M.日期 = (SELECT MAX(日期) FROM MasterStockAnalysis)
  AND B.自動編號 IN (SELECT MAX(自動編號) FROM [stockchange].[dbo].[basicinfo] GROUP BY 代號)
GROUP BY V.代號, V.名稱 -- 關鍵修正點：按代號群組，移除重複行
ORDER BY [昨日分] DESC

--先搬運basicinfo後才有最新數據,IN ('自選股26','自選股27','自選股28','自選股29')可調整所需要的自選股
` },

              {
                  cat: "盤中60M", title: "「🛰️ 三雄全時空導航儀 (60M技術+法人籌碼)」", sql: `/*資料庫:stockchangedate*/S.名稱, 
S.代號, 
S.日期 AS [今日日期],
S.時間 AS [最後小時],
S.收盤價 AS [盤中價],
S.OSC AS [今日60M力道],
S.K AS [今日60M_K],
-- 將標題修正為「昨收」，反映真實數據來源
V.外資 AS [昨收外資_億],
V.投信 AS [昨收投信_億],
V.外資3日合計 AS [外資3日金額],
N.外資10日合計 AS [外資10日張數],

-- 核心診斷邏輯：利用「昨日籌碼」驗證「今日小時轉折」
(CASE 
    WHEN V.外資 > 0 AND V.投信 > 0 AND S.OSC > 0 AND S.K > S.D THEN N'☀️ 土洋金身：昨日大買+今日小時反攻'
    WHEN V.外資 > 0 AND S.OSC > 0 THEN N'🌤️ 昨買今發：外資昨日護盤，今日小時翻多'
    WHEN V.外資 < 0 AND S.OSC > 0 THEN N'🔄 跌深反彈：法人昨日提款，今日僅短線反彈'
    WHEN N.外資10日合計 < 0 AND S.收盤價 < S.SMA20 THEN N'⛈️ 趨勢走空：長線提款+小時破位'
    ELSE N'☁️ 盤整觀察' 
END) AS [戰情診斷]

FROM (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY 代號 ORDER BY 日期 DESC, 時間 DESC) AS rn
    FROM [stockchange].[dbo].[Stock60M]
) AS S
INNER JOIN [stockchangedate].[dbo].[threemastervalue] V 
    ON RTRIM(S.代號) = RTRIM(V.代號) 
    AND V.日期 = (SELECT MAX(日期) FROM [stockchangedate].[dbo].[threemastervalue])
INNER JOIN [stockchangedate].[dbo].[threemasternumber] N 
    ON RTRIM(S.代號) = RTRIM(N.代號) 
    AND N.日期 = V.日期
WHERE S.rn = 1 
  AND S.代號 IN ('2330', '2454', '2317')
ORDER BY S.OSC DESC

/*核心邏輯： 當法人在日線級別「大買（金額）」且「持續（10日合計張數）」，而 60M 小時線正好出現「OSC 翻正」或「KD 低檔金叉」，這就是您勝率最高的**「大戶順風車」**進場點。
🚀 專家實戰建議：
盤中 (13:30 前)：使用這個「昨收法人」對齊「今日 60M」的指令，判斷昨日大戶的態度在今天是否有延續性。
盤後 (16:00 後)：等您搬運完今日（6/30）最新的法人買賣超數據後，再執行一次。屆時，「昨收外資」就會變成「今日外資」，戰情診斷會切換到下一個循環。
*/` },


              {
                  cat: "盤中60M", title: "「🎭 龍頭陷阱偵測儀 (避開法人誘多盤)」", sql: `/*資料庫:stockchangedate*/
S.名稱, 
S.代號, 
S.時間 AS [最後小時],
S.收盤價 AS [盤中價],
S.SMA20 AS [60M生命線], -- 使用 60M 生命線作為防禦基準
N.外資10日合計 AS [外資10日累計張數],
S.OSC AS [60M動能],
-- 診斷邏輯：偵測長線撤退與短線破位的死亡組合
(CASE 
    -- 情況 1：外資長線大撤退 + 小時線跌破生命線 = 崩盤預警
    WHEN N.外資10日合計 < -1000 AND S.收盤價 < S.SMA20 THEN N'💀 崩盤預警：法人提款+破生命線'
    
    -- 情況 2：外資長線撤退 + 盤中漲卻動能轉弱 = 假面反彈 (誘多)
    WHEN N.外資10日合計 < 0 AND S.OSC < 0 THEN N'🎭 假面反彈：大戶出貨中，切勿追高'
    
    -- 情況 3：股價在生命線下掙扎
    WHEN S.收盤價 < S.SMA20 THEN N'🌧️ 小時轉弱：靜待止跌'
    
    ELSE N'✅ 結構安全'
END) AS [陷阱診斷],
-- 計算與生命線的距離
ROUND(((S.收盤價 - S.SMA20) / S.SMA20) * 100, 2) AS [距生命線%]

FROM (
    -- 抓取 60M 最後一跳
    SELECT *, ROW_NUMBER() OVER (PARTITION BY 代號 ORDER BY 日期 DESC, 時間 DESC) AS rn
    FROM [stockchange].[dbo].[Stock60M]
) AS S
-- 關聯法人10日累計數據 (昨日結算值)
INNER JOIN [stockchangedate].[dbo].[threemasternumber] N 
    ON RTRIM(S.代號) = RTRIM(N.代號) 
    AND N.日期 = (SELECT MAX(日期) FROM [stockchangedate].[dbo].[threemasternumber])
WHERE S.rn = 1 
  AND S.代號 IN ('2330', '2454', '2317')
ORDER BY [外資10日累計張數] ASC

/*這是一個極具防禦價值的實戰戰術。在操盤上，最怕的就是看到紅K就想追，結果進場後才發現是法人趁反彈大舉倒貨。
這套 【大戶假面偵測】 系統，核心功能就是**「拆穿法人的假面具」**：利用日線級別的「外資10日總體態度」來對抗 60M 的「短線誘多」。
🛡️ 什麼是「真反轉」？
只有當 外資10日累計 開始由負轉正（或賣壓連續三天大幅縮小），且 60M 價格成功站回 SMA20 且 OSC > 0。這時，我們才會把「假面具」標籤移除，轉為「金身重啟」。

*/` },


              {
                  cat: "盤中60M", title: "三雄盤中紅綠燈預警系統", sql: `/*資料庫:stockchangedate*/
    S.名稱, 
    S.代號,
    -- 1. 視覺燈號 (DataTables 顯示用)
    (CASE 
        WHEN S.OSC > 0 AND S.收盤價 > S.SMA20 THEN N'🟢 綠燈 (安全)'
        WHEN S.OSC > 0 AND S.收盤價 < S.SMA20 THEN N'🟡 黃燈 (陷阱)'
        ELSE N'🔴 紅燈 (修正)' 
    END) AS [目前燈號],

    -- 2. 語音警報 (包含燈號朗讀)
    (CASE 
        WHEN S.OSC > 0 AND S.收盤價 > S.SMA20 
            THEN N'綠燈！' + S.名稱 + N'小時線翻正並站上生命線，結構安全，多頭進攻。'
        WHEN S.OSC > 0 AND S.收盤價 < S.SMA20 
            THEN N'黃燈警告！' + S.名稱 + N'目前為假面反彈，雖然動能翻正但仍低於生命線，大戶持續出貨中，請勿追高。'
        WHEN N.外資10日合計 < -50000 AND S.收盤價 < S.SMA20 
            THEN N'紅燈大警報！' + S.名稱 + N'偵測到崩盤預警，外資大舉提款且股價破位，請立即執行避險。'
        ELSE N'紅燈！' + S.名稱 + N'目前處於空頭修正，動能低迷。'
    END) AS [語音警報內容],

    S.收盤價 AS [盤中價],
    S.SMA20 AS [60M生命線],
    ROUND(((S.收盤價 - S.SMA20) / S.SMA20) * 100, 2) AS [距生命線%],
    N.外資10日合計 AS [外資10日趨勢]

FROM (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY 代號 ORDER BY 日期 DESC, 時間 DESC) AS rn
    FROM [stockchange].[dbo].[Stock60M]
) AS S
INNER JOIN [stockchangedate].[dbo].[threemasternumber] N 
    ON RTRIM(S.代號) = RTRIM(N.代號) AND N.日期 = (SELECT MAX(日期) FROM [stockchangedate].[dbo].[threemasternumber])
WHERE S.rn = 1 AND S.代號 IN ('2330', '2454', '2317')
ORDER BY [目前燈號] ASC -- 讓紅燈跟黃燈排在最前面` },


              {
                  cat: "凱利金流導航儀", title: "「💰 凱利金流導航儀：最佳投入比例與持股期」", sql: `/*資料庫:stockchangedate*/
M.名稱, 
M.代號, 
M.專家實戰總分 AS [今日得分],
P.股性標籤,
P.最佳天數 AS [建議持有天數],
P.最高勝率 AS [歷史勝率%],
P.預期報酬 AS [贏面%],

-- 凱利公式計算 (假設 5% 固定停損)
-- F = (B*P - Q) / B
-- B = 預期報酬 / 5, P = 勝率/100, Q = 1 - P
CAST(
    (( (P.預期報酬/5.0) * (P.最高勝率/100.0) - (1 - P.最高勝率/100.0) ) / (NULLIF(P.預期報酬/5.0, 0))) * 100 
AS DECIMAL(10,1)) AS [凱利全倉比例%],

-- 半凱利建議 (更穩健)
CAST(
    (( (P.預期報酬/5.0) * (P.最高勝率/100.0) - (1 - P.最高勝率/100.0) ) / (NULLIF(P.預期報酬/5.0, 0))) * 50 
AS DECIMAL(10,1)) AS [半凱利建議投組%],

M.具體概念
FROM MasterStockAnalysis M
INNER JOIN StockPersonality P ON M.代號 = P.代號
WHERE M.日期 = (SELECT MAX(日期) FROM MasterStockAnalysis)
  AND M.專家實戰總分 > 30 -- 買入時間判定：總分 > 30
  AND P.最高勝率 > 55    -- 凱利公式前提：勝率必須大於一定門檻才有正期望值
ORDER BY [半凱利建議投組%] DESC

/*這是一個非常高階的量化交易思維！將「凱利公式（Kelly Criterion）」引入您的「數據坦克」，等於是為您的戰情室裝上了**「自動金流控盤大腦」**。
在股票實戰中，凱利公式能解決最難的兩個問題：「這檔該買多少？」以及「如何避免一次大賠就畢業？」
以下我將凱利公式與您的 StockPersonality（股性基因）與 MasterStockAnalysis（專家分數）結合，為您開發出一套 「凱利金流導航系統」。*/` },

              {
                  cat: "盤中操盤", title: "盤中+obv及量能突(跌)破+共振量能總分全部", sql: `/*資料庫:stockchange*/ * FROM (
    SELECT 
        T2.名稱, T2.代號, T2.盤中價, T2.盤中漲幅, T2.具體概念, T2.昨總分,
        T2.昨共振, T2.預估收盤共振, T2.盤中增減項,
        T2.乖離率, T2.量倍率,
        -- 價格五日線狀態
        CASE 
            WHEN T2.昨收 < T2.昨MA5 AND T2.盤中價 > T2.盤中MA5 THEN N'✅ 突破'
            WHEN T2.昨收 > T2.昨MA5 AND T2.盤中價 < T2.盤中MA5 THEN N'🚨 跌破'
            WHEN T2.盤中價 > T2.盤中MA5 THEN N'站上'
            ELSE N'線下'
        END AS 價格狀態,
        -- OBV 能量狀態
        CASE 
            WHEN T2.昨OBV < T2.昨OBV_MA5 AND T2.盤中OBV > T2.盤中OBV_MA5 THEN N'🚀 金叉'
            WHEN T2.昨OBV > T2.昨OBV_MA5 AND T2.盤中OBV < T2.盤中OBV_MA5 THEN N'💀 死叉'
            WHEN T2.盤中OBV > T2.盤中OBV_MA5 THEN N'強勢'
            ELSE N'弱勢'
        END AS OBV狀態,
        -- 專家點評 (現在可以安全使用 T2 定義好的欄位)
        CASE 
            WHEN T2.預估收盤共振 >= 5 AND T2.昨總分 > 35 AND T2.盤中價 > T2.盤中MA5 THEN N'⭐ 極致強勢股'
            WHEN T2.預估收盤共振 >= 5 AND T2.量倍率 > 1.2 THEN N'🔥 價量齊揚'
            WHEN T2.昨收 > T2.昨MA5 AND T2.盤中價 < T2.盤中MA5 THEN N'🚨 轉弱減碼'
            ELSE N'--'
        END AS 專家點評,
        T2.盤中突破項目,
        T2.產業價值鏈資訊
    FROM (
        SELECT 
            T1.*,
            -- 計算數值 (下移至此層，解決別名無效問題)
            ROUND(((T1.盤中價 - T1.盤中MA5) / NULLIF(T1.盤中MA5, 0)) * 100, 2) AS 乖離率,
            ROUND((CAST(T1.盤中量 AS FLOAT) / NULLIF(T1.昨全天量, 0)), 2) AS 量倍率,
            -- 計算增減分
            CASE WHEN T1.昨價金叉 = 0 AND T1.盤中價 > T1.盤中MA5 THEN 1 
                 WHEN T1.昨價金叉 = 1 AND T1.盤中價 < T1.盤中MA5 THEN -1 ELSE 0 END AS 價增分,
            CASE WHEN T1.昨OBV金叉 = 0 AND T1.盤中OBV > T1.盤中OBV_MA5 THEN 1 
                 WHEN T1.昨OBV金叉 = 1 AND T1.盤中OBV < T1.盤中OBV_MA5 THEN -1 ELSE 0 END AS OBV增分,
            CASE WHEN T1.昨量金叉 = 0 AND T1.盤中量 > T1.盤中量MA5 THEN 1 
                 WHEN T1.昨量金叉 = 1 AND T1.盤中量 < T1.盤中量MA5 THEN -1 ELSE 0 END AS 量增分,
            -- 預估共振總數
            (T1.昨共振 + 
                (CASE WHEN T1.昨價金叉 = 0 AND T1.盤中價 > T1.盤中MA5 THEN 1 WHEN T1.昨價金叉 = 1 AND T1.盤中價 < T1.盤中MA5 THEN -1 ELSE 0 END) + 
                (CASE WHEN T1.昨OBV金叉 = 0 AND T1.盤中OBV > T1.盤中OBV_MA5 THEN 1 WHEN T1.昨OBV金叉 = 1 AND T1.盤中價 < T1.盤中OBV_MA5 THEN -1 ELSE 0 END) + 
                (CASE WHEN T1.昨量金叉 = 0 AND T1.盤中量 > T1.盤中量MA5 THEN 1 WHEN T1.昨量金叉 = 1 AND T1.盤中量 < T1.盤中量MA5 THEN -1 ELSE 0 END)
            ) AS 預估收盤共振,
            (
                (CASE WHEN T1.昨價金叉 = 0 AND T1.盤中價 > T1.盤中MA5 THEN 1 WHEN T1.昨價金叉 = 1 AND T1.盤中價 < T1.盤中MA5 THEN -1 ELSE 0 END) + 
                (CASE WHEN T1.昨OBV金叉 = 0 AND T1.盤中OBV > T1.盤中OBV_MA5 THEN 1 WHEN T1.昨OBV金叉 = 1 AND T1.盤中OBV < T1.盤中OBV_MA5 THEN -1 ELSE 0 END) + 
                (CASE WHEN T1.昨量金叉 = 0 AND T1.盤中量 > T1.盤中量MA5 THEN 1 WHEN T1.昨量金叉 = 1 AND T1.盤中量 < T1.盤中量MA5 THEN -1 ELSE 0 END)
            ) AS 盤中增減項,
            -- 突破項目
            CASE WHEN (CASE WHEN T1.昨價金叉 = 0 AND T1.盤中價 > T1.盤中MA5 THEN 1 ELSE 0 END) = 1 THEN N'[價突破] ' ELSE '' END +
            CASE WHEN (CASE WHEN T1.昨OBV金叉 = 0 AND T1.盤中OBV > T1.盤中OBV_MA5 THEN 1 ELSE 0 END) = 1 THEN N'[量能噴發] ' ELSE '' END +
            CASE WHEN (CASE WHEN T1.昨量金叉 = 0 AND T1.盤中量 > T1.盤中量MA5 THEN 1 ELSE 0 END) = 1 THEN N'[異常放量] ' ELSE '' END AS 盤中突破項目
        FROM (
            SELECT 
                I.名稱, I.代號, I.成交價 AS 盤中價, I.漲幅 AS 盤中漲幅, I.總量 AS 盤中量, I.漲跌,
                Y.日期 AS 昨日期, Y.盤中現價 AS 昨收, Y.obv淨額 AS 昨OBV, Y.專家實戰總分 AS 昨總分, Y.盤中總量 AS 昨全天量,
                N.name1 AS 具體概念,
                -- 【修正點】補全 View_notioninfoskill 的資料庫路徑
                (SELECT TOP 1 STRING_AGG(CAST(RTRIM(V2.name1) + '(' + RTRIM(V2.mail1) + ')' AS NVARCHAR(MAX)), ' | ') 
                 FROM stockchangedate.dbo.View_notioninfoskill V2 WHERE V2.memo LIKE '%' + REPLACE(RTRIM(I.名稱), '*', '') + '%') AS 產業價值鏈資訊,
                -- 歷史共振
                (CASE WHEN Y.均價黃金交叉次數 > 0 THEN 1 ELSE 0 END + CASE WHEN Y.obv累積金叉次數 > 0 THEN 1 ELSE 0 END + CASE WHEN Y.均量黃金交叉次數 > 0 THEN 1 ELSE 0 END + CASE WHEN Y.三大法人黃金交叉次數 > 0 THEN 1 ELSE 0 END + CASE WHEN Y.外資黃金交叉次數 > 0 THEN 1 ELSE 0 END + CASE WHEN Y.投信黃金交叉次數 > 0 THEN 1 ELSE 0 END) AS 昨共振,
                CASE WHEN Y.均價黃金交叉次數 > 0 THEN 1 ELSE 0 END AS 昨價金叉,
                CASE WHEN Y.obv累積金叉次數 > 0 THEN 1 ELSE 0 END AS 昨OBV金叉,
                CASE WHEN Y.均量黃金交叉次數 > 0 THEN 1 ELSE 0 END AS 昨量金叉,
                -- 均線與預估
                (SELECT AVG(盤中現價) FROM (SELECT TOP 5 盤中現價 FROM stockchangedate.dbo.MasterStockAnalysis M2 WHERE M2.代號 = I.代號 AND M2.日期 <= Y.日期 ORDER BY M2.日期 DESC) a) AS 昨MA5,
                ((SELECT AVG(盤中現價) FROM (SELECT TOP 4 盤中現價 FROM stockchangedate.dbo.MasterStockAnalysis M2 WHERE M2.代號 = I.代號 AND M2.日期 <= Y.日期 ORDER BY M2.日期 DESC) b) * 4 + I.成交價) / 5 AS 盤中MA5,
                (SELECT AVG(obv淨額) FROM (SELECT TOP 5 obv淨額 FROM stockchangedate.dbo.MasterStockAnalysis M3 WHERE M3.代號 = I.代號 AND M3.日期 <= Y.日期 ORDER BY M3.日期 DESC) c) AS 昨OBV_MA5,
                CASE WHEN I.漲跌 > 0 THEN Y.obv淨額 + I.總量 WHEN I.漲跌 < 0 THEN Y.obv淨額 - I.總量 ELSE Y.obv淨額 END AS 盤中OBV,
                ((SELECT AVG(obv淨額) FROM (SELECT TOP 4 obv淨額 FROM stockchangedate.dbo.MasterStockAnalysis M3 WHERE M3.代號 = I.代號 AND M3.日期 <= Y.日期 ORDER BY M3.日期 DESC) d) * 4 + (CASE WHEN I.漲跌 > 0 THEN Y.obv淨額 + I.總量 WHEN I.漲跌 < 0 THEN Y.obv淨額 - I.總量 ELSE Y.obv淨額 END)) / 5 AS 盤中OBV_MA5,
                ((SELECT AVG(盤中總量) FROM (SELECT TOP 4 盤中總量 FROM stockchangedate.dbo.MasterStockAnalysis M4 WHERE M4.代號 = I.代號 AND M4.日期 <= Y.日期 ORDER BY M4.日期 DESC) e) * 4 + I.總量) / 5 AS 盤中量MA5
            FROM dbo.basicinfo I
            INNER JOIN stockchangedate.dbo.MasterStockAnalysis Y ON I.代號 = Y.代號
            LEFT JOIN stockchangedate.dbo.notioninfo N ON REPLACE(RTRIM(I.名稱), '*', '') = REPLACE(RTRIM(N.mail1), '*', '')
            WHERE Y.日期 = (SELECT MAX(日期) FROM stockchangedate.dbo.MasterStockAnalysis)
        ) T1
    ) T2
) Final

ORDER BY 
    (CASE WHEN Final.價格狀態 = N'🚨 跌破' OR Final.OBV狀態 = N'💀 死叉' THEN 1 ELSE 2 END), 
    Final.預估收盤共振 DESC, 
    Final.量倍率 DESC;

--盤中全部股票`
              },
              {
                  cat: "盤中操盤", title: "昨天基因好，今天帶量剛突破，且還沒漲到噴出（乖離不過大）", sql: `/*資料庫:stockchange*/ * FROM (
    SELECT 
        T2.名稱, T2.代號, T2.盤中價, T2.盤中漲幅, T2.具體概念, T2.昨總分,
        T2.昨共振, T2.預估收盤共振, T2.盤中增減項,
        T2.乖離率, T2.量倍率,
        -- 價格五日線狀態
        CASE 
            WHEN T2.昨收 < T2.昨MA5 AND T2.盤中價 > T2.盤中MA5 THEN N'✅ 突破'
            WHEN T2.昨收 > T2.昨MA5 AND T2.盤中價 < T2.盤中MA5 THEN N'🚨 跌破'
            WHEN T2.盤中價 > T2.盤中MA5 THEN N'站上'
            ELSE N'線下'
        END AS 價格狀態,
        -- OBV 能量狀態
        CASE 
            WHEN T2.昨OBV < T2.昨OBV_MA5 AND T2.盤中OBV > T2.盤中OBV_MA5 THEN N'🚀 金叉'
            WHEN T2.昨OBV > T2.昨OBV_MA5 AND T2.盤中OBV < T2.盤中OBV_MA5 THEN N'💀 死叉'
            WHEN T2.盤中OBV > T2.盤中OBV_MA5 THEN N'強勢'
            ELSE N'弱勢'
        END AS OBV狀態,
        -- 專家點評 (現在可以安全使用 T2 定義好的欄位)
        CASE 
            WHEN T2.預估收盤共振 >= 5 AND T2.昨總分 > 35 AND T2.盤中價 > T2.盤中MA5 THEN N'⭐ 極致強勢股'
            WHEN T2.預估收盤共振 >= 5 AND T2.量倍率 > 1.2 THEN N'🔥 價量齊揚'
            WHEN T2.昨收 > T2.昨MA5 AND T2.盤中價 < T2.盤中MA5 THEN N'🚨 轉弱減碼'
            ELSE N'--'
        END AS 專家點評,
        T2.盤中突破項目,
        T2.產業價值鏈資訊
    FROM (
        SELECT 
            T1.*,
            -- 計算數值 (下移至此層，解決別名無效問題)
            ROUND(((T1.盤中價 - T1.盤中MA5) / NULLIF(T1.盤中MA5, 0)) * 100, 2) AS 乖離率,
            ROUND((CAST(T1.盤中量 AS FLOAT) / NULLIF(T1.昨全天量, 0)), 2) AS 量倍率,
            -- 計算增減分
            CASE WHEN T1.昨價金叉 = 0 AND T1.盤中價 > T1.盤中MA5 THEN 1 
                 WHEN T1.昨價金叉 = 1 AND T1.盤中價 < T1.盤中MA5 THEN -1 ELSE 0 END AS 價增分,
            CASE WHEN T1.昨OBV金叉 = 0 AND T1.盤中OBV > T1.盤中OBV_MA5 THEN 1 
                 WHEN T1.昨OBV金叉 = 1 AND T1.盤中OBV < T1.盤中OBV_MA5 THEN -1 ELSE 0 END AS OBV增分,
            CASE WHEN T1.昨量金叉 = 0 AND T1.盤中量 > T1.盤中量MA5 THEN 1 
                 WHEN T1.昨量金叉 = 1 AND T1.盤中量 < T1.盤中量MA5 THEN -1 ELSE 0 END AS 量增分,
            -- 預估共振總數
            (T1.昨共振 + 
                (CASE WHEN T1.昨價金叉 = 0 AND T1.盤中價 > T1.盤中MA5 THEN 1 WHEN T1.昨價金叉 = 1 AND T1.盤中價 < T1.盤中MA5 THEN -1 ELSE 0 END) + 
                (CASE WHEN T1.昨OBV金叉 = 0 AND T1.盤中OBV > T1.盤中OBV_MA5 THEN 1 WHEN T1.昨OBV金叉 = 1 AND T1.盤中價 < T1.盤中OBV_MA5 THEN -1 ELSE 0 END) + 
                (CASE WHEN T1.昨量金叉 = 0 AND T1.盤中量 > T1.盤中量MA5 THEN 1 WHEN T1.昨量金叉 = 1 AND T1.盤中量 < T1.盤中量MA5 THEN -1 ELSE 0 END)
            ) AS 預估收盤共振,
            (
                (CASE WHEN T1.昨價金叉 = 0 AND T1.盤中價 > T1.盤中MA5 THEN 1 WHEN T1.昨價金叉 = 1 AND T1.盤中價 < T1.盤中MA5 THEN -1 ELSE 0 END) + 
                (CASE WHEN T1.昨OBV金叉 = 0 AND T1.盤中OBV > T1.盤中OBV_MA5 THEN 1 WHEN T1.昨OBV金叉 = 1 AND T1.盤中OBV < T1.盤中OBV_MA5 THEN -1 ELSE 0 END) + 
                (CASE WHEN T1.昨量金叉 = 0 AND T1.盤中量 > T1.盤中量MA5 THEN 1 WHEN T1.昨量金叉 = 1 AND T1.盤中量 < T1.盤中量MA5 THEN -1 ELSE 0 END)
            ) AS 盤中增減項,
            -- 突破項目
            CASE WHEN (CASE WHEN T1.昨價金叉 = 0 AND T1.盤中價 > T1.盤中MA5 THEN 1 ELSE 0 END) = 1 THEN N'[價突破] ' ELSE '' END +
            CASE WHEN (CASE WHEN T1.昨OBV金叉 = 0 AND T1.盤中OBV > T1.盤中OBV_MA5 THEN 1 ELSE 0 END) = 1 THEN N'[量能噴發] ' ELSE '' END +
            CASE WHEN (CASE WHEN T1.昨量金叉 = 0 AND T1.盤中量 > T1.盤中量MA5 THEN 1 ELSE 0 END) = 1 THEN N'[異常放量] ' ELSE '' END AS 盤中突破項目
        FROM (
            SELECT 
                I.名稱, I.代號, I.成交價 AS 盤中價, I.漲幅 AS 盤中漲幅, I.總量 AS 盤中量, I.漲跌,
                Y.日期 AS 昨日期, Y.盤中現價 AS 昨收, Y.obv淨額 AS 昨OBV, Y.專家實戰總分 AS 昨總分, Y.盤中總量 AS 昨全天量,
                N.name1 AS 具體概念,
                -- 【修正點】補全 View_notioninfoskill 的資料庫路徑
                (SELECT TOP 1 STRING_AGG(CAST(RTRIM(V2.name1) + '(' + RTRIM(V2.mail1) + ')' AS NVARCHAR(MAX)), ' | ') 
                 FROM stockchangedate.dbo.View_notioninfoskill V2 WHERE V2.memo LIKE '%' + REPLACE(RTRIM(I.名稱), '*', '') + '%') AS 產業價值鏈資訊,
                -- 歷史共振
                (CASE WHEN Y.均價黃金交叉次數 > 0 THEN 1 ELSE 0 END + CASE WHEN Y.obv累積金叉次數 > 0 THEN 1 ELSE 0 END + CASE WHEN Y.均量黃金交叉次數 > 0 THEN 1 ELSE 0 END + CASE WHEN Y.三大法人黃金交叉次數 > 0 THEN 1 ELSE 0 END + CASE WHEN Y.外資黃金交叉次數 > 0 THEN 1 ELSE 0 END + CASE WHEN Y.投信黃金交叉次數 > 0 THEN 1 ELSE 0 END) AS 昨共振,
                CASE WHEN Y.均價黃金交叉次數 > 0 THEN 1 ELSE 0 END AS 昨價金叉,
                CASE WHEN Y.obv累積金叉次數 > 0 THEN 1 ELSE 0 END AS 昨OBV金叉,
                CASE WHEN Y.均量黃金交叉次數 > 0 THEN 1 ELSE 0 END AS 昨量金叉,
                -- 均線與預估
                (SELECT AVG(盤中現價) FROM (SELECT TOP 5 盤中現價 FROM stockchangedate.dbo.MasterStockAnalysis M2 WHERE M2.代號 = I.代號 AND M2.日期 <= Y.日期 ORDER BY M2.日期 DESC) a) AS 昨MA5,
                ((SELECT AVG(盤中現價) FROM (SELECT TOP 4 盤中現價 FROM stockchangedate.dbo.MasterStockAnalysis M2 WHERE M2.代號 = I.代號 AND M2.日期 <= Y.日期 ORDER BY M2.日期 DESC) b) * 4 + I.成交價) / 5 AS 盤中MA5,
                (SELECT AVG(obv淨額) FROM (SELECT TOP 5 obv淨額 FROM stockchangedate.dbo.MasterStockAnalysis M3 WHERE M3.代號 = I.代號 AND M3.日期 <= Y.日期 ORDER BY M3.日期 DESC) c) AS 昨OBV_MA5,
                CASE WHEN I.漲跌 > 0 THEN Y.obv淨額 + I.總量 WHEN I.漲跌 < 0 THEN Y.obv淨額 - I.總量 ELSE Y.obv淨額 END AS 盤中OBV,
                ((SELECT AVG(obv淨額) FROM (SELECT TOP 4 obv淨額 FROM stockchangedate.dbo.MasterStockAnalysis M3 WHERE M3.代號 = I.代號 AND M3.日期 <= Y.日期 ORDER BY M3.日期 DESC) d) * 4 + (CASE WHEN I.漲跌 > 0 THEN Y.obv淨額 + I.總量 WHEN I.漲跌 < 0 THEN Y.obv淨額 - I.總量 ELSE Y.obv淨額 END)) / 5 AS 盤中OBV_MA5,
                ((SELECT AVG(盤中總量) FROM (SELECT TOP 4 盤中總量 FROM stockchangedate.dbo.MasterStockAnalysis M4 WHERE M4.代號 = I.代號 AND M4.日期 <= Y.日期 ORDER BY M4.日期 DESC) e) * 4 + I.總量) / 5 AS 盤中量MA5
            FROM dbo.basicinfo I
            INNER JOIN stockchangedate.dbo.MasterStockAnalysis Y ON I.代號 = Y.代號
            LEFT JOIN stockchangedate.dbo.notioninfo N ON REPLACE(RTRIM(I.名稱), '*', '') = REPLACE(RTRIM(N.mail1), '*', '')
            WHERE Y.日期 = (SELECT MAX(日期) FROM stockchangedate.dbo.MasterStockAnalysis)
        ) T1
    ) T2
) Final
WHERE Final.預估收盤共振 >= 5 
  AND Final.價格狀態 = N'✅ 突破' 
  AND Final.量倍率 > 0.7
  AND Final.乖離率 BETWEEN 0.1 AND 6.0

ORDER BY 
    (CASE WHEN Final.價格狀態 = N'🚨 跌破' OR Final.OBV狀態 = N'💀 死叉' THEN 1 ELSE 2 END), 
    Final.預估收盤共振 DESC, 
    Final.量倍率 DESC;

--1. 嚴選強勢進攻股 (最推薦：高共振 + 剛突破 + 量能爆發)
--這組條件找的是：昨天基因好，今天帶量剛突破，且還沒漲到噴出（乖離不過大）。`
              },
              {
                  cat: "盤中操盤", title: "原本可能在盤整，但今天突然「多維度共振」跳升，且大戶明顯進場。", sql: `/*資料庫:stockchange*/ * FROM (
    SELECT 
        T2.名稱, T2.代號, T2.盤中價, T2.盤中漲幅, T2.具體概念, T2.昨總分,
        T2.昨共振, T2.預估收盤共振, T2.盤中增減項,
        T2.乖離率, T2.量倍率,
        -- 價格五日線狀態
        CASE 
            WHEN T2.昨收 < T2.昨MA5 AND T2.盤中價 > T2.盤中MA5 THEN N'✅ 突破'
            WHEN T2.昨收 > T2.昨MA5 AND T2.盤中價 < T2.盤中MA5 THEN N'🚨 跌破'
            WHEN T2.盤中價 > T2.盤中MA5 THEN N'站上'
            ELSE N'線下'
        END AS 價格狀態,
        -- OBV 能量狀態
        CASE 
            WHEN T2.昨OBV < T2.昨OBV_MA5 AND T2.盤中OBV > T2.盤中OBV_MA5 THEN N'🚀 金叉'
            WHEN T2.昨OBV > T2.昨OBV_MA5 AND T2.盤中OBV < T2.盤中OBV_MA5 THEN N'💀 死叉'
            WHEN T2.盤中OBV > T2.盤中OBV_MA5 THEN N'強勢'
            ELSE N'弱勢'
        END AS OBV狀態,
        -- 專家點評 (現在可以安全使用 T2 定義好的欄位)
        CASE 
            WHEN T2.預估收盤共振 >= 5 AND T2.昨總分 > 35 AND T2.盤中價 > T2.盤中MA5 THEN N'⭐ 極致強勢股'
            WHEN T2.預估收盤共振 >= 5 AND T2.量倍率 > 1.2 THEN N'🔥 價量齊揚'
            WHEN T2.昨收 > T2.昨MA5 AND T2.盤中價 < T2.盤中MA5 THEN N'🚨 轉弱減碼'
            ELSE N'--'
        END AS 專家點評,
        T2.盤中突破項目,
        T2.產業價值鏈資訊
    FROM (
        SELECT 
            T1.*,
            -- 計算數值 (下移至此層，解決別名無效問題)
            ROUND(((T1.盤中價 - T1.盤中MA5) / NULLIF(T1.盤中MA5, 0)) * 100, 2) AS 乖離率,
            ROUND((CAST(T1.盤中量 AS FLOAT) / NULLIF(T1.昨全天量, 0)), 2) AS 量倍率,
            -- 計算增減分
            CASE WHEN T1.昨價金叉 = 0 AND T1.盤中價 > T1.盤中MA5 THEN 1 
                 WHEN T1.昨價金叉 = 1 AND T1.盤中價 < T1.盤中MA5 THEN -1 ELSE 0 END AS 價增分,
            CASE WHEN T1.昨OBV金叉 = 0 AND T1.盤中OBV > T1.盤中OBV_MA5 THEN 1 
                 WHEN T1.昨OBV金叉 = 1 AND T1.盤中OBV < T1.盤中OBV_MA5 THEN -1 ELSE 0 END AS OBV增分,
            CASE WHEN T1.昨量金叉 = 0 AND T1.盤中量 > T1.盤中量MA5 THEN 1 
                 WHEN T1.昨量金叉 = 1 AND T1.盤中量 < T1.盤中量MA5 THEN -1 ELSE 0 END AS 量增分,
            -- 預估共振總數
            (T1.昨共振 + 
                (CASE WHEN T1.昨價金叉 = 0 AND T1.盤中價 > T1.盤中MA5 THEN 1 WHEN T1.昨價金叉 = 1 AND T1.盤中價 < T1.盤中MA5 THEN -1 ELSE 0 END) + 
                (CASE WHEN T1.昨OBV金叉 = 0 AND T1.盤中OBV > T1.盤中OBV_MA5 THEN 1 WHEN T1.昨OBV金叉 = 1 AND T1.盤中價 < T1.盤中OBV_MA5 THEN -1 ELSE 0 END) + 
                (CASE WHEN T1.昨量金叉 = 0 AND T1.盤中量 > T1.盤中量MA5 THEN 1 WHEN T1.昨量金叉 = 1 AND T1.盤中量 < T1.盤中量MA5 THEN -1 ELSE 0 END)
            ) AS 預估收盤共振,
            (
                (CASE WHEN T1.昨價金叉 = 0 AND T1.盤中價 > T1.盤中MA5 THEN 1 WHEN T1.昨價金叉 = 1 AND T1.盤中價 < T1.盤中MA5 THEN -1 ELSE 0 END) + 
                (CASE WHEN T1.昨OBV金叉 = 0 AND T1.盤中OBV > T1.盤中OBV_MA5 THEN 1 WHEN T1.昨OBV金叉 = 1 AND T1.盤中OBV < T1.盤中OBV_MA5 THEN -1 ELSE 0 END) + 
                (CASE WHEN T1.昨量金叉 = 0 AND T1.盤中量 > T1.盤中量MA5 THEN 1 WHEN T1.昨量金叉 = 1 AND T1.盤中量 < T1.盤中量MA5 THEN -1 ELSE 0 END)
            ) AS 盤中增減項,
            -- 突破項目
            CASE WHEN (CASE WHEN T1.昨價金叉 = 0 AND T1.盤中價 > T1.盤中MA5 THEN 1 ELSE 0 END) = 1 THEN N'[價突破] ' ELSE '' END +
            CASE WHEN (CASE WHEN T1.昨OBV金叉 = 0 AND T1.盤中OBV > T1.盤中OBV_MA5 THEN 1 ELSE 0 END) = 1 THEN N'[量能噴發] ' ELSE '' END +
            CASE WHEN (CASE WHEN T1.昨量金叉 = 0 AND T1.盤中量 > T1.盤中量MA5 THEN 1 ELSE 0 END) = 1 THEN N'[異常放量] ' ELSE '' END AS 盤中突破項目
        FROM (
            SELECT 
                I.名稱, I.代號, I.成交價 AS 盤中價, I.漲幅 AS 盤中漲幅, I.總量 AS 盤中量, I.漲跌,
                Y.日期 AS 昨日期, Y.盤中現價 AS 昨收, Y.obv淨額 AS 昨OBV, Y.專家實戰總分 AS 昨總分, Y.盤中總量 AS 昨全天量,
                N.name1 AS 具體概念,
                -- 【修正點】補全 View_notioninfoskill 的資料庫路徑
                (SELECT TOP 1 STRING_AGG(CAST(RTRIM(V2.name1) + '(' + RTRIM(V2.mail1) + ')' AS NVARCHAR(MAX)), ' | ') 
                 FROM stockchangedate.dbo.View_notioninfoskill V2 WHERE V2.memo LIKE '%' + REPLACE(RTRIM(I.名稱), '*', '') + '%') AS 產業價值鏈資訊,
                -- 歷史共振
                (CASE WHEN Y.均價黃金交叉次數 > 0 THEN 1 ELSE 0 END + CASE WHEN Y.obv累積金叉次數 > 0 THEN 1 ELSE 0 END + CASE WHEN Y.均量黃金交叉次數 > 0 THEN 1 ELSE 0 END + CASE WHEN Y.三大法人黃金交叉次數 > 0 THEN 1 ELSE 0 END + CASE WHEN Y.外資黃金交叉次數 > 0 THEN 1 ELSE 0 END + CASE WHEN Y.投信黃金交叉次數 > 0 THEN 1 ELSE 0 END) AS 昨共振,
                CASE WHEN Y.均價黃金交叉次數 > 0 THEN 1 ELSE 0 END AS 昨價金叉,
                CASE WHEN Y.obv累積金叉次數 > 0 THEN 1 ELSE 0 END AS 昨OBV金叉,
                CASE WHEN Y.均量黃金交叉次數 > 0 THEN 1 ELSE 0 END AS 昨量金叉,
                -- 均線與預估
                (SELECT AVG(盤中現價) FROM (SELECT TOP 5 盤中現價 FROM stockchangedate.dbo.MasterStockAnalysis M2 WHERE M2.代號 = I.代號 AND M2.日期 <= Y.日期 ORDER BY M2.日期 DESC) a) AS 昨MA5,
                ((SELECT AVG(盤中現價) FROM (SELECT TOP 4 盤中現價 FROM stockchangedate.dbo.MasterStockAnalysis M2 WHERE M2.代號 = I.代號 AND M2.日期 <= Y.日期 ORDER BY M2.日期 DESC) b) * 4 + I.成交價) / 5 AS 盤中MA5,
                (SELECT AVG(obv淨額) FROM (SELECT TOP 5 obv淨額 FROM stockchangedate.dbo.MasterStockAnalysis M3 WHERE M3.代號 = I.代號 AND M3.日期 <= Y.日期 ORDER BY M3.日期 DESC) c) AS 昨OBV_MA5,
                CASE WHEN I.漲跌 > 0 THEN Y.obv淨額 + I.總量 WHEN I.漲跌 < 0 THEN Y.obv淨額 - I.總量 ELSE Y.obv淨額 END AS 盤中OBV,
                ((SELECT AVG(obv淨額) FROM (SELECT TOP 4 obv淨額 FROM stockchangedate.dbo.MasterStockAnalysis M3 WHERE M3.代號 = I.代號 AND M3.日期 <= Y.日期 ORDER BY M3.日期 DESC) d) * 4 + (CASE WHEN I.漲跌 > 0 THEN Y.obv淨額 + I.總量 WHEN I.漲跌 < 0 THEN Y.obv淨額 - I.總量 ELSE Y.obv淨額 END)) / 5 AS 盤中OBV_MA5,
                ((SELECT AVG(盤中總量) FROM (SELECT TOP 4 盤中總量 FROM stockchangedate.dbo.MasterStockAnalysis M4 WHERE M4.代號 = I.代號 AND M4.日期 <= Y.日期 ORDER BY M4.日期 DESC) e) * 4 + I.總量) / 5 AS 盤中量MA5
            FROM dbo.basicinfo I
            INNER JOIN stockchangedate.dbo.MasterStockAnalysis Y ON I.代號 = Y.代號
            LEFT JOIN stockchangedate.dbo.notioninfo N ON REPLACE(RTRIM(I.名稱), '*', '') = REPLACE(RTRIM(N.mail1), '*', '')
            WHERE Y.日期 = (SELECT MAX(日期) FROM stockchangedate.dbo.MasterStockAnalysis)
        ) T1
    ) T2
) Final
WHERE Final.盤中增減項 >= 2 
  AND Final.預估收盤共振 >= 4
  AND Final.量倍率 > 0.8
  AND Final.OBV狀態 <> N'弱勢'
ORDER BY 
    (CASE WHEN Final.價格狀態 = N'🚨 跌破' OR Final.OBV狀態 = N'💀 死叉' THEN 1 ELSE 2 END), 
    Final.預估收盤共振 DESC, 
    Final.量倍率 DESC;


--2. 潛力黑馬股 (共振跳升 + 基因厚實)
--這組條件找的是：原本可能在盤整，但今天突然「多維度共振」跳升，且大戶明顯進場。`
              },

              {
                  cat: "盤中操盤", title: "趨勢已經形成，目前穩穩站在五日線上，且 OBV 持續強勢。", sql: `/*資料庫:stockchange*/ * FROM (
    SELECT 
        T2.名稱, T2.代號, T2.盤中價, T2.盤中漲幅, T2.具體概念, 
        T2.昨共振, T2.預估收盤共振, T2.盤中增減項,
        T2.乖離率, T2.量倍率, T2.昨總分,
        -- 價格五日線狀態
        CASE 
            WHEN T2.昨收 < T2.昨MA5 AND T2.盤中價 > T2.盤中MA5 THEN N'✅ 突破'
            WHEN T2.昨收 > T2.昨MA5 AND T2.盤中價 < T2.盤中MA5 THEN N'🚨 跌破'
            WHEN T2.盤中價 > T2.盤中MA5 THEN N'站上'
            ELSE N'線下'
        END AS 價格狀態,
        -- OBV 能量狀態
        CASE 
            WHEN T2.昨OBV < T2.昨OBV_MA5 AND T2.盤中OBV > T2.盤中OBV_MA5 THEN N'🚀 金叉'
            WHEN T2.昨OBV > T2.昨OBV_MA5 AND T2.盤中OBV < T2.盤中OBV_MA5 THEN N'💀 死叉'
            WHEN T2.盤中OBV > T2.盤中OBV_MA5 THEN N'強勢'
            ELSE N'弱勢'
        END AS OBV狀態,
        -- 專家點評
        CASE 
            WHEN T2.預估收盤共振 >= 5 AND T2.昨總分 > 35 AND T2.盤中價 > T2.盤中MA5 THEN N'⭐ 極致強勢股'
            WHEN T2.預估收盤共振 >= 5 AND T2.量倍率 > 1.2 THEN N'🔥 價量齊揚'
            WHEN T2.昨收 > T2.昨MA5 AND T2.盤中價 < T2.盤中MA5 THEN N'🚨 轉弱減碼'
            ELSE N'--'
        END AS 專家點評,
        T2.盤中突破項目,
        T2.產業價值鏈資訊
    FROM (
        SELECT 
            T1.名稱, T1.代號, T1.盤中價, T1.盤中漲幅, T1.盤中量, T1.昨收, T1.昨MA5, T1.昨OBV, T1.昨OBV_MA5, T1.昨總分, T1.昨全天量,
            T1.具體概念, T1.產業價值鏈資訊, T1.昨共振, T1.昨價金叉, T1.昨OBV金叉, T1.昨量金叉, T1.盤中MA5, T1.盤中OBV, T1.盤中OBV_MA5, T1.盤中量MA5,
            -- 計算數值
            ROUND(((T1.盤中價 - T1.盤中MA5) / NULLIF(T1.盤中MA5, 0)) * 100, 2) AS 乖離率,
            ROUND((CAST(T1.盤中量 AS FLOAT) / NULLIF(T1.昨全天量, 0)), 2) AS 量倍率,
            -- 計算增減分
            (CASE WHEN T1.昨價金叉 = 0 AND T1.盤中價 > T1.盤中MA5 THEN 1 WHEN T1.昨價金叉 = 1 AND T1.盤中價 < T1.盤中MA5 THEN -1 ELSE 0 END) AS 價增分,
            (CASE WHEN T1.昨OBV金叉 = 0 AND T1.盤中OBV > T1.盤中OBV_MA5 THEN 1 WHEN T1.昨OBV金叉 = 1 AND T1.盤中OBV < T1.盤中OBV_MA5 THEN -1 ELSE 0 END) AS OBV增分,
            (CASE WHEN T1.昨量金叉 = 0 AND T1.盤中量 > T1.盤中量MA5 THEN 1 WHEN T1.昨量金叉 = 1 AND T1.盤中量 < T1.盤中量MA5 THEN -1 ELSE 0 END) AS 量增分,
            -- 預估共振總數
            (T1.昨共振 + 
                (CASE WHEN T1.昨價金叉 = 0 AND T1.盤中價 > T1.盤中MA5 THEN 1 WHEN T1.昨價金叉 = 1 AND T1.盤中價 < T1.盤中MA5 THEN -1 ELSE 0 END) + 
                (CASE WHEN T1.昨OBV金叉 = 0 AND T1.盤中OBV > T1.盤中OBV_MA5 THEN 1 WHEN T1.昨OBV金叉 = 1 AND T1.盤中OBV < T1.盤中OBV_MA5 THEN -1 ELSE 0 END) + 
                (CASE WHEN T1.昨量金叉 = 0 AND T1.盤中量 > T1.盤中量MA5 THEN 1 WHEN T1.昨量金叉 = 1 AND T1.盤中量 < T1.盤中量MA5 THEN -1 ELSE 0 END)
            ) AS 預估收盤共振,
            -- 盤中增減項
            ((CASE WHEN T1.昨價金叉 = 0 AND T1.盤中價 > T1.盤中MA5 THEN 1 WHEN T1.昨價金叉 = 1 AND T1.盤中價 < T1.盤中MA5 THEN -1 ELSE 0 END) + 
             (CASE WHEN T1.昨OBV金叉 = 0 AND T1.盤中OBV > T1.盤中OBV_MA5 THEN 1 WHEN T1.昨OBV金叉 = 1 AND T1.盤中OBV < T1.盤中OBV_MA5 THEN -1 ELSE 0 END) + 
             (CASE WHEN T1.昨量金叉 = 0 AND T1.盤中量 > T1.盤中量MA5 THEN 1 WHEN T1.昨量金叉 = 1 AND T1.盤中量 < T1.盤中量MA5 THEN -1 ELSE 0 END)
            ) AS 盤中增減項,
            -- 項目
            CASE WHEN (CASE WHEN T1.昨價金叉 = 0 AND T1.盤中價 > T1.盤中MA5 THEN 1 ELSE 0 END) = 1 THEN N'[價突破] ' ELSE '' END +
            CASE WHEN (CASE WHEN T1.昨OBV金叉 = 0 AND T1.盤中OBV > T1.盤中OBV_MA5 THEN 1 ELSE 0 END) = 1 THEN N'[量能噴發] ' ELSE '' END +
            CASE WHEN (CASE WHEN T1.昨量金叉 = 0 AND T1.盤中量 > T1.盤中量MA5 THEN 1 ELSE 0 END) = 1 THEN N'[異常放量] ' ELSE '' END AS 盤中突破項目
        FROM (
            SELECT 
                I.名稱, I.代號, I.成交價 AS 盤中價, I.漲幅 AS 盤中漲幅, I.總量 AS 盤中量, I.漲跌,
                Y.盤中現價 AS 昨收, Y.obv淨額 AS 昨OBV, Y.專家實戰總分 AS 昨總分, Y.盤中總量 AS 昨全天量,
                N.name1 AS 具體概念,
                (SELECT TOP 1 STRING_AGG(CAST(RTRIM(V2.name1) + '(' + RTRIM(V2.mail1) + ')' AS NVARCHAR(MAX)), ' | ') 
                 FROM stockchangedate.dbo.View_notioninfoskill V2 WHERE V2.memo LIKE '%' + REPLACE(RTRIM(I.名稱), '*', '') + '%') AS 產業價值鏈資訊,
                (CASE WHEN Y.均價黃金交叉次數 > 0 THEN 1 ELSE 0 END + CASE WHEN Y.obv累積金叉次數 > 0 THEN 1 ELSE 0 END + CASE WHEN Y.均量黃金交叉次數 > 0 THEN 1 ELSE 0 END + CASE WHEN Y.三大法人黃金交叉次數 > 0 THEN 1 ELSE 0 END + CASE WHEN Y.外資黃金交叉次數 > 0 THEN 1 ELSE 0 END + CASE WHEN Y.投信黃金交叉次數 > 0 THEN 1 ELSE 0 END) AS 昨共振,
                CASE WHEN Y.均價黃金交叉次數 > 0 THEN 1 ELSE 0 END AS 昨價金叉,
                CASE WHEN Y.obv累積金叉次數 > 0 THEN 1 ELSE 0 END AS 昨OBV金叉,
                CASE WHEN Y.均量黃金交叉次數 > 0 THEN 1 ELSE 0 END AS 昨量金叉,
                (SELECT AVG(盤中現價) FROM (SELECT TOP 5 盤中現價 FROM stockchangedate.dbo.MasterStockAnalysis M2 WHERE M2.代號 = I.代號 AND M2.日期 <= Y.日期 ORDER BY M2.日期 DESC) a) AS 昨MA5,
                ((SELECT AVG(盤中現價) FROM (SELECT TOP 4 盤中現價 FROM stockchangedate.dbo.MasterStockAnalysis M2 WHERE M2.代號 = I.代號 AND M2.日期 <= Y.日期 ORDER BY M2.日期 DESC) b) * 4 + I.成交價) / 5 AS 盤中MA5,
                (SELECT AVG(obv淨額) FROM (SELECT TOP 5 obv淨額 FROM stockchangedate.dbo.MasterStockAnalysis M3 WHERE M3.代號 = I.代號 AND M3.日期 <= Y.日期 ORDER BY M3.日期 DESC) c) AS 昨OBV_MA5,
                CASE WHEN I.漲跌 > 0 THEN Y.obv淨額 + I.總量 WHEN I.漲跌 < 0 THEN Y.obv淨額 - I.總量 ELSE Y.obv淨額 END AS 盤中OBV,
                ((SELECT AVG(obv淨額) FROM (SELECT TOP 4 obv淨額 FROM stockchangedate.dbo.MasterStockAnalysis M3 WHERE M3.代號 = I.代號 AND M3.日期 <= Y.日期 ORDER BY M3.日期 DESC) d) * 4 + (CASE WHEN I.漲跌 > 0 THEN Y.obv淨額 + I.總量 WHEN I.漲跌 < 0 THEN Y.obv淨額 - I.總量 ELSE Y.obv淨額 END)) / 5 AS 盤中OBV_MA5,
                ((SELECT AVG(盤中總量) FROM (SELECT TOP 4 盤中總量 FROM stockchangedate.dbo.MasterStockAnalysis M4 WHERE M4.代號 = I.代號 AND M4.日期 <= Y.日期 ORDER BY M4.日期 DESC) e) * 4 + I.總量) / 5 AS 盤中量MA5
            FROM dbo.basicinfo I
            INNER JOIN stockchangedate.dbo.MasterStockAnalysis Y ON I.代號 = Y.代號
            LEFT JOIN stockchangedate.dbo.notioninfo N ON REPLACE(RTRIM(I.名稱), '*', '') = REPLACE(RTRIM(N.mail1), '*', '')
            WHERE Y.日期 = (SELECT MAX(日期) FROM stockchangedate.dbo.MasterStockAnalysis)
        ) T1
    ) T2
) Final
WHERE Final.預估收盤共振 >= 5 
  AND Final.價格狀態 = N'站上'
  AND Final.OBV狀態 IN (N'🚀 金叉', N'強勢')
  AND Final.昨總分 > 35

ORDER BY 
    (CASE WHEN Final.價格狀態 = N'🚨 跌破' OR Final.OBV狀態 = N'💀 死叉' THEN 1 ELSE 2 END), 
    Final.預估收盤共振 DESC, 
    Final.量倍率 DESC;

--	3. 穩健多頭股 (適合回檔後續強)
--這組條件找的是：趨勢已經形成，目前穩穩站在五日線上，且 OBV 持續強勢。`
              },

              {
                  cat: "盤中操盤", title: "一次看到所有好股票（不分強度），可以使用這個綜合條件", sql: `/*資料庫:stockchange*/ * FROM (
    SELECT 
        T2.名稱, T2.代號, T2.盤中價, T2.盤中漲幅, T2.具體概念, 
        T2.昨共振, T2.預估收盤共振, T2.盤中增減項,
        T2.乖離率, T2.量倍率, T2.昨總分,
        -- 價格五日線狀態
        CASE 
            WHEN T2.昨收 < T2.昨MA5 AND T2.盤中價 > T2.盤中MA5 THEN N'✅ 突破'
            WHEN T2.昨收 > T2.昨MA5 AND T2.盤中價 < T2.盤中MA5 THEN N'🚨 跌破'
            WHEN T2.盤中價 > T2.盤中MA5 THEN N'站上'
            ELSE N'線下'
        END AS 價格狀態,
        -- OBV 能量狀態
        CASE 
            WHEN T2.昨OBV < T2.昨OBV_MA5 AND T2.盤中OBV > T2.盤中OBV_MA5 THEN N'🚀 金叉'
            WHEN T2.昨OBV > T2.昨OBV_MA5 AND T2.盤中OBV < T2.盤中OBV_MA5 THEN N'💀 死叉'
            WHEN T2.盤中OBV > T2.盤中OBV_MA5 THEN N'強勢'
            ELSE N'弱勢'
        END AS OBV狀態,
        -- 專家點評
        CASE 
            WHEN T2.預估收盤共振 >= 5 AND T2.昨總分 > 35 AND T2.盤中價 > T2.盤中MA5 THEN N'⭐ 極致強勢股'
            WHEN T2.預估收盤共振 >= 5 AND T2.量倍率 > 1.2 THEN N'🔥 價量齊揚'
            WHEN T2.昨收 > T2.昨MA5 AND T2.盤中價 < T2.盤中MA5 THEN N'🚨 轉弱減碼'
            ELSE N'--'
        END AS 專家點評,
        T2.盤中突破項目,
        T2.產業價值鏈資訊
    FROM (
        SELECT 
            T1.名稱, T1.代號, T1.盤中價, T1.盤中漲幅, T1.盤中量, T1.昨收, T1.昨MA5, T1.昨OBV, T1.昨OBV_MA5, T1.昨總分, T1.昨全天量,
            T1.具體概念, T1.產業價值鏈資訊, T1.昨共振, T1.昨價金叉, T1.昨OBV金叉, T1.昨量金叉, T1.盤中MA5, T1.盤中OBV, T1.盤中OBV_MA5, T1.盤中量MA5,
            -- 計算數值
            ROUND(((T1.盤中價 - T1.盤中MA5) / NULLIF(T1.盤中MA5, 0)) * 100, 2) AS 乖離率,
            ROUND((CAST(T1.盤中量 AS FLOAT) / NULLIF(T1.昨全天量, 0)), 2) AS 量倍率,
            -- 計算增減分
            (CASE WHEN T1.昨價金叉 = 0 AND T1.盤中價 > T1.盤中MA5 THEN 1 WHEN T1.昨價金叉 = 1 AND T1.盤中價 < T1.盤中MA5 THEN -1 ELSE 0 END) AS 價增分,
            (CASE WHEN T1.昨OBV金叉 = 0 AND T1.盤中OBV > T1.盤中OBV_MA5 THEN 1 WHEN T1.昨OBV金叉 = 1 AND T1.盤中OBV < T1.盤中OBV_MA5 THEN -1 ELSE 0 END) AS OBV增分,
            (CASE WHEN T1.昨量金叉 = 0 AND T1.盤中量 > T1.盤中量MA5 THEN 1 WHEN T1.昨量金叉 = 1 AND T1.盤中量 < T1.盤中量MA5 THEN -1 ELSE 0 END) AS 量增分,
            -- 預估共振總數
            (T1.昨共振 + 
                (CASE WHEN T1.昨價金叉 = 0 AND T1.盤中價 > T1.盤中MA5 THEN 1 WHEN T1.昨價金叉 = 1 AND T1.盤中價 < T1.盤中MA5 THEN -1 ELSE 0 END) + 
                (CASE WHEN T1.昨OBV金叉 = 0 AND T1.盤中OBV > T1.盤中OBV_MA5 THEN 1 WHEN T1.昨OBV金叉 = 1 AND T1.盤中OBV < T1.盤中OBV_MA5 THEN -1 ELSE 0 END) + 
                (CASE WHEN T1.昨量金叉 = 0 AND T1.盤中量 > T1.盤中量MA5 THEN 1 WHEN T1.昨量金叉 = 1 AND T1.盤中量 < T1.盤中量MA5 THEN -1 ELSE 0 END)
            ) AS 預估收盤共振,
            -- 盤中增減項
            ((CASE WHEN T1.昨價金叉 = 0 AND T1.盤中價 > T1.盤中MA5 THEN 1 WHEN T1.昨價金叉 = 1 AND T1.盤中價 < T1.盤中MA5 THEN -1 ELSE 0 END) + 
             (CASE WHEN T1.昨OBV金叉 = 0 AND T1.盤中OBV > T1.盤中OBV_MA5 THEN 1 WHEN T1.昨OBV金叉 = 1 AND T1.盤中OBV < T1.盤中OBV_MA5 THEN -1 ELSE 0 END) + 
             (CASE WHEN T1.昨量金叉 = 0 AND T1.盤中量 > T1.盤中量MA5 THEN 1 WHEN T1.昨量金叉 = 1 AND T1.盤中量 < T1.盤中量MA5 THEN -1 ELSE 0 END)
            ) AS 盤中增減項,
            -- 項目
            CASE WHEN (CASE WHEN T1.昨價金叉 = 0 AND T1.盤中價 > T1.盤中MA5 THEN 1 ELSE 0 END) = 1 THEN N'[價突破] ' ELSE '' END +
            CASE WHEN (CASE WHEN T1.昨OBV金叉 = 0 AND T1.盤中OBV > T1.盤中OBV_MA5 THEN 1 ELSE 0 END) = 1 THEN N'[量能噴發] ' ELSE '' END +
            CASE WHEN (CASE WHEN T1.昨量金叉 = 0 AND T1.盤中量 > T1.盤中量MA5 THEN 1 ELSE 0 END) = 1 THEN N'[異常放量] ' ELSE '' END AS 盤中突破項目
        FROM (
            SELECT 
                I.名稱, I.代號, I.成交價 AS 盤中價, I.漲幅 AS 盤中漲幅, I.總量 AS 盤中量, I.漲跌,
                Y.盤中現價 AS 昨收, Y.obv淨額 AS 昨OBV, Y.專家實戰總分 AS 昨總分, Y.盤中總量 AS 昨全天量,
                N.name1 AS 具體概念,
                (SELECT TOP 1 STRING_AGG(CAST(RTRIM(V2.name1) + '(' + RTRIM(V2.mail1) + ')' AS NVARCHAR(MAX)), ' | ') 
                 FROM stockchangedate.dbo.View_notioninfoskill V2 WHERE V2.memo LIKE '%' + REPLACE(RTRIM(I.名稱), '*', '') + '%') AS 產業價值鏈資訊,
                (CASE WHEN Y.均價黃金交叉次數 > 0 THEN 1 ELSE 0 END + CASE WHEN Y.obv累積金叉次數 > 0 THEN 1 ELSE 0 END + CASE WHEN Y.均量黃金交叉次數 > 0 THEN 1 ELSE 0 END + CASE WHEN Y.三大法人黃金交叉次數 > 0 THEN 1 ELSE 0 END + CASE WHEN Y.外資黃金交叉次數 > 0 THEN 1 ELSE 0 END + CASE WHEN Y.投信黃金交叉次數 > 0 THEN 1 ELSE 0 END) AS 昨共振,
                CASE WHEN Y.均價黃金交叉次數 > 0 THEN 1 ELSE 0 END AS 昨價金叉,
                CASE WHEN Y.obv累積金叉次數 > 0 THEN 1 ELSE 0 END AS 昨OBV金叉,
                CASE WHEN Y.均量黃金交叉次數 > 0 THEN 1 ELSE 0 END AS 昨量金叉,
                (SELECT AVG(盤中現價) FROM (SELECT TOP 5 盤中現價 FROM stockchangedate.dbo.MasterStockAnalysis M2 WHERE M2.代號 = I.代號 AND M2.日期 <= Y.日期 ORDER BY M2.日期 DESC) a) AS 昨MA5,
                ((SELECT AVG(盤中現價) FROM (SELECT TOP 4 盤中現價 FROM stockchangedate.dbo.MasterStockAnalysis M2 WHERE M2.代號 = I.代號 AND M2.日期 <= Y.日期 ORDER BY M2.日期 DESC) b) * 4 + I.成交價) / 5 AS 盤中MA5,
                (SELECT AVG(obv淨額) FROM (SELECT TOP 5 obv淨額 FROM stockchangedate.dbo.MasterStockAnalysis M3 WHERE M3.代號 = I.代號 AND M3.日期 <= Y.日期 ORDER BY M3.日期 DESC) c) AS 昨OBV_MA5,
                CASE WHEN I.漲跌 > 0 THEN Y.obv淨額 + I.總量 WHEN I.漲跌 < 0 THEN Y.obv淨額 - I.總量 ELSE Y.obv淨額 END AS 盤中OBV,
                ((SELECT AVG(obv淨額) FROM (SELECT TOP 4 obv淨額 FROM stockchangedate.dbo.MasterStockAnalysis M3 WHERE M3.代號 = I.代號 AND M3.日期 <= Y.日期 ORDER BY M3.日期 DESC) d) * 4 + (CASE WHEN I.漲跌 > 0 THEN Y.obv淨額 + I.總量 WHEN I.漲跌 < 0 THEN Y.obv淨額 - I.總量 ELSE Y.obv淨額 END)) / 5 AS 盤中OBV_MA5,
                ((SELECT AVG(盤中總量) FROM (SELECT TOP 4 盤中總量 FROM stockchangedate.dbo.MasterStockAnalysis M4 WHERE M4.代號 = I.代號 AND M4.日期 <= Y.日期 ORDER BY M4.日期 DESC) e) * 4 + I.總量) / 5 AS 盤中量MA5
            FROM dbo.basicinfo I
            INNER JOIN stockchangedate.dbo.MasterStockAnalysis Y ON I.代號 = Y.代號
            LEFT JOIN stockchangedate.dbo.notioninfo N ON REPLACE(RTRIM(I.名稱), '*', '') = REPLACE(RTRIM(N.mail1), '*', '')
            WHERE Y.日期 = (SELECT MAX(日期) FROM stockchangedate.dbo.MasterStockAnalysis)
        ) T1
    ) T2
) Final

WHERE Final.預估收盤共振 >= 5                -- 條件一：高維度共振（基本門檻）
  AND Final.價格狀態 <> N'🚨 跌破'           -- 條件二：排除正在轉弱的
  AND Final.乖離率 < 7.0                    -- 條件三：防止追在當天最高點（乖離保護）
  AND (Final.量倍率 > 0.6 OR Final.昨總分 > 40) -- 條件四：要有量，或是原本就是選股名單的高分股
ORDER BY 
    (CASE WHEN Final.價格狀態 = N'🚨 跌破' OR Final.OBV狀態 = N'💀 死叉' THEN 1 ELSE 2 END), 
    Final.預估收盤共振 DESC, 
    Final.量倍率 DESC;

--	💡 專家小提醒：
--如果您想在 Excel 裡一次看到所有好股票（不分強度），可以使用這個綜合條件：`
              },

              {
                  cat: "盤中操盤", title: "⚡ 盤中預警：權值三雄即時氣象站 (避崩專用)", sql: `/*資料庫:stockchange*/I.名稱 + '(' + I.代號 + ')' AS 股票,
I.成交價 AS 盤中價,
I.漲幅 AS 盤中漲幅,
(CASE 
    WHEN I.成交價 < A.price_ma5 AND I.漲幅 < -2.0 THEN N'⛈️ 災難爆發 (破五日線)'
    WHEN I.成交價 < A.price_ma5 THEN N'🌧️ 轉雨 (均線之下)'
    WHEN I.漲幅 > 2.0 AND I.成交價 > A.price_ma5 THEN N'☀️ 總攻中'
    ELSE N'☁️ 盤整觀望' 
END) AS 即時氣象,
-- 成交值校準：假設 I.總量 為股數，除以 1 億換算為「億」；若為張數請改除以 10 萬
CAST(CAST((I.成交價 * I.總量 / 100000.0) AS DECIMAL(18,1)) AS VARCHAR) + '億' AS 估計成交,
(CASE 
    WHEN I.成交價 < A.price_ma5 AND I.代號 = '2330' THEN N'⚠️ 權王破線，大盤危險！'
    WHEN I.漲幅 < -3.0 THEN N'🚨 主力大單出脫'
    ELSE '--' 
END) AS 專家急電
FROM dbo.basicinfo I
INNER JOIN stockchangedate.dbo.MasterStockAnalysis M ON RTRIM(I.代號) = RTRIM(M.代號)
INNER JOIN stockchangedate.dbo.allcross A ON RTRIM(I.代號) = RTRIM(A.代號) AND A.日期 = M.日期
WHERE I.自動編號 IN (SELECT MAX(自動編號) FROM dbo.basicinfo WHERE 代號 IN ('2330', '2454', '2317') GROUP BY 代號)
  AND M.日期 = (SELECT MAX(日期) FROM stockchangedate.dbo.MasterStockAnalysis)

--  設定排程/習慣：在 09:15、10:30、13:00 各跑一次這個指令。
--觀察「台積電」的連動：
--台積電☀️ + 另外二雄⛈️ = 拉積盤（只有權王動，個股要小心）。
--台積電⛈️ + 另外二雄⛈️ = 全面撤退（如 6/24 盤中的慘狀）。
--預防 6/24 的悲劇重演：
--回顧 6/24，台積電盤中就一路走低。這套 SQL 會在盤中不斷提醒您 「台積電破線，大盤危險！」。
--「黃金橫盤」☀️ ☀️ ☀️：
--如果一整橫排都是太陽，代表權值股全速前進，那是大盤最穩的噴發段。
--「結構裂解」⛈️ ⛅ ☀️：
--這最精彩！如果您看到台積電是 ⛈️ 暴雨，但聯發科跟鴻海是 ☀️ 晴天。
--專家觀點：這就是「拉小護大」或「資金轉向」。外資在砍權王，但內資大戶死守另外兩雄。這時候大盤指數會跌，但個股依然有戲。
--「全體淪陷」⛈️ ⛈️ ⛈️：`
              },


              {
                  cat: "盤中操盤", title: "「🛰️ 全市場導航儀：上市櫃強度 + 三雄 21 日戰情彙總」", sql: `/*資料庫:stockchangedate*/M.日期,
-- 【全市場背景：上市 TSE】 
MAX(CASE WHEN T.股票代號 = 'TSE' THEN 
    (CASE WHEN T.均價黃金交叉次數 >= 6 THEN N'☀️' WHEN T.均價黃金交叉次數 BETWEEN 3 AND 5 THEN N'⛅' ELSE N'⛈️' END) 
    + CAST(T.均價黃金交叉次數 AS VARCHAR) + '(' + CAST(T.一日交叉成功 AS VARCHAR) + ')' END) AS [上市TSE_強度(1日)],

-- 【全市場背景：上櫃 OTC】
MAX(CASE WHEN O.股票代號 = 'OTC' THEN 
    (CASE WHEN O.均價黃金交叉次數 >= 6 THEN N'☀️' WHEN O.均價黃金交叉次數 BETWEEN 3 AND 5 THEN N'⛅' ELSE N'⛈️' END) 
    + CAST(O.均價黃金交叉次數 AS VARCHAR) + '(' + CAST(O.一日交叉成功 AS VARCHAR) + ')' END) AS [上櫃OTC_強度(1日)],

-- 【台積電 2330】
MAX(CASE WHEN M.代號 = '2330' THEN (CASE WHEN M.專家實戰總分 > 30 THEN N'☀️' WHEN M.專家實戰總分 BETWEEN 10 AND 30 THEN N'⛅' WHEN M.專家實戰總分 BETWEEN 0 AND 10 THEN N'☁️' ELSE N'⛈️' END) + CAST(CAST(M.專家實戰總分 AS DECIMAL(10,1)) AS VARCHAR) END) AS [2330_氣象分],
MAX(CASE WHEN M.代號 = '2330' THEN CAST(CAST(P.mail1/100.0 AS DECIMAL(10,1)) AS VARCHAR) + '億' END) AS [2330_成交值],

-- 【聯發科 2454】
MAX(CASE WHEN M.代號 = '2454' THEN (CASE WHEN M.專家實戰總分 > 30 THEN N'☀️' WHEN M.專家實戰總分 BETWEEN 10 AND 30 THEN N'⛅' WHEN M.專家實戰總分 BETWEEN 0 AND 10 THEN N'☁️' ELSE N'⛈️' END) + CAST(CAST(M.專家實戰總分 AS DECIMAL(10,1)) AS VARCHAR) END) AS [2454_氣象分],
MAX(CASE WHEN M.代號 = '2454' THEN CAST(CAST(P.mail1/100.0 AS DECIMAL(10,1)) AS VARCHAR) + '億' END) AS [2454_成交值],

-- 【鴻海 2317】
MAX(CASE WHEN M.代號 = '2317' THEN (CASE WHEN M.專家實戰總分 > 30 THEN N'☀️' WHEN M.專家實戰總分 BETWEEN 10 AND 30 THEN N'⛅' WHEN M.專家實戰總分 BETWEEN 0 AND 10 THEN N'☁️' ELSE N'⛈️' END) + CAST(CAST(M.專家實戰總分 AS DECIMAL(10,1)) AS VARCHAR) END) AS [2317_氣象分],
MAX(CASE WHEN M.代號 = '2317' THEN CAST(CAST(P.mail1/100.0 AS DECIMAL(10,1)) AS VARCHAR) + '億' END) AS [2317_成交值]

FROM [stockchangedate].[dbo].[MasterStockAnalysis] M
-- 關鍵修正：將 DATE 型態轉換為 INT 進行 JOIN
LEFT JOIN [stockchangedate].[dbo].[View_集中市場1] T ON M.日期 = CAST(FORMAT(T.日期, 'yyyyMMdd') AS INT)
LEFT JOIN [stockchangedate].[dbo].[View_櫃買市場1] O ON M.日期 = CAST(FORMAT(O.日期, 'yyyyMMdd') AS INT)
LEFT JOIN [poem1_stock7].[dbo].[poem] P ON M.代號 = RIGHT(RTRIM(P.name1), 4) AND M.日期 = P.時間戳記
WHERE M.代號 IN ('2330', '2454', '2317')
  AND M.日期 IN (SELECT TOP 21 日期 FROM (SELECT DISTINCT 日期 FROM [stockchangedate].[dbo].[MasterStockAnalysis]) AS D ORDER BY 日期 DESC)
GROUP BY M.日期
ORDER BY M.日期 DESC

/*真多頭：金黃色矩陣】
狀態：上市 ☀️、上櫃 ☀️、三雄 ☀️☀️☀️。
解讀：權值股與中小型股齊飛，隨便買都會賺，這是最安全的「加碼區」。
【吸金怪物：權值獨秀】
狀態：上市 ☀️、上櫃 ⛈️ 或 ⛅、台積電 ☀️。
解讀：這就是可怕的「拉積盤」。大盤看起來很強（次數高），但櫃買在跌，三雄以外的股票在失血。此時「絕對不能追中小型股」，錢都被權值股吸走了。
【末跌段：三雄撐盤、大盤轉雨】
狀態：三雄 ☀️、但 上市轉 ⛅、上櫃轉 ⛈️。
解讀：這是出貨訊號。主力拉住三雄穩住指數，但背地裡已經在撤離中小型股。這就是您提到的「盤中預估是否出狀況」的最佳領先指標。
【強度表示法】：
例如 ☀️6(1)：代表均價金叉 6 次，且 1 日（極短線）也金叉，強中之強。
例如 ⛅4(-1)：代表長線還在，但 1 日已經轉負（-1），這是大盤準備回檔的鐵證
(1)：多頭共識達成
代表「今天的收盤價」成功站上（或維持在）其最敏感的短線均線之上。這意味著市場當下的情緒是偏多的，買盤願意在極短線內追價。
(-1)：多頭警報響起
代表「今天的收盤價」跌破了其最敏感的短線均線。這意味著市場當下的情緒已經轉弱，或者大戶開始在極短線內撤退。*/`
              },



              {
                  cat: "盤中操盤", title: "「🚩 全產業龍頭導航儀：地位、分數與即時風向」", sql: `/*資料庫:stockchange*/G.name1 AS [產業地位],
G.mail1 AS [股票],
I.成交價 AS [盤中價],
I.漲幅 AS [漲幅%],
-- 偵測即時風向 (1) 或 (-1)
(CASE WHEN I.成交價 > A.price_ma5 THEN '(1)☀️' ELSE '(-1)⛈️' END) AS [風向],
M.專家實戰總分 AS [專家分],
M.實戰標籤,
M.具體概念
FROM (
    -- 第一層子查詢：從 guestinfowd5 提取代號並鎖定最新地位清單
    SELECT 
        name1, mail1,
        SUBSTRING(word1, CHARINDEX('(', word1) + 1, LEN(word1) - CHARINDEX('(', word1) - 1) as 提取代號
    FROM fromaccessdatabase.dbo.guestinfowd5
    WHERE 時間戳記 = (SELECT MAX(時間戳記) FROM fromaccessdatabase.dbo.guestinfowd5)
) G
-- 第二層：關聯盤中即時表 (basicinfo) 並只取最後一跳
INNER JOIN stockchange.dbo.basicinfo I ON RTRIM(G.提取代號) = RTRIM(I.代號)
-- 第三層：關聯歷史大寬表與五日線
INNER JOIN stockchangedate.dbo.MasterStockAnalysis M ON RTRIM(G.提取代號) = RTRIM(M.代號)
INNER JOIN stockchangedate.dbo.allcross A ON RTRIM(G.提取代號) = RTRIM(A.代號) AND A.日期 = M.日期
WHERE M.日期 = (SELECT MAX(日期) FROM stockchangedate.dbo.MasterStockAnalysis)
  AND I.自動編號 IN (SELECT MAX(自動編號) FROM stockchange.dbo.basicinfo GROUP BY 代號)
ORDER BY G.name1 ASC

/*🔍 觀察「龍頭帶頭效應」
場景：如果您看到 「半導體產業龍頭 (台積電)」 是 (1)☀️ 且漲幅大，但 「二哥 (聯發科)」 和 「三哥 (日月光投控)」 是 (-1)⛈️。
診斷：這叫 「孤掌難鳴」。只有龍頭在撐盤，資金沒有擴散到二、三哥，這天的半導體行情偏假，不可輕易追入二線股。
2. 🚀 捕捉「小弟超車」 (二哥轉強)
場景：龍頭漲幅 1%，但 「被動元件產業二哥 (華新科)」 漲幅 5% 且專家分飆高。
診斷：二哥的攻擊力道超越龍頭，這通常是族群進入 「噴發段」 的訊號。因為大資金買完龍頭後，開始溢流到二哥身上，這時候二哥的期望值（獲利空間）通常比龍頭更高。
3. 🛡️ 避開「全面崩壞」
場景：某一產業（如：石化塑橡膠）的龍頭、二哥、三哥 同步顯示為 (-1)⛈️。
診斷：該產業目前處於 「系統性空頭」。不論該族群有什麼利多，只要三位大哥都跌破五日線，絕對不能進場攤平。
4. 🧬 概念標籤的交叉驗證
觀察 具體概念。如果 「人工智慧產業龍頭 (世芯-KY)」 的標籤包含 CPO，而 「光通訊族群」 今天也集體表態，那世芯的帶動效果會倍增。*/`
              },


              {
                  cat: "盤中操盤", title: "🏆 三雄戰情儀表板：21日對照 (含名稱、億兆單位、外資共振)", sql: `M.日期,
-- 【台積電 2330】
MAX(CASE WHEN M.代號 = '2330' THEN (CASE WHEN M.專家實戰總分 > 30 THEN N'☀️' WHEN M.專家實戰總分 BETWEEN 10 AND 30 THEN N'⛅' WHEN M.專家實戰總分 BETWEEN 0 AND 10 THEN N'☁️' ELSE N'⛈️' END) + CAST(CAST(M.專家實戰總分 AS DECIMAL(10,1)) AS VARCHAR) END) AS [台積電2330_氣象分],
MAX(CASE WHEN M.代號 = '2330' THEN CAST(M.盤中漲幅 AS VARCHAR) + '%' END) AS [台積電2330_漲幅],
MAX(CASE WHEN M.代號 = '2330' THEN (CASE WHEN P.mail1 >= 1000000 THEN CAST(CAST(P.mail1/1000000.0 AS DECIMAL(10,2)) AS VARCHAR) + '兆' ELSE CAST(CAST(P.mail1/100.0 AS DECIMAL(10,1)) AS VARCHAR) + '億' END) END) AS [台積電2330_成交值],
MAX(CASE WHEN M.代號 = '2330' THEN CAST(A.外資黃金交叉次數 AS VARCHAR) + ' / ' + CAST((ISNULL(A.obv黃金交叉次數,0) + ISNULL(A.成交價黃金交叉次數,0) + ISNULL(A.外資黃金交叉次數,0) + ISNULL(A.投信黃金交叉次數,0)) AS VARCHAR) END) AS [台積電2330_外資/總共振],

-- 【聯發科 2454】
MAX(CASE WHEN M.代號 = '2454' THEN (CASE WHEN M.專家實戰總分 > 30 THEN N'☀️' WHEN M.專家實戰總分 BETWEEN 10 AND 30 THEN N'⛅' WHEN M.專家實戰總分 BETWEEN 0 AND 10 THEN N'☁️' ELSE N'⛈️' END) + CAST(CAST(M.專家實戰總分 AS DECIMAL(10,1)) AS VARCHAR) END) AS [聯發科2454_氣象分],
MAX(CASE WHEN M.代號 = '2454' THEN CAST(M.盤中漲幅 AS VARCHAR) + '%' END) AS [聯發科2454_漲幅],
MAX(CASE WHEN M.代號 = '2454' THEN (CASE WHEN P.mail1 >= 1000000 THEN CAST(CAST(P.mail1/1000000.0 AS DECIMAL(10,2)) AS VARCHAR) + '兆' ELSE CAST(CAST(P.mail1/100.0 AS DECIMAL(10,1)) AS VARCHAR) + '億' END) END) AS [聯發科2454_成交值],
MAX(CASE WHEN M.代號 = '2454' THEN CAST(A.外資黃金交叉次數 AS VARCHAR) + ' / ' + CAST((ISNULL(A.obv黃金交叉次數,0) + ISNULL(A.成交價黃金交叉次數,0) + ISNULL(A.外資黃金交叉次數,0) + ISNULL(A.投信黃金交叉次數,0)) AS VARCHAR) END) AS [聯發科2454_外資/總共振],

-- 【鴻海 2317】
MAX(CASE WHEN M.代號 = '2317' THEN (CASE WHEN M.專家實戰總分 > 30 THEN N'☀️' WHEN M.專家實戰總分 BETWEEN 10 AND 30 THEN N'⛅' WHEN M.專家實戰總分 BETWEEN 0 AND 10 THEN N'☁️' ELSE N'⛈️' END) + CAST(CAST(M.專家實戰總分 AS DECIMAL(10,1)) AS VARCHAR) END) AS [鴻海2317_氣象分],
MAX(CASE WHEN M.代號 = '2317' THEN CAST(M.盤中漲幅 AS VARCHAR) + '%' END) AS [鴻海2317_漲幅],
MAX(CASE WHEN M.代號 = '2317' THEN (CASE WHEN P.mail1 >= 1000000 THEN CAST(CAST(P.mail1/1000000.0 AS DECIMAL(10,2)) AS VARCHAR) + '兆' ELSE CAST(CAST(P.mail1/100.0 AS DECIMAL(10,1)) AS VARCHAR) + '億' END) END) AS [鴻海2317_成交值],
MAX(CASE WHEN M.代號 = '2317' THEN CAST(A.外資黃金交叉次數 AS VARCHAR) + ' / ' + CAST((ISNULL(A.obv黃金交叉次數,0) + ISNULL(A.成交價黃金交叉次數,0) + ISNULL(A.外資黃金交叉次數,0) + ISNULL(A.投信黃金交叉次數,0)) AS VARCHAR) END) AS [鴻海2317_外資/總共振]

FROM [stockchangedate].[dbo].[MasterStockAnalysis] M
LEFT JOIN [poem1_stock7].[dbo].[poem] P ON M.代號 = RIGHT(RTRIM(P.name1), 4) AND M.日期 = P.時間戳記
LEFT JOIN [stockchangedate].[dbo].[allcross] A ON M.代號 = A.代號 AND M.日期 = A.日期
WHERE M.代號 IN ('2330', '2454', '2317')
  AND M.日期 IN (SELECT DISTINCT TOP 21 日期 FROM [stockchangedate].[dbo].[MasterStockAnalysis] ORDER BY 日期 DESC)
GROUP BY M.日期
ORDER BY M.日期 DESC

--氣象分 (☀️/⛈️)：
--最直觀的「體質判斷」。☀️ 代表 AI 覺得現在是主升段；⛈️ 代表 AI 建議快跑。-
--為了節省空間，我將金額除以 1000 並標註為 G (Billions/十億)。例如 162.5G 代表當天成交了 1625 億。這能讓您一眼看出誰是當天的「吸金王」。
--外資 / 總共振 (例如 3 / 8)：
--左邊數字：外資黃金交叉次數（看外資臉色）。
--右邊數字：四維總共振強度（OBV+價+外資+投信）。
--專家密技：如果「外資/總共振」出現 6 / 15 這種高比值，代表外資正在瘋狂回補。 `
              },







              {
                  cat: "盤中操盤", title: "盤中起漲黑馬獵人", sql: `/*資料庫:stockchangedate*/名稱, 代號, 盤中價, 盤中漲幅, 盤中OBV, 新OBV五日均線, 昨共振, 預估收盤共振, 昨總分, 盤中狀態
FROM              View_盤中起漲黑馬獵人
--預設條件不可更改,盤後更後不會有資料
--可以抓取共振2可能變成共振3或obv站上其五日均線
--前端採集：按鍵精靈 (QuickMacro)，每 5 分鐘執行一次。
--中台搬運：Python (Watchdog + pyodbc)，監控 C:\StockExport，自動清洗理*寶欄位 SQL。
--核心運算：View_盤中起漲黑馬獵人，實現「歷史 vs 盤中」跨庫比對，計算「新 OBV 五日均線」與「預估共振進化」。`
              },

              {
                  cat: "盤中操盤", title: "🎯 盤中主流族群偵測 (自動對齊版)", sql: `/*資料庫:stockchange*/M.產業分類, 
       COUNT(DISTINCT I.代號) as [起漲股數], 
       ROUND(AVG(CAST(I.漲幅 AS FLOAT)), 2) as [平均漲幅]
FROM dbo.basicinfo I
INNER JOIN stockchangedate.dbo.MasterStockAnalysis M ON RTRIM(I.代號) = RTRIM(M.代號)
WHERE M.日期 = (SELECT MAX(日期) FROM stockchangedate.dbo.MasterStockAnalysis)
  AND I.漲幅 BETWEEN 2.0 AND 10.5
  AND I.總量 > 500
GROUP BY M.產業分類
HAVING COUNT(DISTINCT I.代號) >= 2
ORDER BY [起漲股數] DESC`
              },

              {
                  cat: "盤中操盤", title: "🔗 族群聯動：尋找同產業補漲標的", sql: `/*資料庫:stockchange*/
 M.名稱, M.代號, M.專家實戰總分, I.漲幅 as 盤中漲幅, M.具體概念, M.產業分類
FROM stockchangedate.dbo.MasterStockAnalysis M
INNER JOIN dbo.basicinfo I ON M.代號 = I.代號
WHERE M.日期 = (SELECT MAX(日期) FROM stockchangedate.dbo.MasterStockAnalysis)
  AND I.漲幅 BETWEEN -1 AND 1.5 -- 還沒噴出 (漲幅微小)
  AND M.專家實戰總分 > 30       -- 但底子好 (專家分高)
  AND M.產業分類 IN (
      -- 找出盤中平均漲幅大於 4% 的熱門產業
      SELECT TOP 3 M2.產業分類
      FROM dbo.basicinfo I2
      INNER JOIN stockchangedate.dbo.MasterStockAnalysis M2 ON I2.代號 = M2.代號
      WHERE M2.日期 = (SELECT MAX(日期) FROM stockchangedate.dbo.MasterStockAnalysis)
      GROUP BY M2.產業分類
      HAVING COUNT(*) >= 2
      ORDER BY AVG(I2.漲幅) DESC
  )
ORDER BY M.專家實戰總分 DESC
/*-- 解讀：當領先股拉開空間，這些「高分低位」的同業極大機率會被資金帶動。*/`
              },

              {
                  cat: "盤中操盤", title: "⚠️ 避險警報：盤中跌破五日線", sql: `/*資料庫:stockchange*/I.名稱, I.代號, I.成交價 as 盤中價, I.漲幅, 
       A.price_ma5 as 五日線, M.專家實戰總分
FROM dbo.basicinfo I
INNER JOIN stockchangedate.dbo.MasterStockAnalysis M ON RTRIM(I.代號) = RTRIM(M.代號)
INNER JOIN stockchangedate.dbo.allcross A ON RTRIM(I.代號) = RTRIM(A.代號) AND M.日期 = A.日期
WHERE M.日期 = (SELECT MAX(日期) FROM stockchangedate.dbo.MasterStockAnalysis)
  AND I.成交價 < A.price_ma5
  AND I.漲幅 < 0
  AND M.專家實戰總分 > 30
ORDER BY I.漲幅 ASC`
              },

              {
                  cat: "盤中操盤", title: "🛑 獲利了結：高檔回落警示", sql: `/*資料庫:stockchange*/I.名稱, I.代號, I.成交價 as 盤中價, I.漲幅, 
       M.盤中現價 as 昨收價, M.專家實戰總分
FROM dbo.basicinfo I
INNER JOIN stockchangedate.dbo.MasterStockAnalysis M ON RTRIM(I.代號) = RTRIM(M.代號)
WHERE M.日期 = (SELECT MAX(日期) FROM stockchangedate.dbo.MasterStockAnalysis)
  AND I.漲幅 < 1.0  -- 漲幅收斂
  AND M.專家實戰總分 > 40 -- 原本是高分股
  AND I.成交價 < (M.盤中現價 * 1.01) -- 幾乎回到平盤
ORDER BY M.專家實戰總分 DESC`
              },

              {
                  cat: "盤中操盤", title: "⚡ 急拉獵人：盤中爆量攻擊偵測", sql: `/*資料庫:stockchange*/I.名稱, I.代號, I.漲幅, 
       I.總量 as 盤中量, M.盤中總量 as 昨全天量,
       ROUND(CAST(I.總量 AS FLOAT) / NULLIF(M.盤中總量, 0), 2) as [今日量能倍數],
       M.具體概念
FROM dbo.basicinfo I
INNER JOIN stockchangedate.dbo.MasterStockAnalysis M ON RTRIM(I.代號) = RTRIM(M.代號)
WHERE M.日期 = (SELECT MAX(日期) FROM stockchangedate.dbo.MasterStockAnalysis)
  AND I.總量 > M.盤中總量
  AND I.漲幅 > 2.0
ORDER BY [今日量能倍數] DESC`
              },

              {
                  cat: "盤中操盤", title: "🎯 盤中主流：族群強勢表態掃描", sql: `/*資料庫:stockchange*/
M.產業分類, COUNT(DISTINCT I.代號) as [起漲股數], ROUND(AVG(CAST(I.漲幅 AS FLOAT)), 2) as [平均漲幅]
FROM dbo.basicinfo I
INNER JOIN stockchangedate.dbo.MasterStockAnalysis M ON RTRIM(I.代號) = RTRIM(M.代號)
WHERE M.日期 = (SELECT MAX(日期) FROM stockchangedate.dbo.MasterStockAnalysis)
  AND I.漲幅 BETWEEN 3.0 AND 10.5 -- 漲幅要在 3% 以上才算表態
GROUP BY M.產業分類
HAVING COUNT(DISTINCT I.代號) >= 3 -- 該產業至少 3 檔起漲才叫主流
ORDER BY [起漲股數] DESC

/*--09:15 - 09:30：先跑「主流偵測」，看看今天是哪個族群（如：CPO、MOSFET）在帶隊。
--09:30 - 10:30：如果龍頭買不到，跑「聯動補漲」找族群內的二號、三號標的。
--11:00 以後：跑「破線賣點」，檢查手上的股票有沒有因為大盤轉弱而撐不住的，適時獲利了結。*/`
              },

              {
                  cat: "盤中操盤", title: "🔗 族群聯動：高分低位補漲獵人", sql: `/*資料庫:stockchange*/
I.名稱, I.代號, M.專家實戰總分, I.漲幅 as 今日漲幅, M.具體概念, M.產業分類
FROM stockchangedate.dbo.MasterStockAnalysis M
INNER JOIN dbo.basicinfo I ON RTRIM(M.代號) = RTRIM(I.代號)
WHERE M.日期 = (SELECT MAX(日期) FROM stockchangedate.dbo.MasterStockAnalysis)
  AND I.漲幅 BETWEEN -1 AND 1.5 -- 漲幅還沒拉開
  AND M.專家實戰總分 > 35       -- 專家分高 (有基因)
  AND M.產業分類 IN (
      -- 鎖定盤中平均漲幅前 3 名的產業
      SELECT TOP 3 M2.產業分類
      FROM dbo.basicinfo I2
      INNER JOIN stockchangedate.dbo.MasterStockAnalysis M2 ON RTRIM(I2.代號) = RTRIM(M2.代號)
      WHERE M2.日期 = (SELECT MAX(日期) FROM stockchangedate.dbo.MasterStockAnalysis)
      GROUP BY M2.產業分類
      ORDER BY AVG(I2.漲幅) DESC
  )
ORDER BY M.專家實戰總分 DESC

/*--09:15 - 09:30：先跑「主流偵測」，看看今天是哪個族群（如：CPO、MOSFET）在帶隊。
--09:30 - 10:30：如果龍頭買不到，跑「聯動補漲」找族群內的二號、三號標的。
--11:00 以後：跑「破線賣點」，檢查手上的股票有沒有因為大盤轉弱而撐不住的，適時獲利了結。*/`
              },
              {
                  cat: "盤中操盤", title: "⚠️ 避險賣點：高分股盤中破線警示", sql: `/*資料庫:stockchange*/
I.名稱, I.代號, I.成交價 as 盤中價, I.漲幅, A.price_ma5 as 五日線, M.專家實戰總分
FROM dbo.basicinfo I
INNER JOIN stockchangedate.dbo.MasterStockAnalysis M ON RTRIM(I.代號) = RTRIM(M.代號)
INNER JOIN stockchangedate.dbo.allcross A ON RTRIM(I.代號) = RTRIM(A.代號) AND M.日期 = A.日期
WHERE M.日期 = (SELECT MAX(日期) FROM stockchangedate.dbo.MasterStockAnalysis)
  AND I.成交價 < A.price_ma5 -- 關鍵：盤中價跌破 5 日線
  AND M.專家實戰總分 > 30     -- 監控您追蹤的高分股
ORDER BY I.漲幅 ASC

/*--09:15 - 09:30：先跑「主流偵測」，看看今天是哪個族群（如：CPO、MOSFET）在帶隊。
--09:30 - 10:30：如果龍頭買不到，跑「聯動補漲」找族群內的二號、三號標的。
--11:00 以後：跑「破線賣點」，檢查手上的股票有沒有因為大盤轉弱而撐不住的，適時獲利了結。*/`
              },

              {
                  cat: "盤中操盤", title: "🛑 風險預警：盤中重挫標的掃描", sql: `/*資料庫:stockchange*/
I.名稱, I.代號, I.漲幅, I.成交價, M.專家實戰總分, M.實戰標籤
FROM dbo.basicinfo I
INNER JOIN stockchangedate.dbo.MasterStockAnalysis M ON RTRIM(I.代號) = RTRIM(M.代號)
WHERE M.日期 = (SELECT MAX(日期) FROM stockchangedate.dbo.MasterStockAnalysis)
  AND I.漲幅 < -4.5 -- 單日跌幅過大，通常是主力出貨或利空
ORDER BY I.漲幅 ASC

/*--09:15 - 09:30：先跑「主流偵測」，看看今天是哪個族群（如：CPO、MOSFET）在帶隊。
--09:30 - 10:30：如果龍頭買不到，跑「聯動補漲」找族群內的二號、三號標的。
--11:00 以後：跑「破線賣點」，檢查手上的股票有沒有因為大盤轉弱而撐不住的，適時獲利了結。*/`
              },



              {
                  cat: "產業類選股", title: "【核心選股】2026 頂級題材 + 強勢共振", sql: `TOP 10 
    名稱, 代號, 專家實戰總分, 盤中漲幅, 具體概念, 產業價值鏈資訊
FROM MasterStockAnalysis
WHERE 日期 = (SELECT MAX(日期) FROM MasterStockAnalysis)
  AND (具體概念 LIKE '%GB200%' 
       OR 具體概念 LIKE '%CPO%' 
       OR 具體概念 LIKE '%FOPLP%' 
       OR 具體概念 LIKE '%BBU%')
ORDER BY 專家實戰總分 DESC` },

              {
                  cat: "產業類選股", title: "【題材疊加王】多重概念 + 高勝率回測", sql: `TOP 100 
    M.名稱, M.代號, M.專家實戰總分, M.具體概念,
    (LEN(M.具體概念) - LEN(REPLACE(M.具體概念, '|', '')) + 1) as 題材數量
FROM MasterStockAnalysis M
WHERE M.日期 = (SELECT MAX(日期) FROM MasterStockAnalysis)
  AND M.具體概念 <> '無特定概念'
  AND (LEN(M.具體概念) - LEN(REPLACE(M.具體概念, '|', ''))) >= 2 -- 至少3個標籤
ORDER BY 專家實戰總分 DESC` },


              {
                  cat: "產業類選股", title: "🔥 產業熱度溫度計", sql: `日期, 產業分類, 
       COUNT(*) as [產業強勢股數量], 
       ROUND(AVG(平均專家總分), 2) as [產業平均分],
       STRING_AGG(CAST(名稱 AS NVARCHAR(MAX)), ' | ') WITHIN GROUP (ORDER BY 平均專家總分 DESC) as [代表股名單]
FROM (
    -- 第一層：先找出符合 3 項以上的股票，並聯集寬表抓取產業分類
    SELECT 
        H.日期, H.代號, M.名稱, M.產業分類,
        COUNT(*) as 符合次數, 
        AVG(H.專家總分) as 平均專家總分
    FROM [dbo].[ResonanceHits] H
    INNER JOIN [dbo].[MasterStockAnalysis] M ON H.代號 = M.代號 AND H.日期 = M.日期
    GROUP BY H.日期, H.代號, M.名稱, M.產業分類
    HAVING COUNT(*) >= 3 
) AS IndustryBase
GROUP BY 日期, 產業分類
ORDER BY 日期 DESC, [產業強勢股數量] DESC
--群聚效應」 (Cluster Effect)：
--如果某個產業（如：電子上游-IC-設計）在當天有 5 檔以上 同時符合 3 項共振，這就是「主流族群表態」。
--單打獨鬥的強勢股（數量=1）風險較高，群聚的族群勝率最高。
--「區塊平均分」的意義：
--如果該產業數量多，且平均分 > 40，代表這不是落後補漲，而是「集體主升段」。
--觀察「代表股」的變化：
--透過 STRING_AGG 列出的名單，您可以觀察領頭羊是誰。如果領頭羊從「台積電」換成「中小型 IC 股」，代表資金開始往二線擴散。` },

              {
                  cat: "產業類選股", title: "洗盤結束：低位放量起漲點", sql: `TOP 100 * FROM (
    SELECT
        代號, 名稱, 專家實戰總分, obv累積金叉次數, 具體概念, 產業價值鏈資訊, 盤中總量,
        LAG(盤中總量) OVER (PARTITION BY 代號 ORDER BY 日期) as 前一日總量,
        LAG(盤中總量, 2) OVER (PARTITION BY 代號 ORDER BY 日期) as 前二日總量,
        日期
    FROM MasterStockAnalysis
) AS v
WHERE 日期 = (SELECT MAX(日期) FROM MasterStockAnalysis)
  AND 盤中總量 > 前一日總量 AND 前一日總量 < 前二日總量 
  AND 專家實戰總分 > 30 
ORDER BY 專家實戰總分 DESC`
              },
              {
                  cat: "產業類選股", title: "共振彙總最新日", sql: `ResonanceHits.日期, ResonanceHits.代號, ResonanceHits.名稱, COUNT(*) AS 符合條件數, 
                            STRING_AGG(ResonanceHits.符合類型, ' | ') AS 符合清單, MAX(ResonanceHits.專家總分) AS 專家總分, 
                            MasterStockAnalysis.具體概念, MasterStockAnalysis.產業價值鏈資訊
FROM              ResonanceHits INNER JOIN
                            MasterStockAnalysis ON ResonanceHits.代號 = MasterStockAnalysis.代號 AND 
                            ResonanceHits.日期 = MasterStockAnalysis.日期
WHERE          (ResonanceHits.日期 =
                                (SELECT          MAX(日期) AS Expr1
                                  FROM               ResonanceHits AS ResonanceHits_1))
GROUP BY   ResonanceHits.日期, ResonanceHits.代號, ResonanceHits.名稱, MasterStockAnalysis.具體概念, 
                            MasterStockAnalysis.產業價值鏈資訊
ORDER BY   符合條件數 DESC, 專家總分 DESC`
              },
              {
                  cat: "產業類選股", title: "六維度共振+專家高分", sql: `TOP (100) M.名稱, M.代號, M.日期, M.專家實戰總分, M.實戰標籤, M.盤中漲幅, A.成交價黃金交叉次數 AS 價金叉, 
                            A.obv黃金交叉次數 AS OBV金叉, A.總量黃金交叉次數 AS 量金叉, A.外資黃金交叉次數 AS 外資金叉, 
                            A.投信黃金交叉次數 AS 投信金叉, A.三大法人黃金交叉次數 AS 法人金叉, 
                            CASE WHEN A.成交價黃金交叉次數 > 0 THEN 1 ELSE 0 END + CASE WHEN A.obv黃金交叉次數 > 0 THEN 1 ELSE 0 END
                             + CASE WHEN A.總量黃金交叉次數 > 0 THEN 1 ELSE 0 END + CASE WHEN A.外資黃金交叉次數 > 0 THEN 1 ELSE 0 END
                             + CASE WHEN A.投信黃金交叉次數 > 0 THEN 1 ELSE 0 END + CASE WHEN A.三大法人黃金交叉次數 > 0 THEN 1 ELSE
                             0 END AS 共振數, M.具體概念, M.產業價值鏈資訊
FROM              MasterStockAnalysis AS M INNER JOIN
                            allcross AS A ON M.代號 = A.代號 AND M.日期 = A.日期
WHERE          (M.日期 =
                                (SELECT          MAX(日期) AS Expr1
                                  FROM               MasterStockAnalysis)) AND 
                            (CASE WHEN A.成交價黃金交叉次數 > 0 THEN 1 ELSE 0 END + CASE WHEN A.obv黃金交叉次數 > 0 THEN 1 ELSE 0 END
                             + CASE WHEN A.總量黃金交叉次數 > 0 THEN 1 ELSE 0 END + CASE WHEN A.外資黃金交叉次數 > 0 THEN 1 ELSE 0 END
                             + CASE WHEN A.投信黃金交叉次數 > 0 THEN 1 ELSE 0 END + CASE WHEN A.三大法人黃金交叉次數 > 0 THEN 1 ELSE
                             0 END >= 5)
ORDER BY   M.專家實戰總分 DESC`
              },
              {
                  cat: "產業類選股", title: "獵鷹行動：內外資聯手鎖碼", sql: `TOP (100) M.名稱, M.代號, M.專家實戰總分, M.盤中漲幅, A.外資黃金交叉次數 AS 外資, A.投信黃金交叉次數 AS 投信, 
                            M.具體概念, M.產業價值鏈資訊
FROM              MasterStockAnalysis AS M INNER JOIN
                            allcross AS A ON M.代號 = A.代號 AND M.日期 = A.日期
WHERE          (M.日期 =
                                (SELECT          MAX(日期) AS Expr1
                                  FROM               MasterStockAnalysis)) AND (A.外資黃金交叉次數 >= 3) AND (A.投信黃金交叉次數 >= 3)
ORDER BY   A.外資黃金交叉次數 + A.投信黃金交叉次數 DESC`
              },
              {
                  cat: "產業類選股", title: "能量噴發：低位階全共振黑馬", sql: `TOP (100) M.名稱, M.代號, M.專家實戰總分, M.k9, M.盤中漲幅, 
                            CASE WHEN A.成交價黃金交叉次數 > 0 THEN 1 ELSE 0 END + CASE WHEN A.obv黃金交叉次數 > 0 THEN 1 ELSE 0 END
                             + CASE WHEN A.總量黃金交叉次數 > 0 THEN 1 ELSE 0 END + CASE WHEN A.外資黃金交叉次數 > 0 THEN 1 ELSE 0 END
                             + CASE WHEN A.投信黃金交叉次數 > 0 THEN 1 ELSE 0 END + CASE WHEN A.三大法人黃金交叉次數 > 0 THEN 1 ELSE
                             0 END AS 共振數, M.具體概念, M.產業價值鏈資訊
FROM              MasterStockAnalysis AS M INNER JOIN
                            allcross AS A ON M.代號 = A.代號 AND M.日期 = A.日期
WHERE          (M.日期 =
                                (SELECT          MAX(日期) AS Expr1
                                  FROM               MasterStockAnalysis)) AND (M.k9 < 50) AND 
                            (CASE WHEN A.成交價黃金交叉次數 > 0 THEN 1 ELSE 0 END + CASE WHEN A.obv黃金交叉次數 > 0 THEN 1 ELSE 0 END
                             + CASE WHEN A.總量黃金交叉次數 > 0 THEN 1 ELSE 0 END + CASE WHEN A.外資黃金交叉次數 > 0 THEN 1 ELSE 0 END
                             + CASE WHEN A.投信黃金交叉次數 > 0 THEN 1 ELSE 0 END + CASE WHEN A.三大法人黃金交叉次數 > 0 THEN 1 ELSE
                             0 END >= 5)
ORDER BY   M.專家實戰總分 DESC`
              },
              {
                  cat: "產業類選股", title: "勝率診斷：歷史共振噴發點回測", sql: `TOP (100) M.名稱, M.代號, M.專家實戰總分, M.k9, M.盤中漲幅, 
                            CASE WHEN A.成交價黃金交叉次數 > 0 THEN 1 ELSE 0 END + CASE WHEN A.obv黃金交叉次數 > 0 THEN 1 ELSE 0 END
                             + CASE WHEN A.總量黃金交叉次數 > 0 THEN 1 ELSE 0 END + CASE WHEN A.外資黃金交叉次數 > 0 THEN 1 ELSE 0 END
                             + CASE WHEN A.投信黃金交叉次數 > 0 THEN 1 ELSE 0 END + CASE WHEN A.三大法人黃金交叉次數 > 0 THEN 1 ELSE
                             0 END AS 共振數, M.具體概念, M.產業價值鏈資訊
FROM              MasterStockAnalysis AS M INNER JOIN
                            allcross AS A ON M.代號 = A.代號 AND M.日期 = A.日期
WHERE          (M.日期 =
                                (SELECT          MAX(日期) AS Expr1
                                  FROM               MasterStockAnalysis)) AND (M.k9 < 50) AND 
                            (CASE WHEN A.成交價黃金交叉次數 > 0 THEN 1 ELSE 0 END + CASE WHEN A.obv黃金交叉次數 > 0 THEN 1 ELSE 0 END
                             + CASE WHEN A.總量黃金交叉次數 > 0 THEN 1 ELSE 0 END + CASE WHEN A.外資黃金交叉次數 > 0 THEN 1 ELSE 0 END
                             + CASE WHEN A.投信黃金交叉次數 > 0 THEN 1 ELSE 0 END + CASE WHEN A.三大法人黃金交叉次數 > 0 THEN 1 ELSE
                             0 END >= 5)
ORDER BY   M.專家實戰總分 DESC`
              },
              {
                  cat: "產業類選股", title: "勝率診斷：歷史共振噴發點回測預設+select版", sql: `TOP 100 * FROM (
        SELECT *, LAG(共振數) OVER (PARTITION BY 代號 ORDER BY 日期) as 昨日共振
        FROM (
            SELECT M.代號, M.名稱, M.日期, M.專家實戰總分, M.盤中漲幅, M.具體概念, M.產業價值鏈資訊,
                   (CASE WHEN A.成交價黃金交叉次數 > 0 THEN 1 ELSE 0 END +
                    CASE WHEN A.obv黃金交叉次數 > 0 THEN 1 ELSE 0 END +
                    CASE WHEN A.總量黃金交叉次數 > 0 THEN 1 ELSE 0 END +
                    CASE WHEN A.外資黃金交叉次數 > 0 THEN 1 ELSE 0 END +
                    CASE WHEN A.投信黃金交叉次數 > 0 THEN 1 ELSE 0 END +
                    CASE WHEN A.三大法人黃金交叉次數 > 0 THEN 1 ELSE 0 END) AS 共振數
            FROM MasterStockAnalysis M
            INNER JOIN allcross A ON M.代號 = A.代號 AND M.日期 = A.日期
        ) AS DailyRes
) AS Trend
WHERE 日期 = (SELECT MAX(日期) FROM MasterStockAnalysis)
      AND 共振數 >= 5
      AND (昨日共振 <= 2 OR 昨日共振 IS NULL)
ORDER BY 專家實戰總分 DESC`
              },
              {
                  cat: "產業類選股", title: "王者再臨：高分籌碼龍頭股 (穩健版)", sql: `TOP (100) M.名稱, M.代號, M.專家實戰總分, M.產業分類, M.盤中漲幅, A.obv黃金交叉次數 AS OBV能量, 
                            A.三大法人黃金交叉次數 AS 法人力量, M.具體概念, M.產業價值鏈資訊
FROM              MasterStockAnalysis AS M INNER JOIN
                            allcross AS A ON M.代號 = A.代號 AND M.日期 = A.日期
WHERE          (M.日期 =
                                (SELECT          MAX(日期) AS Expr1
                                  FROM               MasterStockAnalysis)) AND (M.專家實戰總分 > 30) AND (A.obv黃金交叉次數 >= 2) AND 
                            (A.三大法人黃金交叉次數 >= 2)
ORDER BY   M.專家實戰總分 DESC`
              },
              {
                  cat: "產業類選股", title: "王者再臨：多維度戰力排行", sql: `TOP (100) M.名稱, M.代號, M.專家實戰總分, M.產業分類, 
                            A.obv黃金交叉次數 + A.三大法人黃金交叉次數 + A.成交價黃金交叉次數 AS 總戰力值, A.obv黃金交叉次數 AS OBV, 
                            A.三大法人黃金交叉次數 AS 法人, M.具體概念, M.產業價值鏈資訊
FROM              MasterStockAnalysis AS M INNER JOIN
                            allcross AS A ON M.代號 = A.代號 AND M.日期 = A.日期
WHERE          (M.日期 =
                                (SELECT          MAX(日期) AS Expr1
                                  FROM               MasterStockAnalysis)) AND (M.專家實戰總分 > 25) AND 
                            (A.obv黃金交叉次數 + A.三大法人黃金交叉次數 >= 4)
ORDER BY   總戰力值 DESC, M.專家實戰總分 DESC`
              },
              {
                  cat: "產業類選股", title: "王者再臨：產業熱門領頭羊", sql: `TOP (100) M.名稱, M.代號, M.專家實戰總分, M.產業分類, M.股本億, A.obv黃金交叉次數 AS OBV能量, 
                            A.三大法人黃金交叉次數 AS 法人, M.具體概念, M.產業價值鏈資訊
FROM              MasterStockAnalysis AS M INNER JOIN
                            allcross AS A ON M.代號 = A.代號 AND M.日期 = A.日期
WHERE          (M.日期 =
                                (SELECT          MAX(日期) AS Expr1
                                  FROM               MasterStockAnalysis)) AND (M.專家實戰總分 > 32) AND (M.股本億 > 20) AND 
                            (A.obv黃金交叉次數 > 0) OR
                            (M.日期 =
                                (SELECT          MAX(日期) AS Expr1
                                  FROM               MasterStockAnalysis AS MasterStockAnalysis_1)) AND (M.專家實戰總分 > 32) AND (M.股本億 > 20) 
                            AND (A.三大法人黃金交叉次數 > 0)
ORDER BY   M.產業分類, M.專家實戰總分 DESC`
              },



              {
                  cat: "回測+回報+勝率", title: "輸入股票代號+回測天數 選第二個執行預存程序有勝率統計(不同天數回報率有相當差別)", sql: `exec [sp_GetStockBacktest_Universal1] 2330,10`
              },
              {
                  cat: "回測+回報+勝率", title: "輸入股票代號+回測天數 選第二個執行預存程序無勝率統計(不同天數回報率有相當差別)", sql: `exec [sp_GetStockBacktest_Universal] 2330,10`
              },

              {
                  cat: "回測+回報+勝率", title: "輸入股票代號執行預存程序顯示黃金建議及性格診斷", sql: `EXEC sp_FindOptimalHoldingPeriod1 N'2330'`
              },

              {
                  cat: "回測+回報+勝率", title: "輸入股票代號執行預存程序💎 尋找該股黃金持股期", sql: `EXEC sp_FindOptimalHoldingPeriod N'2330'`
              },

              {
                  cat: "回測+回報+勝率", title: "篩選今日專家分 > 30 且歷史勝率 100% 的完美標的", sql: `TOP 50 
            M.名稱, M.代號, M.專家實戰總分, P.最佳天數, P.最高勝率, P.股性標籤
FROM MasterStockAnalysis M
INNER JOIN StockPersonality P ON M.代號 = P.代號
WHERE M.日期 = (SELECT MAX(日期) FROM MasterStockAnalysis)
            AND M.專家實戰總分 > 30
  AND P.最高勝率 = 100
ORDER BY M.專家實戰總分 DESC

--1. 【必殺技】高分共振 + 歷史 100% 勝率` },

              {
                  cat: "回測+回報+勝率", title: "找股性屬於「快攻型」，且歷史預期報酬最高的股票", sql: `TOP 50 
    M.名稱, M.代號, M.專家實戰總分, P.最佳天數, M.實戰標籤, P.預期報酬
FROM MasterStockAnalysis M
INNER JOIN StockPersonality P ON M.代號 = P.代號
WHERE M.日期 = (SELECT MAX(日期) FROM MasterStockAnalysis)
  AND P.股性標籤 = N'快攻獵豹型'
  AND M.專家實戰總分 > 15 -- 維持基本門檻即可
ORDER BY P.預期報酬 DESC

--2. 【效率之王】快攻獵豹型 (放寬量價限制)
--用途：捕捉那些「股性活潑」且「歷史期望值最高」的短線股` },


              {
                  cat: "回測+回報+勝率", title: "找勝率 > 85% 且 K9 尚在低檔的長線績優股", sql: `TOP 50 
    M.名稱, M.代號, P.最高勝率, P.最佳天數, M.k9
FROM MasterStockAnalysis M
INNER JOIN StockPersonality P ON M.代號 = P.代號
WHERE M.日期 = (SELECT MAX(日期) FROM MasterStockAnalysis)
  AND P.股性標籤 = N'長線保護型'
  AND M.k9 < 50
  AND P.最高勝率 > 85
ORDER BY P.最高勝率 DESC
--3. 【防守反擊】長線保護 + 低位階
--用途：針對台積電這類股票，找回測勝率高且現在位階還在低檔的。` },

              {
                  cat: "回測+回報+勝率", title: "🔥 找全市場勝率 > 80% 且預期報酬 > 5% 的黃金名單", sql: ` * 
FROM StockPersonality 
WHERE 最高勝率 > 80 AND 預期報酬 > 5
ORDER BY 預期報酬 DESC;`
              },

              {
                  cat: "專家組合", title: "🌡️ 大盤溫度計：成交值+實戰標籤家+具體概念", sql: `/*資料庫:stockchangedate*/
P.時間戳記,
    MAX(B.上市1上櫃2) AS 上市1上櫃2,
    LEFT(RTRIM(P.name1), LEN(RTRIM(P.name1)) - 4) AS 股票名稱,
    RIGHT(RTRIM(P.name1), 4) AS 股票代號,
    MAX(CAST(P.mail1 AS FLOAT)) AS 成交金額_百萬,
    MAX(P.word1) AS 排名描述,
    MAX(M.專家實戰總分) AS 專家實戰總分,
    MAX(M.實戰標籤) AS 實戰標籤,
    MAX(M.具體概念) AS 具體概念,
    MAX(M.產業分類) AS 產業分類
FROM
    poem1_stock7.dbo.poem AS P
INNER JOIN
    basicinfo AS B ON RIGHT(RTRIM(P.name1), 4) = RTRIM(B.代號)
INNER JOIN
   MasterStockAnalysis AS M ON RIGHT(RTRIM(P.name1), 4) = RTRIM(M.代號) AND P.時間戳記 = M.日期
WHERE
    P.時間戳記 = (SELECT MAX(時間戳記) FROM poem1_stock7.dbo.poem)
GROUP BY
    P.時間戳記, P.name1 -- 關鍵：針對日期與股票名稱進行群組，強制合併重複列
ORDER BY
    成交金額_百萬 DESC;`
              },

              {
                  cat: "專家組合",
                  title: "📈 個股資金與專家分數 (手動換代號)",
                  sql: `TOP 60 P.時間戳記,P.name1 as 名稱代號, P.mail1 AS [個股成交額_百萬], M.專家實戰總分, M.盤中漲幅, P.word1 AS [今日排名動態] 
FROM [poem1_stock7].[dbo].[poem] P 
INNER JOIN [stockchangedate].[dbo].[MasterStockAnalysis] M 
ON RIGHT(RTRIM(P.name1), 4) = RTRIM(M.代號) AND P.時間戳記 = M.日期 
WHERE M.代號 = '2330' 
ORDER BY P.時間戳記 DESC`
              },
              {
                  cat: "專家組合",
                  title: "📈 個股資金與專家分數最新日",
                  sql: `TOP 60 P.時間戳記,p.name1, P.mail1 AS [個股成交額_百萬], M.專家實戰總分, M.盤中漲幅, P.word1 AS [今日排名動態] 
FROM [poem1_stock7].[dbo].[poem] P 
INNER JOIN [stockchangedate].[dbo].[MasterStockAnalysis] M 
ON RIGHT(RTRIM(P.name1), 4) = RTRIM(M.代號) AND P.時間戳記 = M.日期 
WHERE M.日期 = (select max(日期) from [stockchangedate].[dbo].[MasterStockAnalysis])
ORDER BY P.mail1 DESC`
              },

              {
                  cat: "專家組合", title: "🏆 金牌基因：歷史勝率 100% 且今日剛發訊", sql: `/*資料庫:stockchangedate*/
M.名稱, M.代號, M.專家實戰總分, P.最佳天數, P.最高勝率, P.預期報酬, P.股性標籤, M.具體概念
FROM MasterStockAnalysis M
INNER JOIN StockPersonality P ON M.代號 = P.代號
WHERE M.日期 = (SELECT MAX(日期) FROM MasterStockAnalysis)
  AND M.專家實戰總分 > 30
  AND P.最高勝率 = 100
ORDER BY P.預期報酬 DESC`
              },



              {
                  cat: "專家組合", title: "市場熱度統計 (市場溫度計)", sql: `日期,
        COUNT(*) as [符合3項以上強勢股數量],
        ROUND(AVG(平均專家總分), 2) as [當日強勢股平均分]
FROM (
        -- 第一層：先算出每檔股票在每一天中了幾個標籤
        SELECT
            日期,
            代號,
            COUNT(*) as 符合次數,
            AVG(專家總分) as 平均專家總分
        FROM [dbo].[ResonanceHits]
        GROUP BY 日期, 代號
        HAVING COUNT(*) >= 3 -- 關鍵過濾：只要「符合 3 項以上」的股票
) AS DailyStrongStocks
GROUP BY 日期
ORDER BY 日期 DESC;
--查詢市場熱度：找出過去一年，每天有多少股票符合 3 項以上共振
--數據解讀指引（如何當專家達人）：
--市場過熱預警：
--如果「強勢股數量」突然從 10 檔飆升到 80 檔，代表群眾共識達成，通常是大行情的啟動點。
--如果數量處於高檔（例如 >100 檔）一段時間後開始下降，代表動能衰退，要小心回檔。
--平均分數意義：
--如果強勢股數量多，且「平均分」同步上升（例如從 30 變 45），代表領漲股力道非常紮實。`
              },
              {
                  cat: "專家組合", title: "洗盤結束：低位放量起漲點", sql: `TOP 100 * FROM (
        SELECT
            代號, 名稱, 日期, 專家實戰總分, obv累積金叉次數, 盤中總量, 實戰標籤,
            -- 取得前一天與前兩天的總量來比對洗盤特徵
            LAG(盤中總量) OVER (PARTITION BY 代號 ORDER BY 日期) as 前一日總量,
            LAG(盤中總量, 2) OVER (PARTITION BY 代號 ORDER BY 日期) as 前二日總量
        FROM MasterStockAnalysis
) AS VolumeData
WHERE 日期 = (SELECT MAX(日期) FROM MasterStockAnalysis)
      AND 盤中總量 > 前一日總量  -- 1. 今日量增 (攻擊啟動)
      AND 前一日總量 < 前二日總量 -- 2. 昨日量縮 (洗盤特徵)
      AND 專家實戰總分 > 30      -- 3. 專家評分強勢
      AND obv累積金叉次數 > 0     -- 4. OBV 指標在多頭區
ORDER BY 專家實戰總分 DESC
--  做法二：開發「量價背離」與「洗盤結束」訊號
--專家觀點：最強的股票不是今天大漲，而是 「主力洗盤剛結束」。
--邏輯：
--洗盤條件：過去 3 天縮量（成交量遞減）。
--啟動條件：今天突然出現「專家總分 > 30」且「OBV金叉」。`
              },


              {
                  cat: "多重金身加持",
                  title: "共振彙總最新日",
                  sql: `/*資料庫:stockchangedate*/
        日期, 代號, 名稱,
        COUNT(*) AS 符合條件數,
        STRING_AGG(符合類型, ' | ') AS 符合清單,
        MAX(專家總分) AS 專家總分
FROM ResonanceHits
WHERE 日期 = (SELECT MAX(日期) FROM ResonanceHits)
GROUP BY 日期, 代號, 名稱
ORDER BY 符合條件數 DESC, 專家總分 DESC;`
              },

              {
                  cat: "多重金身加持",
                  title: "共振彙總區間",
                  sql: `ResonanceHits.代號, ResonanceHits.名稱, COUNT(*) AS 這段期間共振次數, COUNT(DISTINCT ResonanceHits.日期)
                                AS 出現天數, MasterStockAnalysis.產業分類, MasterStockAnalysis.股本億
FROM              ResonanceHits INNER JOIN
                                MasterStockAnalysis ON ResonanceHits.代號 = MasterStockAnalysis.代號
WHERE          (ResonanceHits.日期 >=
                                    (SELECT          MIN(日期) AS Expr1
                                      FROM               ResonanceHits AS ResonanceHits1
                                      WHERE           (日期 IN
                                                                      (SELECT DISTINCT TOP (10)/*可調整天數*/ 日期
                                                                        FROM               ResonanceHits AS ResonanceHits2
                                                                        ORDER BY    日期 DESC))))
GROUP BY   ResonanceHits.代號, ResonanceHits.名稱, MasterStockAnalysis.產業分類, MasterStockAnalysis.股本億
ORDER BY   這段期間共振次數 DESC`
              },

              {
                  cat: "多重金身加持",
                  title: "共振彙總區間+股本條件",
                  sql: `ResonanceHits.代號, ResonanceHits.名稱, COUNT(*) AS 這段期間共振次數, COUNT(DISTINCT ResonanceHits.日期)
                                AS 出現天數, MasterStockAnalysis.產業分類, MasterStockAnalysis.股本億
FROM              ResonanceHits INNER JOIN
                                MasterStockAnalysis ON ResonanceHits.代號 = MasterStockAnalysis.代號
WHERE          (ResonanceHits.日期 >=
                                    (SELECT          MIN(日期) AS Expr1
                                      FROM               ResonanceHits AS ResonanceHits1
                                      WHERE           (日期 IN
                                                                      (SELECT DISTINCT TOP (10)/*可調整天數*/ 日期
                                                                        FROM               ResonanceHits AS ResonanceHits2
                                                                        ORDER BY    日期 DESC))))
GROUP BY   ResonanceHits.代號, ResonanceHits.名稱, MasterStockAnalysis.產業分類, MasterStockAnalysis.股本億
HAVING           (MasterStockAnalysis.股本億 > 0 AND MasterStockAnalysis.股本億 < 5)/*可調整股本條件*/
ORDER BY   這段期間共振次數 DESC`
              },






              {
                  cat: "最強組合",
                  title: "六維度共振+專家高分",
                  sql: `/*資料庫:stockchangedate*/
TOP 100 M.名稱, M.代號, M.日期, M.專家實戰總分, M.實戰標籤, M.盤中漲幅,
           A.成交價黃金交叉次數 AS 價金叉, A.obv黃金交叉次數 AS OBV金叉, A.總量黃金交叉次數 AS 量金叉,
           A.外資黃金交叉次數 AS 外資金叉, A.投信黃金交叉次數 AS 投信金叉, A.三大法人黃金交叉次數 AS 法人金叉,
           (CASE WHEN A.成交價黃金交叉次數 > 0 THEN 1 ELSE 0 END + CASE WHEN A.obv黃金交叉次數 > 0 THEN 1 ELSE 0 END + CASE WHEN A.總量黃金交叉次數 > 0 THEN 1 ELSE 0 END + CASE WHEN A.外資黃金交叉次數 > 0 THEN 1 ELSE 0 END + CASE WHEN A.投信黃金交叉次數 > 0 THEN 1 ELSE 0 END + CASE WHEN A.三大法人黃金交叉次數 > 0 THEN 1 ELSE 0 END) AS 共振數
FROM MasterStockAnalysis M
INNER JOIN allcross A ON M.代號 = A.代號 AND M.日期 = A.日期
WHERE M.日期 = (SELECT MAX(日期) FROM MasterStockAnalysis)
      AND (CASE WHEN A.成交價黃金交叉次數 > 0 THEN 1 ELSE 0 END + CASE WHEN A.obv黃金交叉次數 > 0 THEN 1 ELSE 0 END + CASE WHEN A.總量黃金交叉次數 > 0 THEN 1 ELSE 0 END + CASE WHEN A.外資黃金交叉次數 > 0 THEN 1 ELSE 0 END + CASE WHEN A.投信黃金交叉次數 > 0 THEN 1 ELSE 0 END + CASE WHEN A.三大法人黃金交叉次數 > 0 THEN 1 ELSE 0 END) >= 5
ORDER BY 專家實戰總分 DESC`
              },

              {
                  cat: "最強組合",
                  title: "獵鷹行動：內外資聯手鎖碼",
                  sql: `/*資料庫:stockchangedate*/
TOP 100 M.名稱, M.代號, M.專家實戰總分, M.盤中漲幅,
           A.外資黃金交叉次數 AS 外資, A.投信黃金交叉次數 AS 投信
FROM MasterStockAnalysis M
INNER JOIN allcross A ON M.代號 = A.代號 AND M.日期 = A.日期
WHERE M.日期 = (SELECT MAX(日期) FROM MasterStockAnalysis)
      AND A.外資黃金交叉次數 >= 3 AND A.投信黃金交叉次數 >= 3
ORDER BY (A.外資黃金交叉次數 + A.投信黃金交叉次數) DESC`
              },

              {
                  cat: "最強組合",
                  title: "能量噴發：低位階全共振黑馬",
                  sql: `/*資料庫:stockchangedate*/
TOP 100 M.名稱, M.代號, M.專家實戰總分, M.k9, M.盤中漲幅,
           (CASE WHEN A.成交價黃金交叉次數 > 0 THEN 1 ELSE 0 END + CASE WHEN A.obv黃金交叉次數 > 0 THEN 1 ELSE 0 END + CASE WHEN A.總量黃金交叉次數 > 0 THEN 1 ELSE 0 END + CASE WHEN A.外資黃金交叉次數 > 0 THEN 1 ELSE 0 END + CASE WHEN A.投信黃金交叉次數 > 0 THEN 1 ELSE 0 END + CASE WHEN A.三大法人黃金交叉次數 > 0 THEN 1 ELSE 0 END) AS 共振數
FROM MasterStockAnalysis M
INNER JOIN allcross A ON M.代號 = A.代號 AND M.日期 = A.日期
WHERE M.日期 = (SELECT MAX(日期) FROM MasterStockAnalysis)
      AND M.k9 < 50  -- 確保還沒漲太高
      AND (CASE WHEN A.成交價黃金交叉次數 > 0 THEN 1 ELSE 0 END + CASE WHEN A.obv黃金交叉次數 > 0 THEN 1 ELSE 0 END + CASE WHEN A.總量黃金交叉次數 > 0 THEN 1 ELSE 0 END + CASE WHEN A.外資黃金交叉次數 > 0 THEN 1 ELSE 0 END + CASE WHEN A.投信黃金交叉次數 > 0 THEN 1 ELSE 0 END + CASE WHEN A.三大法人黃金交叉次數 > 0 THEN 1 ELSE 0 END) >= 5
ORDER BY M.專家實戰總分 DESC`
              },


              {
                  cat: "最強組合",
                  title: "勝率診斷：歷史共振噴發點回測",
                  sql: `/*資料庫:stockchangedate*/
TOP 100 M.名稱, M.代號, M.專家實戰總分, M.k9, M.盤中漲幅,
           (CASE WHEN A.成交價黃金交叉次數 > 0 THEN 1 ELSE 0 END + CASE WHEN A.obv黃金交叉次數 > 0 THEN 1 ELSE 0 END + CASE WHEN A.總量黃金交叉次數 > 0 THEN 1 ELSE 0 END + CASE WHEN A.外資黃金交叉次數 > 0 THEN 1 ELSE 0 END + CASE WHEN A.投信黃金交叉次數 > 0 THEN 1 ELSE 0 END + CASE WHEN A.三大法人黃金交叉次數 > 0 THEN 1 ELSE 0 END) AS 共振數
FROM MasterStockAnalysis M
INNER JOIN allcross A ON M.代號 = A.代號 AND M.日期 = A.日期
WHERE M.日期 = (SELECT MAX(日期) FROM MasterStockAnalysis)
      AND M.k9 < 50  -- 確保還沒漲太高
      AND (CASE WHEN A.成交價黃金交叉次數 > 0 THEN 1 ELSE 0 END + CASE WHEN A.obv黃金交叉次數 > 0 THEN 1 ELSE 0 END + CASE WHEN A.總量黃金交叉次數 > 0 THEN 1 ELSE 0 END + CASE WHEN A.外資黃金交叉次數 > 0 THEN 1 ELSE 0 END + CASE WHEN A.投信黃金交叉次數 > 0 THEN 1 ELSE 0 END + CASE WHEN A.三大法人黃金交叉次數 > 0 THEN 1 ELSE 0 END) >= 5
ORDER BY M.專家實戰總分 DESC`
              },

              {
                  cat: "最強組合",
                  title: "勝率診斷：歷史共振噴發點回測預設+select版",
                  sql: `/*資料庫:stockchangedate*/
TOP 100 * FROM (
        SELECT *, LAG(共振數) OVER (PARTITION BY 代號 ORDER BY 日期) as 昨日共振
        FROM (
            SELECT M.代號, M.名稱, M.日期, M.專家實戰總分, M.盤中漲幅,
                   (CASE WHEN A.成交價黃金交叉次數 > 0 THEN 1 ELSE 0 END +
                    CASE WHEN A.obv黃金交叉次數 > 0 THEN 1 ELSE 0 END +
                    CASE WHEN A.總量黃金交叉次數 > 0 THEN 1 ELSE 0 END +
                    CASE WHEN A.外資黃金交叉次數 > 0 THEN 1 ELSE 0 END +
                    CASE WHEN A.投信黃金交叉次數 > 0 THEN 1 ELSE 0 END +
                    CASE WHEN A.三大法人黃金交叉次數 > 0 THEN 1 ELSE 0 END) AS 共振數
            FROM MasterStockAnalysis M
            INNER JOIN allcross A ON M.代號 = A.代號 AND M.日期 = A.日期
        ) AS DailyRes
) AS Trend
WHERE 日期 = (SELECT MAX(日期) FROM MasterStockAnalysis)
      AND 共振數 >= 5
      AND (昨日共振 <= 2 OR 昨日共振 IS NULL)
ORDER BY 專家實戰總分 DESC`
              },

              {
                  cat: "最強組合",
                  title: "王者再臨：高分籌碼龍頭股 (穩健版)",
                  sql: `/*資料庫:stockchangedate*/
TOP 100 M.名稱, M.代號, M.專家實戰總分, M.產業分類, M.盤中漲幅,
           A.obv黃金交叉次數 AS OBV能量, A.三大法人黃金交叉次數 AS 法人力量
FROM MasterStockAnalysis M
INNER JOIN allcross A ON M.代號 = A.代號 AND M.日期 = A.日期
WHERE M.日期 = (SELECT MAX(日期) FROM MasterStockAnalysis)
      AND M.專家實戰總分 > 30               -- 分數維持在前 15%
      AND A.obv黃金交叉次數 >= 2           -- 有基礎量能支撐
      AND A.三大法人黃金交叉次數 >= 2      -- 法人有基本進場
ORDER BY M.專家實戰總分 DESC`
              },

              {
                  cat: "最強組合",
                  title: "王者再臨：多維度戰力排行",
                  sql: `/*資料庫:stockchangedate*/
TOP 100 M.名稱, M.代號, M.專家實戰總分, M.產業分類,
           (A.obv黃金交叉次數 + A.三大法人黃金交叉次數 + A.成交價黃金交叉次數) AS 總戰力值,
           A.obv黃金交叉次數 AS OBV, A.三大法人黃金交叉次數 AS 法人
FROM MasterStockAnalysis M
INNER JOIN allcross A ON M.代號 = A.代號 AND M.日期 = A.日期
WHERE M.日期 = (SELECT MAX(日期) FROM MasterStockAnalysis)
      AND M.專家實戰總分 > 25
      AND (A.obv黃金交叉次數 + A.三大法人黃金交叉次數) >= 4 -- 兩者相加超過 4 即可
ORDER BY 總戰力值 DESC, M.專家實戰總分 DESC`
              },


              {
                  cat: "最強組合",
                  title: "王者再臨：產業熱門領頭羊",
                  sql: `/*資料庫:stockchangedate*/
TOP 100 M.名稱, M.代號, M.專家實戰總分, M.產業分類, M.股本億,
           A.obv黃金交叉次數 AS OBV能量, A.三大法人黃金交叉次數 AS 法人
FROM MasterStockAnalysis M
INNER JOIN allcross A ON M.代號 = A.代號 AND M.日期 = A.日期
WHERE M.日期 = (SELECT MAX(日期) FROM MasterStockAnalysis)
      AND M.專家實戰總分 > 32
      AND M.股本億 > 20 -- 既然是「王者」，篩選中大型股
      AND (A.obv黃金交叉次數 > 0 OR A.三大法人黃金交叉次數 > 0)
ORDER BY M.產業分類, M.專家實戰總分 DESC`
              },


              {
                  cat: "盤中操盤", title: "盤中起漲黑馬獵人可修改", sql: `/*資料庫:stockchange*/TOP (100) I.名稱, I.代號, I.成交價 AS 盤中價, I.漲幅 AS 盤中漲幅, 
                            Y.昨OBV + (CASE WHEN I.漲跌 > 0 THEN I.總量 WHEN I.漲跌 < 0 THEN - I.總量 ELSE 0 END) AS 盤中OBV, 
                            (Y.前四日OBV總和 + (Y.昨OBV + (CASE WHEN I.漲跌 > 0 THEN I.總量 WHEN I.漲跌 < 0 THEN - I.總量 ELSE 0 END))) 
                            / 5 AS 新OBV五日均線, Y.昨共振, 
                            Y.昨共振 + (CASE WHEN (Y.昨OBV + (CASE WHEN I.漲跌 > 0 THEN I.總量 WHEN I.漲跌 < 0 THEN - I.總量 ELSE 0 END))
                             > ((Y.前四日OBV總和 + (Y.昨OBV + (CASE WHEN I.漲跌 > 0 THEN I.總量 WHEN I.漲跌 < 0 THEN - I.總量 ELSE 0 END)))
                             / 5) THEN 1 ELSE 0 END) AS 預估收盤共振, Y.昨總分, CASE WHEN I.成交價 > Y.昨收 AND 
                            I.漲幅 > 0.5 THEN N'🚀 價量齊揚' ELSE N'量強價弱' END AS 盤中狀態
FROM              dbo.basicinfo AS I INNER JOIN
                                (SELECT          代號, 專家實戰總分 AS 昨總分, obv淨額 AS 昨OBV, 盤中現價 AS 昨收, 
                                                              CASE WHEN 均價黃金交叉次數 > 0 THEN 1 ELSE 0 END + CASE WHEN obv累積金叉次數 > 0 THEN 1 ELSE
                                                               0 END + CASE WHEN 均量黃金交叉次數 > 0 THEN 1 ELSE 0 END + CASE WHEN 三大法人黃金交叉次數
                                                               > 0 THEN 1 ELSE 0 END + CASE WHEN 外資黃金交叉次數 > 0 THEN 1 ELSE 0 END + CASE WHEN 投信黃金交叉次數
                                                               > 0 THEN 1 ELSE 0 END AS 昨共振,
                                                                  (SELECT          SUM(obv淨額) AS Expr1
                                                                    FROM               (SELECT          TOP (4) obv淨額
                                                                                                 FROM               stockchangedate.dbo.MasterStockAnalysis AS M2
                                                                                                 WHERE           (代號 = M1.代號) AND (日期 < M1.日期)
                                                                                                 ORDER BY    日期 DESC) AS t) AS 前四日OBV總和
                                  FROM               stockchangedate.dbo.MasterStockAnalysis AS M1
                                  WHERE           (日期 =
                                                                  (SELECT          MAX(日期) AS Expr1
                                                                    FROM               stockchangedate.dbo.MasterStockAnalysis))) AS Y ON I.代號 = Y.代號 AND 
                            I.成交價 > Y.昨收
WHERE          (I.漲幅 BETWEEN 0.5 AND 7.0) AND (Y.昨總分 > 15) AND 
                            (Y.昨OBV + (CASE WHEN I.漲跌 > 0 THEN I.總量 WHEN I.漲跌 < 0 THEN - I.總量 ELSE 0 END) 
                            > (Y.前四日OBV總和 + (Y.昨OBV + (CASE WHEN I.漲跌 > 0 THEN I.總量 WHEN I.漲跌 < 0 THEN - I.總量 ELSE 0 END))) 
                            / 5)
ORDER BY   預估收盤共振 DESC, Y.昨總分 DESC
--放寬條件方可找到資料來顯示obv站上其五日均線,,盤後更後不會有資料
--按鍵精靈+python，可以自動更新盤中成交價等資料
--可以抓取共振2可能變成共振3或obv站上其五日均線--前端採集：按鍵精靈 (QuickMacro)，每 5 分鐘執行一次。
--中台搬運：Python (Watchdog + pyodbc)，監控 C:\StockExport，自動清洗理*寶欄位並  進 SQL。
--核心運算：View_盤中起漲黑馬獵人，實現「歷史 vs 盤中」跨庫比對，計算「新 OBV 五日均線」與「預估共振進化」。`
              },



              {
                  cat: "AI選股模型", title: "啟動AI篩選", sql: `名稱, 代號, 產業分類, 股本億, 日期, 盤中現價, 盤中漲幅, 盤中總量, 價五日乖離, 量倍數, OBV分, 價均分,
                                技術分, 籌碼分, 量能分, 專家實戰總分, 實戰標籤, 資使用率, 資使用率黃金交叉次數, 券使用率,
                                券使用率黃金交叉次數, 券資比, 券資比黃金交叉次數, 站均, 均價黃金交叉次數, 均量黃金交叉次數,
                                三大法人黃金交叉次數, 外資黃金交叉次數, 投信黃金交叉次數, k9, d9, 週k9, 週d9, 月k9, 月d9, macd, 紅綠棒值,
                                集中度1日, 集中度5日, 集中度10日, 集中度20日, 集中度60日, obv淨額, obv5日均線, obv34日均線,
                                obv累積金叉次數
FROM              MasterStockAnalysis
WHERE          (代號 = N'2330')
ORDER BY   日期 DESC` },
              {
                  cat: "AI選股模型", title: "專家實戰選股", sql: `名稱, 代號, 產業分類, 股本億, 盤中現價, 盤中漲幅, 盤中總量, 價五日乖離, 量倍數, OBV分, 價均分, 技術分,
                                籌碼分, 量能分, 專家實戰總分, 實戰標籤, 日期, 資使用率, 資使用率黃金交叉次數, 券使用率, 券使用率黃金交叉次數,
                                券資比, 券資比黃金交叉次數, 站均, 均價黃金交叉次數, 均量黃金交叉次數, 三大法人黃金交叉次數,
                                外資黃金交叉次數, 投信黃金交叉次數, k9, d9, 週k9, 週d9, 月k9, 月d9, macd, 紅綠棒值, 集中度1日, 集中度5日,
                                集中度10日, 集中度20日, 集中度60日
FROM              StockScore
WHERE          (代號 = 2330)
ORDER BY   日期 DESC` },


              {
                  cat: "專家選股", title: "盤中追高部份", sql: `TOP (100) PERCENT
            obv盤中選股.名稱,
            obv盤中選股.代號,
            View_stockchange.產業分類,
            obv盤中選股.盤中成交價 AS 盤中現價,
            View_stockchange.漲幅 AS 盤中漲幅,
            obv盤中選股.總量 AS 盤中總量,

            -- [乖離與量倍數]
            ROUND((obv盤中選股.盤中成交價 - p.五日均線) / NULLIF (p.五日均線, 0) * 100, 2) AS 五日乖離,
            ROUND(CAST(obv盤中選股.總量 AS FLOAT) / NULLIF (v.二十日均量, 0), 2) AS 量倍數,

            -- [細項得分]
            ROUND(ISNULL(obvnewdate.obv黃金交叉次數, 0) * 2.0, 1) AS OBV分,
            ROUND(ISNULL(a.均價黃金交叉次數, 0) * 1.0, 1) AS 價均分,
            ROUND((((ISNULL(a.k9, 0) - ISNULL(a.d9, 0)) + (ISNULL(a.週k9, 0) - ISNULL(a.週d9, 0)))
                  + (ISNULL(a.月k9, 0) - ISNULL(a.月d9, 0))) / 5.0 + ISNULL(macdpic.DIF減MACD, 0) / NULLIF (obv盤中選股.盤中成交價, 0) * 200.0, 1) AS 技術分,
            ROUND((ISNULL(a.三大法人黃金交叉次數, 0) * 1.5 + (ISNULL(a.三週庫存比率, 0) - ISNULL(a.六週庫存比率, 0)+ISNULL(a.四週庫存比率, 0) - ISNULL(a.七週庫存比率, 0)) * 1.5/2)
                  + ((ISNULL(a.集中度1日, 0) * 0.4 + ISNULL(a.集中度5日, 0) * 0.4) + ISNULL(a.集中度20日, 0) * 0.2) / 5.0, 1) AS 籌碼分,
            ROUND(ISNULL(v.五日交叉, 0) / NULLIF (v.五日均量, 0) * 5.0 + ISNULL(v.站均量, 0) * 1.0, 1) AS 量能分,

            -- [專家實戰總分]
            ROUND(
                (ISNULL(obvnewdate.obv黃金交叉次數, 0) * 2.0 + ISNULL(a.均價黃金交叉次數, 0) * 1.0) +
                (((ISNULL(a.k9, 0) - ISNULL(a.d9, 0)) + (ISNULL(a.週k9, 0) - ISNULL(a.週d9, 0)) + (ISNULL(a.月k9, 0) - ISNULL(a.月d9, 0))) / 5.0) +
                (ISNULL(macdpic.DIF減MACD, 0) / NULLIF (obv盤中選股.盤中成交價, 0) * 200.0) +
                (ISNULL(a.三大法人黃金交叉次數, 0) * 1.5) + (((ISNULL(a.四週庫存比率, 0) - ISNULL(a.七週庫存比率, 0)) * 1.5) +
                ((ISNULL(a.三週庫存比率, 0) - ISNULL(a.六週庫存比率, 0)) * 1.5))/2 +
                (((ISNULL(a.集中度1日, 0) * 0.4 + ISNULL(a.集中度5日, 0) * 0.4) + ISNULL(a.集中度20日, 0) * 0.2) / 5.0) +
                (ISNULL(v.五日交叉, 0) / NULLIF (v.五日均量, 0) * 5.0) +
                (ISNULL(v.站均量, 0) * 1.0)
            , 2) AS 專家實戰總分,

            -- [實戰標籤：改為複選串接邏輯]
            ISNULL(
                NULLIF(
                    -- 條件1: 追高警示 (二選一)
                    (CASE
                        WHEN (obv盤中選股.盤中成交價 - p.五日均線) / NULLIF (p.五日均線, 0) > 0.18 THEN N'★追高>18% '
                        WHEN (obv盤中選股.盤中成交價 - p.五日均線) / NULLIF (p.五日均線, 0) > 0.08 and (obv盤中選股.盤中成交價 - p.五日均線) / NULLIF (p.五日均線, 0) <= 0.18THEN N'★追高8~18% '
                        ELSE N''
                    END) +
                    -- 條件2: 量價齊揚
                    (CASE
                        WHEN v.站均量 >= 7 AND View_stockchange.漲幅 > 3 THEN N'🔥量價齊揚 '
                        ELSE N''
                    END) +
                    -- 條件3: 大戶鎖碼
                    (CASE
                        WHEN ((ISNULL(a.三週庫存比率, 0) - ISNULL(a.六週庫存比率, 0))+(ISNULL(a.四週庫存比率, 0) - ISNULL(a.七週庫存比率, 0)))/2 > 2 THEN N'💎大戶鎖碼 '
                        ELSE N''
                    END)
                , N''),
                N'穩定觀察'
            ) AS 實戰標籤

FROM obv盤中選股
INNER JOIN View_stockchange ON obv盤中選股.代號 = View_stockchange.代號
INNER JOIN obvnewdate ON obv盤中選股.代號 = obvnewdate.代號
INNER JOIN winnewdate AS a ON obvnewdate.代號 = a.股票代號 AND obvnewdate.日期 = a.日期
INNER JOIN macdpic ON a.股票代號 = macdpic.股票代號 AND a.日期 = macdpic.日期
INNER JOIN View_avgamountcount AS v ON obv盤中選股.代號 = v.股票代號 AND a.日期 = v.日期
INNER JOIN View_avgpricecount AS p ON obv盤中選股.代號 = p.股票代號 AND a.日期 = p.日期

WHERE (obvnewdate.日期 = (SELECT MAX(日期) FROM basicinfo))
          AND (a.k9 > a.d9)
          AND (macdpic.DIF減MACD > 0)
          AND (obv盤中選股.盤中的累積obv均量 > obv盤中選股.盤中計算出來的最新五日平均線)
          AND (obv盤中選股.總量 > 1000)

ORDER BY 專家實戰總分 DESC;

--(五日乖離:盤中成交價-前一日的價五日均線)/前一日的價五日均線(今天還沒出來)
--量倍數:盤中總量 / 前一日的二十日均量(今天還沒出來)
--OBV分:obv黃金交叉次數*2
--價均分: 均價黃金交叉次數*1
--技術分:(k9-d9 + 週k9- 週d9  + 月k9-月d9) / 5.0 + macd紅綠棒值 /盤中成交價 * 200 (5%*200就是10分)
--籌碼分: 三大法人黃金交叉次數 * 1.5 + [(三週庫存比率-六週庫存比率)+(四週庫存比率-七週庫存比率)]/2 * 1.5 + [(集中度1日 * 0.4 + 集中度5日 * 0.4 + 集中度20日 * 0.2)] / 5
--量能分:(成交量五日交叉的增量 /五日均量) * 5.0 + 站均量 * 1
--專家實戰總分: OBV分+價均分+技術分 + 籌碼分+量能分

--★追高(五日乖離):(盤中成交價 - 五日均線)/五日均線 8%~18%
--🔥量價齊揚:站上成交量均線個數>= 7 AND 盤中漲幅 > 3%
--💎大戶鎖碼:較長期時間太短可能只是當沖等比較不準 ((集保庫存3週比率-集保庫存6週比率)+ (集保庫存4週比率-集保庫存7週比率))/2 > 2% 用兩個區段來平均比較不會錯過` },

              {
                  cat: "專家選股", title: "盤中追高全部", sql: `TOP (100) PERCENT
            obv盤中選股.名稱,
            obv盤中選股.代號,
            View_stockchange.產業分類,
            obv盤中選股.盤中成交價 AS 盤中現價,
            View_stockchange.漲幅 AS 盤中漲幅,
            obv盤中選股.總量 AS 盤中總量,

            -- [乖離與量倍數]
            ROUND((obv盤中選股.盤中成交價 - p.五日均線) / NULLIF (p.五日均線, 0) * 100, 2) AS 五日乖離,
            ROUND(CAST(obv盤中選股.總量 AS FLOAT) / NULLIF (v.二十日均量, 0), 2) AS 量倍數,

            -- [細項得分]
            ROUND(ISNULL(obvnewdate.obv黃金交叉次數, 0) * 2.0, 1) AS OBV分,
            ROUND(ISNULL(a.均價黃金交叉次數, 0) * 1.0, 1) AS 價均分,
            ROUND((((ISNULL(a.k9, 0) - ISNULL(a.d9, 0)) + (ISNULL(a.週k9, 0) - ISNULL(a.週d9, 0)))
                  + (ISNULL(a.月k9, 0) - ISNULL(a.月d9, 0))) / 5.0 + ISNULL(macdpic.DIF減MACD, 0) / NULLIF (obv盤中選股.盤中成交價, 0) * 200.0, 1) AS 技術分,
            ROUND((ISNULL(a.三大法人黃金交叉次數, 0) * 1.5 + (ISNULL(a.三週庫存比率, 0) - ISNULL(a.六週庫存比率, 0)+ISNULL(a.四週庫存比率, 0) - ISNULL(a.七週庫存比率, 0)) * 1.5/2)
                  + ((ISNULL(a.集中度1日, 0) * 0.4 + ISNULL(a.集中度5日, 0) * 0.4) + ISNULL(a.集中度20日, 0) * 0.2) / 5.0, 1) AS 籌碼分,
            ROUND(ISNULL(v.五日交叉, 0) / NULLIF (v.五日均量, 0) * 5.0 + ISNULL(v.站均量, 0) * 1.0, 1) AS 量能分,

            -- [專家實戰總分]
            ROUND(
                (ISNULL(obvnewdate.obv黃金交叉次數, 0) * 2.0 + ISNULL(a.均價黃金交叉次數, 0) * 1.0) +
                (((ISNULL(a.k9, 0) - ISNULL(a.d9, 0)) + (ISNULL(a.週k9, 0) - ISNULL(a.週d9, 0)) + (ISNULL(a.月k9, 0) - ISNULL(a.月d9, 0))) / 5.0) +
                (ISNULL(macdpic.DIF減MACD, 0) / NULLIF (obv盤中選股.盤中成交價, 0) * 200.0) +
                (ISNULL(a.三大法人黃金交叉次數, 0) * 1.5) + (((ISNULL(a.四週庫存比率, 0) - ISNULL(a.七週庫存比率, 0)) * 1.5) +
                ((ISNULL(a.三週庫存比率, 0) - ISNULL(a.六週庫存比率, 0)) * 1.5))/2 +
                (((ISNULL(a.集中度1日, 0) * 0.4 + ISNULL(a.集中度5日, 0) * 0.4) + ISNULL(a.集中度20日, 0) * 0.2) / 5.0) +
                (ISNULL(v.五日交叉, 0) / NULLIF (v.五日均量, 0) * 5.0) +
                (ISNULL(v.站均量, 0) * 1.0)
            , 2) AS 專家實戰總分,

            -- [實戰標籤：改為複選串接邏輯]
            ISNULL(
                NULLIF(
                    -- 條件1: 追高警示 (二選一)
                    (CASE
                        WHEN (obv盤中選股.盤中成交價 - p.五日均線) / NULLIF (p.五日均線, 0) > 0.18 THEN N'★追高>18% '
                        WHEN (obv盤中選股.盤中成交價 - p.五日均線) / NULLIF (p.五日均線, 0) > 0.08 and (obv盤中選股.盤中成交價 - p.五日均線) / NULLIF (p.五日均線, 0) <= 0.18THEN N'★追高8~18% '
                        ELSE N''
                    END) +
                    -- 條件2: 量價齊揚
                    (CASE
                        WHEN v.站均量 >= 7 AND View_stockchange.漲幅 > 3 THEN N'🔥量價齊揚 '
                        ELSE N''
                    END) +
                    -- 條件3: 大戶鎖碼
                    (CASE
                        WHEN ((ISNULL(a.三週庫存比率, 0) - ISNULL(a.六週庫存比率, 0))+(ISNULL(a.四週庫存比率, 0) - ISNULL(a.七週庫存比率, 0)))/2 > 2 THEN N'💎大戶鎖碼 '
                        ELSE N''
                    END)
                , N''),
                N'穩定觀察'
            ) AS 實戰標籤

FROM obv盤中選股
INNER JOIN View_stockchange ON obv盤中選股.代號 = View_stockchange.代號
INNER JOIN obvnewdate ON obv盤中選股.代號 = obvnewdate.代號
INNER JOIN winnewdate AS a ON obvnewdate.代號 = a.股票代號 AND obvnewdate.日期 = a.日期
INNER JOIN macdpic ON a.股票代號 = macdpic.股票代號 AND a.日期 = macdpic.日期
INNER JOIN View_avgamountcount AS v ON obv盤中選股.代號 = v.股票代號 AND a.日期 = v.日期
INNER JOIN View_avgpricecount AS p ON obv盤中選股.代號 = p.股票代號 AND a.日期 = p.日期
ORDER BY 專家實戰總分 DESC;

--(五日乖離:盤中成交價-前一日的價五日均線)/前一日的價五日均線(今天還沒出來)
--量倍數:盤中總量 / 前一日的二十日均量(今天還沒出來)
--OBV分:obv黃金交叉次數*2
--價均分: 均價黃金交叉次數*1
--技術分:(k9-d9 + 週k9- 週d9  + 月k9-月d9) / 5.0 + macd紅綠棒值 /盤中成交價 * 200 (5%*200就是10分)
--籌碼分: 三大法人黃金交叉次數 * 1.5 + [(三週庫存比率-六週庫存比率)+(四週庫存比率-七週庫存比率)]/2 * 1.5 + [(集中度1日 * 0.4 + 集中度5日 * 0.4 + 集中度20日 * 0.2)] / 5
--量能分:(成交量五日交叉的增量 /五日均量) * 5.0 + 站均量 * 1
--專家實戰總分: OBV分+價均分+技術分 + 籌碼分+量能分

--★追高(五日乖離):(盤中成交價 - 五日均線)/五日均線 8%~18%
--🔥量價齊揚:站上成交量均線個數>= 7 AND 盤中漲幅 > 3%
--💎大戶鎖碼:較長期時間太短可能只是當沖等比較不準 ((集保庫存3週比率-集保庫存6週比率)+ (集保庫存4週比率-集保庫存7週比率))/2 > 2% 用兩個區段來平均比較不會錯過` },

              {
                  cat: "專家選股", title: "盤中全部多欄位", sql: `TOP (100) PERCENT
            obv盤中選股.名稱,
            obv盤中選股.代號,
            View_stockchange.產業分類,
            obv盤中選股.盤中成交價 AS 盤中現價,
            View_stockchange.漲幅 AS 盤中漲幅,
            obv盤中選股.總量 AS 盤中總量,

            -- [乖離與量倍數]
            ROUND((obv盤中選股.盤中成交價 - p.五日均線) / NULLIF (p.五日均線, 0) * 100, 2) AS 五日乖離,
            ROUND(CAST(obv盤中選股.總量 AS FLOAT) / NULLIF (v.二十日均量, 0), 2) AS 量倍數,

            -- [細項得分]
            ROUND(ISNULL(obvnewdate.obv黃金交叉次數, 0) * 2.0, 1) AS OBV分,
            ROUND(ISNULL(a.均價黃金交叉次數, 0) * 1.0, 1) AS 價均分,
            ROUND((((ISNULL(a.k9, 0) - ISNULL(a.d9, 0)) + (ISNULL(a.週k9, 0) - ISNULL(a.週d9, 0)))
                  + (ISNULL(a.月k9, 0) - ISNULL(a.月d9, 0))) / 5.0 + ISNULL(macdpic.DIF減MACD, 0) / NULLIF (obv盤中選股.盤中成交價, 0) * 200.0, 1) AS 技術分,
            ROUND((ISNULL(a.三大法人黃金交叉次數, 0) * 1.5 + (ISNULL(a.三週庫存比率, 0) - ISNULL(a.六週庫存比率, 0)+ISNULL(a.四週庫存比率, 0) - ISNULL(a.七週庫存比率, 0)) * 1.5/2)
                  + ((ISNULL(a.集中度1日, 0) * 0.4 + ISNULL(a.集中度5日, 0) * 0.4) + ISNULL(a.集中度20日, 0) * 0.2) / 5.0, 1) AS 籌碼分,
            ROUND(ISNULL(v.五日交叉, 0) / NULLIF (v.五日均量, 0) * 5.0 + ISNULL(v.站均量, 0) * 1.0, 1) AS 量能分,

            -- [專家實戰總分]
            ROUND(
                (ISNULL(obvnewdate.obv黃金交叉次數, 0) * 2.0 + ISNULL(a.均價黃金交叉次數, 0) * 1.0) +
                (((ISNULL(a.k9, 0) - ISNULL(a.d9, 0)) + (ISNULL(a.週k9, 0) - ISNULL(a.週d9, 0)) + (ISNULL(a.月k9, 0) - ISNULL(a.月d9, 0))) / 5.0) +
                (ISNULL(macdpic.DIF減MACD, 0) / NULLIF (obv盤中選股.盤中成交價, 0) * 200.0) +
                (ISNULL(a.三大法人黃金交叉次數, 0) * 1.5) + (((ISNULL(a.四週庫存比率, 0) - ISNULL(a.七週庫存比率, 0)) * 1.5) +
                ((ISNULL(a.三週庫存比率, 0) - ISNULL(a.六週庫存比率, 0)) * 1.5))/2 +
                (((ISNULL(a.集中度1日, 0) * 0.4 + ISNULL(a.集中度5日, 0) * 0.4) + ISNULL(a.集中度20日, 0) * 0.2) / 5.0) +
                (ISNULL(v.五日交叉, 0) / NULLIF (v.五日均量, 0) * 5.0) +
                (ISNULL(v.站均量, 0) * 1.0)
            , 2) AS 專家實戰總分,

            -- [實戰標籤：改為複選串接邏輯]
            ISNULL(
                NULLIF(
                    -- 條件1: 追高警示 (二選一)
                    (CASE
                        WHEN (obv盤中選股.盤中成交價 - p.五日均線) / NULLIF (p.五日均線, 0) > 0.18 THEN N'★追高>18% '
                        WHEN (obv盤中選股.盤中成交價 - p.五日均線) / NULLIF (p.五日均線, 0) > 0.08 and (obv盤中選股.盤中成交價 - p.五日均線) / NULLIF (p.五日均線, 0) <= 0.18THEN N'★追高8~18% '
                        ELSE N''
                    END) +
                    -- 條件2: 量價齊揚
                    (CASE
                        WHEN v.站均量 >= 7 AND View_stockchange.漲幅 > 3 THEN N'🔥量價齊揚 '
                        ELSE N''
                    END) +
                    -- 條件3: 大戶鎖碼
                    (CASE
                        WHEN ((ISNULL(a.三週庫存比率, 0) - ISNULL(a.六週庫存比率, 0))+(ISNULL(a.四週庫存比率, 0) - ISNULL(a.七週庫存比率, 0)))/2 > 2 THEN N'💎大戶鎖碼 '
                        ELSE N''
                    END)
                , N''),
                N'穩定觀察'
            ) AS 實戰標籤, a.資使用率, a.資使用率黃金交叉次數, a.券使用率,
                                    a.券使用率黃金交叉次數, a.券資比, a.券資比黃金交叉次數, a.站均, a.均價黃金交叉次數, a.均量黃金交叉次數,
                                    a.三大法人黃金交叉次數, a.外資黃金交叉次數, a.投信黃金交叉次數, a.k9, a.d9, a.週k9, a.週d9, a.月k9, a.月d9,
                                    a.macd, macdpic.DIF減MACD AS 紅綠棒值, a.集中度1日, a.集中度5日, a.集中度10日, a.集中度20日,
                                    a.集中度60日
FROM obv盤中選股
INNER JOIN View_stockchange ON obv盤中選股.代號 = View_stockchange.代號
INNER JOIN obvnewdate ON obv盤中選股.代號 = obvnewdate.代號
INNER JOIN winnewdate AS a ON obvnewdate.代號 = a.股票代號 AND obvnewdate.日期 = a.日期
INNER JOIN macdpic ON a.股票代號 = macdpic.股票代號 AND a.日期 = macdpic.日期
INNER JOIN View_avgamountcount AS v ON obv盤中選股.代號 = v.股票代號 AND a.日期 = v.日期
INNER JOIN View_avgpricecount AS p ON obv盤中選股.代號 = p.股票代號 AND a.日期 = p.日期
ORDER BY   專家實戰總分 DESC

--(五日乖離:盤中成交價-前一日的價五日均線)/前一日的價五日均線(今天還沒出來)
--量倍數:盤中總量 / 前一日的二十日均量(今天還沒出來)
--OBV分:obv黃金交叉次數*2
--價均分: 均價黃金交叉次數*1
--技術分:(k9-d9 + 週k9- 週d9  + 月k9-月d9) / 5.0 + macd紅綠棒值 /盤中成交價 * 200 (5%*200就是10分)
--籌碼分: 三大法人黃金交叉次數 * 1.5 + [(三週庫存比率-六週庫存比率)+(四週庫存比率-七週庫存比率)]/2 * 1.5 + [(集中度1日 * 0.4 + 集中度5日 * 0.4 + 集中度20日 * 0.2)] / 5
--量能分:(成交量五日交叉的增量 /五日均量) * 5.0 + 站均量 * 1
--專家實戰總分: OBV分+價均分+技術分 + 籌碼分+量能分

--★追高(五日乖離):(盤中成交價 - 五日均線)/五日均線 8%~18%
--🔥量價齊揚:站上成交量均線個數>= 7 AND 盤中漲幅 > 3%
--💎大戶鎖碼:較長期時間太短可能只是當沖等比較不準 ((集保庫存3週比率-集保庫存6週比率)+ (集保庫存4週比率-集保庫存7週比率))/2 > 2% 用兩個區段來平均比較不會錯過` },





              {
                  cat: "專家選股", title: "實戰總分連三高", sql: `A.名稱, A.代號, A.專家實戰總分 AS 今日分數, B.專家實戰總分 AS 昨日分數, C.專家實戰總分 AS 前日分數, A.產業分類,
                                    A.股本億, A.盤中現價, A.盤中漲幅, A.盤中總量, A.價五日乖離, A.量倍數, A.OBV分, A.價均分, A.技術分, A.籌碼分,
                                    A.量能分, A.專家實戰總分, A.實戰標籤, A.日期, A.均價黃金交叉次數, A.均量黃金交叉次數, A.三大法人黃金交叉次數,
                                    A.外資黃金交叉次數, A.投信黃金交叉次數, A.站均
FROM              StockScore AS A INNER JOIN
                                    StockScore AS B ON A.代號 = B.代號 AND B.日期 =
                                        (SELECT          MIN(日期) AS 指定日期
                                          FROM               basicinfo
                                          WHERE           (日期 =
                                                                          (SELECT          MIN(日期) AS Expr1
                                                                            FROM               basicinfo AS basicinfo1
                                                                            WHERE           (日期 IN
                                                                                                            (SELECT DISTINCT TOP (2) 日期
                                                                                                              FROM               basicinfo AS basicinfo2
                                                                                                              ORDER BY    日期 DESC))))) AND A.專家實戰總分 > B.專家實戰總分 AND
                                    A.專家實戰總分 > B.專家實戰總分 INNER JOIN
                                    StockScore AS C ON A.代號 = C.代號 AND C.日期 =
                                        (SELECT          MIN(日期) AS 指定日期
                                          FROM               basicinfo
                                          WHERE           (日期 =
                                                                          (SELECT          MIN(日期) AS Expr1
                                                                            FROM               basicinfo AS basicinfo1
                                                                            WHERE           (日期 IN
                                                                                                            (SELECT DISTINCT TOP (3) 日期
                                                                                                              FROM               basicinfo AS basicinfo2
                                                                                                              ORDER BY    日期 DESC))))) AND B.專家實戰總分 > C.專家實戰總分 AND
                                    B.專家實戰總分 > C.專家實戰總分
WHERE          (A.專家實戰總分 > 25) AND (A.日期 =
                                        (SELECT          MAX(日期) AS 指定日期
                                          FROM               basicinfo))
ORDER BY   今日分數 DESC
--分數連三升且今天已經進入強勢區` },
              {
                  cat: "專家選股", title: "單股多天實戰總分", sql: `名稱, 代號, 產業分類, 股本億, 盤中現價, 盤中漲幅, 盤中總量, 價五日乖離, 量倍數, OBV分, 價均分, 技術分,
                                    籌碼分, 量能分, 專家實戰總分, 實戰標籤, 日期
FROM              StockScore
WHERE          (代號 = 2330)
ORDER BY   日期 DESC` },

              {
                  cat: "專家選股", title: "單股多天實戰總分", sql: `名稱, 代號, 產業分類, 股本億, 盤中現價, 盤中漲幅, 盤中總量, 價五日乖離, 量倍數, OBV分, 價均分, 技術分,
                                    籌碼分, 量能分, 專家實戰總分, 實戰標籤, 日期
FROM              StockScore
WHERE          (代號 = 2330)
ORDER BY   日期 DESC` },

              {
                  cat: "專家選股", title: "啟動AI篩選", sql: `名稱, 代號, 產業分類, 股本億, 日期, 盤中現價, 盤中漲幅, 盤中總量, 價五日乖離, 量倍數, OBV分, 價均分,
                                技術分, 籌碼分, 量能分, 專家實戰總分, 實戰標籤, 資使用率, 資使用率黃金交叉次數, 券使用率,
                                券使用率黃金交叉次數, 券資比, 券資比黃金交叉次數, 站均, 均價黃金交叉次數, 均量黃金交叉次數,
                                三大法人黃金交叉次數, 外資黃金交叉次數, 投信黃金交叉次數, k9, d9, 週k9, 週d9, 月k9, 月d9, macd, 紅綠棒值,
                                集中度1日, 集中度5日, 集中度10日, 集中度20日, 集中度60日, obv淨額, obv5日均線, obv34日均線,
                                obv累積金叉次數
FROM              MasterStockAnalysis
WHERE          (代號 = N'2330')
ORDER BY   日期 DESC` },
              {
                  cat: "專家選股", title: "專家實戰選股", sql: `名稱, 代號, 產業分類, 股本億, 盤中現價, 盤中漲幅, 盤中總量, 價五日乖離, 量倍數, OBV分, 價均分, 技術分,
                                籌碼分, 量能分, 專家實戰總分, 實戰標籤, 日期, 資使用率, 資使用率黃金交叉次數, 券使用率, 券使用率黃金交叉次數,
                                券資比, 券資比黃金交叉次數, 站均, 均價黃金交叉次數, 均量黃金交叉次數, 三大法人黃金交叉次數,
                                外資黃金交叉次數, 投信黃金交叉次數, k9, d9, 週k9, 週d9, 月k9, 月d9, macd, 紅綠棒值, 集中度1日, 集中度5日,
                                集中度10日, 集中度20日, 集中度60日
FROM              StockScore
WHERE          (代號 = 2330)
ORDER BY   日期 DESC` },

              {
                  cat: "專家選股", title: "產業龍頭三巨頭", sql: `/*資料庫:fromaccessdatabase*/ name1, mail1, word1, 時間戳記 FROM guestinfowd5 WHERE (時間戳記 = N'20260419') ORDER BY name1`
              },

              {
                  cat: "專家選股", title: "文字打包系統", sql: `[ID] ,[Content],日期  FROM [dbo].[TextShares1] order by 日期 desc`
              },



              {
                  cat: "專家選股", title: "均線金叉obv查詢", sql: `代號, 名稱, 日期, obv淨額, 成交價, 盤中總量, obv_ma5, obv_ma10, obv_ma20, obv_ma35, obv_ma60, obv_ma120,
                                obv_ma200, obv_ma240, obv_ma34, 五日交叉成功, 十日交叉成功, 二十日交叉成功, 三十五日交叉成功,
                                六十日交叉成功, 一百二十日交叉成功, 二百日交叉成功, 二百四十日交叉成功, obv黃金交叉次數, price_ma5,
                                price_ma10, price_ma20, price_ma35, price_ma60, price_ma120, price_ma200, price_ma240, price_ma34,
                                五日成交價交叉成功, 十日成交價交叉成功, 二十日成交價交叉成功, 三十五日成交價交叉成功,
                                六十日成交價交叉成功, 一百二十日成交價交叉成功, 二百日成交價交叉成功, 二百四十日成交價交叉成功,
                                成交價黃金交叉次數, amount_ma5, amount_ma10, amount_ma20, amount_ma35, amount_ma60, amount_ma120,
                                amount_ma200, amount_ma240, amount_ma34, 五日總量交叉成功, 十日總量交叉成功, 二十日總量交叉成功,
                                三十五日總量交叉成功, 六十日總量交叉成功, 一百二十日總量交叉成功, 二百日總量交叉成功,
                                二百四十日總量交叉成功, 總量黃金交叉次數, 投信_ma5, 投信_ma10, 投信_ma20, 投信_ma35, 投信_ma60,
                                投信_ma120, 投信_ma200, 投信_ma240, 投信_ma34, 五日投信交叉成功, 十日投信交叉成功, 二十日投信交叉成功,
                                三十五日投信交叉成功, 六十日投信交叉成功, 一百二十日投信交叉成功, 二百日投信交叉成功,
                                二百四十日投信交叉成功, 投信黃金交叉次數, 外資_ma5, 外資_ma10, 外資_ma20, 外資_ma35, 外資_ma60,
                                外資_ma120, 外資_ma200, 外資_ma240, 外資_ma34, 五日外資交叉成功, 十日外資交叉成功, 二十日外資交叉成功,
                                三十五日外資交叉成功, 六十日外資交叉成功, 一百二十日外資交叉成功, 二百日外資交叉成功,
                                二百四十日外資交叉成功, 外資黃金交叉次數, 三大法人_ma5, 三大法人_ma10, 三大法人_ma20, 三大法人_ma35,
                                三大法人_ma60, 三大法人_ma120, 三大法人_ma200, 三大法人_ma240, 三大法人_ma34, 五日三大法人交叉成功,
                                十日三大法人交叉成功, 二十日三大法人交叉成功, 三十五日三大法人交叉成功, 六十日三大法人交叉成功,
                                一百二十日三大法人交叉成功, 二百日三大法人交叉成功, 二百四十日三大法人交叉成功,
                                三大法人黃金交叉次數
FROM              allcross
WHERE          (代號 = 2330)
ORDER BY   日期 DESC` },

              {
                  cat: "漲幅選股", title: "近10期價量漲幅", sql: `priceincrease1.名稱, priceincrease1.代號,
                                                   View_stockchange.成交價, View_stockchange.漲幅, View_stockchange.總量,
                                                   priceincrease1.成交價漲幅百分比 AS 近2期價漲幅,
                                                   priceincrease2.成交價漲幅百分比 AS 近3期價漲幅,
                                                   priceincrease3.成交價漲幅百分比 AS 近4期價漲幅,
                                                   priceincrease4.成交價漲幅百分比 AS 近5期價漲幅,
                                                   priceincrease5.成交價漲幅百分比 AS 近6期價漲幅,
                                                   priceincrease6.成交價漲幅百分比 AS 近7期價漲幅,
                                                   priceincrease7.成交價漲幅百分比 AS 近8期價漲幅,
                                                   priceincrease8.成交價漲幅百分比 AS 近9期價漲幅,
                                                   priceincrease9.成交價漲幅百分比 AS 近10期價漲幅,
                                                   priceincrease10.成交價漲幅百分比 AS 近11期價漲幅,
                                                   View_stockchange.產業分類, View_stockchange.交易所分類,
                                                   View_stockchange.股本億,
                                                   STRING_AGG(View_notioninfo.name1, ', ') AS 概念股
                                            FROM priceincrease1
                                            INNER JOIN priceincrease4 ON priceincrease1.代號 = priceincrease4.代號
                                            LEFT OUTER JOIN priceincrease5 ON priceincrease1.代號 = priceincrease5.代號
                                            LEFT OUTER JOIN priceincrease6 ON priceincrease1.代號 = priceincrease6.代號
                                            LEFT OUTER JOIN priceincrease7 ON priceincrease1.代號 = priceincrease7.代號
                                            LEFT OUTER JOIN priceincrease8 ON priceincrease1.代號 = priceincrease8.代號
                                            LEFT OUTER JOIN priceincrease9 ON priceincrease1.代號 = priceincrease9.代號
                                            LEFT OUTER JOIN priceincrease10 ON priceincrease1.代號 = priceincrease10.代號
                                            LEFT OUTER JOIN View_stockchange ON priceincrease1.代號 = View_stockchange.代號
                                            LEFT OUTER JOIN View_notioninfo ON priceincrease1.名稱 = View_notioninfo.mail1
                                            LEFT OUTER JOIN priceincrease3 ON priceincrease1.代號 = priceincrease3.代號
                                            LEFT OUTER JOIN priceincrease2 ON priceincrease1.代號 = priceincrease2.代號
                                            GROUP BY priceincrease1.名稱, priceincrease1.代號,
                                                     View_stockchange.成交價, View_stockchange.漲幅, View_stockchange.總量,
                                                     priceincrease1.成交價漲幅百分比, priceincrease2.成交價漲幅百分比, priceincrease3.成交價漲幅百分比,
                                                     priceincrease4.成交價漲幅百分比, priceincrease5.成交價漲幅百分比, priceincrease6.成交價漲幅百分比,
                                                     priceincrease7.成交價漲幅百分比, priceincrease8.成交價漲幅百分比, priceincrease9.成交價漲幅百分比,
                                                     priceincrease10.成交價漲幅百分比, View_stockchange.產業分類,
                                                     View_stockchange.交易所分類, View_stockchange.股本億
                                            ORDER BY 近4期價漲幅 DESC` },
              {
                  cat: "漲幅選股", title: "自選股近10期價量漲幅", sql: `priceincrease1.名稱, priceincrease1.代號,
                                                            ROUND(priceincrease10.成交價漲幅百分比 - priceincrease4.成交價漲幅百分比, 2) AS 前8期漲幅,
                                                            ROUND(priceincrease10.成交量漲幅百分比 - priceincrease4.成交量漲幅百分比, 2) AS 近3期量增幅,
                                                            View_stockchange.成交價, View_stockchange.漲幅, View_stockchange.總量,
                                                            priceincrease1.成交價漲幅百分比 AS 近2期價漲幅, priceincrease2.成交價漲幅百分比 AS 近3期價漲幅,
                                                            priceincrease3.成交價漲幅百分比 AS 近4期價漲幅, priceincrease4.成交價漲幅百分比 AS 近5期價漲幅,
                                                            priceincrease5.成交價漲幅百分比 AS 近6期價漲幅, priceincrease6.成交價漲幅百分比 AS 近7期價漲幅,
                                                            priceincrease7.成交價漲幅百分比 AS 近8期價漲幅, priceincrease8.成交價漲幅百分比 AS 近9期價漲幅,
                                                            priceincrease9.成交價漲幅百分比 AS 近10期價漲幅, priceincrease10.成交價漲幅百分比 AS 近11期價漲幅,
                                                            priceincrease1.成交量漲幅百分比 AS 近2期量漲幅, priceincrease2.成交量漲幅百分比 AS 近3期量漲幅,
                                                            priceincrease3.成交量漲幅百分比 AS 近4期量漲幅, priceincrease4.成交量漲幅百分比 AS 近5期量漲幅,
                                                            View_stockchange.產業分類, View_stockchange.交易所分類, View_stockchange.股本億, priceincrease1.本日 AS 今日,
                                                            priceincrease10.前一日 AS 前日,STRING_AGG(View_notioninfo.name1, ', ') AS 概念股
FROM              priceincrease1 INNER JOIN
                                                            priceincrease4 ON priceincrease1.代號 = priceincrease4.代號 LEFT OUTER JOIN
                                                            priceincrease5 ON priceincrease1.代號 = priceincrease5.代號 LEFT OUTER JOIN
                                                            priceincrease6 ON priceincrease1.代號 = priceincrease6.代號 LEFT OUTER JOIN
                                                            priceincrease7 ON priceincrease1.代號 = priceincrease7.代號 LEFT OUTER JOIN
                                                            priceincrease8 ON priceincrease1.代號 = priceincrease8.代號 LEFT OUTER JOIN
                                                            priceincrease9 ON priceincrease1.代號 = priceincrease9.代號 LEFT OUTER JOIN
                                                            priceincrease10 ON priceincrease1.代號 = priceincrease10.代號 LEFT OUTER JOIN
                                                            View_stockchange ON priceincrease1.代號 = View_stockchange.代號 LEFT OUTER JOIN
                                                            View_notioninfo ON priceincrease1.名稱 = View_notioninfo.mail1 LEFT OUTER JOIN
                                                            priceincrease3 ON priceincrease1.代號 = priceincrease3.代號 LEFT OUTER JOIN
                                                            priceincrease2 ON priceincrease1.代號 = priceincrease2.代號
WHERE  priceincrease1.代號 IN (SELECT          代號
                                                                  FROM               incomechar)
GROUP BY priceincrease1.名稱, priceincrease1.代號,
                                                            ROUND(priceincrease10.成交價漲幅百分比 - priceincrease4.成交價漲幅百分比, 2),
                                                            ROUND(priceincrease10.成交量漲幅百分比 - priceincrease4.成交量漲幅百分比, 2),
                                                            View_stockchange.成交價, View_stockchange.漲幅, View_stockchange.總量,
                                                            priceincrease1.成交價漲幅百分比, priceincrease2.成交價漲幅百分比,
                                                            priceincrease3.成交價漲幅百分比, priceincrease4.成交價漲幅百分比,
                                                            priceincrease5.成交價漲幅百分比, priceincrease6.成交價漲幅百分比,
                                                            priceincrease7.成交價漲幅百分比, priceincrease8.成交價漲幅百分比,
                                                            priceincrease9.成交價漲幅百分比, priceincrease10.成交價漲幅百分比,
                                                            priceincrease1.成交量漲幅百分比, priceincrease2.成交量漲幅百分比,
                                                            priceincrease3.成交量漲幅百分比, priceincrease4.成交量漲幅百分比,
                                                            View_stockchange.產業分類, View_stockchange.交易所分類, View_stockchange.股本億, priceincrease1.本日,
                                                            priceincrease10.前一日
ORDER BY   近4期價漲幅 DESC` },
              {
                  cat: "漲幅選股", title: "剛起漲", sql: `priceincrease1.名稱, priceincrease1.代號,ROUND(priceincrease10.成交價漲幅百分比 - priceincrease4.成交價漲幅百分比, 2) AS 前8期漲幅,
                                                        ROUND(priceincrease10.成交量漲幅百分比 - priceincrease4.成交量漲幅百分比, 2) AS 近3期量增幅,
                                                        View_stockchange.成交價, View_stockchange.漲幅, View_stockchange.總量,
                                                        priceincrease1.成交價漲幅百分比 AS 近2期價漲幅, priceincrease2.成交價漲幅百分比 AS 近3期價漲幅,
                                                        priceincrease3.成交價漲幅百分比 AS 近4期價漲幅, priceincrease4.成交價漲幅百分比 AS 近5期價漲幅,
                                                        priceincrease5.成交價漲幅百分比 AS 近6期價漲幅, priceincrease6.成交價漲幅百分比 AS 近7期價漲幅,
                                                        priceincrease7.成交價漲幅百分比 AS 近8期價漲幅, priceincrease8.成交價漲幅百分比 AS 近9期價漲幅,
                                                        priceincrease9.成交價漲幅百分比 AS 近10期價漲幅, priceincrease10.成交價漲幅百分比 AS 近11期價漲幅,
                                                        priceincrease1.成交量漲幅百分比 AS 近2期量漲幅, priceincrease2.成交量漲幅百分比 AS 近3期量漲幅,
                                                        priceincrease3.成交量漲幅百分比 AS 近4期量漲幅, priceincrease4.成交量漲幅百分比 AS 近5期量漲幅,
                                                        priceincrease5.成交量漲幅百分比 AS 近6期量漲幅, priceincrease6.成交量漲幅百分比 AS 近7期量漲幅,
                                                        priceincrease7.成交量漲幅百分比 AS 近8期量漲幅, priceincrease8.成交量漲幅百分比 AS 近9期量漲幅,
                                                        priceincrease9.成交量漲幅百分比 AS 近10期量漲幅, priceincrease10.成交量漲幅百分比 AS 近11期量漲幅,
                                                        View_stockchange.產業分類, View_stockchange.交易所分類, View_stockchange.股本億, priceincrease1.本日 AS 今日,
                                                        priceincrease10.前一日 AS 前日
FROM              priceincrease1 INNER JOIN
                                                        priceincrease4 ON priceincrease1.代號 = priceincrease4.代號 LEFT OUTER JOIN
                                                        priceincrease5 ON priceincrease1.代號 = priceincrease5.代號 LEFT OUTER JOIN
                                                        priceincrease6 ON priceincrease1.代號 = priceincrease6.代號 LEFT OUTER JOIN
                                                        priceincrease7 ON priceincrease1.代號 = priceincrease7.代號 LEFT OUTER JOIN
                                                        priceincrease8 ON priceincrease1.代號 = priceincrease8.代號 LEFT OUTER JOIN
                                                        priceincrease9 ON priceincrease1.代號 = priceincrease9.代號 LEFT OUTER JOIN
                                                        priceincrease10 ON priceincrease1.代號 = priceincrease10.代號 LEFT OUTER JOIN
                                                        View_stockchange ON priceincrease1.代號 = View_stockchange.代號 LEFT OUTER JOIN
                                                        priceincrease3 ON priceincrease1.代號 = priceincrease3.代號 LEFT OUTER JOIN
                                                        priceincrease2 ON priceincrease1.代號 = priceincrease2.代號
WHERE  priceincrease1.代號 IN ((SELECT          代號
                                                              FROM               incomechar8)) and (priceincrease3.成交價漲幅百分比 < 15) AND (priceincrease3.成交價漲幅百分比 > -3) and
                                                        (priceincrease10.成交價漲幅百分比 - priceincrease4.成交價漲幅百分比 < 3)  and (priceincrease10.成交價漲幅百分比 - priceincrease4.成交價漲幅百分比 > -5 ) AND
                                                        (priceincrease3.成交量漲幅百分比 > 50) and View_stockchange.總量>500
ORDER BY   近4期價漲幅 DESC` },

              {
                  cat: "漲幅選股", title: "剛起漲-自選股", sql: `priceincrease1.名稱, priceincrease1.代號,
                                                            ROUND(priceincrease10.成交價漲幅百分比 - priceincrease4.成交價漲幅百分比, 2) AS 前8期漲幅,
                                                            ROUND(priceincrease10.成交量漲幅百分比 - priceincrease4.成交量漲幅百分比, 2) AS 近3期量增幅,
                                                            View_stockchange.成交價, View_stockchange.漲幅, View_stockchange.總量,
                                                            priceincrease1.成交價漲幅百分比 AS 近2期價漲幅, priceincrease2.成交價漲幅百分比 AS 近3期價漲幅,
                                                            priceincrease3.成交價漲幅百分比 AS 近4期價漲幅, priceincrease4.成交價漲幅百分比 AS 近5期價漲幅,
                                                            priceincrease5.成交價漲幅百分比 AS 近6期價漲幅, priceincrease6.成交價漲幅百分比 AS 近7期價漲幅,
                                                            priceincrease7.成交價漲幅百分比 AS 近8期價漲幅, priceincrease8.成交價漲幅百分比 AS 近9期價漲幅,
                                                            priceincrease9.成交價漲幅百分比 AS 近10期價漲幅, priceincrease10.成交價漲幅百分比 AS 近11期價漲幅,
                                                            priceincrease1.成交量漲幅百分比 AS 近2期量漲幅, priceincrease2.成交量漲幅百分比 AS 近3期量漲幅,
                                                            priceincrease3.成交量漲幅百分比 AS 近4期量漲幅, priceincrease4.成交量漲幅百分比 AS 近5期量漲幅,
                                                            View_stockchange.產業分類, View_stockchange.交易所分類, View_stockchange.股本億, priceincrease1.本日 AS 今日,
                                                            priceincrease10.前一日 AS 前日,STRING_AGG(View_notioninfo.name1, ', ') AS 概念股
FROM              priceincrease1 INNER JOIN
                                                            priceincrease4 ON priceincrease1.代號 = priceincrease4.代號 LEFT OUTER JOIN
                                                            priceincrease5 ON priceincrease1.代號 = priceincrease5.代號 LEFT OUTER JOIN
                                                            priceincrease6 ON priceincrease1.代號 = priceincrease6.代號 LEFT OUTER JOIN
                                                            priceincrease7 ON priceincrease1.代號 = priceincrease7.代號 LEFT OUTER JOIN
                                                            priceincrease8 ON priceincrease1.代號 = priceincrease8.代號 LEFT OUTER JOIN
                                                            priceincrease9 ON priceincrease1.代號 = priceincrease9.代號 LEFT OUTER JOIN
                                                            priceincrease10 ON priceincrease1.代號 = priceincrease10.代號 LEFT OUTER JOIN
                                                            View_stockchange ON priceincrease1.代號 = View_stockchange.代號 LEFT OUTER JOIN
                                                            View_notioninfo ON priceincrease1.名稱 = View_notioninfo.mail1 LEFT OUTER JOIN
                                                            priceincrease3 ON priceincrease1.代號 = priceincrease3.代號 LEFT OUTER JOIN
                                                            priceincrease2 ON priceincrease1.代號 = priceincrease2.代號
WHERE  priceincrease1.代號 IN (SELECT          代號
                                                                  FROM               incomechar)
GROUP BY priceincrease1.名稱, priceincrease1.代號,
                                                            ROUND(priceincrease10.成交價漲幅百分比 - priceincrease4.成交價漲幅百分比, 2),
                                                            ROUND(priceincrease10.成交量漲幅百分比 - priceincrease4.成交量漲幅百分比, 2),
                                                            View_stockchange.成交價, View_stockchange.漲幅, View_stockchange.總量,
                                                            priceincrease1.成交價漲幅百分比, priceincrease2.成交價漲幅百分比,
                                                            priceincrease3.成交價漲幅百分比, priceincrease4.成交價漲幅百分比,
                                                            priceincrease5.成交價漲幅百分比, priceincrease6.成交價漲幅百分比,
                                                            priceincrease7.成交價漲幅百分比, priceincrease8.成交價漲幅百分比,
                                                            priceincrease9.成交價漲幅百分比, priceincrease10.成交價漲幅百分比,
                                                            priceincrease1.成交量漲幅百分比, priceincrease2.成交量漲幅百分比,
                                                            priceincrease3.成交量漲幅百分比, priceincrease4.成交量漲幅百分比,
                                                            View_stockchange.產業分類, View_stockchange.交易所分類, View_stockchange.股本億, priceincrease1.本日,
                                                            priceincrease10.前一日
ORDER BY   近4期價漲幅 DESC` },
              {
                  cat: "漲幅選股", title: "盤中剛起漲-自選股", sql: `obv盤中選股.名稱, obv盤中選股.代號,
                                                            ROUND(priceincrease10.成交價漲幅百分比 - priceincrease4.成交價漲幅百分比, 2) AS 前8期漲幅,
                                                            ROUND(priceincrease10.成交量漲幅百分比 - priceincrease4.成交量漲幅百分比, 2) AS 近3期量增幅,
                                                            priceincrease3.成交價漲幅百分比 AS 近4期價漲幅, View_stockchange.成交價, View_stockchange.漲幅,
                                                            obv盤中選股.盤中成交價, obv盤中選股.最高, obv盤中選股.最低, obv盤中選股.總量,
                                                            obv計算黃金交叉次數.obv黃金交叉次數, obv盤中選股.前一日累積obv成交量, obv盤中選股.盤中的單日obv均量,
                                                            obv盤中選股.盤中的累積obv均量, obv盤中選股.盤中計算出來的最新三十四日平均線,
                                                            ROUND((obv盤中選股.盤中的累積obv均量 - obv盤中選股.盤中計算出來的最新三十四日平均線)
                                                            / ABS(obv盤中選股.盤中計算出來的最新三十四日平均線) * 100, 2) AS 盤中離34日均線乖離率,
                                                            obv盤中選股.盤中的累積obv均量 - obv盤中選股.盤中計算出來的最新三十四日平均線 AS 站上34日均線張數,
                                                            View_stockchange.產業分類, View_stockchange.交易所分類, View_stockchange.上市1上櫃2,
                                                            View_stockchange.股本億, obv盤中選股.盤中計算出來的最新五日平均線,
                                                            ROUND((obv盤中選股.盤中的累積obv均量 - obv盤中選股.盤中計算出來的最新五日平均線)
                                                            / ABS(obv盤中選股.盤中計算出來的最新五日平均線) * 100, 2) AS 盤中離5日均線乖離率,
                                                            obv盤中選股.盤中的累積obv均量 - obv盤中選股.盤中計算出來的最新五日平均線 AS 站上五日平均線張數,STRING_AGG(View_notioninfo.name1, ', ') AS 概念股
FROM              obv盤中選股 INNER JOIN
                                                            View_stockchange ON obv盤中選股.代號 = View_stockchange.代號 INNER JOIN
                                                            obv計算黃金交叉次數 ON obv盤中選股.代號 = obv計算黃金交叉次數.代號 LEFT OUTER JOIN
                                                            View_notioninfo ON obv盤中選股.名稱 = View_notioninfo.mail1 INNER JOIN
                                                            priceincrease1 ON obv盤中選股.代號 = priceincrease1.代號 INNER JOIN
                                                            priceincrease4 ON obv盤中選股.代號 = priceincrease4.代號 INNER JOIN
                                                            priceincrease5 ON obv盤中選股.代號 = priceincrease5.代號 INNER JOIN
                                                            priceincrease6 ON obv盤中選股.代號 = priceincrease6.代號 INNER JOIN
                                                            priceincrease7 ON obv盤中選股.代號 = priceincrease7.代號 INNER JOIN
                                                            priceincrease8 ON obv盤中選股.代號 = priceincrease8.代號 INNER JOIN
                                                            priceincrease9 ON obv盤中選股.代號 = priceincrease9.代號 INNER JOIN
                                                            priceincrease10 ON obv盤中選股.代號 = priceincrease10.代號 INNER JOIN
                                                            priceincrease3 ON obv盤中選股.代號 = priceincrease3.代號 INNER JOIN
                                                            priceincrease2 ON obv盤中選股.代號 = priceincrease2.代號
WHERE          (obv盤中選股.盤中計算出來的最新三十四日平均線 <> 0) AND (View_stockchange.代號 IN
                                                                (SELECT          代號
                                                                  FROM               incomechar)) AND (obv計算黃金交叉次數.日期 =
                                                                (SELECT          TOP (1) MAX(日期) AS Expr1
                                                                  FROM               basicinfo AS basicinfo_1)) AND (obv盤中選股.盤中計算出來的最新五日平均線 <> 0)
GROUP BY obv盤中選股.名稱, obv盤中選股.代號,
                                                            ROUND(priceincrease10.成交價漲幅百分比 - priceincrease4.成交價漲幅百分比, 2),
                                                            ROUND(priceincrease10.成交量漲幅百分比 - priceincrease4.成交量漲幅百分比, 2),
                                                            priceincrease3.成交價漲幅百分比, View_stockchange.成交價, View_stockchange.漲幅,
                                                            obv盤中選股.盤中成交價, obv盤中選股.最高, obv盤中選股.最低, obv盤中選股.總量,
                                                            obv計算黃金交叉次數.obv黃金交叉次數, obv盤中選股.前一日累積obv成交量, obv盤中選股.盤中的單日obv均量,
                                                            obv盤中選股.盤中的累積obv均量, obv盤中選股.盤中計算出來的最新三十四日平均線,
                                                            ROUND((obv盤中選股.盤中的累積obv均量 - obv盤中選股.盤中計算出來的最新三十四日平均線)
                                                            / ABS(obv盤中選股.盤中計算出來的最新三十四日平均線) * 100, 2),
                                                            obv盤中選股.盤中的累積obv均量 - obv盤中選股.盤中計算出來的最新三十四日平均線,
                                                            View_stockchange.產業分類, View_stockchange.交易所分類, View_stockchange.上市1上櫃2,
                                                            View_stockchange.股本億, obv盤中選股.盤中計算出來的最新五日平均線,
                                                            ROUND((obv盤中選股.盤中的累積obv均量 - obv盤中選股.盤中計算出來的最新五日平均線)
                                                            / ABS(obv盤中選股.盤中計算出來的最新五日平均線) * 100, 2),
                                                            obv盤中選股.盤中的累積obv均量 - obv盤中選股.盤中計算出來的最新五日平均線
ORDER BY   站上五日平均線張數 DESC` },
              {
                  cat: "漲幅選股", title: "盤中+OBV+自選股+概念股", sql: `obv盤中選股.名稱, obv盤中選股.代號, View_stockchange.漲幅,
                                                            obv盤中選股.盤中成交價, obv盤中選股.最高, obv盤中選股.最低, obv盤中選股.總量,
                                                            obv計算黃金交叉次數.obv黃金交叉次數, obv盤中選股.前一日累積obv成交量, obv盤中選股.盤中的單日obv均量,
                                                            obv盤中選股.盤中的累積obv均量, obv盤中選股.盤中計算出來的最新三十四日平均線,
                                                            ROUND((obv盤中選股.盤中的累積obv均量 - obv盤中選股.盤中計算出來的最新三十四日平均線)
                                                            / ABS(obv盤中選股.盤中計算出來的最新三十四日平均線) * 100, 2) AS 盤中離34日均線乖離率,
                                                            obv盤中選股.盤中的累積obv均量 - obv盤中選股.盤中計算出來的最新三十四日平均線 AS 站上34日均線張數,
                                                            View_stockchange.產業分類, View_stockchange.交易所分類, View_stockchange.上市1上櫃2,
                                                            View_stockchange.股本億, obv盤中選股.盤中計算出來的最新五日平均線,
                                                            ROUND((obv盤中選股.盤中的累積obv均量 - obv盤中選股.盤中計算出來的最新五日平均線)
                                                            / ABS(obv盤中選股.盤中計算出來的最新五日平均線) * 100, 2) AS 盤中離5日均線乖離率,
                                                            obv盤中選股.盤中的累積obv均量 - obv盤中選股.盤中計算出來的最新五日平均線 AS 站上五日平均線張數,STRING_AGG(View_notioninfo.name1, ', ') AS 概念股
FROM              obv盤中選股 INNER JOIN
                                                            View_stockchange ON obv盤中選股.代號 = View_stockchange.代號 INNER JOIN
                                                            obv計算黃金交叉次數 ON obv盤中選股.代號 = obv計算黃金交叉次數.代號 LEFT OUTER JOIN
                                                            View_notioninfo ON obv盤中選股.名稱 = View_notioninfo.mail1
WHERE          (obv盤中選股.盤中計算出來的最新三十四日平均線 <> 0) AND (View_stockchange.代號 IN
                                                                (SELECT          代號
                                                                  FROM               incomechar)) AND (obv計算黃金交叉次數.日期 =
                                                                (SELECT          TOP (1) MAX(日期) AS Expr1
                                                                  FROM               basicinfo AS basicinfo_1)) AND (obv盤中選股.盤中計算出來的最新五日平均線 <> 0)
GROUP BY obv盤中選股.名稱, obv盤中選股.代號, View_stockchange.漲幅,
                                                            obv盤中選股.盤中成交價, obv盤中選股.最高, obv盤中選股.最低, obv盤中選股.總量,
                                                            obv計算黃金交叉次數.obv黃金交叉次數, obv盤中選股.前一日累積obv成交量, obv盤中選股.盤中的單日obv均量,
                                                            obv盤中選股.盤中的累積obv均量, obv盤中選股.盤中計算出來的最新三十四日平均線,
                                                            ROUND((obv盤中選股.盤中的累積obv均量 - obv盤中選股.盤中計算出來的最新三十四日平均線)
                                                            / ABS(obv盤中選股.盤中計算出來的最新三十四日平均線) * 100, 2),
                                                            obv盤中選股.盤中的累積obv均量 - obv盤中選股.盤中計算出來的最新三十四日平均線,
                                                            View_stockchange.產業分類, View_stockchange.交易所分類, View_stockchange.上市1上櫃2,
                                                            View_stockchange.股本億, obv盤中選股.盤中計算出來的最新五日平均線,
                                                            ROUND((obv盤中選股.盤中的累積obv均量 - obv盤中選股.盤中計算出來的最新五日平均線)
                                                            / ABS(obv盤中選股.盤中計算出來的最新五日平均線) * 100, 2),
                                                            obv盤中選股.盤中的累積obv均量 - obv盤中選股.盤中計算出來的最新五日平均線
ORDER BY   站上五日平均線張數 DESC` },

              { cat: "漲幅選股", title: "盤中漲幅TOP100", sql: `/*資料庫:stockchange*/top 100 名稱,代號,成交價,漲跌,漲幅,總量,產業分類,交易所分類,上市1上櫃2,	上市櫃年數,股本億,市值億 from basicinfo order by 漲幅 desc` },
              { cat: "漲幅選股", title: "預存程式前N日至最新日", sql: `https://zen2965.duckdns.org:8888/excelimport/excelimport2 中第29項可查詢` },
              {
                  cat: "預存程序", title: "兩日間之漲幅", sql: `/*資料庫選:stockchangedate,執行前要把備註刪除,否則會出現錯誤 */
                    exec stockpriceincrease 20260408,20260410` },
              {
                  cat: "預存程序", title: "兩日間之股權漲幅in自選股", sql: `/*資料庫選:stockprice,自選股0~自選股5:myequityselfselect~myequityselfselect5,日期以週五為原則,執行前要把備註刪除,否則會出現錯誤,400張以上大戶增加比率(彙總表第29項) */
         exec myequityselfselect 20260327,20260410, N'2330'` },
              {
                  cat: "預存程序", title: "兩日間之股權漲幅in自選股", sql: `/*資料庫選:stockprice,自選股0~自選股5:myequityselfselect~myequityselfselect5,日期以週五為原則,執行前要把備註刪除,否則會出現錯誤,400張以上大戶增加比率(彙總表第29項) */
                    exec myequityselfselect2 20260327,20260410, N'2330'` },
              {
                  cat: "預存程序", title: "兩日間之股權變動1", sql: `/*資料庫選:stockprice,執行前要把備註刪除,否則會出現錯誤,400張以上大戶增加比率(彙總表第29項) */
exec myequity1 20260327,20260410, N'2330'` },
              {
                  cat: "預存程序", title: "兩日間之股權變動2", sql: `/*資料庫選:stockprice,日期以週五為原則,執行前要把備註刪除,否則會出現錯誤,400張以上大戶增加比率(彙總表第29項) */
exec myequity2 20260327,20260410, N'2330'` },


              { cat: "黃金交叉次數", title: "黃金交叉次數選股", sql: `TOP (100) PERCENT dbo.winnewdate.股票名稱, dbo.winnewdate.股票代號, dbo.winnewdate.站均, dbo.winnewdate.均價黃金交叉次數, dbo.winnewdate.均量黃金交叉次數, dbo.winnewdate.三大法人黃金交叉次數, dbo.winnewdate.外資黃金交叉次數, dbo.winnewdate.投信黃金交叉次數, dbo.winnewdate.k9, dbo.winnewdate.d9, dbo.winnewdate.週k9, dbo.winnewdate.週d9, dbo.winnewdate.月k9, dbo.winnewdate.月d9, dbo.winnewdate.macd, dbo.winnewdate.資使用率, dbo.winnewdate.資使用率黃金交叉次數, dbo.winnewdate.券使用率, dbo.winnewdate.券使用率黃金交叉次數, dbo.winnewdate.券資比, dbo.winnewdate.券資比黃金交叉次數, dbo.winnewdate.產業分類, dbo.winnewdate.交易所分類, dbo.winnewdate.股本億, dbo.winnewdate.日期 FROM dbo.winnewdate INNER JOIN dbo.View_basicinfo ON dbo.winnewdate.股票代號 = dbo.View_basicinfo.代號 WHERE (dbo.View_basicinfo.總量 > 5000) AND (dbo.winnewdate.日期 = 20260327) AND (dbo.winnewdate.均價黃金交叉次數 > 0) AND (dbo.winnewdate.均量黃金交叉次數 >= 0) AND (dbo.winnewdate.k9 - dbo.winnewdate.d9 >= 0) AND (dbo.winnewdate.macd > 0) ORDER BY dbo.winnewdate.均價黃金交叉次數 DESC, dbo.winnewdate.均量黃金交叉次數 DESC, dbo.winnewdate.三大法人黃金交叉次數 DESC` },
              {
                  cat: "黃金交叉次數", title: "均價黃金交叉+加權後分數", sql: `TOP (100) PERCENT dbo.winnewdate.股票名稱, dbo.winnewdate.股票代號, dbo.winnewdate.站均, dbo.winnewdate.均價黃金交叉次數, dbo.winnewdate.均量黃金交叉次數, dbo.winnewdate.三大法人黃金交叉次數, dbo.winnewdate.外資黃金交叉次數, dbo.winnewdate.投信黃金交叉次數, dbo.winnewdate.k9, dbo.winnewdate.d9, dbo.winnewdate.週k9, dbo.winnewdate.週d9, dbo.winnewdate.月k9, dbo.winnewdate.月d9, dbo.winnewdate.macd, dbo.winnewdate.資使用率, dbo.winnewdate.資使用率黃金交叉次數, dbo.winnewdate.券使用率, dbo.winnewdate.券使用率黃金交叉次數, dbo.winnewdate.券資比, dbo.winnewdate.券資比黃金交叉次數, dbo.winnewdate.產業分類, dbo.winnewdate.交易所分類, dbo.winnewdate.股本億, dbo.winnewdate.日期 FROM dbo.winnewdate INNER JOIN dbo.View_basicinfo ON dbo.winnewdate.股票代號 = dbo.View_basicinfo.代號 WHERE (dbo.View_basicinfo.總量 > 5000) AND (dbo.winnewdate.日期 = 20260327) AND (dbo.winnewdate.均價黃金交叉次數 > 0) AND (dbo.winnewdate.均量黃金交叉次數 >= 0) AND (dbo.winnewdate.k9 - dbo.winnewdate.d9 >= 0) AND (dbo.winnewdate.macd > 0) ORDER BY dbo.winnewdate.均價黃金交叉次數 DESC, dbo.winnewdate.均量黃金交叉次數 DESC, dbo.winnewdate.三大法人黃金交叉次數 DESC,
                                                            dbo.winnewdate.均價黃金交叉次數, dbo.winnewdate.集中度1日, dbo.winnewdate.正負DI百分比,
                                                            dbo.winnewdate.三週庫存比率 / 100 AS [三週庫存比率/100], dbo.winnewdate.日期,
                                                            dbo.winnewdate.k9 - dbo.winnewdate.d9 AS 日kd差, dbo.winnewdate.週k9 - dbo.winnewdate.週d9 AS 週kd差,
                                                            dbo.winnewdate.月k9 - dbo.winnewdate.月d9 AS 月kd差,
                                                            ROUND((((((((dbo.winnewdate.均價黃金交叉次數 + dbo.winnewdate.k9 / 5) - dbo.winnewdate.d9 / 5)
                                                            + dbo.winnewdate.週k9 / 5) - dbo.winnewdate.週d9 / 5) + dbo.winnewdate.月k9 / 5) - dbo.winnewdate.月d9 / 5)
                                                            + dbo.winnewdate.合計十天 / 10) + dbo.winnewdate.三週庫存比率 / 100, 2) AS 總分
FROM              dbo.winnewdate INNER JOIN
                                                            dbo.basicinfo ON dbo.winnewdate.股票代號 = dbo.basicinfo.代號 AND
                                                            dbo.winnewdate.日期 = dbo.basicinfo.日期
WHERE          (dbo.winnewdate.k9 - dbo.winnewdate.d9 > 0) AND (dbo.winnewdate.日期 =
                                                                (SELECT          TOP (1) MAX(日期) AS Expr1
                                                                  FROM               dbo.basicinfo AS basicinfo_1)) AND (dbo.winnewdate.週k9 - dbo.winnewdate.週d9 > 0) AND
                                                            (dbo.winnewdate.月k9 - dbo.winnewdate.月d9 > 0) AND (dbo.winnewdate.正負DI百分比 > 100) AND
                                                            (dbo.winnewdate.均價黃金交叉次數 > 0) AND (dbo.basicinfo.總量 >  5000)
ORDER BY   ROUND((((((((dbo.winnewdate.均價黃金交叉次數 + dbo.winnewdate.k9 / 5) - dbo.winnewdate.d9 / 5)
                                                            + dbo.winnewdate.週k9 / 5) - dbo.winnewdate.週d9 / 5) + dbo.winnewdate.月k9 / 5) - dbo.winnewdate.月d9 / 5)
                                                            + dbo.winnewdate.合計十天 / 10) + dbo.winnewdate.三週庫存比率 / 100, 2) DESC`
              },
              {
                  cat: "黃金交叉次數", title: "OBV多空淨額(量)+均線交叉情況", sql: `代號, 名稱, 成交價, 總量, 最高, 最低, obv淨額, 五日平均線, 十日平均線, 二十日平均線, 三十四日平均線,
                                                            ROUND((obv淨額 - 五日平均線) / ABS(五日平均線), 2) AS 五日乖離, ROUND((obv淨額 - 十日平均線)
                                                            / ABS(十日平均線), 2) AS 十日乖離, ROUND((obv淨額 - 二十日平均線) / ABS(二十日平均線), 2) AS 二十日乖離,
                                                            ROUND((obv淨額 - 三十四日平均線) / ABS(三十四日平均線), 2) AS 三十四日乖離, ROUND((五日平均線 - 十日平均線)
                                                            / ABS(十日平均線), 2) AS 五日與十日黃金交叉, round((十日平均線 - 二十日平均線) / ABS(二十日平均線),2)
                                                            AS 十日與二十日黃金交叉, ROUND((二十日平均線 - 三十四日平均線) / ABS(三十四日平均線), 2)
                                                            AS 二十日與三十四日黃金交叉, 日期
FROM              obvdatea5
WHERE          (代號 = N'2330') AND (日期 >= 20250101)
order by 日期 desc`
              },
              { cat: "黃金交叉次數", title: "成交價黃金交叉增加最多(列出最近四天)", sql: `TOP 50 股票名稱, 股票代號, 成交價, 漲幅, 總量, 近4期均價合計, 近4期均量合計, 產業分類, 交易所分類, 股本億, 日期, 近1期均價, 近2期均價, 近3期均價, 近4期均價, 近1期均量, 近2期均量, 近3期均量, 近4期均量, ROW_NUMBER() OVER (ORDER BY 近4期均價合計 desc) AS 流水號 FROM winnewdatechange WHERE (總量 >= 1000)  and 日期 = 20260327 ORDER BY 近4期均價合計 DESC,近4期均量合計 DESC` },
              { cat: "黃金交叉次數", title: "成交量黃金交叉增加最多(列出最近四天)", sql: `TOP 50 股票名稱, 股票代號, 成交價, 漲幅, 總量, 近4期均價合計, 近4期均量合計, 產業分類, 交易所分類, 股本億, 日期, 近1期均價, 近2期均價, 近3期均價, 近4期均價, 近1期均量, 近2期均量, 近3期均量, 近4期均量, ROW_NUMBER() OVER (ORDER BY 近4期均量合計 desc) AS 流水號 FROM winnewdatechange WHERE (總量 >= 5000) ORDER BY 近4期均量合計 DESC,近4期均價合計 DESC` },
              { cat: "黃金交叉次數", title: "三大法人黃金交叉增加最多(列出最近四天) ", sql: `TOP 50 dbo.View_day1winnew.股票名稱, dbo.View_day1winnew.股票代號, dbo.View_stockchange.成交價, dbo.View_stockchange.漲幅, dbo.View_stockchange.總量, (((dbo.View_day1winnew.三大法人1黃金交叉次數 - dbo.View_day2winnew.三大法人2黃金交叉次數) + (dbo.View_day2winnew.三大法人2黃金交叉次數 - dbo.View_day3winnew.三大法人3黃金交叉次數)) + (dbo.View_day3winnew.三大法人3黃金交叉次數 - dbo.View_day4winnew.三大法人4黃金交叉次數)) + (dbo.View_day4winnew.三大法人4黃金交叉次數 - dbo.View_day5winnew.三大法人5黃金交叉次數) AS 近4期三大法人合計, (((dbo.View_day1winnew.外資1黃金交叉次數 - dbo.View_day2winnew.外資2黃金交叉次數) + (dbo.View_day2winnew.外資2黃金交叉次數 - dbo.View_day3winnew.外資3黃金交叉次數)) + (dbo.View_day3winnew.外資3黃金交叉次數 - dbo.View_day4winnew.外資4黃金交叉次數)) + (dbo.View_day4winnew.外資4黃金交叉次數 - dbo.View_day5winnew.外資5黃金交叉次數) AS 近4期外資合計, (((dbo.View_day1winnew.投信1黃金交叉次數 - dbo.View_day2winnew.投信2黃金交叉次數) + (dbo.View_day2winnew.投信2黃金交叉次數 - dbo.View_day3winnew.投信3黃金交叉次數)) + (dbo.View_day3winnew.投信3黃金交叉次數 - dbo.View_day4winnew.投信4黃金交叉次數)) + (dbo.View_day4winnew.投信4黃金交叉次數 - dbo.View_day5winnew.投信5黃金交叉次數) AS 近4期投信合計, dbo.View_day1winnew.產業分類, dbo.View_day1winnew.交易所分類, dbo.View_day1winnew.股本億, dbo.View_day1winnew.日期, dbo.View_day1winnew.三大法人1黃金交叉次數 - dbo.View_day2winnew.三大法人2黃金交叉次數 AS 近1期三大法人, dbo.View_day2winnew.三大法人2黃金交叉次數 - dbo.View_day3winnew.三大法人3黃金交叉次數 AS 近2期三大法人, dbo.View_day3winnew.三大法人3黃金交叉次數 - dbo.View_day4winnew.三大法人4黃金交叉次數 AS 近3期三大法人, dbo.View_day4winnew.三大法人4黃金交叉次數 - dbo.View_day5winnew.三大法人5黃金交叉次數 AS 近4期三大法人, dbo.View_day1winnew.外資1黃金交叉次數 - dbo.View_day2winnew.外資2黃金交叉次數 AS 近1期外資, dbo.View_day2winnew.外資2黃金交叉次數 - dbo.View_day3winnew.外資3黃金交叉次數 AS 近2期外資, dbo.View_day3winnew.外資3黃金交叉次數 - dbo.View_day4winnew.外資4黃金交叉次數 AS 近3期外資, dbo.View_day4winnew.外資4黃金交叉次數 - dbo.View_day5winnew.外資5黃金交叉次數 AS 近4期外資, dbo.View_day1winnew.投信1黃金交叉次數 - dbo.View_day2winnew.投信2黃金交叉次數 AS 近1期投信, dbo.View_day2winnew.投信2黃金交叉次數 - dbo.View_day3winnew.投信3黃金交叉次數 AS 近2期投信, dbo.View_day3winnew.投信3黃金交叉次數 - dbo.View_day4winnew.投信4黃金交叉次數 AS 近3期投信, dbo.View_day4winnew.投信4黃金交叉次數 - dbo.View_day5winnew.投信5黃金交叉次數 AS 近4期投信 FROM dbo.View_day1winnew INNER JOIN dbo.View_day2winnew ON dbo.View_day1winnew.股票代號 = dbo.View_day2winnew.股票代號 INNER JOIN dbo.View_day3winnew ON dbo.View_day2winnew.股票代號 = dbo.View_day3winnew.股票代號 INNER JOIN dbo.View_day4winnew ON dbo.View_day3winnew.股票代號 = dbo.View_day4winnew.股票代號 INNER JOIN dbo.View_day5winnew ON dbo.View_day4winnew.股票代號 = dbo.View_day5winnew.股票代號 INNER JOIN dbo.View_stockchange ON dbo.View_day1winnew.股票代號 = dbo.View_stockchange.代號 ORDER BY 近4期三大法人合計 DESC, 近4期外資合計 DESC, 近4期投信合計 DESC` },
              {
                  cat: "黃金交叉次數", title: "自選股+成交價金叉加權分數等", sql: `DISTINCT
                                                        TOP (100) PERCENT View_winnewdate1.股票名稱, View_winnewdate1.股票代號, View_winnewdate1.站均,
                                                        View_winnewdate1.均價黃金交叉次數, View_winnewdate1.集中度1日, View_winnewdate1.集中度5日,
                                                        View_winnewdate1.集中度10日, View_winnewdate1.集中度20日, View_winnewdate1.集中度60日,
                                                        View_winnewdate1.正負DI百分比, View_winnewdate1.三週庫存比率 / 100 AS [三週庫存比率/100],
                                                        View_winnewdate1.日期, ROUND(View_winnewdate1.k9 - View_winnewdate1.d9, 2) AS 日kd差,
                                                        ROUND(View_winnewdate1.週k9 - View_winnewdate1.週d9, 2) AS 週kd差,
                                                        ROUND(View_winnewdate1.月k9 - View_winnewdate1.月d9, 2) AS 月kd差,
                                                        ROUND((((((((View_winnewdate1.均價黃金交叉次數 + View_winnewdate1.k9 / 5) - View_winnewdate1.d9 / 5)
                                                        + View_winnewdate1.週k9 / 5) - View_winnewdate1.週d9 / 5) + View_winnewdate1.月k9 / 5)
                                                        - View_winnewdate1.月d9 / 5) + View_winnewdate1.合計十天 / 10) + View_winnewdate1.三週庫存比率 / 100, 2)
                                                        AS 總分, View_obvday1.obv淨額, View_obvday1.三十四日平均線,
                                                        ROUND((View_obvday1.obv淨額 - View_obvday1.三十四日平均線) / ABS(View_obvday1.三十四日平均線) * 100, 2)
                                                        AS obv均線乖離率
FROM              View_winnewdate1 INNER JOIN
                                                        View_obvday1 ON View_winnewdate1.股票代號 = View_obvday1.代號
WHERE          (View_winnewdate1.股票代號 IN
                                                            (SELECT          代號
                                                              FROM               incomechar))
ORDER BY   總分 DESC` },

              {
                  cat: "股權分散表", title: "週變動排序", sql: `/*資料庫:stockprice*/TOP (100) PERCENT View_day1mastersum.名稱, View_day1mastersum.證券代號,
                                                            View_day1mastersum.主力庫存比率day1加總, View_day2mastersum.主力庫存比率day2加總,
                                                            View_day3mastersum.主力庫存比率day3加總, View_day4mastersum.主力庫存比率day4加總,
                                                            View_day5mastersum.主力庫存比率day5加總, View_day6mastersum.主力庫存比率day6加總,
                                                            View_day7mastersum.主力庫存比率day7加總,
                                                            ROUND((View_day1mastersum.主力庫存比率day1加總 - View_day2mastersum.主力庫存比率day2加總)
                                                            / View_day2mastersum.主力庫存比率day2加總 * 100, 2) AS [最近一期增幅%],
                                                            ROUND((View_day1mastersum.主力庫存比率day1加總 - View_day3mastersum.主力庫存比率day3加總)
                                                            / View_day3mastersum.主力庫存比率day3加總 * 100, 2) AS [最近二期增幅%],
                                                            ROUND((View_day1mastersum.主力庫存比率day1加總 - View_day4mastersum.主力庫存比率day4加總)
                                                            / View_day4mastersum.主力庫存比率day4加總 * 100, 2) AS [最近三期增幅%],
                                                            ROUND((View_day1mastersum.主力庫存比率day1加總 - View_day5mastersum.主力庫存比率day5加總)
                                                            / View_day5mastersum.主力庫存比率day5加總 * 100, 2) AS [最近四期增幅%],
                                                            ROUND((View_day1mastersum.主力庫存比率day1加總 - View_day6mastersum.主力庫存比率day6加總)
                                                            / View_day6mastersum.主力庫存比率day6加總 * 100, 2) AS [最近五期增幅%],
                                                            ROUND((View_day1mastersum.主力庫存比率day1加總 - View_day7mastersum.主力庫存比率day7加總)
                                                            / View_day7mastersum.主力庫存比率day7加總 * 100, 2) AS [最近六期增幅%],
                                                            View_day1mastersum.資料日期 AS 最新日期, View_day7mastersum.資料日期 AS 最舊日期
FROM              View_day1mastersum INNER JOIN
                                                            View_day2mastersum ON View_day1mastersum.名稱 = View_day2mastersum.名稱 INNER JOIN
                                                            View_day3mastersum ON View_day1mastersum.名稱 = View_day3mastersum.名稱 INNER JOIN
                                                            View_day4mastersum ON View_day1mastersum.名稱 = View_day4mastersum.名稱 INNER JOIN
                                                            View_day5mastersum ON View_day1mastersum.名稱 = View_day5mastersum.名稱 INNER JOIN
                                                            View_day6mastersum ON View_day1mastersum.名稱 = View_day6mastersum.名稱 INNER JOIN
                                                            View_day7mastersum ON View_day1mastersum.名稱 = View_day7mastersum.名稱
WHERE          (View_day2mastersum.主力庫存比率day2加總 > 0) AND (View_day3mastersum.主力庫存比率day3加總 > 0) AND
                                                            (View_day4mastersum.主力庫存比率day4加總 > 0) AND (View_day5mastersum.主力庫存比率day5加總 > 0) AND
                                                            (View_day6mastersum.主力庫存比率day6加總 > 0) AND (View_day7mastersum.主力庫存比率day7加總 > 0)
                                 ORDER BY  ROUND((View_day1mastersum.主力庫存比率day1加總 - View_day2mastersum.主力庫存比率day2加總)
                                                            / View_day2mastersum.主力庫存比率day2加總 * 100, 2) desc` },
              {
                  cat: "股權分散表", title: "400張以上", sql: `/*資料庫:stockprice*/TOP (100) PERCENT dbo.View_selectdatemaster.名稱,
                                                            dbo.View_selectdatemaster.證券代號, ROUND(SUM(dbo.View_selectdatemaster.占集保庫存數比例), 2)
                                                            AS 占集保庫存數總比例, dbo.View_stockchangedate.成交價, dbo.View_stockchangedate.產業分類,
                                                            dbo.View_stockchangedate.交易所分類, dbo.View_stockchangedate.股本億, dbo.View_stockchangedate.市值億,
                                                            dbo.View_selectdatemaster.資料日期
FROM              dbo.View_selectdatemaster INNER JOIN
                                                            dbo.View_stockchangedate ON dbo.View_selectdatemaster.證券代號 = dbo.View_stockchangedate.代號 AND
                                                            dbo.View_selectdatemaster.資料日期 = dbo.View_stockchangedate.日期
GROUP BY   dbo.View_selectdatemaster.名稱, dbo.View_selectdatemaster.證券代號, dbo.View_selectdatemaster.資料日期,
                                                            dbo.View_stockchangedate.成交價, dbo.View_stockchangedate.產業分類, dbo.View_stockchangedate.交易所分類,
                                                            dbo.View_stockchangedate.股本億, dbo.View_stockchangedate.市值億
HAVING           (dbo.View_selectdatemaster.名稱 = N'台積電') or (dbo.View_selectdatemaster.證券代號 = '2330') ORDER BY dbo.View_selectdatemaster.資料日期 desc` },
              {
                  cat: "股權分散表", title: "1,000張以上", sql: `/*資料庫:stockprice*/TOP (100) PERCENT dbo.View_selectdatemaster1.名稱,
                                                            dbo.View_selectdatemaster1.證券代號, ROUND(SUM(dbo.View_selectdatemaster1.占集保庫存數比例), 2)
                                                            AS 占集保庫存數總比例, dbo.View_stockchangedate.成交價, dbo.View_stockchangedate.產業分類,
                                                            dbo.View_stockchangedate.交易所分類, dbo.View_stockchangedate.股本億, dbo.View_stockchangedate.市值億,
                                                            dbo.View_selectdatemaster1.資料日期
FROM              dbo.View_selectdatemaster1 INNER JOIN
                                                            dbo.View_stockchangedate ON dbo.View_selectdatemaster1.證券代號 = dbo.View_stockchangedate.代號 AND
                                                            dbo.View_selectdatemaster1.資料日期 = dbo.View_stockchangedate.日期
GROUP BY   dbo.View_selectdatemaster1.名稱, dbo.View_selectdatemaster1.證券代號, dbo.View_selectdatemaster1.資料日期,
                                                            dbo.View_stockchangedate.成交價, dbo.View_stockchangedate.產業分類, dbo.View_stockchangedate.交易所分類,
                                                            dbo.View_stockchangedate.股本億, dbo.View_stockchangedate.市值億
HAVING           (dbo.View_selectdatemaster1.名稱 = N'台積電') or (dbo.View_selectdatemaster1.證券代號 = '2330') ORDER BY dbo.View_selectdatemaster1.資料日期 desc` },
              {
                  cat: "股權分散表", title: "20張以下", sql: `/*資料庫:stockprice*/TOP (100) PERCENT dbo.View_equity20.名稱, dbo.View_equity20.證券代號,
                                                            ROUND(SUM(dbo.View_equity20.占集保庫存數比例), 2) AS 占集保庫存數總比例, dbo.View_stockchangedate.成交價,
                                                            dbo.View_stockchangedate.產業分類, dbo.View_stockchangedate.交易所分類, dbo.View_stockchangedate.股本億,
                                                            dbo.View_equity20.資料日期
FROM              dbo.View_equity20 INNER JOIN
                                                            dbo.View_stockchangedate ON dbo.View_equity20.證券代號 = dbo.View_stockchangedate.代號 AND
                                                            dbo.View_equity20.資料日期 = dbo.View_stockchangedate.日期
GROUP BY   dbo.View_equity20.名稱, dbo.View_equity20.證券代號, dbo.View_equity20.資料日期,
                                                            dbo.View_stockchangedate.成交價, dbo.View_stockchangedate.產業分類, dbo.View_stockchangedate.交易所分類,
                                                            dbo.View_stockchangedate.股本億
HAVING           (dbo.View_equity20.名稱 = N'台積電') or (dbo.View_equity20.證券代號 = '2330') ORDER BY dbo.View_equity20.資料日期 desc` },
              /*{ cat: "搜尋類", title: "關鍵字搜尋我的最愛", sql: `top 100 * FROM favor1 WHERE word1 LIKE '%deepseek%' ORDER BY 時間戳記 DESC` },*/
              { cat: "資料庫", title: "找出資料庫中所有資料表", sql: `TABLE_NAME FROM INFORMATION_SCHEMA.TABLES ORDER BY TABLE_NAME` },
              { cat: "資料庫", title: "找出該資料表(winnewdate)中的所有欄位", sql: `COLUMN_NAME,ORDINAL_POSITION,DATA_TYPE,CHARACTER_MAXIMUM_LENGTH FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'winnewdate'` },
              { cat: "資料庫", title: "找出該資料表(chips5)中的主鍵欄位", sql: `COLUMN_NAME FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE WHERE TABLE_NAME = 'chips5'` },
              { cat: "籌碼類", title: "Macd紅綠棒+Kdj的J值選股", sql: `dbo.RSVdate.名稱, dbo.RSVdate.代號, dbo.RSVdate.成交價 as 成交價, dbo.RSVdate.漲幅, dbo.RSVdate.總量, dbo.RSVdate.當日K值, dbo.RSVdate.當日D值, dbo.RSVdate.當日J值 as J值, dbo.macdchartable.macd as macd紅綠值, dbo.RSVdate.產業分類, dbo.RSVdate.交易所分類, dbo.RSVdate.股本億, dbo.RSVdate.日期, ROW_NUMBER() OVER (ORDER BY dbo.RSVdate.日期) AS X軸 FROM dbo.macdchartable INNER JOIN dbo.RSVdate ON dbo.macdchartable.股票代號 = dbo.RSVdate.代號 AND dbo.macdchartable.日期 = dbo.RSVdate.日期 WHERE (總量 >= 500) and ((dbo.macdchartable.macd >= 0) AND (dbo.macdchartable.macd <= 50) AND (dbo.RSVdate.當日J值 >= 0) AND (dbo.RSVdate.當日J值 <= 50) and (dbo.macdchartable.日期 >= (SELECT TOP (1) 日期 FROM dbo.basicinfo WHERE (日期 = (SELECT MIN(日期) AS firstday FROM (SELECT TOP (4560) 日期 FROM dbo.basicinfo AS basicinfo_1 ORDER BY 日期 DESC) AS line5)) ORDER BY 代號 DESC, 日期 DESC)) ) ORDER BY dbo.macdchartable.日期 desc,dbo.macdchartable.macd asc` },
              {
                  cat: "籌碼類", title: "彙總表再加上macd紅綠棒及kdj的J值", sql: `DISTINCT
                                                            TOP (100) PERCENT View_basicinfo.名稱 AS 股票名稱, View_basicinfo.代號 AS 股票代號, View_basicinfo.成交價,
                                                             View_basicinfo.漲跌, View_basicinfo.漲幅, View_basicinfo.總量, linedaysort.站均, avggold.均價黃金交叉次數,
                                                            avggold.均量黃金交叉次數, avggold三大法人.三大法人黃金交叉次數,
                                                            avggold三大法人.外資黃金交叉次數, avggold三大法人.投信黃金交叉次數,
                                                            macdchartable.macd AS macd紅綠棒值, rsvjasc.當日J值一 AS 今日J值, rsvjasc.當日J值二 AS 前一日J值,
                                                            rsvjasc.當日J值三 AS 前二日J值, rsvjasc.當日J值四 AS 前三日J值, rsvjasc.J值過高 AS J值過三日高差值,
                                                            day1kd.k9, day1kd.d9, day1kd.週k9, day1kd.週d9, day1kd.月k9, day1kd.月d9, day1macd.macd,
                                                            View_chips5table.集中度1日, View_chips5table.集中度5日, View_chips5table.集中度10日,
                                                            View_chips5table.集中度20日, View_chips5table.集中度60日, View_value.本益比預估,
                                                            View_value.本益比近四季, View_value.股價淨值比, View_value.現金殖利率, trend.一日漲幅, trend.三日漲幅,
                                                            trend.五日漲幅, trend.十日漲幅, trend.二十日漲幅, trend.四十日漲幅, trend.六十日漲幅, todaydi.正DI,
                                                            todaydi.負DI, todaydi.趨向ADX, todaydi.正趨百分比, todaydi.負趨百分比, todaydi.正負DI百分比,
                                                            主力加法人佔股本比彙總.[三大法人佔股本比%一天], 主力加法人佔股本比彙總.[主力佔股本比%一天],
                                                            主力加法人佔股本比彙總.合計一天, 主力加法人佔股本比彙總.法人三天,
                                                            主力加法人佔股本比彙總.主力三天, 主力加法人佔股本比彙總.合計三天,
                                                            主力加法人佔股本比彙總.法人五天, 主力加法人佔股本比彙總.主力五天,
                                                            主力加法人佔股本比彙總.合計五天, 主力加法人佔股本比彙總.法人十天,
                                                            主力加法人佔股本比彙總.主力十天, 主力加法人佔股本比彙總.合計十天,
                                                            主力加法人佔股本比彙總.法人二十天, 主力加法人佔股本比彙總.主力二十天,
                                                            主力加法人佔股本比彙總.合計二十天, 主力加法人佔股本比彙總.法人預設,
                                                            主力加法人佔股本比彙總.主力預設, 主力加法人佔股本比彙總.合計預設, View_weekequity.一週庫存比率,
                                                            View_weekequity.二週庫存比率, View_weekequity.三週庫存比率, View_weekequity.四週庫存比率,
                                                            View_weekequity.五週庫存比率, View_weekequity.六週庫存比率, View_weekequity.七週庫存比率,
                                                            View_weekequity.近二期增幅, View_weekequity.近三期增幅, View_weekequity.近四期增幅,
                                                            View_weekequity.近五期增幅, View_weekequity.近六期增幅, View_weekequity.近七期增幅,
                                                            View_weekequity.最新週, avggold融資券.資使用率, avggold融資券.資使用率黃金交叉次數,
                                                            avggold融資券.券使用率, avggold融資券.券使用率黃金交叉次數, avggold融資券.券資比,
                                                            avggold融資券.券資比黃金交叉次數, avggold.產業分類, avggold.交易所分類, avggold.股本億,
                                                            avggold.日期
FROM              avggold INNER JOIN
                                                            View_value ON avggold.股票代號 = View_value.代號 LEFT OUTER JOIN
                                                            macdchartable ON avggold.日期 = macdchartable.日期 AND
                                                            avggold.股票代號 = macdchartable.股票代號 LEFT OUTER JOIN
                                                            rsvjasc ON avggold.股票代號 = rsvjasc.代號 LEFT OUTER JOIN
                                                            View_chips5table ON avggold.股票代號 = View_chips5table.代號 RIGHT OUTER JOIN
                                                            View_basicinfo ON avggold.股票代號 = View_basicinfo.代號 LEFT OUTER JOIN
                                                            avggold融資券 ON avggold.股票代號 = avggold融資券.代號 LEFT OUTER JOIN
                                                            View_weekequity ON avggold.股票代號 = View_weekequity.代號 LEFT OUTER JOIN
                                                            linedaysort ON avggold.股票代號 = linedaysort.代號 LEFT OUTER JOIN
                                                            day1macd ON avggold.股票代號 = day1macd.股票代號 LEFT OUTER JOIN
                                                            day1kd ON avggold.股票代號 = day1kd.股票代號 LEFT OUTER JOIN
                                                            avggold三大法人 ON avggold.股票代號 = avggold三大法人.股票代號 LEFT OUTER JOIN
                                                            主力加法人佔股本比彙總 ON avggold.股票代號 = 主力加法人佔股本比彙總.代號 LEFT OUTER JOIN
                                                            todaydi ON avggold.股票代號 = todaydi.股票代號 LEFT OUTER JOIN
                                                            trend ON avggold.股票代號 = trend.代號
WHERE          (View_basicinfo.總量 >= 500) and ((macdchartable.macd >= -0.05) AND (macdchartable.macd <=  50)) and ((rsvjasc.當日J值一 >= 0) AND (rsvjasc.當日J值一 <=  50))` },
              {
                  cat: "籌碼類", title: "kdj的J值連三增(macd紅綠棒及J值範圍)", sql: `dbo.RSVdate.名稱, dbo.RSVdate.代號, dbo.RSVdate.成交價 as 成交價, dbo.RSVdate.漲幅,
                                                            dbo.RSVdate.總量, dbo.RSVdate.當日K值, dbo.RSVdate.當日D值, dbo.RSVdate.當日J值 as J值, dbo.macdchartable.macd as macd紅綠值,
                                                            dbo.RSVdate.產業分類, dbo.RSVdate.交易所分類, dbo.RSVdate.股本億, dbo.RSVdate.日期, ROW_NUMBER() OVER (ORDER BY dbo.RSVdate.日期) AS X軸
FROM              macdchartable INNER JOIN
                                                            RSVdate ON macdchartable.股票代號 = RSVdate.代號 AND macdchartable.日期 = RSVdate.日期 INNER JOIN
                                                            rsvjasc ON macdchartable.股票代號 = rsvjasc.代號

WHERE          (dbo.RSVdate.總量 >= 500) and ((dbo.macdchartable.macd >= -0.03) AND (dbo.macdchartable.macd <= 100) AND (dbo.RSVdate.當日J值 >= 0) AND
                                                            (dbo.RSVdate.當日J值 <= 100) and (dbo.macdchartable.日期 >= (SELECT          TOP (1) 日期
FROM              dbo.basicinfo
WHERE          (日期 =
                                                                (SELECT          MIN(日期) AS firstday
                                                                  FROM               (SELECT          TOP (4560) 日期
                                                                                               FROM               dbo.basicinfo AS basicinfo_1
                                                                                               ORDER BY    日期 DESC) AS line5))
ORDER BY   代號 DESC, 日期 DESC))
)  AND (rsvjasc.J值day1 > 0) AND
                                                            (rsvjasc.J值day2 > 0) AND (rsvjasc.J值day3 > 0)
ORDER BY   dbo.macdchartable.日期 desc,dbo.macdchartable.macd asc` },
              {
                  cat: "技術類", title: "接近季線 乖離率%", sql: `TOP (100) PERCENT dbo.basicinfo.名稱 AS 股票名稱, dbo.basicinfo.代號 AS 股票代號, dbo.basicinfo.漲幅,
                                                            dbo.basicinfo.成交價, dbo.basicinfo.總量,round((dbo.basicinfo.總量/(dbo.basicinfo.股本億*10000))* 100,2) as [週轉率%], dbo.Chips5.集中度1日, dbo.Chips5.集中度5日, dbo.Chips5.集中度10日,
                                                            dbo.Chips5.集中度20日, dbo.Chips5.集中度60日,
                                                            dbo.basicinfo.股本億, dbo.basicinfo.交易所分類, dbo.basicinfo.日期,dbo.linedaytotoldate.今日成交價, dbo.linedaytotoldate.五日均線, dbo.linedaytotoldate.二十日均線,
                                                            dbo.linedaytotoldate.六十日均線, ROUND((dbo.linedaytotoldate.今日成交價 - dbo.linedaytotoldate.五日均線)
                                                            / dbo.linedaytotoldate.五日均線 * 100, 2) AS 五日乖離,
                                                            ROUND((dbo.linedaytotoldate.今日成交價 - dbo.linedaytotoldate.二十日均線) / dbo.linedaytotoldate.二十日均線 * 100,
                                                            2) AS 二十日乖離, ROUND((dbo.linedaytotoldate.今日成交價 - dbo.linedaytotoldate.六十日均線)
                                                            / dbo.linedaytotoldate.六十日均線 * 100, 2) AS 六十日乖離,STRING_AGG(View_notioninfo.name1, ', ') AS 概念股

FROM                       dbo.Chips5  INNER JOIN  dbo.basicinfo ON dbo.Chips5.代號 = dbo.basicinfo.代號 INNER JOIN
                                                            dbo.linedaytotoldate ON basicinfo.代號 = dbo.linedaytotoldate.股票代號 LEFT OUTER JOIN
                                                            View_notioninfo ON dbo.basicinfo.名稱 = View_notioninfo.mail1
WHERE          (dbo.basicinfo.日期 = 20260327) AND (dbo.Chips5.日期 = 20260327) AND
                                                            (dbo.linedaytotoldate.日期 = 20260327) AND ( ROUND((dbo.linedaytotoldate.今日成交價 - dbo.linedaytotoldate.五日均線)
                                                             / dbo.linedaytotoldate.五日均線 * 100, 2) >= 0.01) AND
                                                            (ROUND((dbo.linedaytotoldate.今日成交價 - dbo.linedaytotoldate.二十日均線) / dbo.linedaytotoldate.二十日均線 * 100,
                                                             2)  >= 0.01) AND (ROUND((dbo.linedaytotoldate.今日成交價 - dbo.linedaytotoldate.六十日均線)
                                                            / dbo.linedaytotoldate.六十日均線 * 100, 2) >= 0.01) AND (dbo.basicinfo.總量 >= 5000)
                                                            AND (ROUND((dbo.linedaytotoldate.今日成交價 - dbo.linedaytotoldate.二十日均線) / dbo.linedaytotoldate.二十日均線 * 100,
                                                             2)  <=10) AND (ROUND((dbo.linedaytotoldate.今日成交價 - dbo.linedaytotoldate.六十日均線)
                                                            / dbo.linedaytotoldate.六十日均線 * 100, 2) <= 10) AND
                                                            (ROUND((dbo.linedaytotoldate.今日成交價 - dbo.linedaytotoldate.五日均線)
                                                             / dbo.linedaytotoldate.五日均線 * 100, 2)  <= 10) AND (dbo.linedaytotoldate.五日均線 > 0) AND (dbo.linedaytotoldate.二十日均線 > 0) AND
                                                            (dbo.linedaytotoldate.六十日均線 > 0)
GROUP BY dbo.basicinfo.名稱, dbo.basicinfo.代號, dbo.basicinfo.漲幅,
                                                            dbo.basicinfo.成交價, dbo.basicinfo.總量,round((dbo.basicinfo.總量/(dbo.basicinfo.股本億*10000))* 100,2), dbo.Chips5.集中度1日, dbo.Chips5.集中度5日, dbo.Chips5.集中度10日,
                                                            dbo.Chips5.集中度20日, dbo.Chips5.集中度60日,
                                                            dbo.basicinfo.股本億, dbo.basicinfo.交易所分類, dbo.basicinfo.日期,dbo.linedaytotoldate.今日成交價, dbo.linedaytotoldate.五日均線, dbo.linedaytotoldate.二十日均線,
                                                            dbo.linedaytotoldate.六十日均線, ROUND((dbo.linedaytotoldate.今日成交價 - dbo.linedaytotoldate.五日均線)
                                                            / dbo.linedaytotoldate.五日均線 * 100, 2),
                                                            ROUND((dbo.linedaytotoldate.今日成交價 - dbo.linedaytotoldate.二十日均線) / dbo.linedaytotoldate.二十日均線 * 100,
                                                            2), ROUND((dbo.linedaytotoldate.今日成交價 - dbo.linedaytotoldate.六十日均線)
                                                            / dbo.linedaytotoldate.六十日均線 * 100, 2)
ORDER BY   五日乖離 desc` },

              {
                  cat: "技術類", title: "總量+maxd紅綠棒值+J值", sql: `DISTINCT
                                                        TOP (100) PERCENT View_basicinfo.名稱 AS 股票名稱, View_basicinfo.代號 AS 股票代號, View_basicinfo.成交價,
                                                         View_basicinfo.漲跌, View_basicinfo.漲幅, View_basicinfo.總量, linedaysort.站均, avggold.均價黃金交叉次數,
                                                        avggold.均量黃金交叉次數, avggold三大法人.三大法人黃金交叉次數,
                                                        avggold三大法人.外資黃金交叉次數, avggold三大法人.投信黃金交叉次數,
                                                        macdchartable.macd AS macd紅綠棒值, rsvjasc.當日J值一 AS 今日J值, rsvjasc.當日J值二 AS 前一日J值,
                                                        rsvjasc.當日J值三 AS 前二日J值, rsvjasc.當日J值四 AS 前三日J值, rsvjasc.J值過高 AS J值過三日高差值,
                                                        day1kd.k9, day1kd.d9, day1kd.週k9, day1kd.週d9, day1kd.月k9, day1kd.月d9, day1macd.macd,
                                                        View_chips5table.集中度1日, View_chips5table.集中度5日, View_chips5table.集中度10日,
                                                        View_chips5table.集中度20日, View_chips5table.集中度60日, View_value.本益比預估,
                                                        View_value.本益比近四季, View_value.股價淨值比, View_value.現金殖利率, trend.一日漲幅, trend.三日漲幅,
                                                        trend.五日漲幅, trend.十日漲幅, trend.二十日漲幅, trend.四十日漲幅, trend.六十日漲幅, todaydi.正DI,
                                                        todaydi.負DI, todaydi.趨向ADX, todaydi.正趨百分比, todaydi.負趨百分比, todaydi.正負DI百分比,
                                                        主力加法人佔股本比彙總.[三大法人佔股本比%一天], 主力加法人佔股本比彙總.[主力佔股本比%一天],
                                                        主力加法人佔股本比彙總.合計一天, 主力加法人佔股本比彙總.法人三天,
                                                        主力加法人佔股本比彙總.主力三天, 主力加法人佔股本比彙總.合計三天,
                                                        主力加法人佔股本比彙總.法人五天, 主力加法人佔股本比彙總.主力五天,
                                                        主力加法人佔股本比彙總.合計五天, 主力加法人佔股本比彙總.法人十天,
                                                        主力加法人佔股本比彙總.主力十天, 主力加法人佔股本比彙總.合計十天,
                                                        主力加法人佔股本比彙總.法人二十天, 主力加法人佔股本比彙總.主力二十天,
                                                        主力加法人佔股本比彙總.合計二十天, 主力加法人佔股本比彙總.法人預設,
                                                        主力加法人佔股本比彙總.主力預設, 主力加法人佔股本比彙總.合計預設, View_weekequity.一週庫存比率,
                                                        View_weekequity.二週庫存比率, View_weekequity.三週庫存比率, View_weekequity.四週庫存比率,
                                                        View_weekequity.五週庫存比率, View_weekequity.六週庫存比率, View_weekequity.七週庫存比率,
                                                        View_weekequity.近二期增幅, View_weekequity.近三期增幅, View_weekequity.近四期增幅,
                                                        View_weekequity.近五期增幅, View_weekequity.近六期增幅, View_weekequity.近七期增幅,
                                                        View_weekequity.最新週, avggold融資券.資使用率, avggold融資券.資使用率黃金交叉次數,
                                                        avggold融資券.券使用率, avggold融資券.券使用率黃金交叉次數, avggold融資券.券資比,
                                                        avggold融資券.券資比黃金交叉次數, avggold.產業分類, avggold.交易所分類, avggold.股本億,
                                                        avggold.日期
FROM              avggold INNER JOIN
                                                        View_value ON avggold.股票代號 = View_value.代號 LEFT OUTER JOIN
                                                        macdchartable ON avggold.日期 = macdchartable.日期 AND
                                                        avggold.股票代號 = macdchartable.股票代號 LEFT OUTER JOIN
                                                        rsvjasc ON avggold.股票代號 = rsvjasc.代號 LEFT OUTER JOIN
                                                        View_chips5table ON avggold.股票代號 = View_chips5table.代號 RIGHT OUTER JOIN
                                                        View_basicinfo ON avggold.股票代號 = View_basicinfo.代號 LEFT OUTER JOIN
                                                        avggold融資券 ON avggold.股票代號 = avggold融資券.代號 LEFT OUTER JOIN
                                                        View_weekequity ON avggold.股票代號 = View_weekequity.代號 LEFT OUTER JOIN
                                                        linedaysort ON avggold.股票代號 = linedaysort.代號 LEFT OUTER JOIN
                                                        day1macd ON avggold.股票代號 = day1macd.股票代號 LEFT OUTER JOIN
                                                        day1kd ON avggold.股票代號 = day1kd.股票代號 LEFT OUTER JOIN
                                                        avggold三大法人 ON avggold.股票代號 = avggold三大法人.股票代號 LEFT OUTER JOIN
                                                        主力加法人佔股本比彙總 ON avggold.股票代號 = 主力加法人佔股本比彙總.代號 LEFT OUTER JOIN
                                                        todaydi ON avggold.股票代號 = todaydi.股票代號 LEFT OUTER JOIN
                                                        trend ON avggold.股票代號 = trend.代號
WHERE         (View_basicinfo.總量 >= 500) and ((macdchartable.macd >= -0.03) AND (macdchartable.macd <= 50)) and ((rsvjasc.當日J值一 >= 0) AND (rsvjasc.當日J值一 <=  100))` },

              {
                  cat: "obv多空淨額", title: "自選股+盤後+綜合+OBV均線", sql: `a.[股票名稱],a.[股票代號],a.[站均],a.[均價黃金交叉次數],ROUND((((((((a.均價黃金交叉次數 + a.k9 / 5) - a.d9 / 5)
                                                            + a.週k9 / 5) - a.週d9 / 5) + a.月k9 / 5) - a.月d9 / 5)
                                                            + a.合計十天 / 10) + a.三週庫存比率 / 100, 2) AS 加權總分,a.[均量黃金交叉次數],a.[三大法人黃金交叉次數],a.[外資黃金交叉次數] ,a.[投信黃金交叉次數],c.obv淨額,c.三十四日平均線,d.五日平均線,c.obv淨額-d.五日平均線 as 站上五日均線,c.obv淨額-c.三十四日平均線 as 站上三十四日均線,macdpic.DIF減MACD,a.[k9],a.[d9] ,a.[週k9],a.[週d9],a.[月k9] ,a.[月d9],a.[macd],a.[集中度1日] ,a.[集中度5日] ,a.[集中度10日],a.[集中度20日] ,a.[集中度60日],a.[本益比預估] ,a.[本益比近四季],a.[股價淨值比] ,a.[現金殖利率] ,a.[正DI] ,a.[負DI] ,a.[趨向ADX] ,a.[正趨百分比] ,a.[負趨百分比] ,a.[正負DI百分比] ,a.[三大法人佔股本比%一天] ,a.[主力佔股本比%一天],a.[合計一天] ,a.[法人三天],a.[主力三天],a.[合計三天],a.[法人五天],a.[主力五天],a.[合計五天] ,a.[法人十天] ,a.[主力十天],a.[合計十天] ,a.[法人二十天] ,a.[主力二十天],a.[合計二十天] ,a.[法人預設] ,a.[主力預設] ,a.[合計預設] ,a.[一週庫存比率] ,a.[二週庫存比率] ,a.[三週庫存比率],a.[四週庫存比率],a.[五週庫存比率] ,a.[六週庫存比率] ,a.[七週庫存比率] ,a.[近二期增幅] ,a.[近三期增幅] ,a.[近四期增幅] ,a.[近五期增幅] ,a.[近六期增幅],a.[近七期增幅] ,a.[最新週],a.[資使用率] ,a.[資使用率黃金交叉次數] ,a.[券使用率] ,a.[券使用率黃金交叉次數] ,a.[券資比] ,a.[券資比黃金交叉次數] ,a.[產業分類] ,a.[交易所分類] ,a.[股本億] ,a.[日期], b.成交價 as 盤中成交價, b.漲跌, b.漲幅, b.總量 as 盤中總量 from winnewdate as a inner join view_basicinfo as b on a.股票代號 = b.代號 inner join obvdatea3 as c on a.股票代號 = c.代號 and a.日期 = c.日期 inner join obvdatea5 as d on c.代號 =  d.代號 and c.日期 = d.日期 INNER JOIN macdpic on  a.股票代號 = macdpic.股票代號 and a.日期 = macdpic.日期
where (b.代號 IN (SELECT 代號 FROM  incomechar20)) AND (a.日期 = (SELECT TOP (1) MAX(日期) AS Expr1  FROM basicinfo AS basicinfo_1))` },
              {
                  cat: "obv多空淨額", title: "單股+obv+winewdate多天", sql: `top 20 a.[股票名稱],a.[股票代號],a.[站均],a.[均價黃金交叉次數],ROUND((((((((a.均價黃金交叉次數 + a.k9 / 5) - a.d9 / 5)
                                                            + a.週k9 / 5) - a.週d9 / 5) + a.月k9 / 5) - a.月d9 / 5)
                                                            + a.合計十天 / 10) + a.三週庫存比率 / 100, 2) AS 加權總分 ,a.[均量黃金交叉次數],a.[三大法人黃金交叉次數],a.[外資黃金交叉次數] ,a.[投信黃金交叉次數],c.obv淨額,c.三十四日平均線,d.五日平均線,c.obv淨額-d.五日平均線 As 站上五日均線,c.obv淨額-c.三十四日平均線 As 站上三十四日均線,macdpic.DIF減MACD,a.[k9],a.[d9] ,a.[週k9],a.[週d9],a.[月k9] ,a.[月d9],a.[macd],a.[集中度1日] ,a.[集中度5日] ,a.[集中度10日],a.[集中度20日] ,a.[集中度60日],a.[本益比預估] ,a.[本益比近四季],a.[股價淨值比] ,a.[現金殖利率] ,a.[正DI] ,a.[負DI] ,a.[趨向ADX] ,a.[正趨百分比] ,a.[負趨百分比] ,a.[正負DI百分比] ,a.[三大法人佔股本比%一天] ,a.[主力佔股本比%一天],a.[合計一天] ,a.[法人三天],a.[主力三天],a.[合計三天],a.[法人五天],a.[主力五天],a.[合計五天] ,a.[法人十天] ,a.[主力十天],a.[合計十天] ,a.[法人二十天] ,a.[主力二十天],a.[合計二十天] ,a.[法人預設] ,a.[主力預設] ,a.[合計預設] ,a.[一週庫存比率] ,a.[二週庫存比率] ,a.[三週庫存比率],a.[四週庫存比率],a.[五週庫存比率] ,a.[六週庫存比率] ,a.[七週庫存比率] ,a.[近二期增幅] ,a.[近三期增幅] ,a.[近四期增幅] ,a.[近五期增幅] ,a.[近六期增幅],a.[近七期增幅] ,a.[最新週],a.[資使用率] ,a.[資使用率黃金交叉次數] ,a.[券使用率] ,a.[券使用率黃金交叉次數] ,a.[券資比] ,a.[券資比黃金交叉次數] ,a.[產業分類] ,a.[交易所分類] ,a.[股本億] ,a.[日期], b.成交價 As 盤中成交價, b.漲跌, b.漲幅, b.總量 As 盤中總量  from winnewdate As a inner join view_basicinfo As b On a.股票代號 = b.代號 inner join obvdatea3 As c On a.股票代號 = c.代號 And a.日期 = c.日期 inner join obvdatea5 As d On c.代號 =  d.代號 And c.日期 = d.日期 INNER JOIN macdpic On  a.股票代號 = macdpic.股票代號 And a.日期 = macdpic.日期 where
(b.代號 = /*輸入股票代號=>*/N'3017') order by 日期 desc` },

              {
                  cat: "基本面", title: "近五年營業額", sql: `TOP (100) PERCENT View_income近一年.名稱 AS 股票名稱, View_income近一年.代號 AS 股票代號,
                                                            View_income最新年.最新年營收 AS 營收最新年, View_income近一年.近一年營收 AS 營收近一年,
                                                            View_income近二年.近二年營收 AS 營收近二年, View_income近三年.近三年營收 AS 營收近三年,
                                                            View_income近四年.近四年營收 AS 營收近四年, View_income近五年.近五年營收 AS 營收近五年,
                                                            right(View_income近一年.日期,2) AS 月份, View_income最新年.年成長 AS 最新年成長,
                                                            View_income最新年.累計營收年成長 AS 最新年累計營收年成長, View_income近一年.年成長 AS 近一年成長,
                                                            View_income近一年.累計營收年成長 AS 近一年累計營收年成長, View_income近一年.月變動 AS 近一年月變動,
                                                            View_income近一年.近12月營收成長 AS 近一年近12月營收成長, View_income近二年.年成長 AS 近二年成長,
                                                            View_income近二年.累計營收年成長 AS 近二年累計營收年成長, View_income近二年.月變動 AS 近二年月變動,
                                                            View_income近二年.近12月營收成長 AS 近二年近12月營收成長, View_income近三年.年成長 AS 近三年成長,
                                                            View_income近三年.累計營收年成長 AS 近三年累計營收年成長, View_income近三年.月變動 AS 近三年月變動,
                                                            View_income近三年.近12月營收成長 AS 近三年近12月營收成長, View_income近四年.年成長 AS 近四年成長,
                                                            View_income近四年.累計營收年成長 AS 近四年累計營收年成長, View_income近四年.月變動 AS 近四年月變動,
                                                            View_income近四年.近12月營收成長 AS 近四年近12月營收成長, View_income近五年.年成長 AS 近五年成長,
                                                            View_income近五年.累計營收年成長 AS 近五年累計營收年成長, View_income近五年.月變動 AS 近五年月變動,
                                                            View_income近五年.近12月營收成長 AS 近五年近12月營收成長
FROM              View_income近二年 INNER JOIN
                                                            View_income近三年 ON View_income近二年.代號 = View_income近三年.代號 AND RIGHT(View_income近二年.日期,
                                                            2) = RIGHT(View_income近三年.日期, 2) INNER JOIN
                                                            View_income近四年 ON View_income近二年.代號 = View_income近四年.代號 AND RIGHT(View_income近二年.日期,
                                                            2) = RIGHT(View_income近四年.日期, 2) INNER JOIN
                                                            View_income近一年 ON View_income近二年.代號 = View_income近一年.代號 AND RIGHT(View_income近二年.日期,
                                                            2) = RIGHT(View_income近一年.日期, 2) INNER JOIN
                                                            View_income近五年 ON View_income近四年.代號 = View_income近五年.代號 AND RIGHT(View_income近五年.日期,
                                                            2) = RIGHT(View_income近四年.日期, 2) LEFT OUTER JOIN
                                                            View_income最新年 ON View_income近二年.代號 = View_income最新年.代號 AND RIGHT(View_income近二年.日期,
                                                            2) = RIGHT(View_income最新年.日期, 2)
                                                            WHERE (View_income近一年.代號 = N'2330')
                                                            ORDER BY  View_income近一年.日期` },
              {
                  cat: "基本面", title: "近五年EPS", sql: `TOP (100) PERCENT dbo.View_finance最新年.名稱, dbo.View_finance最新年.代號,
                                                            dbo.View_finance最新年.最新年EPS累計, dbo.View_finance近一年.近一年EPS累計,
                                                            dbo.View_finance近二年.近二年EPS累計, dbo.View_finance近三年.近三年EPS累計,
                                                            dbo.View_finance近四年.近四年EPS累計, dbo.View_finance最新年.最新年毛利率,
                                                            dbo.View_finance近一年.近一年毛利率, dbo.View_finance近二年.近二年毛利率,
                                                            dbo.View_finance近三年.近三年毛利率, dbo.View_finance近四年.近四年毛利率,
                                                            dbo.View_finance最新年.最新年營業利益率, dbo.View_finance近一年.近一年營業利益率,
                                                            dbo.View_finance近二年.近二年營業利益率, dbo.View_finance近三年.近三年營業利益率,
                                                            dbo.View_finance近四年.近四年營業利益率, dbo.View_finance最新年.最新年稅後純益,
                                                            dbo.View_finance近一年.近一年稅後純益, dbo.View_finance近二年.近二年稅後純益,
                                                            dbo.View_finance近三年.近三年稅後純益, dbo.View_finance近四年.近四年稅後純益,
                                                            right(dbo.View_finance最新年.日期,2) as 季度
FROM              dbo.View_finance近二年 INNER JOIN
                                                            dbo.View_finance近一年 ON dbo.View_finance近二年.代號 = dbo.View_finance近一年.代號 AND
                                                            RIGHT(dbo.View_finance近二年.日期, 2) = RIGHT(dbo.View_finance近一年.日期, 2) INNER JOIN
                                                            dbo.View_finance近三年 ON dbo.View_finance近二年.代號 = dbo.View_finance近三年.代號 AND
                                                            RIGHT(dbo.View_finance近二年.日期, 2) = RIGHT(dbo.View_finance近三年.日期, 2) INNER JOIN
                                                            dbo.View_finance近四年 ON dbo.View_finance近三年.代號 = dbo.View_finance近四年.代號 AND
                                                            RIGHT(dbo.View_finance近三年.日期, 2) = RIGHT(dbo.View_finance近四年.日期, 2) RIGHT OUTER JOIN
                                                            dbo.View_finance最新年 ON dbo.View_finance近一年.代號 = dbo.View_finance最新年.代號 AND
                                                            RIGHT(dbo.View_finance近一年.日期, 2) = RIGHT(dbo.View_finance最新年.日期, 2)
                                                            WHERE (dbo.View_finance最新年.代號 = N'2330')
                                                            ORDER BY   dbo.View_finance最新年.代號, dbo.View_finance最新年.日期` },

              { cat: "圖片類", title: "Ai girl", sql: `/*資料庫:fvor2*/ * from stockgod21 where 識別碼>1000 and 識別碼<1050` },
              { cat: "圖片類", title: "gif檔", sql: `/*資料庫:fvor2*/top 30 * from stockgod28` },
              { cat: "圖片類", title: "面積 考卷", sql: `/*資料庫:fvor2*/top 20 * from stockgod` },
              { cat: "圖片類", title: "美腿圖片", sql: `/*資料庫:poemleg*/識別碼,name1 as 名稱,mail1 as 說明,photo,word1 as 日期 from poem where (識別碼 >= 1 and 識別碼 <= 50)` },
              { cat: "圖片類", title: "圖片藝廊", sql: `/*詳見上排藝廊 https://weizen99.github.io/androidapp/basicinfotable2.html */` },
              { cat: "文字類", title: "成語", sql: `/*資料庫:fromaccessdatabase*/* FROM [dbo].[guestinfo4]` },
              { cat: "文字類", title: "我的最愛", sql: `/*資料庫:fromaccessdatabase*/* FROM [dbo].[guestinfowd1] order by 識別碼 desc` },
              { cat: "文字類", title: "自建概念股", sql: `/*資料庫:fromaccessdatabase*/* FROM [dbo].[guestinfowd5]` },
              { cat: "文字類", title: "美股", sql: `/*資料庫:fromaccessdatabase*/* FROM [dbo].[guestinfowd6]` },
              { cat: "文字類", title: "excel程式碼", sql: `/*資料庫:pokopoko*/top 100 * from poemexcel` },
              { cat: "文字類", title: "java程式碼", sql: ` /*資料庫:pokopoko*/top 100 * from poemjava` },
              { cat: "文字類", title: "visualbasic程式碼", sql: `/*資料庫:pokopoko*/top 100 * from poemvisualbasic` },
              { cat: "文字類", title: "web程式碼", sql: `/*資料庫:pokopoko*/top 100 * from poemweb` },
              { cat: "文字類", title: "youbike座標", sql: `/*資料庫:pokopoko*/ * from textmsgyb` },
              //{ cat: "搜尋類", title: "關鍵字搜尋我的最愛", sql: `top 100 * FROM favor1 WHERE word1 LIKE '%deepseek%' ORDER BY 時間戳記 DESC` },
              //{ cat: "搜尋類", title: "關鍵字搜尋我的最愛", sql: `top 100 * FROM favor1 WHERE word1 LIKE '%deepseek%' ORDER BY 時間戳記 DESC` },
              //{ cat: "搜尋類", title: "關鍵字搜尋我的最愛", sql: `top 100 * FROM favor1 WHERE word1 LIKE '%deepseek%' ORDER BY 時間戳記 DESC` },
              //{ cat: "搜尋類", title: "關鍵字搜尋我的最愛", sql: `top 100 * FROM favor1 WHERE word1 LIKE '%deepseek%' ORDER BY 時間戳記 DESC` },
              {
                  cat: "盤中選股", title: "盤中obv+自選股", sql: `obv盤中選股.名稱, obv盤中選股.代號, View_stockchange.漲幅, obv盤中選股.盤中成交價, obv盤中選股.最高,
                                                        obv盤中選股.最低, obv盤中選股.總量, obv計算黃金交叉次數.obv黃金交叉次數, obv盤中選股.前一日累積obv成交量,
                                                        obv盤中選股.盤中的單日obv均量, obv盤中選股.盤中的累積obv均量,
                                                        obv盤中選股.盤中計算出來的最新三十四日平均線,
                                                        ROUND((obv盤中選股.盤中的累積obv均量 - obv盤中選股.盤中計算出來的最新三十四日平均線)
                                                        / ABS(obv盤中選股.盤中計算出來的最新三十四日平均線) * 100, 2) AS 盤中離34日均線乖離率, (obv盤中選股.盤中的累積obv均量-obv盤中選股.盤中計算出來的最新三十四日平均線) as 站上34日均線張數,
                                                        View_stockchange.產業分類, View_stockchange.交易所分類, View_stockchange.上市1上櫃2,
                                                        View_stockchange.股本億, obv盤中選股.盤中計算出來的最新五日平均線,
                                                        ROUND((obv盤中選股.盤中的累積obv均量 - obv盤中選股.盤中計算出來的最新五日平均線)                / ABS(obv盤中選股.盤中計算出來的最新五日平均線) * 100, 2) AS 盤中離5日均線乖離率 ,
(obv盤中選股.盤中的累積obv均量 - obv盤中選股.盤中計算出來的最新五日平均線) AS 站上五日平均線張數
FROM              obv盤中選股 INNER JOIN
                                                        View_stockchange ON obv盤中選股.代號 = View_stockchange.代號 INNER JOIN
                                                        obv計算黃金交叉次數 ON obv盤中選股.代號 = obv計算黃金交叉次數.代號
WHERE          (obv盤中選股.盤中計算出來的最新三十四日平均線 <> 0) AND (View_stockchange.代號 IN
                                                            (SELECT          代號
                                                              FROM               incomechar20)) AND (obv計算黃金交叉次數.日期 =
                                                            (SELECT          TOP (1) MAX(日期) AS Expr1
                                                              FROM               basicinfo AS basicinfo_1)) and (obv盤中選股.盤中計算出來的最新五日平均線 <> 0)
ORDER BY   站上五日平均線張數 DESC` },
              {
                  cat: "盤中選股", title: "盤中站上obv五日均線", sql: `obv盤中選股.名稱, obv盤中選股.代號, View_stockchange.漲幅, obv盤中選股.盤中成交價, obv盤中選股.最高,
                                                        obv盤中選股.最低, obv盤中選股.總量, obv計算黃金交叉次數.obv黃金交叉次數, obv盤中選股.前一日累積obv成交量,
                                                        obv盤中選股.盤中的單日obv均量, obv盤中選股.盤中的累積obv均量,
                                                        obv盤中選股.盤中計算出來的最新三十四日平均線,
                                                        ROUND((obv盤中選股.盤中的累積obv均量 - obv盤中選股.盤中計算出來的最新三十四日平均線)
                                                        / ABS(obv盤中選股.盤中計算出來的最新三十四日平均線) * 100, 2) AS 盤中離34日均線乖離率,
                                                        obv盤中選股.盤中的累積obv均量 - obv盤中選股.盤中計算出來的最新三十四日平均線 AS 站上34日均線張數,
                                                        View_stockchange.產業分類, View_stockchange.交易所分類, View_stockchange.上市1上櫃2,
                                                        View_stockchange.股本億, obv盤中選股.盤中計算出來的最新五日平均線,
                                                        ROUND((obv盤中選股.盤中的累積obv均量 - obv盤中選股.盤中計算出來的最新五日平均線)
                                                        / ABS(obv盤中選股.盤中計算出來的最新五日平均線) * 100, 2) AS 盤中離5日均線乖離率,
                                                        obv盤中選股.盤中的累積obv均量 - obv盤中選股.盤中計算出來的最新五日平均線 AS 站上五日平均線張數
FROM              obv盤中選股 INNER JOIN
                                                        View_stockchange ON obv盤中選股.代號 = View_stockchange.代號 INNER JOIN
                                                        obv計算黃金交叉次數 ON obv盤中選股.代號 = obv計算黃金交叉次數.代號 INNER JOIN
                                                        View_day2obvdate3_1 ON obv盤中選股.代號 = View_day2obvdate3_1.代號
WHERE          (obv盤中選股.盤中計算出來的最新三十四日平均線 <> 0) AND (View_stockchange.代號 IN
                                                            (SELECT          代號
                                                              FROM               incomechar20)) AND (obv計算黃金交叉次數.日期 =
                                                            (SELECT          TOP (1) MAX(日期) AS Expr1
                                                              FROM               basicinfo AS basicinfo_1)) AND (obv盤中選股.盤中計算出來的最新五日平均線 <> 0) AND
                                                        (View_day2obvdate3_1.obv淨額 - obv盤中選股.盤中計算出來的最新五日平均線 < 0) and (obv盤中選股.盤中的累積obv均量 - obv盤中選股.盤中計算出來的最新五日平均線 >0)
ORDER BY   站上五日平均線張數 DESC` },
              {
                  cat: "盤中選股", title: "盤中站上obv五日均線+winnewdate+自選股", sql: `obv盤中選股.名稱, obv盤中選股.代號, View_stockchange.漲幅, obv盤中選股.盤中成交價, obv盤中選股.最高,
                                                        obv盤中選股.最低, obv盤中選股.總量, obv計算黃金交叉次數.obv黃金交叉次數, obv盤中選股.前一日累積obv成交量,
                                                        obv盤中選股.盤中的單日obv均量, obv盤中選股.盤中的累積obv均量,
                                                        obv盤中選股.盤中計算出來的最新三十四日平均線,
                                                        ROUND((obv盤中選股.盤中的累積obv均量 - obv盤中選股.盤中計算出來的最新三十四日平均線)
                                                        / ABS(obv盤中選股.盤中計算出來的最新三十四日平均線) * 100, 2) AS 盤中離34日均線乖離率,
                                                        obv盤中選股.盤中的累積obv均量 - obv盤中選股.盤中計算出來的最新三十四日平均線 AS 站上34日均線張數,
                                                        View_stockchange.產業分類, View_stockchange.交易所分類, View_stockchange.上市1上櫃2,
                                                        View_stockchange.股本億, obv盤中選股.盤中計算出來的最新五日平均線,
                                                        ROUND((obv盤中選股.盤中的累積obv均量 - obv盤中選股.盤中計算出來的最新五日平均線)
                                                        / ABS(obv盤中選股.盤中計算出來的最新五日平均線) * 100, 2) AS 盤中離5日均線乖離率,
                                                        obv盤中選股.盤中的累積obv均量 - obv盤中選股.盤中計算出來的最新五日平均線 AS 站上五日平均線張數,macdpic.DIF減MACD,a.[站均],a.[均價黃金交叉次數],a.[均量黃金交叉次數],a.[三大法人黃金交叉次數],a.[外資黃金交叉次數] ,a.[投信黃金交叉次數],a.[k9],a.[d9] ,a.[週k9],a.[週d9],a.[月k9] ,a.[月d9],a.[macd],a.[集中度1日] ,a.[集中度5日] ,a.[集中度10日],a.[集中度20日] ,a.[集中度60日],a.[本益比預估] ,a.[本益比近四季],a.[股價淨值比] ,a.[現金殖利率] ,a.[正DI] ,a.[負DI] ,a.[趨向ADX] ,a.[正趨百分比] ,a.[負趨百分比] ,a.[正負DI百分比] ,a.[三大法人佔股本比%一天] ,a.[主力佔股本比%一天],a.[合計一天] ,a.[法人三天],a.[主力三天],a.[合計三天],a.[法人五天],a.[主力五天],a.[合計五天] ,a.[法人十天] ,a.[主力十天],a.[合計十天] ,a.[法人二十天] ,a.[主力二十天],a.[合計二十天] ,a.[法人預設] ,a.[主力預設] ,a.[合計預設] ,a.[一週庫存比率] ,a.[二週庫存比率] ,a.[三週庫存比率],a.[四週庫存比率],a.[五週庫存比率] ,a.[六週庫存比率] ,a.[七週庫存比率] ,a.[近二期增幅] ,a.[近三期增幅] ,a.[近四期增幅] ,a.[近五期增幅] ,a.[近六期增幅],a.[近七期增幅] ,a.[最新週],a.[資使用率] ,a.[資使用率黃金交叉次數] ,a.[券使用率] ,a.[券使用率黃金交叉次數] ,a.[券資比] ,a.[券資比黃金交叉次數] ,a.[產業分類] ,a.[交易所分類] ,a.[股本億] ,a.[日期]
FROM              obv盤中選股 INNER JOIN
                                                        View_stockchange ON obv盤中選股.代號 = View_stockchange.代號 INNER JOIN
                                                        obv計算黃金交叉次數 ON obv盤中選股.代號 = obv計算黃金交叉次數.代號 INNER JOIN
                                                        View_day2obvdate3_1 ON obv盤中選股.代號 = View_day2obvdate3_1.代號  INNER JOIN winnewdate as a on obv計算黃金交叉次數.代號 = a.股票代號 and obv計算黃金交叉次數.日期 = a.日期
                             INNER JOIN macdpic on  a.股票代號 = macdpic.股票代號 and a.日期 = macdpic.日期
WHERE          (obv盤中選股.盤中計算出來的最新三十四日平均線 <> 0) AND (View_stockchange.代號 IN
                                                            (SELECT          代號
                                                              FROM               incomechar20)) AND (obv計算黃金交叉次數.日期 =
                                                            (SELECT          TOP (1) MAX(日期) AS Expr1
                                                              FROM               basicinfo AS basicinfo_1)) AND (obv盤中選股.盤中計算出來的最新五日平均線 <> 0) AND
                                                        (View_day2obvdate3_1.obv淨額 - obv盤中選股.盤中計算出來的最新五日平均線 < 0) and (obv盤中選股.盤中的累積obv均量 - obv盤中選股.盤中計算出來的最新五日平均線 >0)
ORDER BY   站上五日平均線張數 DESC` },
              {
                  cat: "盤中選股", title: "盤中站上obv五日均線全部+條件", sql: `obv盤中選股.名稱, obv盤中選股.代號, View_stockchange.漲幅, obv盤中選股.盤中成交價, obv盤中選股.最高,
                                                        obv盤中選股.最低, obv盤中選股.總量, obv計算黃金交叉次數.obv黃金交叉次數, obv盤中選股.前一日累積obv成交量,
                                                        obv盤中選股.盤中的單日obv均量, obv盤中選股.盤中的累積obv均量,
                                                        obv盤中選股.盤中計算出來的最新三十四日平均線,
                                                        ROUND((obv盤中選股.盤中的累積obv均量 - obv盤中選股.盤中計算出來的最新三十四日平均線)
                                                        / ABS(obv盤中選股.盤中計算出來的最新三十四日平均線) * 100, 2) AS 盤中離34日均線乖離率,(obv盤中選股.盤中的累積obv均量 - obv盤中選股.盤中計算出來的最新三十四日平均線) as 站上34日均線張數,
                                                        View_stockchange.產業分類, View_stockchange.交易所分類, View_stockchange.上市1上櫃2,
                                                        View_stockchange.股本億, obv盤中選股.盤中計算出來的最新五日平均線,
                                                        ROUND((obv盤中選股.盤中的累積obv均量 - obv盤中選股.盤中計算出來的最新五日平均線)
                                                        / ABS(obv盤中選股.盤中計算出來的最新五日平均線) * 100, 2) AS 盤中離5日均線乖離率,
(obv盤中選股.盤中的累積obv均量 - obv盤中選股.盤中計算出來的最新五日平均線) AS 站上五日平均線張數
FROM              obv盤中選股 INNER JOIN
                                                        View_stockchange ON obv盤中選股.代號 = View_stockchange.代號 INNER JOIN
                                                        obv計算黃金交叉次數 ON obv盤中選股.代號 = obv計算黃金交叉次數.代號
WHERE          (obv盤中選股.盤中計算出來的最新三十四日平均線 <> 0) AND (View_stockchange.總量 >= 5000)
AND (obv計算黃金交叉次數.日期 = (SELECT          TOP (1) MAX(日期) AS Expr1
                                                              FROM               basicinfo AS basicinfo_1)) and (ROUND((obv盤中選股.盤中的累積obv均量 - obv盤中選股.盤中計算出來的最新五日平均線)
                                                        / ABS(obv盤中選股.盤中計算出來的最新五日平均線) * 100, 2) >= -10) and (ROUND((obv盤中選股.盤中的累積obv均量 - obv盤中選股.盤中計算出來的最新五日平均線)
                                                        / ABS(obv盤中選股.盤中計算出來的最新五日平均線) * 100, 2) <= 1000) and (obv盤中選股.盤中計算出來的最新五日平均線 <> 0)
ORDER BY   站上五日平均線張數 DESC` },
              {
                  cat: "盤中選股", title: "盤中站上obv五日均線全部+條件+winnewdate", sql: `obv盤中選股.名稱, obv盤中選股.代號, View_stockchange.漲幅, obv盤中選股.盤中成交價, obv盤中選股.最高,
                                                        obv盤中選股.最低, obv盤中選股.總量, obv計算黃金交叉次數.obv黃金交叉次數, obv盤中選股.前一日累積obv成交量,
                                                        obv盤中選股.盤中的單日obv均量, obv盤中選股.盤中的累積obv均量,
                                                        obv盤中選股.盤中計算出來的最新三十四日平均線,
                                                        ROUND((obv盤中選股.盤中的累積obv均量 - obv盤中選股.盤中計算出來的最新三十四日平均線)
                                                        / ABS(obv盤中選股.盤中計算出來的最新三十四日平均線) * 100, 2) AS 盤中離34日均線乖離率,(obv盤中選股.盤中的累積obv均量 - obv盤中選股.盤中計算出來的最新三十四日平均線) as 站上34日均線張數,
                                                        View_stockchange.產業分類, View_stockchange.交易所分類, View_stockchange.上市1上櫃2,
                                                        View_stockchange.股本億, obv盤中選股.盤中計算出來的最新五日平均線,
                                                        ROUND((obv盤中選股.盤中的累積obv均量 - obv盤中選股.盤中計算出來的最新五日平均線)
                                                        / ABS(obv盤中選股.盤中計算出來的最新五日平均線) * 100, 2) AS 盤中離5日均線乖離率,
(obv盤中選股.盤中的累積obv均量 - obv盤中選股.盤中計算出來的最新五日平均線) AS 站上五日平均線張數,a.[站均],a.[均價黃金交叉次數],a.[均量黃金交叉次數],a.[三大法人黃金交叉次數],a.[外資黃金交叉次數] ,a.[投信黃金交叉次數],a.[k9],a.[d9] ,a.[週k9],a.[週d9],a.[月k9] ,a.[月d9],a.[macd],a.[集中度1日] ,a.[集中度5日] ,a.[集中度10日],a.[集中度20日] ,a.[集中度60日],a.[本益比預估] ,a.[本益比近四季],a.[股價淨值比] ,a.[現金殖利率] ,a.[正DI] ,a.[負DI] ,a.[趨向ADX] ,a.[正趨百分比] ,a.[負趨百分比] ,a.[正負DI百分比] ,a.[三大法人佔股本比%一天] ,a.[主力佔股本比%一天],a.[合計一天] ,a.[法人三天],a.[主力三天],a.[合計三天],a.[法人五天],a.[主力五天],a.[合計五天] ,a.[法人十天] ,a.[主力十天],a.[合計十天] ,a.[法人二十天] ,a.[主力二十天],a.[合計二十天] ,a.[法人預設] ,a.[主力預設] ,a.[合計預設] ,a.[一週庫存比率] ,a.[二週庫存比率] ,a.[三週庫存比率],a.[四週庫存比率],a.[五週庫存比率] ,a.[六週庫存比率] ,a.[七週庫存比率] ,a.[近二期增幅] ,a.[近三期增幅] ,a.[近四期增幅] ,a.[近五期增幅] ,a.[近六期增幅],a.[近七期增幅] ,a.[最新週],a.[資使用率] ,a.[資使用率黃金交叉次數] ,a.[券使用率] ,a.[券使用率黃金交叉次數] ,a.[券資比] ,a.[券資比黃金交叉次數] ,a.[產業分類] ,a.[交易所分類] ,a.[股本億] ,a.[日期]
FROM              obv盤中選股 INNER JOIN
                                                        View_stockchange ON obv盤中選股.代號 = View_stockchange.代號 INNER JOIN
                                                        obv計算黃金交叉次數 ON obv盤中選股.代號 = obv計算黃金交叉次數.代號  INNER JOIN winnewdate as a on obv計算黃金交叉次數.代號 = a.股票代號 and obv計算黃金交叉次數.日期 = a.日期
WHERE          (obv盤中選股.盤中計算出來的最新三十四日平均線 <> 0) AND (View_stockchange.總量 >= 5000)
AND (obv計算黃金交叉次數.日期 = (SELECT          TOP (1) MAX(日期) AS Expr1
                                                              FROM               basicinfo AS basicinfo_1)) and (ROUND((obv盤中選股.盤中的累積obv均量 - obv盤中選股.盤中計算出來的最新五日平均線)
                                                        / ABS(obv盤中選股.盤中計算出來的最新五日平均線) * 100, 2) >= -10) and (ROUND((obv盤中選股.盤中的累積obv均量 - obv盤中選股.盤中計算出來的最新五日平均線)
                                                        / ABS(obv盤中選股.盤中計算出來的最新五日平均線) * 100, 2) <= 1000) and (obv盤中選股.盤中計算出來的最新五日平均線 <> 0)
ORDER BY   站上五日平均線張數 DESC` },
              {
                  cat: "盤中選股", title: "盤中站上obv五日均線全部+條件+winnewdate+macd紅綠棒", sql: `obv盤中選股.名稱, obv盤中選股.代號, View_stockchange.漲幅, obv盤中選股.盤中成交價, obv盤中選股.最高,
                                                        obv盤中選股.最低, obv盤中選股.總量, obv計算黃金交叉次數.obv黃金交叉次數, obv盤中選股.前一日累積obv成交量,
                                                        obv盤中選股.盤中的單日obv均量, obv盤中選股.盤中的累積obv均量,
                                                        obv盤中選股.盤中計算出來的最新三十四日平均線,
                                                        ROUND((obv盤中選股.盤中的累積obv均量 - obv盤中選股.盤中計算出來的最新三十四日平均線)
                                                        / ABS(obv盤中選股.盤中計算出來的最新三十四日平均線) * 100, 2) AS 盤中離34日均線乖離率,
                                                        obv盤中選股.盤中的累積obv均量 - obv盤中選股.盤中計算出來的最新三十四日平均線 AS 站上34日均線張數,
                                                        View_stockchange.產業分類, View_stockchange.交易所分類, View_stockchange.上市1上櫃2,
                                                        View_stockchange.股本億, obv盤中選股.盤中計算出來的最新五日平均線,
                                                        ROUND((obv盤中選股.盤中的累積obv均量 - obv盤中選股.盤中計算出來的最新五日平均線)
                                                        / ABS(obv盤中選股.盤中計算出來的最新五日平均線) * 100, 2) AS 盤中離5日均線乖離率,
                                                        obv盤中選股.盤中的累積obv均量 - obv盤中選股.盤中計算出來的最新五日平均線 AS 站上五日平均線張數,macdpic.DIF減MACD,a.[站均],a.[均價黃金交叉次數],ROUND((((((((a.均價黃金交叉次數 + a.k9 / 5) - a.d9 / 5)
                                                        + a.週k9 / 5) - a.週d9 / 5) + a.月k9 / 5) - a.月d9 / 5)
                                                        + a.合計十天 / 10) + a.三週庫存比率 / 100, 2) AS 加權總分,a.[均量黃金交叉次數],a.[三大法人黃金交叉次數],a.[外資黃金交叉次數] ,a.[投信黃金交叉次數],a.[k9],a.[d9] ,a.[週k9],a.[週d9],a.[月k9] ,a.[月d9],a.[macd],a.[集中度1日] ,a.[集中度5日] ,a.[集中度10日],a.[集中度20日] ,a.[集中度60日],a.[本益比預估] ,a.[本益比近四季],a.[股價淨值比] ,a.[現金殖利率] ,a.[正DI] ,a.[負DI] ,a.[趨向ADX] ,a.[正趨百分比] ,a.[負趨百分比] ,a.[正負DI百分比] ,a.[三大法人佔股本比%一天] ,a.[主力佔股本比%一天],a.[合計一天] ,a.[法人三天],a.[主力三天],a.[合計三天],a.[法人五天],a.[主力五天],a.[合計五天] ,a.[法人十天] ,a.[主力十天],a.[合計十天] ,a.[法人二十天] ,a.[主力二十天],a.[合計二十天] ,a.[法人預設] ,a.[主力預設] ,a.[合計預設] ,a.[一週庫存比率] ,a.[二週庫存比率] ,a.[三週庫存比率],a.[四週庫存比率],a.[五週庫存比率] ,a.[六週庫存比率] ,a.[七週庫存比率] ,a.[近二期增幅] ,a.[近三期增幅] ,a.[近四期增幅] ,a.[近五期增幅] ,a.[近六期增幅],a.[近七期增幅] ,a.[最新週],a.[資使用率] ,a.[資使用率黃金交叉次數] ,a.[券使用率] ,a.[券使用率黃金交叉次數] ,a.[券資比] ,a.[券資比黃金交叉次數] ,a.[產業分類] ,a.[交易所分類] ,a.[股本億] ,a.[日期]
FROM              obv盤中選股 INNER JOIN
                                                        View_stockchange ON obv盤中選股.代號 = View_stockchange.代號 INNER JOIN
                                                        obv計算黃金交叉次數 ON obv盤中選股.代號 = obv計算黃金交叉次數.代號 INNER JOIN
                                                        View_day2obvdate3_1 ON obv盤中選股.代號 = View_day2obvdate3_1.代號  INNER JOIN winnewdate as a on obv計算黃金交叉次數.代號 = a.股票代號 and obv計算黃金交叉次數.日期 = a.日期 INNER JOIN macdpic on  a.股票代號 = macdpic.股票代號 and a.日期 = macdpic.日期
WHERE          (obv盤中選股.盤中計算出來的最新三十四日平均線 <> 0) AND (View_stockchange.代號 IN
                                                            (SELECT          代號
                                                              FROM               incomechar20)) AND (obv計算黃金交叉次數.日期 =
                                                            (SELECT          TOP (1) MAX(日期) AS Expr1
                                                              FROM               basicinfo AS basicinfo_1)) AND (obv盤中選股.盤中計算出來的最新五日平均線 <> 0) AND
                                                        (View_day2obvdate3_1.obv淨額 - obv盤中選股.盤中計算出來的最新五日平均線 < 0) and (obv盤中選股.盤中的累積obv均量 - obv盤中選股.盤中計算出來的最新五日平均線 >0)
and (macdpic.DIF減MACD >0) and (macdpic.DIF減MACD <10)
ORDER BY   站上五日平均線張數 DESC` },
              {
                  cat: "盤中選股", title: "盤中站上obv三十四日圴線+自選股", sql: `obv盤中選股.名稱, obv盤中選股.代號, View_stockchange.漲幅, obv盤中選股.盤中成交價, obv盤中選股.最高,
                                                        obv盤中選股.最低, obv盤中選股.總量, obv計算黃金交叉次數.obv黃金交叉次數, obv盤中選股.前一日累積obv成交量,
                                                        obv盤中選股.盤中的單日obv均量, obv盤中選股.盤中的累積obv均量,
                                                        obv盤中選股.盤中計算出來的最新三十四日平均線,
                                                        ROUND((obv盤中選股.盤中的累積obv均量 - obv盤中選股.盤中計算出來的最新三十四日平均線)
                                                        / ABS(obv盤中選股.盤中計算出來的最新三十四日平均線) * 100, 2) AS 盤中離34日均線乖離率, (obv盤中選股.盤中的累積obv均量-obv盤中選股.盤中計算出來的最新三十四日平均線) as 站上34日均線張數,
                                                        View_stockchange.產業分類, View_stockchange.交易所分類, View_stockchange.上市1上櫃2,
                                                        View_stockchange.股本億, obv盤中選股.盤中計算出來的最新五日平均線,
                                                        ROUND((obv盤中選股.盤中的累積obv均量 - obv盤中選股.盤中計算出來的最新五日平均線)                / ABS(obv盤中選股.盤中計算出來的最新五日平均線) * 100, 2) AS 盤中離5日均線乖離率 ,
(obv盤中選股.盤中的累積obv均量 - obv盤中選股.盤中計算出來的最新五日平均線) AS 站上五日平均線張數
FROM              obv盤中選股 INNER JOIN
                                                        View_stockchange ON obv盤中選股.代號 = View_stockchange.代號 INNER JOIN
                                                        obv計算黃金交叉次數 ON obv盤中選股.代號 = obv計算黃金交叉次數.代號
WHERE          (obv盤中選股.盤中計算出來的最新三十四日平均線 <> 0) AND (View_stockchange.代號 IN
                                                            (SELECT          代號
                                                              FROM               incomechar20)) AND (obv計算黃金交叉次數.日期 =
                                                            (SELECT          TOP (1) MAX(日期) AS Expr1
                                                              FROM               basicinfo AS basicinfo_1)) and (obv盤中選股.盤中計算出來的最新五日平均線 <> 0)
ORDER BY   站上34日均線張數 DESC` },
              {
                  cat: "盤中選股", title: "盤中站上obv三十四日圴線全部+條件", sql: `obv盤中選股.名稱, obv盤中選股.代號, View_stockchange.漲幅, obv盤中選股.盤中成交價, obv盤中選股.最高,
                                                        obv盤中選股.最低, obv盤中選股.總量, obv計算黃金交叉次數.obv黃金交叉次數, obv盤中選股.前一日累積obv成交量,
                                                        obv盤中選股.盤中的單日obv均量, obv盤中選股.盤中的累積obv均量,
                                                        obv盤中選股.盤中計算出來的最新三十四日平均線,
                                                        ROUND((obv盤中選股.盤中的累積obv均量 - obv盤中選股.盤中計算出來的最新三十四日平均線)
                                                        / ABS(obv盤中選股.盤中計算出來的最新三十四日平均線) * 100, 2) AS 盤中離34日均線乖離率,(obv盤中選股.盤中的累積obv均量 - obv盤中選股.盤中計算出來的最新三十四日平均線) as 站上34日均線張數,
                                                        View_stockchange.產業分類, View_stockchange.交易所分類, View_stockchange.上市1上櫃2,
                                                        View_stockchange.股本億, obv盤中選股.盤中計算出來的最新五日平均線,
                                                        ROUND((obv盤中選股.盤中的累積obv均量 - obv盤中選股.盤中計算出來的最新五日平均線)
                                                        / ABS(obv盤中選股.盤中計算出來的最新五日平均線) * 100, 2) AS 盤中離5日均線乖離率,
(obv盤中選股.盤中的累積obv均量 - obv盤中選股.盤中計算出來的最新五日平均線) AS 站上五日平均線張數
FROM              obv盤中選股 INNER JOIN
                                                        View_stockchange ON obv盤中選股.代號 = View_stockchange.代號 INNER JOIN
                                                        obv計算黃金交叉次數 ON obv盤中選股.代號 = obv計算黃金交叉次數.代號
WHERE          (obv盤中選股.盤中計算出來的最新三十四日平均線 <> 0) AND (View_stockchange.總量 >= 5000)
AND (obv計算黃金交叉次數.日期 = (SELECT          TOP (1) MAX(日期) AS Expr1
                                                              FROM               basicinfo AS basicinfo_1)) and (ROUND((obv盤中選股.盤中的累積obv均量 - obv盤中選股.盤中計算出來的最新五日平均線)
                                                        / ABS(obv盤中選股.盤中計算出來的最新五日平均線) * 100, 2) >= -10) and (ROUND((obv盤中選股.盤中的累積obv均量 - obv盤中選股.盤中計算出來的最新五日平均線)
                                                        / ABS(obv盤中選股.盤中計算出來的最新五日平均線) * 100, 2) <= 1000) and (obv盤中選股.盤中計算出來的最新五日平均線 <> 0)
ORDER BY   站上34日均線張數 DESC` },
              {
                  cat: "盤中選股", title: "自選股+盤中+綜合+OBV均線", sql: `a.[股票名稱],a.[股票代號],a.[站均],a.[均價黃金交叉次數],ROUND((((((((a.均價黃金交叉次數 + a.k9 / 5) - a.d9 / 5)
                                                        + a.週k9 / 5) - a.週d9 / 5) + a.月k9 / 5) - a.月d9 / 5)
                                                        + a.合計十天 / 10) + a.三週庫存比率 / 100, 2) AS 加權總分,a.[均量黃金交叉次數],a.[三大法人黃金交叉次數],a.[外資黃金交叉次數] ,a.[投信黃金交叉次數],c.盤中的累積obv均量,c.盤中計算出來的最新三十四日平均線,c.盤中計算出來的最新五日平均線,c.盤中的累積obv均量-c.盤中計算出來的最新五日平均線 as 新站上五日均線,c.盤中的累積obv均量-c.盤中計算出來的最新三十四日平均線 as 新站上三十四日均線,macdpic.DIF減MACD,a.[k9],a.[d9] ,a.[週k9],a.[週d9],a.[月k9] ,a.[月d9],a.[macd],a.[集中度1日] ,a.[集中度5日] ,a.[集中度10日],a.[集中度20日] ,a.[集中度60日],a.[本益比預估] ,a.[本益比近四季],a.[股價淨值比] ,a.[現金殖利率] ,a.[正DI] ,a.[負DI] ,a.[趨向ADX] ,a.[正趨百分比] ,a.[負趨百分比] ,a.[正負DI百分比] ,a.[三大法人佔股本比%一天] ,a.[主力佔股本比%一天],a.[合計一天] ,a.[法人三天],a.[主力三天],a.[合計三天],a.[法人五天],a.[主力五天],a.[合計五天] ,a.[法人十天] ,a.[主力十天],a.[合計十天] ,a.[法人二十天] ,a.[主力二十天],a.[合計二十天] ,a.[法人預設] ,a.[主力預設] ,a.[合計預設] ,a.[一週庫存比率] ,a.[二週庫存比率] ,a.[三週庫存比率],a.[四週庫存比率],a.[五週庫存比率] ,a.[六週庫存比率] ,a.[七週庫存比率] ,a.[近二期增幅] ,a.[近三期增幅] ,a.[近四期增幅] ,a.[近五期增幅] ,a.[近六期增幅],a.[近七期增幅] ,a.[最新週],a.[資使用率] ,a.[資使用率黃金交叉次數] ,a.[券使用率] ,a.[券使用率黃金交叉次數] ,a.[券資比] ,a.[券資比黃金交叉次數] ,a.[產業分類] ,a.[交易所分類] ,a.[股本億] ,a.[日期], b.成交價 as 盤中成交價, b.漲跌, b.漲幅, b.總量 as 盤中總量 from winnewdate as a inner join view_basicinfo as b on a.股票代號 = b.代號 inner join obvdatea5 as d on d.代號 = a.[股票代號] and d.日期 = a.日期 inner join obv盤中選股 as c on d.代號 = c.代號 INNER JOIN macdpic on  a.股票代號 = macdpic.股票代號 and a.日期 = macdpic.日期
where (b.代號 IN (SELECT 代號 FROM  incomechar20)) AND (a.日期 = (SELECT TOP (1) MAX(日期) AS Expr1  FROM basicinfo AS basicinfo_1))
order by c.盤中的累積obv均量-c.盤中計算出來的最新五日平均線 desc` },

              {
                  cat: "其他", title: "結果轉成JSON格式", sql: `priceincrease1.名稱, priceincrease1.代號,
                                   ROUND(priceincrease10.成交價漲幅百分比 - priceincrease4.成交價漲幅百分比, 2) AS 前8期漲幅,
                                   ROUND(priceincrease3.成交量漲幅百分比, 2) AS 近3期量增幅,
                                   View_stockchange.成交價, View_stockchange.漲幅, View_stockchange.總量,
                                   priceincrease1.成交價漲幅百分比 AS 近2期價漲幅, priceincrease2.成交價漲幅百分比 AS 近3期價漲幅,
                                   priceincrease3.成交價漲幅百分比 AS 近4期價漲幅, priceincrease4.成交價漲幅百分比 AS 近5期價漲幅,
                                   priceincrease5.成交價漲幅百分比 AS 近6期價漲幅, priceincrease6.成交價漲幅百分比 AS 近7期價漲幅,
                                   priceincrease7.成交價漲幅百分比 AS 近8期價漲幅, priceincrease8.成交價漲幅百分比 AS 近9期價漲幅,
                                   priceincrease9.成交價漲幅百分比 AS 近10期價漲幅, priceincrease10.成交價漲幅百分比 AS 近11期價漲幅,
                                   View_stockchange.產業分類, View_stockchange.交易所分類, View_stockchange.股本億,
                                   priceincrease1.本日 AS 今日, priceincrease10.前一日 AS 前日,STRING_AGG(View_notioninfo.name1, ', ') AS 概念股
FROM priceincrease1
INNER JOIN priceincrease4 ON priceincrease1.代號 = priceincrease4.代號
LEFT OUTER JOIN priceincrease5 ON priceincrease1.代號 = priceincrease5.代號
LEFT OUTER JOIN priceincrease6 ON priceincrease1.代號 = priceincrease6.代號
LEFT OUTER JOIN priceincrease7 ON priceincrease1.代號 = priceincrease7.代號
LEFT OUTER JOIN priceincrease8 ON priceincrease1.代號 = priceincrease8.代號
LEFT OUTER JOIN priceincrease9 ON priceincrease1.代號 = priceincrease9.代號
LEFT OUTER JOIN priceincrease10 ON priceincrease1.代號 = priceincrease10.代號
LEFT OUTER JOIN View_stockchange ON priceincrease1.代號 = View_stockchange.代號
LEFT OUTER JOIN View_notioninfo ON priceincrease1.名稱 = View_notioninfo.mail1
LEFT OUTER JOIN priceincrease3 ON priceincrease1.代號 = priceincrease3.代號
LEFT OUTER JOIN priceincrease2 ON priceincrease1.代號 = priceincrease2.代號
WHERE (priceincrease3.成交價漲幅百分比 < 15)
                              AND (priceincrease3.成交價漲幅百分比 > -3)
                              AND (priceincrease10.成交價漲幅百分比 - priceincrease4.成交價漲幅百分比 < 3)
                              AND (priceincrease10.成交價漲幅百分比 - priceincrease4.成交價漲幅百分比 > -5)
                              AND (priceincrease3.成交量漲幅百分比 > 50)
                              AND (View_stockchange.總量 > 500)
GROUP BY priceincrease1.名稱, priceincrease1.代號,
                                     ROUND(priceincrease10.成交價漲幅百分比 - priceincrease4.成交價漲幅百分比, 2),
                                     ROUND(priceincrease3.成交量漲幅百分比, 2),
                                     View_stockchange.成交價, View_stockchange.漲幅, View_stockchange.總量,
                                     priceincrease1.成交價漲幅百分比, priceincrease2.成交價漲幅百分比, priceincrease3.成交價漲幅百分比,
                                     priceincrease4.成交價漲幅百分比, priceincrease5.成交價漲幅百分比, priceincrease6.成交價漲幅百分比,
                                     priceincrease7.成交價漲幅百分比, priceincrease8.成交價漲幅百分比, priceincrease9.成交價漲幅百分比,
                                     priceincrease10.成交價漲幅百分比, View_stockchange.產業分類, View_stockchange.交易所分類,
                                     View_stockchange.股本億, priceincrease1.本日, priceincrease10.前一日
ORDER BY 近4期價漲幅 DESC
FOR JSON PATH` },
              { cat: "自選股", title: "四季紅", sql: `* FROM incomechar` },
              { cat: "自選股", title: "黃金交金叉", sql: `* FROM incomechar19` },
              { cat: "自選股", title: "所有自選股資訊", sql: ` * from textmsg where 識別碼 >= 21` },

              //{ cat: "類", title: "關", sql: `top 100 * FROM favor1 WHERE word1 LIKE '%deepseek%' ORDER BY 時間戳記 DESC` },
              //{ cat: "搜尋類", title: "關鍵字搜尋我的最愛", sql: `top 100 * FROM favor1 WHERE word1 LIKE '%deepseek%' ORDER BY 時間戳記 DESC` },
              //{ cat: "搜尋類", title: "關鍵字搜尋我的最愛", sql: `top 100 * FROM favor1 WHERE word1 LIKE '%deepseek%' ORDER BY 時間戳記 DESC` },

          ];

          $(document).ready(function () {
              // --- 初始化範本選單函數 ---
              function loadTemplates(filter = "") {
                  const $select = $("#sqlTemplates").empty().append('<option value="">-- 請選擇範本 --</option>');
                  const filtered = sqlTemplateLibrary.filter(t => t.title.includes(filter) || t.cat.includes(filter));
                  let lastCat = "";
                  let $group = null;

                  filtered.forEach(t => {
                      if (t.cat !== lastCat) {
                          lastCat = t.cat;
                          $group = $(`<optgroup label="【${lastCat}】"></optgroup>`).appendTo($select);
                      }
                      $group.append(`<option value="${t.sql}">${t.title}</option>`);
                  });
              }

              // 1. 初始載入選單
              loadTemplates();

              // 2. 搜尋功能連動
              $("#templateSearch").on("input", function () {
                  loadTemplates($(this).val());
              });

              // 3. 選單改變連動 (已將 ID 修正為 sqlText)
              $("#sqlTemplates").on("change", function () {
                  const selectedSql = $(this).val();
                  if (selectedSql) {
                      $("#select指令1").val(selectedSql);
                  }
              });
          }); // 這裡補齊了關閉符號



      </script>
</head>
<body>
    <form id="form1" runat="server">
   <nav class="navbar navbar-expand-lg navbar-dark bg-dark ptest2">
     <a class="navbar-brand" href="https://zen2965.duckdns.org:8888/excelimport/excelimport3">首頁</a>
     <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
         <span class="navbar-toggler-icon"></span>
     </button>

     <div class="collapse navbar-collapse" id="navbarSupportedContent">
         <ul class="navbar-nav mr-auto">

             <li class="nav-item dropdown">
                 <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown1" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                     新選股
                 </a>
                 <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/excelimport/excelsql.html">excelsql html版</a>
                     <a class="dropdown-item" href="https://weizen99.github.io/androidapp/excelsql.html">excelsql github版</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/excelimport/excelimport3" ">excelsql新版</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/androidapp/basicinfotable2.html">WebApi彙總新版</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/mymvc/messageword01.aspx">我的最愛SQL版</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/mymvc/messageword05.aspx">股票概念股</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/mymvc/messageword06.aspx">美股代號名稱</a>
                     <div class="dropdown-divider"></div>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/excelimport/message5.html">留言系統html版</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/excelimport/message.aspx">留言系統asp版</a>
                     <div class="dropdown-divider"></div>
                     <a class="dropdown-item" href="https://weizen99.github.io/androidapp/map.html">定位+資料庫github</a>
                     <a class="dropdown-item" href="http://www.hacker1.somee.com/maptest">somee地圖定位</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/excelimport/googlesheet.html">讀取Google試算表</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/androidapp/index.html">somee連結等</a>


                 </div>
             </li>

             <li class="nav-item dropdown">
                 <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown1" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                     選股
                 </a>
                 <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/pricepicking.aspx">漲幅選股</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/goldencrosspicking.aspx">均線均量法人黃金交叉選股+主力法人</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/goldencross1.aspx">法人黃金交叉選股</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/goldencross1picking.aspx">均線均量法人黃金交叉選股+集中度等</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/goldencrosspicking1.aspx">均線均量法人黃金交叉選股漲幅+股權</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/todaydmi.aspx">均線均價法人黃金交叉+DMI</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/financingbillscount.aspx">融資+融券+券資比黃金交叉選股</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/pricepicking1.aspx">彙總顯示(超長欄位)</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/winnewdatechart.aspx">黃金交叉圖表</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/kdj.aspx">kdj選股</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/kdjdate.aspx">黃金交叉及kdj選股樞紐分析顯示</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/pricepicking2.aspx">成交價(量)標準差 OBV量能 macd+j 圖形</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/pricepicking4.aspx">增加本日macd紅綠棒值+J值(近三日)</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/pricepicking3.aspx">三大法人標準差選股</a>
                     <div class="dropdown-divider"></div>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/work/webpic30.aspx">產業資訊</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888//lookpicture/stockgodpc.aspx">經營項目</a>
                     <div class="dropdown-divider"></div>

                     <div class="dropdown-divider"></div>

                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/View_集中市場1/Index">集中市場黃金交叉個數</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/View_櫃買市場1/Index">櫃買市場黃金交叉個數</a>

                 </div>
             </li>

             <li class="nav-item dropdown">
                 <a class="nav-link dropdown-toggle" href="#" id="navbarDropdowntotol99" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                     自選股彙總查詢
                 </a>

                 <div class="dropdown-menu" aria-labelledby="navbarDropdown">

                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/View_merage1/Index">均線均價法人黃金交叉+漲幅 股權週增幅% 自選股0</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/View_merage1/Index1">均線均價法人黃金交叉+漲幅 股權週增幅% 自選股1</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/View_merage1/Index2">均線均價法人黃金交叉+漲幅 股權週增幅% 自選股2</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/View_merage1/Index3">均線均價法人黃金交叉+漲幅 股權週增幅% 自選股3</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/View_merage1/Index4">均線均價法人黃金交叉+漲幅 股權週增幅% 自選股4</a>
                     <div class="dropdown-divider"></div>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/View_merage2/Index">均線均價法人黃金交叉+漲幅 法人主力投本比% 自選股0</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/View_merage2/Index1">均線均價法人黃金交叉+漲幅 法人主力投本比% 自選股1</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/View_merage2/Index2">均線均價法人黃金交叉+漲幅 法人主力投本比% 自選股2</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/View_merage2/Index3">均線均價法人黃金交叉+漲幅 法人主力投本比% 自選股3</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/View_merage2/Index4">均線均價法人黃金交叉+漲幅 法人主力投本比% 自選股4</a>
                     <div class="dropdown-divider"></div>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/View_merage3/Index">均線均價法人黃金交叉+集中度 自選股0</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/View_merage3/Index1">均線均價法人黃金交叉+集中度 自選股1</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/View_merage3/Index2">均線均價法人黃金交叉+集中度 自選股2</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/View_merage3/Index3">均線均價法人黃金交叉+集中度 自選股3</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/View_merage3/Index4">均線均價法人黃金交叉+集中度 自選股4</a>
                     <div class="dropdown-divider"></div>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/View_merage4/Index">均線均價法人黃金交叉+dmi 自選股0</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/View_merage4/Index1">均線均價法人黃金交叉+dmi 自選股1</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/View_merage4/Index2">均線均價法人黃金交叉+dmi 自選股2</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/View_merage4/Index3">均線均價法人黃金交叉+dmi 自選股3</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/View_merage4/Index4">均線均價法人黃金交叉+dmi 自選股4</a>
                     <div class="dropdown-divider"></div>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/winnews/Index">彙總查詢 自選股0</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/winnews/Index1">彙總查詢 自選股1</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/winnews/Index2">彙總查詢 自選股2</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/winnews/Index3">彙總查詢 自選股3</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/winnews/Index4">彙總查詢 自選股4</a>
                     <div class="dropdown-divider"></div>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/View_%E6%88%90%E4%BA%A4%E5%80%BC%E5%89%8D150%E5%90%8D_%E9%BB%83%E9%87%91%E4%BA%A4%E5%8F%89%E7%AD%89/Index">成交值前150名_黃金交叉等</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/View_%E6%8A%95%E4%BF%A1%E6%8E%92%E5%90%8D%E4%B8%80%E5%A4%A9_%E9%BB%83%E9%87%91%E4%BA%A4%E5%8F%89/Index">投信排名一天前150名_黃金交叉</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/View_%E5%A4%96%E8%B3%87%E6%8E%92%E5%90%8D%E4%B8%80%E5%A4%A9_%E9%BB%83%E9%87%91%E4%BA%A4%E5%8F%89/Index">外資排名一天(不含ky股票)前150名_黃金交叉</a>
                 </div>
             </li>


             <li class="nav-item dropdown">
                 <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown2" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                     各類查詢
                 </a>
                 <div class="dropdown-menu" aria-labelledby="navbarDropdown">

                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/View_daymerge/index">法人主力買賣明細</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/綜合一天/index">主力法人佔股本一天</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/View_主力加法人佔股本比彙總/index">主力法人佔股本多天</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/View_weekequity/index">股權增幅</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/View_equitybig400/index">股權400張以上</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/View_equitybig400/index100">1000張以上</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/View_equitybig400/index10">10張以下</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/View_均線均量彙總/index">均線均量資訊</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/incomesums/index">營業額</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/financesums/index">財務資料</a>



                 </div>
             </li>

             <li class="nav-item dropdown">
                 <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown3" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                     股權比率
                 </a>
                 <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/View_weekequity/Index">股權比率單股</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/View_equitybig400/Index">股權400張以上</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/View_equitybig400/Index1000">1000張以上</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/View_equitybig400/Index10">10張以下散戶</a>
                     <div class="dropdown-divider"></div>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/View_weekequity/Index1">股權增幅最新前50名</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/View_weekequity/自選股0">股權比率自選股0</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/View_weekequity/自選股1">股權比率自選股1</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/View_weekequity/自選股2">股權比率自選股2</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/View_weekequity/自選股3">股權比率自選股3</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/View_weekequity/自選股4">股權比率自選股4</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/View_weekequity/自選股5">股權比率自選股5</a>
                     <div class="dropdown-divider"></div>



                 </div>
             </li>

             <li class="nav-item dropdown">
                 <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown4" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                     主力+法人佔股本比
                 </a>
                 <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/綜合一天/index">綜合一天單股</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/綜合三天/index">綜合亖天單股</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/綜合五天/index">綜合五天單股</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/綜合十天/index">綜合十天單股</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/綜合二十天/index">綜合二十天單股</a>

                     <div class="dropdown-divider"></div>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/View_主力加法人佔股本比彙總/index">綜合多天單股</a>

                     <div class="dropdown-divider"></div>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/綜合一天/index1">綜合一天單天前50</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/綜合三天/index1">綜合三天單天前50</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/綜合五天/index1">綜合五天單天前50</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/綜合十天/index1">綜合十天單天前50</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/綜合二十天/index1">綜合二十天單天前50</a>

                     <div class="dropdown-divider"></div>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/綜合一天/自選股0">綜合一天自選股0</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/綜合一天/自選股1">綜合一天自選股1</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/綜合一天/自選股2">綜合一天自選股2</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/綜合一天/自選股3">綜合一天自選股3</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/綜合一天/自選股4">綜合一天自選股4</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/綜合一天/自選股5">綜合一天自選股5</a>
                     <div class="dropdown-divider"></div>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/綜合三天/自選股2">綜合三天自選股0</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/綜合五天/自選股3">綜合五天自選股0</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/綜合十天/自選股4">綜合十天自選股0</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/綜合二十天/自選股5">綜合二十天自選股0</a>
                     <div class="dropdown-divider"></div>
                 </div>
             </li>
             <li class="nav-item dropdown">
                 <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown5" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                     營業額等
                 </a>
                 <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/incomesums/Index">營業額單股全部</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/financesums/Index">財務單股全部</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/View_daymerge/Index">法人主力買賣超資訊</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/View_均線均量彙總/Index">均線均量資訊</a>
                     <div class="dropdown-divider"></div>


                 </div>
             </li>
             <li class="nav-item dropdown">
                 <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown7" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                     近一年籌碼
                 </a>
                 <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/stockinfo01/info01">資料表一</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/stockinfo01/info02">資料表二</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/stockinfo01/info03">資料表三</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/stockinfo01/info04">資料表四</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/Mvc%20web/stockinfo01/info05">資料表五</a>

                     <div class="dropdown-divider"></div>

                 </div>
             </li>
             <li class="nav-item dropdown">
                 <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown6" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                     其他
                 </a>
                 <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/stockquery/dayoff">股權均線法人等綜合查詢</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/stockquery/trend1">主力法人佔股本比排名</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/fishnew5/income10">Dmi Kd Macd</a>
                     <div class="dropdown-divider"></div>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/fishnew5/poem_stock11">成交值等樞紐分析150名</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/fishnew5/poem1_stockchips">投信外資買賣樞紐分析150名</a>
                     <div class="dropdown-divider"></div>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/mymvc/incomeseason.aspx">最近五年營業額圖表</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/mymvc/fseason.aspx">最近五年EPS圖表</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/mymvc/fgrowth.aspx">最近五年三率圖表</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/mymvc/threechart.aspx">三大法人買賣圖表</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/mymvc/trend1.aspx">綜合資料查詢圖表</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/mymvc/trend2.aspx">黃金交叉彙總+kdj+obv</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/mymvc/trend3.aspx">黃金交叉彙總1+kdj+obv十三個圖表</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/mymvc/trend3s1.aspx">黃金交叉彙總1+kdj+obv三個圖表</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/mymvc/trend4.aspx">黃金交叉彙總1+kdj+obv兩個圖表</a>
                     <div class="dropdown-divider"></div>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/fishnew5/poemaccesshistory">Asp版主頁</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/androidapp/index.html">手機版主頁</a>
                     <a class="dropdown-item" href="https://sites.google.com/view/weizenyan/%E9%A6%96%E9%A0%81">google script網頁</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/excelimport/excelimport2">SQL指令查詢直接下載成excel</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/stockquery/readtext">edge瀏覽器朗讀小說</a>
                     <a class="dropdown-item" href="https://zen2965.duckdns.org:8888/work/myherowars.aspx">我的遊戲輔助網頁</a>



                 </div>
             </li>

         </ul>
     </div>
 </nav>
 <br />

           <ul class="nav nav-tabs auto-style1">
           <li class="nav-item"><a class="nav-link active auto-style2" href="https://zen2965.duckdns.org:8888/excelimport/excelimport2">Excel SQL(本頁)</a> </li>
          <li class="nav-item"><a class="nav-link auto-style2" href="https://zen2965.duckdns.org:8888/stockquery/incomeedit1">自選股編輯(請找空白的使用)</a> </li>
          <li class="nav-item"><a class="nav-link auto-style2" href="https://zen2965.duckdns.org:8888/mymvc/selfselected1.aspx">自選股內容說明</a> </li>
          <li class="nav-item"><a class="nav-link auto-style2" href="https://zen2965.duckdns.org:8888/mymvc/trend3.aspx">顯示十三個圖表</a> </li>
          <li class="nav-item"><a class="nav-link auto-style2" href="https://zen2965.duckdns.org:8888/mymvc/trend3s1.aspx">顯示三個圖表</a> </li>
          <li class="nav-item"><a class="nav-link auto-style2" href="https://zen2965.duckdns.org:8888/mymvc/trend4stock1.aspx">四個圖表(K線+均線等最新)</a> </li>
       
      </ul>
         <br/> 
        <div>
            
           <%-- <p><asp:Label ID="Label6" runat="server" BackColor="White" Font-Names="標楷體" Font-Size="Large" ForeColor="Blue" Text="請先選取 Excel檔案(*.xlsx),然後再上傳(***資料表內容不要有空白***),並顯示在畫面(gridview)中"></asp:Label></p>--%>
        <p>
            <asp:FileUpload ID="FileUpload1" runat="server" />
&nbsp;<asp:Label ID="Label13" runat="server" BackColor="White" Font-Names="標楷體" Font-Size="Large" ForeColor="#990000" Text="選擇那一張工作表:"></asp:Label>
               
                <asp:DropDownList ID="selectworksheet" runat="server" Font-Names="標楷體" Font-Size="Medium" ForeColor="#0000CC">
                    <asp:ListItem Value="0">第1張工作表</asp:ListItem>
                    <asp:ListItem Value="1">第2張工作表</asp:ListItem>
                    <asp:ListItem Value="2">第3張工作表</asp:ListItem>
                    <asp:ListItem Value="3">第4張工作表</asp:ListItem>
                    <asp:ListItem Value="4">第5張工作表</asp:ListItem>
                    <asp:ListItem Value="5">第6張工作表</asp:ListItem>
                    <asp:ListItem Value="6">第7張工作表</asp:ListItem>
                    <asp:ListItem Value="7">第8張工作表</asp:ListItem>
                    <asp:ListItem Value="8">第9張工作表</asp:ListItem>
                    <asp:ListItem Value="9">第10張工作表</asp:ListItem>
                </asp:DropDownList>
        &nbsp; <span class="auto-style2">&nbsp;<asp:Button ID="Button6" runat="server" Text="顯示上傳的excel(.xlsx)表" Width="211px" ToolTip="資料表內容不要有空白,不然會產生錯誤,可選擇前十個資料表的其中一個" BackColor="#000066" ForeColor="White" Font-Names="標楷體" Font-Size="Medium" Height="30px" />

                &nbsp;&nbsp;&nbsp; <asp:Label ID="Label48" runat="server" BackColor="White" Font-Names="標楷體" Font-Size="Large" ForeColor="#990000" Text="密碼:"></asp:Label>
               
                </span>
            <asp:TextBox ID="TextBox14" runat="server" AccessKey="M" BackColor="#FFFF66" Height="21px" TextMode="Password" ToolTip="刪除要輸入密碼:密碼為 " Width="135px"></asp:TextBox>
        <asp:Button ID="Button41" runat="server" Text="顯示結果在下方表格(須密碼)" Width="222px" ToolTip="無法使用預設有select字眼,如t-sql預存程序,但要先輸入密碼" BackColor="#990000" ForeColor="White" Height="30px" Font-Names="標楷體" Font-Size="Medium" />
        <asp:Button ID="Button42" runat="server" Text="SQL查詢+寫入到下載的excel中+凍結窗格" Width="320px" ToolTip="無法使用預設有select字眼,如t-sql預存程序,下載時也要先輸入密碼" BackColor="#990000" ForeColor="White" Height="30px" Font-Names="標楷體" Font-Size="Medium" />
        </p>
          
                
         
            <asp:Label ID="Label44" runat="server" BackColor="White" Font-Names="標楷體" Font-Size="Large" ForeColor="#990000" Text="應用區:("></asp:Label>
                <asp:DropDownList ID="changeselect" runat="server" AutoPostBack="True" Width="200px" Font-Names="標楷體" Font-Size="Medium" ForeColor="Blue" Height="30px">
                   
                     <asp:ListItem Value="100">27.盤中:五日乘離(自選股19自己更改)</asp:ListItem>
                     <asp:ListItem Value="101">27.盤中:五日乘離新站上(自選股19自己更改)+winnewdate(最新)</asp:ListItem>
                     <asp:ListItem Value="102">27.盤中:盤中自選股+OBV+Winnewdate(最新)</asp:ListItem>
                     <asp:ListItem Value="102">27.盤中:五日乘離選股(全部)+winnewdate+macd紅綠棒(範圍)</asp:ListItem>                    
                   
                    
                    <asp:ListItem Value="1">1.黃金交叉選股+(k&gt;=d)+macd&gt;0</asp:ListItem>
                    <asp:ListItem Value="2">3.成交價黃金交叉增加最多(列出最近四天)</asp:ListItem>
                    <asp:ListItem Value="3">4.成交量黃金交叉增加最多(列出最近四天)</asp:ListItem>
                    <asp:ListItem Value="4">5.三大法人黃金交叉增加最多(列出最近四天)</asp:ListItem>
                    <asp:ListItem Value="5">6.Macd紅綠棒+Kdj的J值</asp:ListItem>
                    <asp:ListItem Value="6">7.Obv量能潮近四期增加</asp:ListItem>
                    <asp:ListItem Value="7">8.彙總表再加上macd紅綠棒及kdj的J值</asp:ListItem>
                    <asp:ListItem Value="8">9.彙總表再加上macd紅綠棒及kdj的J值(當日macd紅綠棒及當日kdj的J值)</asp:ListItem>
                    <asp:ListItem Value="9">10.obv選股</asp:ListItem>
                    <asp:ListItem Value="10">11.kdj的J值連三增(macd紅綠棒及J值範圍)</asp:ListItem>
                    <asp:ListItem Value="11">12.kdj的J值過三高</asp:ListItem>
                    <asp:ListItem Value="12">13.Macd+j值+日期</asp:ListItem>
                    <asp:ListItem Value="13">14.總量&gt;?+紅綠棒值+今日J值(參數在下面)</asp:ListItem>
                    <asp:ListItem Value="14">15.最近八期的obv多空淨額法增減最多排序及最後四期合計數</asp:ListItem>
                    <asp:ListItem Value="15">16.最近三期obv多空淨額法淨增加皆大於0</asp:ListItem>
                    <asp:ListItem Value="16">17-1.obv多空淨額法-只要站上均線即可</asp:ListItem>
                    <asp:ListItem Value="17">17-2.obv多空淨額法-站上均線但前一日在均線下</asp:ListItem>
                    <asp:ListItem Value="18">18.加權過後的均價黃金交叉數字:均價黃金交叉次數</asp:ListItem>                  
                    <asp:ListItem Value="19">19-1.按盤中單日obv總量</asp:ListItem>
                    <asp:ListItem Value="22">19-2.按盤中單日obv總量全部</asp:ListItem>
                    <asp:ListItem Value="24">19-3.今日盤中站上均線(前一天在均線下)</asp:ListItem>
                    <asp:ListItem Value="25">19-4盤中操盤顯示1</asp:ListItem>
                    <asp:ListItem Value="26">19-5盤中操盤顯示2</asp:ListItem>                                       
                    <asp:ListItem Value="20">20.盤後obv多空淨額法,盤中obv站上盤中三十四日均線</asp:ListItem>
                    <asp:ListItem Value="21">21-1.第一週跟第13週(股權,資料庫stockprice)</asp:ListItem>
                    <asp:ListItem Value="27">21-2單股查詢(股權,資料庫stockprice)</asp:ListItem>
                    <asp:ListItem Value="28">22.圖片類查詢ai_girl,按有圖片</asp:ListItem>
                    <asp:ListItem Value="29">23.單股加權均價查詢</asp:ListItem>
                    <asp:ListItem Value="30">23.加權均價選股查詢多股</asp:ListItem>
                    <asp:ListItem Value="31">24.加權均價選股自選股(先刪除select, incomechar incomechar1 ...)</asp:ListItem>
                </asp:DropDownList>   <asp:Button ID="Button34" runat="server" Text="顯示結果在下方表格" Width="159px" ToolTip="不要使用select *(列出每個欄位),因為要人工抓表頭,如果有join多個資料表,可自行用取代成空字串方式來編輯表頭,或使用right(a1,5),先取後面五個字" BackColor="#990000" ForeColor="White" Height="30px" Font-Names="標楷體" Font-Size="Medium" />
      <asp:Label ID="Label45" runat="server" BackColor="White" Font-Names="標楷體" Font-Size="Large" ForeColor="#990000" Text=")"></asp:Label>
      <asp:Label ID="Label46" runat="server" BackColor="White" Font-Names="標楷體" Font-Size="Large" ForeColor="#990000" Text=",只限在盤中:("></asp:Label>
          <asp:Button ID="Button1" runat="server" Text="盤中操盤(obv淨額及均線)" Width="205px" ToolTip="1.請先上傳寫入基本資料.xlsx(按上方的顯示上傳的excel表) 2寫入資料 3.執預存程式(T-SQL檔)並顯示在畫中,並帶出新指令供修改 4.盤中的obv多空淨額巳突破34均線或淨額本日增加最多等等" BackColor="#660066" ForeColor="White" Font-Names="標楷體" Font-Size="Medium" Height="30px" />
      &nbsp;<asp:HyperLink ID="HyperLink46" runat="server" BackColor="White" Font-Names="標楷體" Font-Size="Large" ForeColor="#660033" Height="25px" NavigateUrl="https://zen2965.duckdns.org:8888/fishnew5sql/newstockinfo" ToolTip="須先上傳兩個盤中excel檔案" Target="_blank">盤中量價籌碼</asp:HyperLink>
      &nbsp;<asp:HyperLink ID="HyperLink47" runat="server" BackColor="White" Font-Names="標楷體" Font-Size="Large" ForeColor="#660033" Height="25px" NavigateUrl="https://zen2965.duckdns.org:8888/fishnew5sql/newstockinfo1" ToolTip="須先上傳兩個盤中excel檔案" Target="_blank">盤後焦點籌碼(多天)</asp:HyperLink>
      <asp:Label ID="Label10" runat="server" BackColor="White" Font-Names="標楷體" Font-Size="Large" ForeColor="#990000" Text=")"></asp:Label>&nbsp;&nbsp;
            <asp:Label ID="Label1" runat="server" Font-Names="標楷體" Font-Size="Large" Text="錯誤訊息" BackColor="Red" ForeColor="White"></asp:Label>
            <div class="sql-box">
    <!-- 範本載入區 -->
    <div class="template-section">
        <div class="row g-2">
            <div class="col-sm-3">

                <label class="form-label fw-bold">🔍 搜尋範本：</label>
                <input type="text" id="templateSearch" class="form-control" placeholder="輸入關鍵字..."></input>
            </div>
            <div class="col-sm-9">
                <label class="form-label fw-bold">📑 選擇 50+ 組 SQL 範本：</label>
                <select id="sqlTemplates" class="form-select">
                    <option value="">-- 請選擇範本 --</option>
                </select>
            </div>
        </div>
    </div>
   <br/>


   
</div>

      
            <p>
                <%--<asp:Label ID="Label11" runat="server" BackColor="White" Font-Names="標楷體" Font-Size="Large" ForeColor="#990000" Text="sql指令產生的資料,輸出到Excel"></asp:Label>--%>
               &nbsp; <asp:Button ID="Button9" runat="server" Text="清空SQL指今" Width="117px" ToolTip="單純的資料表(另外從資料庫抓的表頭全部欄位)" BackColor="Red" ForeColor="White" Height="30px" />
            &nbsp;
                <asp:Label ID="Label12" runat="server" BackColor="White" Font-Names="標楷體" Font-Size="Large" ForeColor="#990000" Text="最新日期:"></asp:Label>
               
&nbsp;<asp:TextBox ID="起" runat="server" Width="107px" Height="30px"></asp:TextBox>
                <span class="auto-style2"><asp:Button ID="poem1_stock相似搜尋" runat="server" Height="30px" Text="重新整理絅頁" 

            Width="120px" BackColor="#000066" ForeColor="White" ToolTip="重新整理指令會回到原始預設" Font-Names="標楷體" Font-Size="Medium" />

                &nbsp;<asp:Label ID="Label47" runat="server" BackColor="White" Font-Names="標楷體" Font-Size="Large" ForeColor="#990000" Text=", 選擇要使用的資料庫:("></asp:Label>
                <asp:TextBox ID="usedatabase" runat="server" Width="138px" Height="25px" Font-Names="標楷體" Font-Size="Medium">stockchangedate</asp:TextBox>
                <asp:DropDownList ID="changedatabase" runat="server" AutoPostBack="True" Width="148px" Font-Names="標楷體" Font-Size="Medium" ForeColor="Blue" Height="27px">
                    <asp:ListItem Selected="True">stockchangedate</asp:ListItem>
                    <asp:ListItem>stockchange</asp:ListItem>
                    <asp:ListItem>stockinfo</asp:ListItem>
                    <asp:ListItem>stockprice</asp:ListItem>
                    <asp:ListItem>work</asp:ListItem>
                    <asp:ListItem>stockchangefour</asp:ListItem>
                    <asp:ListItem>favor1</asp:ListItem>
                    <asp:ListItem>favor2</asp:ListItem>
                    <asp:ListItem>favor3</asp:ListItem>
                    <asp:ListItem>fromaccessdatabase</asp:ListItem>
                    <asp:ListItem>pokopoko</asp:ListItem>
                    <asp:ListItem>wordvoice</asp:ListItem>
                </asp:DropDownList>

                </span>
            </p>
          
        </div>
      
            <asp:Label ID="Label9" runat="server" BackColor="#660066" Font-Names="標楷體" ForeColor="White" Height="20px" Text="下載excel:請不要使用 *來列出全部欄位,因為要人工抓欄位所以要列出全部欄位,才有資料可進一步處理(有join到不同資料表,表頭比較長,要人工刪除不必要的文字)"></asp:Label>
    
        <p>
                <asp:Label ID="Label5" runat="server" Text="select指令: select "></asp:Label>
                <asp:TextBox ID="select指令1" runat="server" TextMode="MultiLine" Width="800px" ToolTip="select+空格,不用寫直接接後面" Height="360px" Font-Names="標楷體" Font-Size="Small">obv盤中選股.名稱, obv盤中選股.代號, View_stockchange.漲幅, obv盤中選股.盤中成交價, obv盤中選股.最高, 
                            obv盤中選股.最低, obv盤中選股.總量, obv計算黃金交叉次數.obv黃金交叉次數, obv盤中選股.前一日累積obv成交量, 
                            obv盤中選股.盤中的單日obv均量, obv盤中選股.盤中的累積obv均量, 
                            obv盤中選股.盤中計算出來的最新三十四日平均線, 
                            ROUND((obv盤中選股.盤中的累積obv均量 - obv盤中選股.盤中計算出來的最新三十四日平均線) 
                            / ABS(obv盤中選股.盤中計算出來的最新三十四日平均線) * 100, 2) AS 盤中離34日均線乖離率, (obv盤中選股.盤中的累積obv均量-obv盤中選股.盤中計算出來的最新三十四日平均線) as 站上34日均線張數, 
                            View_stockchange.產業分類, View_stockchange.交易所分類, View_stockchange.上市1上櫃2, 
                            View_stockchange.股本億, obv盤中選股.盤中計算出來的最新五日平均線, 
                            ROUND((obv盤中選股.盤中的累積obv均量 - obv盤中選股.盤中計算出來的最新五日平均線)                / ABS(obv盤中選股.盤中計算出來的最新五日平均線) * 100, 2) AS 盤中離5日均線乖離率 , 
(obv盤中選股.盤中的累積obv均量 - obv盤中選股.盤中計算出來的最新五日平均線) AS 站上五日平均線張數            
FROM              obv盤中選股 INNER JOIN
                            View_stockchange ON obv盤中選股.代號 = View_stockchange.代號 INNER JOIN
                            obv計算黃金交叉次數 ON obv盤中選股.代號 = obv計算黃金交叉次數.代號
WHERE          (obv盤中選股.盤中計算出來的最新三十四日平均線 <> 0) AND (View_stockchange.代號 IN
                                (SELECT          代號
                                  FROM               incomechar20)) AND (obv計算黃金交叉次數.日期 =
                                (SELECT          TOP (1) MAX(日期) AS Expr1
                                  FROM               basicinfo AS basicinfo_1)) and (obv盤中選股.盤中計算出來的最新五日平均線 <> 0)
ORDER BY   站上五日平均線張數 DESC</asp:TextBox>
                <asp:Label ID="Label7" runat="server" Text="先顯示:"></asp:Label>
        <asp:Button ID="Button20" runat="server" Text="顯示結果在下方表格" Width="158px" ToolTip="不要使用select *(列出每個欄位),因為要人工抓表頭,如果有join多個資料表,可自行用取代成空字串方式來編輯表頭,或使用right(a1,5),先取後面五個字" BackColor="#990000" ForeColor="White" Height="30px" Font-Names="標楷體" Font-Size="Medium" />
        <asp:Button ID="Button44" runat="server" Text="有圖片" Width="58px" ToolTip="如favor2資料庫,欄位:識別碼,name1,mail1,word1,photo,filekind,memo,圖片放在第五欄位" BackColor="#990000" ForeColor="White" Height="30px" Font-Names="標楷體" Font-Size="Medium" />
            <asp:DropDownList ID="filekind" runat="server" Font-Size="Medium" Height="25px" Width="50px" BackColor="#66FFFF" ToolTip="原則上會自動偵測檔案類型jpg gif png,但須建檔時有此一欄位">
                <asp:ListItem Selected="True">jpg</asp:ListItem>
                <asp:ListItem>gif</asp:ListItem>
                <asp:ListItem>png</asp:ListItem>
            </asp:DropDownList>

            
            &nbsp;<asp:Label ID="Label8" runat="server" Text=",下載:"></asp:Label>
        <asp:Button ID="Button8" runat="server" Text="SQL查詢+寫入到下載的excel中+凍結窗格" Width="305px" ToolTip="不要使用select *(列出每個欄位),因為要人工抓表頭,如果有join多個資料表,可自行用取代成空字串方式來編輯表頭,或使用right(a1,5),先取後面五個字" BackColor="#990000" ForeColor="White" Height="30px" Font-Names="標楷體" Font-Size="Medium" />
            </p>
      
 <asp:HyperLink ID="HyperLink41" runat="server" Font-Names="標楷體" Font-Size="Large" ForeColor="Red" Target="_blank" ToolTip="欄為股票名稱,列為日期(近13天),統計數字是1~150名(可自訂)成交或比率之名次排名">線型</asp:HyperLink>
 &nbsp;<asp:HyperLink ID="HyperLink42" runat="server" Font-Names="標楷體" Font-Size="Large" ForeColor="Blue" Target="_blank" ToolTip="欄為股票名稱,列為日期(近13天),統計數字是1~150名(可自訂)成交或比率之名次排名">線型</asp:HyperLink>
 &nbsp;<asp:HyperLink ID="HyperLink44" runat="server" Font-Names="標楷體" Font-Size="Large" ForeColor="Maroon" Target="_blank" ToolTip="欄為股票名稱,列為日期(近13天),統計數字是1~150名(可自訂)成交或比率之名次排名">線型</asp:HyperLink>
 &nbsp;<asp:HyperLink ID="HyperLink45" runat="server" Font-Names="標楷體" Font-Size="Large" ForeColor="#006600" Target="_blank" ToolTip="欄為股票名稱,列為日期(近13天),統計數字是1~150名(可自訂)成交或比率之名次排名">線型</asp:HyperLink>
 &nbsp;&nbsp; 
               &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <asp:TextBox ID="keyword" runat="server" Visible="False"></asp:TextBox>
        <asp:TextBox ID="keyword0" runat="server" Visible="False"></asp:TextBox>
 
      
     

 <br />

            <asp:GridView ID="GridView1" runat="server" BackColor="White" BorderColor="#999999" BorderStyle="Solid" BorderWidth="1px" CellPadding="3" ForeColor="Black" GridLines="Vertical">
                <AlternatingRowStyle BackColor="#CCCCCC" />
                <Columns>
                    <asp:CommandField HeaderText="看線型" ShowHeader="True" ShowSelectButton="True" />
                </Columns>
                <FooterStyle BackColor="#CCCCCC" />
                <HeaderStyle BackColor="Black" Font-Bold="True" ForeColor="White" />
                <PagerStyle BackColor="#999999" ForeColor="Black" HorizontalAlign="Center" />
                <SelectedRowStyle BackColor="#000099" Font-Bold="True" ForeColor="White" />
                <SortedAscendingCellStyle BackColor="#F1F1F1" />
                <SortedAscendingHeaderStyle BackColor="#808080" />
                <SortedDescendingCellStyle BackColor="#CAC9C9" />
                <SortedDescendingHeaderStyle BackColor="#383838" />
            </asp:GridView>

          <asp:GridView ID="GridView2" runat="server" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None" DataKeyNames="識別碼" ToolTip="討論巳可以使用,會在上方顯示該筆留內容,也可以新增 刪除 編輯" Visible="False">
      <AlternatingRowStyle BackColor="White" />
      <Columns>
          <asp:BoundField DataField="識別碼" HeaderText="識別碼" />
          <asp:BoundField DataField="name1" HeaderText="主旨" />
          <asp:BoundField DataField="mail1" HeaderText="原檔名" />
          <asp:BoundField DataField="word1" HeaderText="備註" />
          <asp:TemplateField HeaderText="圖片">
              <EditItemTemplate>
                  <asp:TextBox ID="TextBox1" runat="server" Text='<%# Bind("photo") %>'></asp:TextBox>
              </EditItemTemplate>
              <ItemTemplate>
                  <asp:Image ID="photoimage" runat="server" ImageUrl='<%# Eval("photo") %>' />
              </ItemTemplate>
          </asp:TemplateField>
          <asp:BoundField DataField="filekind" HeaderText="副檔名" />
          <asp:BoundField DataField="memo" HeaderText="備忘" />
      </Columns>
      <FooterStyle BackColor="#990000" Font-Bold="True" ForeColor="White" />
      <HeaderStyle BackColor="#990000" Font-Bold="True" ForeColor="White" />
      <PagerStyle BackColor="#FFCC66" ForeColor="#333333" HorizontalAlign="Center" />
      <RowStyle BackColor="#FFFBD6" ForeColor="#333333" />
      <SelectedRowStyle BackColor="#FFCC66" Font-Bold="True" ForeColor="Navy" />
  </asp:GridView>


     <br/>





         sql指令的內容如下(範例可修改,資料庫stockchangedate):<br/> 
        1.黃金交叉選股+(k>=d)+macd>0&nbsp;&nbsp;
        <asp:Button ID="Button10" runat="server" Text="把指令貼到上方欄位" Width="181px" ToolTip="把指令貼到上方欄位並把日期改為最新日期" BackColor="#990000" ForeColor="White" CssClass="auto-style1" />

        <br/>

        <br/>
        2.黃金交叉選股(單個資料表):
        <br/>
        *  from winnewdate where 日期= 20230413 order by 均價黃金交叉次數 desc,均量黃金交叉次數 desc,三大法人黃金交叉次數 desc&nbsp;
        <asp:Button ID="Button11" runat="server" Text="把指令貼到上方欄位" Width="181px" ToolTip="把指令貼到上方欄位並把日期改為最新日期" BackColor="#990000" ForeColor="White" CssClass="auto-style1" />

        <br />
        <br />
        3.成交價黃金交叉增加最多(列出最近四天)<br />
        股票名稱, 股票代號, 成交價, 漲幅, 總量, 近4期均價合計, 近4期均量合計, 產業分類, 交易所分類, 股本億, 日期, 近1期均價, 近2期均價, 近3期均價, 近4期均價, 近1期均量, 近2期均量, 近3期均量, 近4期均量, ROW_NUMBER() OVER (ORDER BY 近4期均價合計 desc) AS 流水號 FROM winnewdatechange WHERE (總量 &gt;= 1000) ORDER BY 近4期均價合計 DESC,近4期均量合計 DESC&nbsp;
        <asp:Button ID="Button12" runat="server" Text="把指令貼到上方欄位" Width="181px" ToolTip="把指令貼到上方欄位並把日期改為最新日期" BackColor="#990000" ForeColor="White" CssClass="auto-style1" />

        <br />
        <br />
        4.成交量黃金交叉增加最多(列出最近四天)<br />
        股票名稱, 股票代號, 成交價, 漲幅, 總量, 近4期均價合計, 近4期均量合計, 產業分類, 交易所分類, 股本億, 日期, 近1期均價, 近2期均價, 近3期均價, 近4期均價, 近1期均量, 近2期均量, 近3期均量, 近4期均量, ROW_NUMBER() OVER (ORDER BY 近4期均量合計 desc) AS 流水號 FROM winnewdatechange WHERE (總量 &gt;= 5000) ORDER BY 近4期均量合計 DESC,近4期均價合計 DESC&nbsp;
        <asp:Button ID="Button13" runat="server" Text="把指令貼到上方欄位" Width="181px" ToolTip="把指令貼到上方欄位並把日期改為最新日期" BackColor="#990000" ForeColor="White" CssClass="auto-style1" />

        <br />
        <br />
        5.三大法人黃金交叉增加最多(列出最近四天) &nbsp;
        <asp:Button ID="Button14" runat="server" Text="把指令貼到上方欄位" Width="181px" ToolTip="把指令貼到上方欄位並把日期改為最新日期" BackColor="#990000" ForeColor="White" CssClass="auto-style1" />

        <br />
        <br />
        6.Macd紅綠棒+Kdj的J值&nbsp;
        <asp:Button ID="Button15" runat="server" Text="把指令貼到上方欄位" Width="181px" ToolTip="把指令貼到上方欄位並把日期改為最新日期" BackColor="#990000" ForeColor="White" CssClass="auto-style1" />

        <br />
        <br />
        7.Obv量能潮近四期增加<br />
        名稱, 代號, 成交價, 漲幅, 總量, 近4期obv合計, 產業分類, 交易所分類, 股本億, 日期, 近1期obv, 近2期obv, 近3期obv, 近4期obv, 近5期obv, 近6期obv, 近7期obv, 近8期obv, ROW_NUMBER() OVER (ORDER BY 近4期obv合計 desc) AS 流水號 FROM obvdatechange WHERE (總量 &gt;= 1000) ORDER BY 近4期obv合計 DESC&nbsp;
        <asp:Button ID="Button16" runat="server" Text="把指令貼到上方欄位" Width="181px" ToolTip="把指令貼到上方欄位並把日期改為最新日期" BackColor="#990000" ForeColor="White" CssClass="auto-style1" />

        <br />
        <br />
        8,彙總表再加上macd紅綠棒及kdj的J值&nbsp;
        <asp:Button ID="Button17" runat="server" Text="把指令貼到上方欄位" Width="181px" ToolTip="把指令貼到上方欄位並把日期改為最新日期" BackColor="#990000" ForeColor="White" />

        <br />
        <br />
        9.彙總表再加上macd紅綠棒及kdj的J值(當日macd紅綠棒及當日kdj的J值)<asp:Button ID="Button18" runat="server" Text="把指令貼到上方欄位" Width="181px" ToolTip="把指令貼到上方欄位並把日期改為最新日期" BackColor="#990000" ForeColor="White" Height="34px" />

        <br />
        <br />
        10. obv選股(1.上漲視為人氣匯集,當日成交量取正、2.下跌視為人氣渙散,當日成交量取負、3.平盤則取零,今日累積OBV值＝昨日累積OBV值＋（IF（當日漲跌＞0,+1,-1）*當日成交量）): <asp:Button ID="Button19" runat="server" Text="把指令貼到上方欄位" Width="181px" ToolTip="把指令貼到上方欄位並把日期改為最新日期" BackColor="#990000" ForeColor="White" />

        <br />
        <br />
        11.kdj的J值連三增(macd紅綠棒及J值範圍): <asp:Button ID="Button21" runat="server" Text="把指令貼到上方欄位" Width="181px" ToolTip="把指令貼到上方欄位並把日期改為最新日期" BackColor="#990000" ForeColor="White" />

        <br />
        <br />
        12.kdj的J值過三高: <asp:Button ID="Button22" runat="server" Text="把指令貼到上方欄位" Width="181px" ToolTip="把指令貼到上方欄位並把日期改為最新日期" BackColor="#990000" ForeColor="White" />

        <br />
        <br />
        13.Macd+j值+日期(計算方式 如:近5天 1750*4(少一天)+1000=8000): <asp:Button ID="Button23" runat="server" Text="把指令貼到上方欄位" Width="181px" ToolTip="日期計算方式 如:近5天 1750*4(少一天)+1000=8000" BackColor="#990000" ForeColor="White" />

        <br />
        <br />
        14.<span id="Label40" style="box-sizing: border-box; color: rgb(33, 37, 41); font-family: -apple-system, BlinkMacSystemFont, &quot;Segoe UI&quot;, Roboto, &quot;Helvetica Neue&quot;, Arial, sans-serif, &quot;Apple Color Emoji&quot;, &quot;Segoe UI Emoji&quot;, &quot;Segoe UI Symbol&quot;; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; white-space: normal; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">示範:第一層:總量&gt;?+</span><span style="color: rgb(33, 37, 41); font-family: -apple-system, BlinkMacSystemFont, &quot;Segoe UI&quot;, Roboto, &quot;Helvetica Neue&quot;, Arial, sans-serif, &quot;Apple Color Emoji&quot;, &quot;Segoe UI Emoji&quot;, &quot;Segoe UI Symbol&quot;; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; white-space: normal; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;"><span>&nbsp;</span>(</span><input id="macdlendown" class="auto-style5 text-center" name="macdlendown" style="box-sizing: border-box; margin: 0px; font-family: inherit; font-size: medium; line-height: inherit; overflow: visible; text-align: center !important; orphans: 2; widows: 2; -webkit-text-stroke-width: 0px; white-space: normal; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; color: maroon; background-color: rgb(153, 255, 102); height: 20px; width: 50px;" title="參數(比率或次數等等)" type="text" value="-0.05" /><span style="color: rgb(33, 37, 41); font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol'; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; white-space: normal; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none; background-color: rgb(255, 255, 255)">&nbsp;</span><span id="Label41" style="box-sizing: border-box; color: rgb(33, 37, 41); font-family: -apple-system, BlinkMacSystemFont, &quot;Segoe UI&quot;, Roboto, &quot;Helvetica Neue&quot;, Arial, sans-serif, &quot;Apple Color Emoji&quot;, &quot;Segoe UI Emoji&quot;, &quot;Segoe UI Symbol&quot;; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; white-space: normal; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">&lt;=紅綠棒值&lt;=</span><span style="color: rgb(33, 37, 41); font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol'; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; white-space: normal; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none; background-color: rgb(255, 255, 255)">&nbsp;</span><input id="macdlenup" class="auto-style5 text-center" name="macdlenup" style="box-sizing: border-box; margin: 0px; font-family: inherit; font-size: medium; line-height: inherit; overflow: visible; text-align: center !important; orphans: 2; widows: 2; -webkit-text-stroke-width: 0px; white-space: normal; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; color: maroon; background-color: rgb(153, 255, 102); height: 20px; width: 50px;" title="參數(比率或次數等等)" type="text" value="50" /><span style="color: rgb(33, 37, 41); font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol'; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; white-space: normal; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none; background-color: rgb(255, 255, 255)">&nbsp;</span><span style="color: rgb(33, 37, 41); font-family: -apple-system, BlinkMacSystemFont, &quot;Segoe UI&quot;, Roboto, &quot;Helvetica Neue&quot;, Arial, sans-serif, &quot;Apple Color Emoji&quot;, &quot;Segoe UI Emoji&quot;, &quot;Segoe UI Symbol&quot;; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; white-space: normal; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;"><span>&nbsp;</span>)<span>&nbsp;</span></span><span id="Label42" style="box-sizing: border-box; color: rgb(33, 37, 41); font-family: -apple-system, BlinkMacSystemFont, &quot;Segoe UI&quot;, Roboto, &quot;Helvetica Neue&quot;, Arial, sans-serif, &quot;Apple Color Emoji&quot;, &quot;Segoe UI Emoji&quot;, &quot;Segoe UI Symbol&quot;; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; white-space: normal; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">第二層:+</span><span style="color: rgb(33, 37, 41); font-family: -apple-system, BlinkMacSystemFont, &quot;Segoe UI&quot;, Roboto, &quot;Helvetica Neue&quot;, Arial, sans-serif, &quot;Apple Color Emoji&quot;, &quot;Segoe UI Emoji&quot;, &quot;Segoe UI Symbol&quot;; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; white-space: normal; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;"><span>&nbsp;</span>(</span><input id="jdown" class="auto-style5 text-center" name="jdown" style="box-sizing: border-box; margin: 0px; font-family: inherit; font-size: medium; line-height: inherit; overflow: visible; text-align: center !important; orphans: 2; widows: 2; -webkit-text-stroke-width: 0px; white-space: normal; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; color: maroon; background-color: rgb(153, 255, 102); height: 20px; width: 50px;" title="參數(比率或次數等等)" type="text" value="0" /><span style="color: rgb(33, 37, 41); font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol'; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; white-space: normal; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none; background-color: rgb(255, 255, 255)">&nbsp;</span><span id="Label43" style="box-sizing: border-box; color: rgb(33, 37, 41); font-family: -apple-system, BlinkMacSystemFont, &quot;Segoe UI&quot;, Roboto, &quot;Helvetica Neue&quot;, Arial, sans-serif, &quot;Apple Color Emoji&quot;, &quot;Segoe UI Emoji&quot;, &quot;Segoe UI Symbol&quot;; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; white-space: normal; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">&lt;=今日J值&lt;=</span><span style="color: rgb(33, 37, 41); font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol'; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; white-space: normal; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none; background-color: rgb(255, 255, 255)">&nbsp;</span><input id="jup" class="auto-style5 text-center" name="jup" style="box-sizing: border-box; margin: 0px; font-family: inherit; font-size: medium; line-height: inherit; overflow: visible; text-align: center !important; orphans: 2; widows: 2; -webkit-text-stroke-width: 0px; white-space: normal; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; color: maroon; background-color: rgb(153, 255, 102); height: 20px; width: 50px;" title="參數(比率或次數等等)" type="text" value="50" /><span style="color: rgb(33, 37, 41); font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol'; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; white-space: normal; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none; background-color: rgb(255, 255, 255)">&nbsp;</span><span style="color: rgb(33, 37, 41); font-family: -apple-system, BlinkMacSystemFont, &quot;Segoe UI&quot;, Roboto, &quot;Helvetica Neue&quot;, Arial, sans-serif, &quot;Apple Color Emoji&quot;, &quot;Segoe UI Emoji&quot;, &quot;Segoe UI Symbol&quot;; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; white-space: normal; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;"><span>&nbsp;,請改在程式碼上</span>)</span><asp:Button ID="Button24" runat="server" Text="把指令貼到上方欄位" Width="181px" ToolTip="把指令貼到上方欄位並把日期改為最新日期" BackColor="#990000" ForeColor="White" />

        <br />
        <br />
        15.最近八期的obv多空淨額法增減最多排序及最後四期合計數:<asp:Button ID="Button25" runat="server" Text="把指令貼到上方欄位" Width="181px" ToolTip="把指令貼到上方欄位並把日期改為最新日期" BackColor="#990000" ForeColor="White" />

        <br />
        <br />
        <hr/> <hr/>
        <br />
        16.最近三期obv多空淨額法淨增加皆大於0(連三增,近1天-近2天為第一期,近2天-近3天為第二期,近3天-近4天為為第三期:<asp:Button ID="Button26" runat="server" Text="把指令貼到上方欄位" Width="181px" ToolTip="把指令貼到上方欄位並把日期改為最新日期" BackColor="#990000" ForeColor="White" />

        <br />
        <br />
        17.obv多空淨額法與34日均線的乖離率且obv值站上前兩日的值:總量&gt;<asp:TextBox ID="amountstock" runat="server" Width="49px">5000</asp:TextBox>
        <asp:Button ID="Button27" runat="server" Text="17.把指令貼到上方欄位" Width="181px" ToolTip="把指令貼到上方欄位並把日期改為最新日期" BackColor="#990000" ForeColor="White" />

        ,不要設定條件(全部資料)總量+<asp:Button ID="Button31" runat="server" Text="把指令貼到上方欄位" Width="181px" ToolTip="把指令貼到上方欄位並把日期改為最新日期" BackColor="#990000" ForeColor="White" />

        <br />
        <br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 只要站上均線即可(最好是負很多但開始站上均線 公式:(本日-均線)/均線,總量+<asp:Button ID="Button32" runat="server" Text="17-1.把指令貼到上方欄位" Width="207px" ToolTip="把指令貼到上方欄位並把日期改為最新日期" BackColor="#990000" ForeColor="White" />

        &nbsp;或站上均線但前一日在均線下總量+<asp:Button ID="Button33" runat="server" Text="17-2.把指令貼到上方欄位" Width="207px" ToolTip="把指令貼到上方欄位並把日期改為最新日期" BackColor="#990000" ForeColor="White" />

        <br />
        <br />
        18.加權過後的均價黃金交叉數字:均價黃金交叉次數 
        + k9 / 5 - d9 / 5 + 週k9 / 5 - 週d9 / 5 + 月k9 / 5 - 月d9 / 5 + 主力加法人佔股本比合計十天 / 10 + 集保股權分散之三週庫存比率 / 100 <asp:Button ID="Button28" runat="server" Text="把指令貼到上方欄位" Width="181px" ToolTip="把指令貼到上方欄位並把日期改為最新日期" BackColor="#990000" ForeColor="White" Height="34px" />

        <br />
        
        <br />
        <hr/> <hr/>
        19.盤中操盤:obv多空淨額法,盤中obv站上盤中三十四日均線+總量:<asp:Button ID="Button29" runat="server" Text="19-1.按盤中單日obv總量" Width="200px" ToolTip="把指令貼到上方欄位並把日期改為最新日期" BackColor="#990000" ForeColor="White" />

        <asp:Button ID="Button37" runat="server" Text="19-2.按盤中單日obv總量全部" Width="178px" ToolTip="把指令貼到上方欄位並把日期改為最新日期" BackColor="#990000" ForeColor="White" />

        <asp:Button ID="Button35" runat="server" Text="19-3.今日盤中站上均線(前一天在均線下)" Width="246px" ToolTip="把指令貼到上方欄位並把日期改為最新日期" BackColor="#990000" ForeColor="White" />

        (<asp:Button ID="Button36" runat="server" Text="19-4盤中操盤1" Width="120px" ToolTip="把指令貼到上方欄位並把日期改為最新日期" BackColor="#990000" ForeColor="White" />

        <asp:Button ID="Button38" runat="server" Text="19-5.盤中操盤2" Width="145px" ToolTip="把指令貼到上方欄位並把日期改為最新日期" BackColor="#990000" ForeColor="White" />

        )<br />
        <br />
        20.盤後obv多空淨額法,盤中obv站上盤中三十四日均線+17.中的總量:<asp:Button ID="Button30" runat="server" Text="20.盤後+前一天(不是盤中)" Width="249px" ToolTip="把指令貼到上方欄位並把日期改為最新日期" BackColor="#990000" ForeColor="White" />

        <br />
        <br />
        21.股權分散表: <asp:Button ID="Button140" runat="server" Text="股權週變動" Width="119px" ToolTip="直接用取代去更新二個日期" BackColor="#990000" ForeColor="White" />

        &nbsp;<asp:Button ID="Button141" runat="server" Text="單股400張以上" Width="128px" ToolTip="股權分散表400張(含)以上" BackColor="#990000" ForeColor="White" />

        &nbsp;<asp:Button ID="Button142" runat="server" Text="單股千張以上" Width="117px" ToolTip="股權分散表1000張(含)以上" BackColor="#990000" ForeColor="White" />

        &nbsp;<asp:Button ID="Button143" runat="server" Text="單股20張以下" Width="121px" ToolTip="股權分散表20張(含)以下" BackColor="#990000" ForeColor="White" />

           &nbsp;<asp:HyperLink ID="HyperLink54" runat="server" NavigateUrl="https://zen2965.duckdns.org:8888/stockquery/dayoff" Target="_blank">更多(dayoff)</asp:HyperLink>
           ,(資料庫stockprice)股權分散表不同日期比較(預製)<asp:Button ID="Button39" runat="server" Text="21-1.第一週跟第13週" Width="171px" ToolTip="有更新才會有最新週資料" BackColor="#990000" ForeColor="White" />

        &nbsp;<asp:Button ID="Button40" runat="server" Text="21-2單股查詢" Width="125px" ToolTip="直接用取代去更新二個日期" BackColor="#990000" ForeColor="White" />

        &nbsp;,可直接查詢連結:<asp:HyperLink ID="HyperLink48" runat="server" NavigateUrl="https://zen2965.duckdns.org:8888/mymvc/equitym.aspx" Target="_blank" ToolTip="欄位較多">股權中</asp:HyperLink>

        &nbsp;<asp:HyperLink ID="HyperLink49" runat="server" NavigateUrl="https://zen2965.duckdns.org:8888/mymvc/equitys.aspx" Target="_blank" ToolTip="欄位較少">股權小</asp:HyperLink>

        &nbsp;<asp:HyperLink ID="HyperLink50" runat="server" NavigateUrl="https://zen2965.duckdns.org:8888/webchart/equity" Target="_blank" ToolTip="有圖形配合,資料較多">股權有圖</asp:HyperLink>

        ,<span class="auto-style6">需要輸入密碼</span>:&nbsp;<asp:Button ID="Button43" runat="server" Text="21-3自選股0" Width="142px" ToolTip="不能出現預設select字眼,所以要加上密碼保護" BackColor="#990000" ForeColor="White" />

        (&quot;EXEC myequityselfselect5&quot; 20240419,20240322,N&#39;2330&#39;)<br />
        <br />
        <span class="auto-style3">22.圖片類查詢(限七個欄位名稱需要相同:識別碼(主key自動累加),name1,mail1,word1,photo(放圖片),filekind,memo,圖片放在第五欄位)</span><asp:Button ID="Button45" runat="server" Text="favor2資料庫" Width="116px" ToolTip="可使用如:favor2資料庫,全部資料庫皆可用只要塞入相符資料即可使用,資料庫及資料表要記得同時更改" BackColor="#990000" ForeColor="White" />

        <br />
        <span class="auto-style4">變形用法例如: top 10 識別碼,name1,mail1,word1,photo,left((name1),3) as filekind,left((word1),2) as memo from webfile1</span> <asp:Button ID="Button46" runat="server" Text="poemleg資料庫" Width="122px" ToolTip="可使用如:favor2資料庫,全部資料庫皆可用只要塞入相符資料即可使用,資料庫及資料表要記得同時更改" BackColor="#990000" ForeColor="White" />

        &nbsp;<asp:Button ID="Button47" runat="server" Text="poemsachi03資料庫" Width="149px" ToolTip="可使用如:favor2資料庫,全部資料庫皆可用只要塞入相符資料即可使用,資料庫及資料表要記得同時更改" BackColor="#990000" ForeColor="White" />

        &nbsp;<asp:Button ID="Button52" runat="server" Text="guestpic" Width="79px" ToolTip="可使用如:favor2資料庫,全部資料庫皆可用只要塞入相符資料即可使用,資料庫及資料表要記得同時更改" BackColor="#990000" ForeColor="White" />

        &nbsp;<asp:Button ID="Button48" runat="server" Text="poemsachi02資料庫" Width="154px" ToolTip="可使用如:favor2資料庫,全部資料庫皆可用只要塞入相符資料即可使用,資料庫及資料表要記得同時更改" BackColor="#990000" ForeColor="White" />

        &nbsp;<asp:Button ID="Button49" runat="server" Text="poemsachi01資料庫" Width="150px" ToolTip="可使用如:favor2資料庫,全部資料庫皆可用只要塞入相符資料即可使用,資料庫及資料表要記得同時更改" BackColor="#990000" ForeColor="White" />

        &nbsp;<asp:Button ID="Button50" runat="server" Text="wordvoice資料庫" Width="146px" ToolTip="可使用如:favor2資料庫,全部資料庫皆可用只要塞入相符資料即可使用,資料庫及資料表要記得同時更改" BackColor="#990000" ForeColor="White" />

        &nbsp;<asp:Button ID="Button53" runat="server" Text="aigirl" Width="60px" ToolTip="可使用如:favor2資料庫,全部資料庫皆可用只要塞入相符資料即可使用,資料庫及資料表要記得同時更改" BackColor="#990000" ForeColor="White" />

        &nbsp;<asp:Button ID="Button54" runat="server" Text="gif檔" Width="60px" ToolTip="可使用如:favor2資料庫,全部資料庫皆可用只要塞入相符資料即可使用,資料庫及資料表要記得同時更改" BackColor="#990000" ForeColor="White" />

        <br /> <br />
       
        <span class="auto-style3"> WepApi區單筆:
        <a href="https://zen2965.duckdns.org:8888/webapi/api/avggolds/2330">avggold(部份欄位)</a>&nbsp; <a href="https://zen2965.duckdns.org:8888/webapi/api/stockchange/3017">basicinfo(部份欄位)</a>&nbsp; <a href="https://zen2965.duckdns.org:8888/webapi/api/stockchangedate/3017">winnewdate(部份欄位)</a>&nbsp;
        
        <a href="https://zen2965.duckdns.org:8888/webapi/api/winnewdates/2330">winnewdate(全部欄位,股票名稱或代號)</a>&nbsp; <a href="https://zen2965.duckdns.org:8888/webapi/api/obvdatea5/2330">OBV均線(部份欄位)</a>&nbsp; <a href="https://zen2965.duckdns.org:8888/androidapp/obvtest1.html">OBV均線</a>&nbsp;<a href="https://zen2965.duckdns.org:8888/androidapp/favoritemy.html">查我的最愛關鍵字</a>&nbsp;<a href="https://zen2965.duckdns.org:8888/webapi02/api/stockpics/GetImage/201">leg單筆圖片</a>&nbsp;<a href="https://zen2965.duckdns.org:8888/webapi02/api/View_mybook/getimage/1450">存書單筆圖片</a>&nbsp;<a href="https://zen2965.duckdns.org:8888/webapi02/api/View_favor2stockgod21/getimage/163">AiGirl單筆圖片</a>&nbsp;<a href="https://zen2965.duckdns.org:8888/webapi02/api/View_favor2stockgod6/getimage/27325">herowars(pk)單圖</a>&nbsp;<a href="https://zen2965.duckdns.org:8888/webapi02/api/View_favor2stockgod7/getimage/300">DM18+單圖</a>&nbsp;

   </span>
        <br />
<span class="auto-style3">      
            
       
        WepApi區多筆:<a href="https://zen2965.duckdns.org:8888/webapi/api/avggolds">avggold(傳回全部)</a>&nbsp; <a href="https://zen2965.duckdns.org:8888/webapi/api/stockchange">basicinfo(傳回全部)</a>&nbsp; <a href="https://zen2965.duckdns.org:8888/webapi/api/guestinfowd1/">查我的最愛網址</a>&nbsp; <a href="https://zen2965.duckdns.org:8888/androidapp/stockpic1.html">多圖網頁(info)</a>&nbsp; <a href="https://zen2965.duckdns.org:8888/androidapp/stockpic3.html">Leg藝廊</a>&nbsp; <a href="https://zen2965.duckdns.org:8888/webapi02/api/stockpics/">Leg多圖api</a>&nbsp; <a href="https://zen2965.duckdns.org:8888/androidapp/stockpic4.html">存書藝廊</a>&nbsp; <a href="https://zen2965.duckdns.org:8888/androidapp/stockpic5.html">AiGirl藝廊</a>&nbsp; <a href="https://zen2965.duckdns.org:8888/androidapp/stockpic6.html">herowars(pk)藝廊</a>&nbsp; <a href="https://zen2965.duckdns.org:8888/androidapp/stockpic7.html">DM_18+藝廊</a>&nbsp;
                
            
</span>
      

        <br /> <br />
        23.obv三個區間及加權均價黃金交叉:(區間一:<asp:TextBox ID="obvdate1" runat="server" Width="80px" Height="30px" ToolTip="35天(方便看扣抵位置)"></asp:TextBox>
                ,區間二:<asp:TextBox ID="obvdate2" runat="server" Width="80px" Height="30px" ToolTip="2倍"></asp:TextBox>
                ,區間三:<asp:TextBox ID="obvdate3" runat="server" Width="80px" Height="30px" ToolTip="3倍"></asp:TextBox>
                <asp:Button ID="Button55" runat="server" Text="顯示日期" Width="85px" ToolTip="顯示三個日期,第一次會自動帶入" BackColor="#990000" ForeColor="White" />

        )<asp:Button ID="Button56" runat="server" Text="單股obv及34 日均線" Width="163px" ToolTip="obv淨額站上34日均線,請使用以下網頁瀏覽 https://zen2965.duckdns.org:8888/mymvc/trend3s1.aspx" BackColor="#990000" ForeColor="White" />

        <asp:Button ID="Button57" runat="server" Text="單股加權均價" Width="103px" ToolTip="ROUND((((((((dbo.winnewdate.均價黃金交叉次數 + dbo.winnewdate.k9 / 5) - dbo.winnewdate.d9 / 5) + dbo.winnewdate.週k9 / 5) - dbo.winnewdate.週d9 / 5) + dbo.winnewdate.月k9 / 5) - dbo.winnewdate.月d9 / 5) + dbo.winnewdate.合計十天 / 10) + dbo.winnewdate.三週庫存比率 / 100, 2)" BackColor="#990000" ForeColor="White" />

        <asp:Button ID="Button58" runat="server" Text="加權均價選股" Width="128px" ToolTip="ROUND((((((((dbo.winnewdate.均價黃金交叉次數 + dbo.winnewdate.k9 / 5) - dbo.winnewdate.d9 / 5) + dbo.winnewdate.週k9 / 5) - dbo.winnewdate.週d9 / 5) + dbo.winnewdate.月k9 / 5) - dbo.winnewdate.月d9 / 5) + dbo.winnewdate.合計十天 / 10) + dbo.winnewdate.三週庫存比率 / 100, 2)" BackColor="#990000" ForeColor="White" />

        <asp:Button ID="Button121" runat="server" Text="加權均價+obv金叉" Width="176px" ToolTip="ROUND((((((((dbo.winnewdate.均價黃金交叉次數 + dbo.winnewdate.k9 / 5) - dbo.winnewdate.d9 / 5) + dbo.winnewdate.週k9 / 5) - dbo.winnewdate.週d9 / 5) + dbo.winnewdate.月k9 / 5) - dbo.winnewdate.月d9 / 5) + dbo.winnewdate.合計十天 / 10) + dbo.winnewdate.三週庫存比率 / 100, 2)+(obv黃金交叉次數 - 均量黃金交叉次數)" BackColor="#990000" ForeColor="White" />

        <br />
        <br />
        24.(<asp:DropDownList ID="tablename2" runat="server" 

            Font-Size="Medium" Height="25px"  BackColor="Yellow" ToolTip="查詢出來後再從右3寫入" style="margin-left: 1px">
                   
            <asp:ListItem Selected="True" Value="0">自選股0</asp:ListItem>                   
            <asp:ListItem Value="1">自選股1</asp:ListItem>
            <asp:ListItem Value="2">自選股2</asp:ListItem>
            <asp:ListItem Value="3">自選股3</asp:ListItem>
            <asp:ListItem Value="4">自選股4</asp:ListItem>
            <asp:ListItem Value="5">自選股5</asp:ListItem>
            <asp:ListItem Value="6">自選股6</asp:ListItem>
            <asp:ListItem Value="7">自選股7</asp:ListItem>
            <asp:ListItem Value="8">自選股8</asp:ListItem>
            <asp:ListItem Value="9">自選股9</asp:ListItem>
    </asp:DropDownList>

                          +<asp:Button ID="計算56" runat="server" Height="31px" Text="接收並顯示0~9自選股" Width="176px" BackColor="Maroon" Font-Names="標楷體" Font-Size="Medium" ForeColor="White" ToolTip="在圖示的右方顯示所選自選股(方便點選),或是前一頁超連結單筆轉查詢,可在自選股查詢編輯增刪自選股資料" />
       
     
      
        ,自行輸入查詢文字,請先刪除最前面的&quot;select&quot;),<asp:HyperLink ID="HyperLink51" runat="server" BackColor="White" Font-Names="標楷體" Font-Size="Large" ForeColor="#0000CC" Height="25px" NavigateUrl="https://zen2965.duckdns.org:8888/stockquery/incomeedit1" ToolTip="自選股的新增 修改 刪除" Target="_blank">自選股編輯點此</asp:HyperLink>
&nbsp; <asp:HyperLink ID="HyperLink52" runat="server" BackColor="White" Font-Names="標楷體" Font-Size="Large" ForeColor="#CC3300" Height="25px" NavigateUrl="https://zen2965.duckdns.org:8888/mymvc/trend3s1.aspx" ToolTip="自選股的新增 修改 刪除" Target="_blank">有圖形obv+均線+加權均價等點此</asp:HyperLink>
<br />
        <br />
        25.主力佔股本比%+三大法人佔股本比%(一天 三天 五天 十天 二十天 預設)
        <asp:Label ID="Label19" runat="server" class="text-danger" CssClass="auto-style11" Font-Bold="True" Font-Names="標楷體" Font-Size="Large" ForeColor="Blue" Text="選資料表:" ToolTip="當天也是可以查"></asp:Label>
        &nbsp;<span class="style1"><span class="auto-style2"><span class="auto-style4"><span class="btn btn-default" style="width: 125px"><span class="auto-style1"><span class="auto-style9"><span class="auto-style10"><asp:DropDownList ID="寫入表格" runat="server" BackColor="#990000" Font-Names="標楷體" Font-Size="Large" ForeColor="#CCFF99" Height="30px" ToolTip="有六個表可選擇,除了建檔使用外還可以再下面的:改變總量 改變資料表時使用" Width="120px">
            <asp:ListItem>預設</asp:ListItem>
            <asp:ListItem Selected="True">一天</asp:ListItem>
            <asp:ListItem>三天</asp:ListItem>
            <asp:ListItem>五天</asp:ListItem>
            <asp:ListItem>十天</asp:ListItem>
            <asp:ListItem>二十天</asp:ListItem>
        </asp:DropDownList>
        </span></span></span></span></span></span></span>)<asp:Button ID="Button62" runat="server" Text="查詢選擇資料表" Width="128px" ToolTip="先選擇左邊資料表後,資料會出現在最上方表格內,自行修改後再按顯示或下載為excel表" BackColor="#990000" ForeColor="White" />,
            

                <asp:DropDownList ID="tablename3" runat="server" 

        Font-Size="Medium" Height="25px" Width="92px" BackColor="Yellow" ToolTip="查詢出來後再從右3寫入" style="margin-left: 12px">

               
        <asp:ListItem Value="0">自選股0</asp:ListItem>                   
        <asp:ListItem Value="1">自選股1</asp:ListItem>
        <asp:ListItem Value="2">自選股2</asp:ListItem>
        <asp:ListItem Selected="True" Value="3">自選股3</asp:ListItem>
        <asp:ListItem Value="4">自選股4</asp:ListItem>
        <asp:ListItem Value="5">自選股5</asp:ListItem>
        <asp:ListItem Value="6">自選股6</asp:ListItem>
        <asp:ListItem Value="7">自選股7</asp:ListItem>
        <asp:ListItem Value="8">自選股8</asp:ListItem>
        <asp:ListItem Value="9">自選股9</asp:ListItem>
        <asp:ListItem Value="10">自選股10</asp:ListItem>
        <asp:ListItem Value="11">自選股11</asp:ListItem>
        <asp:ListItem Value="12">自選股12</asp:ListItem>
        <asp:ListItem Value="13">自選股13</asp:ListItem>
        <asp:ListItem Value="14">自選股14</asp:ListItem>
        <asp:ListItem Value="15">自選股15</asp:ListItem>
        <asp:ListItem Value="16">自選股16</asp:ListItem>
        <asp:ListItem Value="17">自選股17</asp:ListItem>
        <asp:ListItem Value="18">自選股18</asp:ListItem>
        <asp:ListItem Value="19">自選股19</asp:ListItem>
        <asp:ListItem Value="20">自選股20</asp:ListItem>                   
        <asp:ListItem Value="21">自選股21</asp:ListItem>
        <asp:ListItem Value="22">自選股22</asp:ListItem>
        <asp:ListItem Value="23">自選股23</asp:ListItem>
        <asp:ListItem Value="24">自選股24</asp:ListItem>
        <asp:ListItem Value="25">自選股25</asp:ListItem>
        <asp:ListItem Value="26">自選股26</asp:ListItem>
        <asp:ListItem Value="27">自選股27</asp:ListItem>
        <asp:ListItem Value="28">自選股28</asp:ListItem>
        <asp:ListItem Value="29">自選股29</asp:ListItem>

</asp:DropDownList>
       
        <asp:Button ID="Button116" runat="server" BackColor="#CC0000" Height="30px" Text="整批自選股_預設" Width="140px" ToolTip="20個自選股可選擇最長日期" CssClass="auto-style2" ForeColor="White" BorderStyle="None" />
        
        (資料會出現在最上方表格內,自行修改後 如:總量,再按顯示或下載為excel表)<br />
        <br />
        26.接近季線
        乖離率%:(5日:<asp:TextBox ID="day5" runat="server" Height="25px" Width="65px" 

        style="margin-left: 0px; color: #0000FF;" Font-Size="Medium" ToolTip="跟五日均線的距離有多少%,可以有正負之分,如:-0.3%~0.5%" BackColor="#FFFF99">0.01</asp:TextBox>

         ~<asp:TextBox ID="day5m" runat="server" Height="25px" Width="65px" 

        style="margin-left: 0px; color: #0000FF;" Font-Size="Medium" ToolTip="跟五日均線的距離有多少%,可以有正負之分,如:-0.3%~0.5%" BackColor="#FFFF99">10</asp:TextBox>

         ),(20日:<asp:TextBox ID="day20" runat="server" Height="25px" Width="65px" 

        style="margin-left: 0px; color: #0000FF;" Font-Size="Medium" ToolTip="跟二十日均線的距離有多少%,可以有正負之分,如:-0.3%~0.5%" BackColor="#FFFF99">0.01</asp:TextBox>

         ~<asp:TextBox ID="day20m" runat="server" Height="25px" Width="65px" 

        style="margin-left: 0px; color: #0000FF;" Font-Size="Medium" ToolTip="跟二十日均線的距離有多少%,可以有正負之分,如:-0.3%~0.5%" BackColor="#FFFF99">10</asp:TextBox>

         ),(60日:<asp:TextBox ID="day60" runat="server" Height="25px" Width="65px" 

        style="margin-left: 0px; color: #0000FF;" Font-Size="Medium" ToolTip="跟六十日均線的距離有多少%,可以有正負之分,如:-0.3%~0.5%" BackColor="#FFFF99">0.01</asp:TextBox>

         ~<asp:TextBox ID="day60m" runat="server" Height="25px" Width="65px" 

        style="margin-left: 0px; color: #0000FF;" Font-Size="Medium" ToolTip="跟六十日均線的距離有多少%,可以有正負之分,如:-0.3%~0.5%" BackColor="#FFFF99">10</asp:TextBox>

         )
        
           (<asp:Button ID="Button117" runat="server" BackColor="#CC0000" Height="30px" Text="價簡單版" Width="122px" ToolTip="20個自選股可選擇最長日期" CssClass="auto-style2" ForeColor="White" BorderStyle="None" />
        
        &nbsp;<asp:Button ID="Button161" runat="server" BackColor="#CC0000" Height="30px" Text="簡" Width="35px" ToolTip="合併概念股" CssClass="auto-style2" ForeColor="White" BorderStyle="None" />
        
           )<br />
        <br />
        <br />
        27.OBV黃金交叉次數<asp:Button ID="Button118" runat="server" BackColor="#CC0000" Height="30px" Text="OBV黃金交叉次數" Width="155px" ToolTip="obv黃金交叉次數選股" CssClass="auto-style2" ForeColor="White" BorderStyle="None" />
        
        &nbsp;<asp:Button ID="Button119" runat="server" BackColor="#CC0000" Height="30px" Text="查單股(by代號)" Width="134px" ToolTip="obv黃金交叉單股最新的一天" CssClass="auto-style2" ForeColor="White" BorderStyle="None" />
        
        &nbsp;<asp:Button ID="Button127" runat="server" BackColor="#CC0000" Height="30px" Text="查單股(by名稱)" Width="132px" ToolTip="obv黃金交叉單股最新的一天" CssClass="auto-style2" ForeColor="White" BorderStyle="None" />
        
        &nbsp;<asp:Button ID="Button120" runat="server" BackColor="#CC0000" Height="30px" Text="查單股含均線" Width="118px" ToolTip="obv黃金交叉單股多天含均線" CssClass="auto-style2" ForeColor="White" BorderStyle="None" />
        
        &nbsp;<asp:Button ID="Button122" runat="server" BackColor="#CC0000" Height="31px" Text="黃仁勳ai" Width="90px" ToolTip="ai股的obv黃金交叉次數 in 自選股3" CssClass="auto-style2" ForeColor="White" BorderStyle="None" />
        
        <span style="color: rgb(0, 0, 0); font-family: &quot;Times New Roman&quot;; font-size: medium; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; white-space: normal; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;">
        <br />
        <br />
        盤中站上5日均</span>:&nbsp;<asp:Button ID="Button123" runat="server" BackColor="#CC0000" Height="30px" Text="五日乘離(自選股19)" Width="169px" ToolTip="站上34日平均線張數 ,盤中選股在自選股19,有計算乘離率所以excel表頭會不正確請複製查詢出來的表頭" CssClass="auto-style2" ForeColor="White" BorderStyle="None" />
        
        &nbsp;<asp:Button ID="Button128" runat="server" BackColor="#CC0000" Height="30px" Text="五日乘離新站上" Width="139px" ToolTip="昨天的累積obv還未站盤中新計算的五日平均線,今天才新站上 in 自選股中" CssClass="auto-style2" ForeColor="White" BorderStyle="None" />
        
        &nbsp;<asp:Button ID="Button132" runat="server" BackColor="#CC0000" Height="30px" Text="五日乘離新站上+winnewdate" Width="234px" ToolTip="昨天的累積obv還未站盤中新計算的五日平均線,今天才新站上 in 自選股中" CssClass="auto-style2" ForeColor="White" BorderStyle="None" />
        
        &nbsp;&nbsp;<asp:Button ID="Button124" runat="server" BackColor="#CC0000" Height="30px" Text="五日乘離選股(全部)" Width="163px" ToolTip="站上5日平均線張數 ,盤中選股可全部股票,有計算乘離率所以excel表頭會不正確請複製查詢出來的表頭" CssClass="auto-style2" ForeColor="White" BorderStyle="None" />
        
        &nbsp;<asp:Button ID="Button133" runat="server" BackColor="#CC0000" Height="30px" Text="五日乘離選股(全部)+winnewdate" Width="258px" ToolTip="站上5日平均線張數 ,盤中選股可全部股票,有計算乘離率所以excel表頭會不正確請複製查詢出來的表頭" CssClass="auto-style2" ForeColor="White" BorderStyle="None" />
        
        &nbsp;<asp:Button ID="Button134" runat="server" BackColor="#CC0000" Height="30px" Text="五日乘離選股(全部)+winnewdate+macd紅綠棒" Width="348px" ToolTip="站上5日平均線張數 ,盤中選股可全部股票,有計算乘離率所以excel表頭會不正確請複製查詢出來的表頭+macd紅綠棒及條件,加權總分" CssClass="auto-style2" ForeColor="White" BorderStyle="None" />
        
        , <span style="color: rgb(0, 0, 0); font-family: &quot;Times New Roman&quot;; font-size: medium; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; white-space: normal; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;">盤中站上34日均</span>:<asp:Button ID="Button125" runat="server" BackColor="#CC0000" Height="30px" Text="34日乘離(自選股19)" Width="162px" ToolTip="站上34日平均線張數 ,盤中選股在自選股19,有計算乘離率所以excel表頭會不正確請複製查詢出來的表頭" CssClass="auto-style2" ForeColor="White" BorderStyle="None" />
        
        &nbsp;<asp:Button ID="Button126" runat="server" BackColor="#CC0000" Height="30px" Text="34日乘離選股(全部)" Width="171px" ToolTip="站上5日平均線張數 ,盤中選股可全部股票,有計算乘離率所以excel表頭會不正確請複製查詢出來的表頭" CssClass="auto-style2" ForeColor="White" BorderStyle="None" />
        
        <br />
        <br />
        28.自選股+盤後+綜合+OBV均線:<asp:Button ID="Button129" runat="server" BackColor="#CC0000" Height="30px" Text="盤後OBV+Winnewdate" Width="197px" ToolTip="最新一天的盤後+綜合+OBV均線,加權總分" CssClass="auto-style2" ForeColor="White" BorderStyle="None" />
        
        &nbsp;單股:<asp:Button ID="Button130" runat="server" BackColor="#CC0000" Height="30px" Text="單股盤後+OBV+Winnewdate" Width="221px" ToolTip="最新一天的winnewdate in 單股歷史多天 + obv,加權總分" CssClass="auto-style2" ForeColor="White" BorderStyle="None" />
        
        ,自選股+<span class="auto-style7">盤中</span>+綜合+OBV均線:<asp:Button ID="Button131" runat="server" BackColor="#CC0000" Height="30px" Text="盤中自選+OBV+Winnewdate" Width="248px" ToolTip="最新一天的盤中OBV+綜合,加權總分" CssClass="auto-style2" ForeColor="White" BorderStyle="None" />
        
        &nbsp;<br />
        <br />
        29.資料庫預存程序類查詢:(起日:<asp:TextBox ID="漲幅起日" runat="server" Height="25px" Width="108px" 

        style="margin-left: 0px; color: #0000FF;" Font-Size="Medium" ToolTip="跟六十日均線的距離有多少%,可以有正負之分,如:-0.3%~0.5%" BackColor="#FFFF99">20241015</asp:TextBox>

         ,訖日:<asp:TextBox ID="漲幅止日" runat="server" Height="25px" Width="100px" 

        style="margin-left: 0px; color: #0000FF;" Font-Size="Medium" ToolTip="跟六十日均線的距離有多少%,可以有正負之分,如:-0.3%~0.5%" BackColor="#FFFF99">20241016</asp:TextBox>
        <asp:Button ID="計算68" runat="server" Height="31px" Text="兩個日期間之股價漲幅" Width="185px" CssClass="auto-style2" BackColor="#FFFF99" Font-Names="標楷體" Font-Size="Medium" ForeColor="#0000CC" ToolTip="起日輸入在左方,預設兩天前,止日為資料庫最新日期" />
         
        ),(左邊兩日期(新的起日,舊的止日)+不用股票代號:<asp:TextBox ID="mystockno" runat="server" Height="25px" Width="100px" 

        style="margin-left: 0px; color: #0000FF;" Font-Size="Medium" ToolTip="跟六十日均線的距離有多少%,可以有正負之分,如:-0.3%~0.5%" BackColor="#FFFF99">2330</asp:TextBox>
           <asp:DropDownList ID="tablename4" runat="server" 

            Font-Size="Medium" Height="25px"  BackColor="Yellow" ToolTip="查詢出來後再從右3寫入" style="margin-left: 1px">
                   
            <asp:ListItem Value="0">自選股0</asp:ListItem>                   
            <asp:ListItem Value="1">自選股1</asp:ListItem>
            <asp:ListItem Value="2">自選股2</asp:ListItem>
            <asp:ListItem Value="3">自選股3</asp:ListItem>
            <asp:ListItem Value="4">自選股4</asp:ListItem>
            <asp:ListItem Selected="True" Value="5">自選股5</asp:ListItem>
    </asp:DropDownList>

        <asp:Button ID="計算69" runat="server" Height="31px" Text="兩個日期間之股權變動" Width="185px" CssClass="auto-style2" BackColor="#FFFF99" Font-Names="標楷體" Font-Size="Medium" ForeColor="#0000CC" ToolTip="前五個自選股,筆數太多會超過時間" />
         
          &nbsp; <asp:HyperLink ID="HyperLink53" runat="server" NavigateUrl="https://zen2965.duckdns.org:8888/mymvc/equitym.aspx" Target="_blank" ToolTip="欄位較多">日期在此查詢</asp:HyperLink>

        )<br />
        30.盤中:<asp:Button ID="Button2" runat="server" Height="31px" Text="盤中漲幅" Width="91px" CssClass="auto-style2" BackColor="#FFFF99" Font-Names="標楷體" Font-Size="Medium" ForeColor="#0000CC" ToolTip="巳經上傳的最新盤中資料" />
           &nbsp;,以下要配合上方的漲跌起日及股票代號: <asp:Button ID="Button135" runat="server" BackColor="#CC0000" Height="30px" Text="營業額(五年)" Width="109px" ToolTip="複製程式碼到上方可更改,最後再按查詢" CssClass="auto-style2" ForeColor="White" BorderStyle="None" />
        
        &nbsp; <asp:Button ID="Button136" runat="server" BackColor="#CC0000" Height="30px" Text="EPS+三率(五年)" Width="141px" ToolTip="複製程式碼到上方可更改,最後再按查詢" CssClass="auto-style2" ForeColor="White" BorderStyle="None" />
        
        &nbsp; <asp:Button ID="Button137" runat="server" BackColor="#CC0000" Height="30px" Text="計算KD(日週月)" Width="135px" ToolTip="使用上方的漲幅起日的日期:起日及股票代號,直接顯示" CssClass="auto-style2" ForeColor="White" BorderStyle="None" />
        
        &nbsp; <asp:Button ID="Button138" runat="server" BackColor="#CC0000" Height="30px" Text="計算日macd" Width="135px" ToolTip="使用上方的漲幅起日的日期:起日及股票代號,直接顯示" CssClass="auto-style2" ForeColor="White" BorderStyle="None" />
        
        &nbsp;<asp:Button ID="Button139" runat="server" BackColor="#CC0000" Height="30px" Text="計算均線及均量" Width="143px" ToolTip="使用上方的漲幅起日的日期:起日及股票代號,計算成交價及成交量的平均線各8條,複製程式碼到上方可更改,最後再按查詢(過程很多天,結果只列出最新一天,改變成top 10會列出十筆,),範圍大一點" CssClass="auto-style2" ForeColor="White" BorderStyle="None" />
        
        <br />
           <br />
           31.近10期成交價量的漲幅變化:(盤後:先建檔<asp:Button ID="Button148" runat="server" BackColor="#CC0000" Height="30px" Text="近十期建檔" Width="133px" ToolTip="先建檔才能查詢,資料寫到basicinfo盤中,寫完新資料表再跟前面一樣再將新資料寫到共用的10表格再進行查詢" CssClass="auto-style2" ForeColor="White" BorderStyle="None" />
        
           後查詢 (<asp:Button ID="Button146" runat="server" BackColor="#CC0000" Height="30px" Text="近10期成交價量增幅" Width="176px" ToolTip="近10期成交價漲幅等變化1" CssClass="auto-style2" ForeColor="White" BorderStyle="None" />
        
           <asp:Button ID="Button155" runat="server" BackColor="#CC0000" Height="30px" Text="簡" Width="35px" ToolTip="合併概念股" CssClass="auto-style2" ForeColor="White" BorderStyle="None" />
        
           )&nbsp;(<asp:Button ID="Button147" runat="server" BackColor="#CC0000" Height="30px" Text="近3期起漲且量增,4~11期價穩" Width="230px" ToolTip="近3期起漲,再前8期變化不大,近三期成交量大於50%" CssClass="auto-style2" ForeColor="White" BorderStyle="None" />
        
           <asp:Button ID="Button156" runat="server" BackColor="#CC0000" Height="30px" Text="簡" Width="35px" ToolTip="合併概念股" CssClass="auto-style2" ForeColor="White" BorderStyle="None" />
        
           <asp:Button ID="Button164" runat="server" BackColor="#CC0000" Height="30px" Text="簡+乖離" Width="78px" ToolTip="合併概念股+60ma 120ma 240ma圴線乖離率,方便選股" CssClass="auto-style2" ForeColor="White" BorderStyle="None" />
        
           <asp:Button ID="Button162" runat="server" BackColor="#CC0000" Height="30px" Text="簡+日期" Width="80px" ToolTip="將概念日期再進行排序asc或desc,近3期起漲且量增,4~11期價穩建檔在自選股16再概念股改成日期,來找出其異動" CssClass="auto-style2" ForeColor="White" BorderStyle="None" />
        
           ), (盤中:先建檔<asp:Button ID="Button149" runat="server" BackColor="#CC0000" Height="30px" Text="盤中近十期建檔" Width="138px" ToolTip="先建檔才能查詢,資料寫到basicinfo盤中,寫完新資料表再跟前面一樣再將新資料寫到共用的10表格再進行查詢" CssClass="auto-style2" ForeColor="White" BorderStyle="None" />
        
           後查詢:共用左邊查詢),另類查詢:<asp:Button ID="Button150" runat="server" BackColor="#CC0000" Height="30px" Text="剛起漲EPS" Width="105px" ToolTip="不在自選股另有條件中(可改)列出多筆的eps等資訊,修件是近3期起漲,再前8期變化不大,近三期成交量大於50%" CssClass="auto-style2" ForeColor="White" BorderStyle="None" />
        
           &nbsp;<asp:Button ID="Button151" runat="server" BackColor="#CC0000" Height="30px" Text="剛起漲營業額" Width="118px" ToolTip="在自選股中列出多筆的營業額等資訊,先使用自選股,修件也可以是近3期起漲,再前8期變化不大,近三期成交量大於50%" CssClass="auto-style2" ForeColor="White" BorderStyle="None" />
        
           &nbsp;<br />
        <br />
       
           32.新起漲(須執行過"近十期建檔",要再按執行):<asp:Button ID="Button152" runat="server" BackColor="#CC0000" Height="30px" Text="剛起漲in自選股" Width="123px" ToolTip="(剛起漲:有量且前三天價漲+後8期價穏)近10期成交價量漲幅變化 in 自選股+前三期量價增幅,後8期價漲幅" CssClass="auto-style2" ForeColor="White" BorderStyle="None" />
        
        &nbsp;(<asp:Button ID="Button153" runat="server" BackColor="#CC0000" Height="30px" Text="剛起漲in自選股+概念股" Width="193px" ToolTip="前三期量價增幅,後8期價漲幅 in 自選股(+有概念股)" CssClass="auto-style2" ForeColor="White" BorderStyle="None" />
        
           <asp:Button ID="Button157" runat="server" BackColor="#CC0000" Height="30px" Text="簡" Width="35px" ToolTip="合併概念股" CssClass="auto-style2" ForeColor="White" BorderStyle="None" />
        
           )&nbsp;(<asp:Button ID="Button154" runat="server" BackColor="#CC0000" Height="30px" Text="obv盤中+新起漲+概念股" Width="193px" ToolTip="obv盤中選股(站上五日平均線張數 DESC) + 前三期量價增幅,後8期價漲幅+ 概念股" CssClass="auto-style2" ForeColor="White" BorderStyle="None" />
        
           <asp:Button ID="Button158" runat="server" BackColor="#CC0000" Height="30px" Text="簡" Width="35px" ToolTip="合併概念股" CssClass="auto-style2" ForeColor="White" BorderStyle="None" />
        
           ),原obv均線+自選股+概念股(<asp:Button ID="Button144" runat="server" BackColor="#CC0000" Height="30px" Text="1.OBV+只概念股+自選股" Width="198px" ToolTip="所有自選股" CssClass="auto-style2" ForeColor="White" BorderStyle="None" />
        
           <asp:Button ID="Button159" runat="server" BackColor="#CC0000" Height="30px" Text="簡" Width="35px" ToolTip="合併概念股" CssClass="auto-style2" ForeColor="White" BorderStyle="None" />
        
           )&nbsp;( <asp:Button ID="Button145" runat="server" BackColor="#CC0000" Height="30px" Text="2.OBV+只概念股+自選股8" Width="210px" ToolTip="自選股8(有加上概念股資訊)" CssClass="auto-style2" ForeColor="White" BorderStyle="None" />
        
           <asp:Button ID="Button160" runat="server" BackColor="#CC0000" Height="30px" Text="簡" Width="35px" ToolTip="合併概念股" CssClass="auto-style2" ForeColor="White" BorderStyle="None" />
        
           )<br />
           33.轉換成為json格式:最後加上 FOR JSON PATH 如:<asp:Button ID="Button163" runat="server" BackColor="#CC0000" Height="30px" Text="簡" Width="35px" ToolTip="合併概念股" CssClass="auto-style2" ForeColor="White" BorderStyle="None" />
        
           <br />
        <br />
        34.專家選股:<asp:Button ID="Button3" runat="server" BackColor="#CC0000" Height="30px" Text="盤中專家選股" Width="134px" ToolTip="盤中:要先執行excel上傳當日檔案才有資料,否則是前一天資料" CssClass="auto-style2" ForeColor="White" BorderStyle="None" />&nbsp;<asp:Button ID="Button166" runat="server" BackColor="#CC0000" Height="30px" Text="盤中專家全部" Width="134px" ToolTip="盤中全部:要先執行excel上傳當日檔案才有資料,否則是前一天資料" CssClass="auto-style2" ForeColor="White" BorderStyle="None" />&nbsp;<asp:Button ID="Button167" runat="server" BackColor="#CC0000" Height="30px" Text="盤中專家多欄位" Width="153px" ToolTip="盤中全部多欄位:要先執行excel上傳當日檔案才有資料,否則是前一天資料" CssClass="auto-style2" ForeColor="White" BorderStyle="None" />&nbsp;
        (區間一:<asp:TextBox ID="專日1" runat="server" Width="80px" Height="30px" ToolTip="35天(方便看扣抵位置)"></asp:TextBox>
                ,區間二:<asp:TextBox ID="專日2" runat="server" Width="80px" Height="30px" ToolTip="2倍"></asp:TextBox>
                ,區間三:<asp:TextBox ID="專日3" runat="server" Width="80px" Height="30px" ToolTip="3倍"></asp:TextBox>
                <asp:Button ID="Button5" runat="server" Text="顯示日期" Width="85px" ToolTip="顯示三個日期,第一次會自動帶入" BackColor="#990000" ForeColor="White" />

        )

        <asp:Button ID="Button165" runat="server" BackColor="#CC0000" Height="30px" Text="分數連三天上升" Width="134px" ToolTip="可直接執行自動補上最近三天日期,可彈性不連續日期" CssClass="auto-style2" ForeColor="White" BorderStyle="None" />&nbsp;<br />
           <br />
        以下空白<br />
        <span class="auto-style2">找出資料庫中所有資料表</span><br class="auto-style2" />
        <span class="auto-style2">(select&nbsp; ) TABLE_NAME FROM INFORMATION_SCHEMA.TABLES ORDER BY TABLE_NAME<asp:Button ID="Button59" runat="server" Text="貼到上方" Width="128px" ToolTip="資料庫等請配合更改" BackColor="#990000" ForeColor="White" />

        </span><br class="auto-style2" />
        <br class="auto-style2" />
        <span class="auto-style2">找出該資料表(winnewdate)中的所有欄位</span><br class="auto-style2" />
        <span class="auto-style2">(select&nbsp; ) COLUMN_NAME,ORDINAL_POSITION,DATA_TYPE,CHARACTER_MAXIMUM_LENGTH FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = &#39;winnewdate&#39;<asp:Button ID="Button60" runat="server" Text="貼到上方" Width="128px" ToolTip="資料庫等請配合更改" BackColor="#990000" ForeColor="White" />

        </span><br class="auto-style2" />
        <br class="auto-style2" />
        <span class="auto-style2">找出該資料表(chips5)中的主鍵欄位</span><br class="auto-style2" />
        <span class="auto-style2">(select&nbsp; ) COLUMN_NAME FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE WHERE TABLE_NAME = &#39;chips5&#39;<asp:Button ID="Button61" runat="server" Text="貼到上方" Width="128px" ToolTip="資料庫等請配合更改" BackColor="#990000" ForeColor="White" />

        </span><br class="auto-style2" />
        <br />
        <br />
        <br />

<br/>
        <br />
        <br />
        <br />
        <br />
        <br />
        <br />
        <br />
        <br />
        <br />
        <br />
        <br />
        <br />
        <br />
        <br />
        <br />
        <br />
        <asp:GridView ID="GridView暫存" runat="server" CellPadding="4" ForeColor="#333333" GridLines="None">
            <AlternatingRowStyle BackColor="White" />
            <FooterStyle BackColor="#990000" Font-Bold="True" ForeColor="White" />
            <HeaderStyle BackColor="#990000" Font-Bold="True" ForeColor="White" />
            <PagerStyle BackColor="#FFCC66" ForeColor="#333333" HorizontalAlign="Center" />
            <RowStyle BackColor="#FFFBD6" ForeColor="#333333" />
            <SelectedRowStyle BackColor="#FFCC66" Font-Bold="True" ForeColor="Navy" />
            <SortedAscendingCellStyle BackColor="#FDF5AC" />
            <SortedAscendingHeaderStyle BackColor="#4D0000" />
            <SortedDescendingCellStyle BackColor="#FCF6C0" />
            <SortedDescendingHeaderStyle BackColor="#820000" />
        </asp:GridView>
        <br />
        <br />
        <br />
        <br />
        <br />
        <br />
        <asp:GridView ID="GridView14" runat="server">
        </asp:GridView>
        <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:stockchangedateConnectionString %>" SelectCommand="SELECT          View_basicinfo.名稱, View_basicinfo.代號, View_basicinfo.成交價, View_basicinfo.漲跌, View_basicinfo.漲幅, 
                            View_basicinfo.總量, ROUND(三大法人統計結束日一天.三大法人 / View_basicinfo.股本億 / 100, 2) 
                            AS [三大法人買賣超佔股本比%], ROUND(主力統計結束日一天.主力買賣超 / View_basicinfo.股本億 / 100, 2) 
                            AS [主力買賣超佔股本比%], ROUND(三大法人統計結束日一天.三大法人 / View_basicinfo.股本億 / 100, 2) 
                            + ROUND(主力統計結束日一天.主力買賣超 / View_basicinfo.股本億 / 100, 2) AS 主力加法人比率合計, 
                            三大法人統計結束日一天.三大法人, 主力統計結束日一天.主力買賣超, View_basicinfo.產業分類, View_basicinfo.交易所分類, 
                            View_basicinfo.股本億
FROM              View_basicinfo INNER JOIN
                            主力統計結束日一天 ON View_basicinfo.代號 = 主力統計結束日一天.代號 INNER JOIN
                            三大法人統計結束日一天 ON View_basicinfo.代號 = 三大法人統計結束日一天.代號
WHERE          (View_basicinfo.總量 &gt;= 5000)
ORDER BY   主力加法人比率合計 DESC"></asp:SqlDataSource>
        <br/>

        





    </form>
    <p>
        &nbsp;</p>
   

      <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/js/bootstrap.min.js" integrity="sha384-smHYKdLADwkXOn1EmN1qk/HfnUcbVRZyYmZ4qpPea6sjB/pTJ0euyQp0Mk8ck+5T" crossorigin="anonymous"></script>
<script src="Scripts/jquery-3.3.1.js"></script>   
    <%--<script src="Scripts/bootstrap.js"></script>--%>
</body>
</html>
