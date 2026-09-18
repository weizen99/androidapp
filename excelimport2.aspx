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
<script src="sqlTemplateLibrary.js"></script>
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
          //const sqlTemplateLibrary = [            

          //];

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
//====================================================================================================
          // 開啟與關閉面板控制
          function openAIPanel() {
              document.getElementById('ai-backdrop').style.display = 'block';
              document.getElementById('ai-panel').style.right = '0';
          }
          function closeAIPanel() {
              document.getElementById('ai-backdrop').style.display = 'none';
              document.getElementById('ai-panel').style.right = '-450px';
          }

          /**
           * 核心自動化：自動解析點選列的數據並觸發 AI 解盤
           * @param {HTMLElement} btnObj 點擊的 HTML 按鈕物件
           */
          async function analyzeRowData(btnObj) {
              // 1. 尋找按鈕所在的整列 (tr)
              const row = btnObj.closest('tr');
              if (!row) return;

              // 2. 依據您的 excelsql2 表格欄位順序自動抓取數據 (請依實際網頁欄位索引微調 index)
              // 假設您的欄位順序為: 名稱[0], 代號[1], 盤中價[2], ..., 週抗壓比[10], FactSet預估EPS[12], 共識目標價[14]
              const cells = row.getElementsByTagName('td');

              const stockName = cells[0]?.innerText.trim() || "-";
              const stockCode = cells[1]?.innerText.trim() || "-";
              const price = parseFloat(cells[2]?.innerText.trim()) || 0;
              const ratio = parseFloat(cells[10]?.innerText.trim()) || 0;
              const estEps = parseFloat(cells[12]?.innerText.trim()) || 0;
              const targetPrice = parseFloat(cells[14]?.innerText.trim()) || 0;

              // 3. 填入面板小卡片
              document.getElementById('ai-meta-name').innerText = `${stockName} (${stockCode})`;
              document.getElementById('ai-meta-price').innerText = `${price} 元`;
              document.getElementById('ai-meta-ratio').innerText = `${ratio}`;
              document.getElementById('ai-meta-eps').innerText = estEps > 0 ? `${estEps} 元 (目標 ${targetPrice} 元)` : "暫無機構資料";

              // 4. 開啟面板
              openAIPanel();

              // 5. 組合 Prompt
              const promptText = `你是一位資深的台股量化操盤專家。請根據以下數據，為【${stockName}(${stockCode})】進行簡短且具體客觀的「戰術解盤」：
1. 盤中現價：${price}元，週抗壓比為${ratio}。
2. 機構預估 EPS 中位數為 ${estEps > 0 ? estEps + '元' : '無資料'}，共識目標價為 ${targetPrice > 0 ? targetPrice + '元' : '無資料'}。
請針對下週一開盤給出「進攻防守點」與「本金凱利部位」配置建議。`;

              const outputBox = document.getElementById('ai-output-box');
              outputBox.innerHTML = '正在建立安全管道，連線本機 Qwen-1.5B 進行分析中...';

              // 6. 呼叫本地串流 API
              try {
                  const response = await fetch('http://localhost:11434/api/generate', {
                      method: 'POST',
                      headers: { 'Content-Type': 'application/json' },
                      body: JSON.stringify({
                          model: 'qwen2.5:7b',
                          prompt: promptText,
                          stream: true
                      })
                  });

                  if (!response.ok) throw new Error('Ollama 連線異常');

                  outputBox.innerHTML = ''; // 清空準備打字效果
                  const reader = response.body.getReader();
                  const decoder = new TextDecoder('utf-8');

                  while (true) {
                      const { value, done } = await reader.read();
                      if (done) break;

                      const chunk = decoder.decode(value, { stream: true });
                      const lines = chunk.split('\n');
                      for (const line of lines) {
                          if (line.trim() !== '') {
                              const parsed = JSON.parse(line);
                              outputBox.innerHTML += parsed.response;
                          }
                      }
                  }
              } catch (error) {
                  outputBox.innerHTML = `<span style="color: #ef4444;">❌ 本地解盤連線失敗。請確認 Ollama 已啟動，且已設定 OLLAMA_ORIGINS = * 並重新啟動。</span>`;
              }
          }

          // 確保 DOM 載入完成後執行
          document.addEventListener("DOMContentLoaded", function () {
              // 監聽網頁中所有表格列 (tr) 的雙擊事件
              document.addEventListener("dblclick", function (event) {
                  // 尋找雙擊的目標是否在表格列內
                  const row = event.target.closest("tr");
                  if (row) {
                      // 避免雙擊到表頭 (th)
                      if (row.querySelector("th")) return;

                      console.log("🖱️ 雙擊列偵測成功，啟動動態欄位解析與解盤...");

                      // 1. 尋找這一列中，我們需要傳給 AI 的按鈕（此處將 'row' 作為虛擬按鈕傳入）
                      // 這樣您就不需要按鈕，雙擊整列就能直接調用我們前一節寫好的 analyzeRowData 函數！
                      analyzeRowData(row);
                  }
              });
          });

          // 微調前面的解析函數，使其同時支援「點擊按鈕」與「雙擊整列」
          async function analyzeRowData(triggerObj) {
              // 如果傳入的是按鈕，尋找 tr；如果雙擊傳入的就是 tr，則直接使用
              const row = (triggerObj.tagName === "TR") ? triggerObj : triggerObj.closest('tr');
              if (!row) return;

              const cells = row.getElementsByTagName('td');

              // 以下維持原有的解析與請求邏輯...
              const stockName = cells[0]?.innerText.trim() || "-";
              const stockCode = cells[1]?.innerText.trim() || "-";
              const price = parseFloat(cells[2]?.innerText.trim()) || 0;
              const ratio = parseFloat(cells[10]?.innerText.trim()) || 0;
              const estEps = parseFloat(cells[12]?.innerText.trim()) || 0;
              const targetPrice = parseFloat(cells[14]?.innerText.trim()) || 0;

              document.getElementById('ai-meta-name').innerText = `${stockName} (${stockCode})`;
              document.getElementById('ai-meta-price').innerText = `${price} 元`;
              document.getElementById('ai-meta-ratio').innerText = `${ratio}`;
              document.getElementById('ai-meta-eps').innerText = estEps > 0 ? `${estEps} 元 (目標 ${targetPrice} 元)` : "暫無機構資料";

              openAIPanel();

              const promptText = `你是一位資深的台股量化操盤專家。請根據以下數據，為【${stockName}(${stockCode})】進行簡短且具體客觀的「戰術解盤」：
1. 盤中現價：${price}元，週抗壓比為${ratio}。
2. 機構預估 EPS 中位數為 ${estEps > 0 ? estEps + '元' : '無資料'}，共識目標價為 ${targetPrice > 0 ? targetPrice + '元' : '無資料'}。
請針對下週一開盤給出「進攻防守點」與「本金凱利部位」配置建議。`;

              const outputBox = document.getElementById('ai-output-box');
              outputBox.innerHTML = '正在連線本機 Qwen-1.5B 進行分析中...';

              try {
                  const response = await fetch('http://localhost:11434/api/generate', {
                      method: 'POST',
                      headers: { 'Content-Type': 'application/json' },
                      body: JSON.stringify({
                          model: 'qwen2.5:7b',
                          prompt: promptText,
                          stream: true
                      })
                  });

                  if (!response.ok) throw new Error('Ollama 連線異常');

                  outputBox.innerHTML = '';
                  const reader = response.body.getReader();
                  const decoder = new TextDecoder('utf-8');

                  while (true) {
                      const { value, done } = await reader.read();
                      if (done) break;

                      const chunk = decoder.decode(value, { stream: true });
                      const lines = chunk.split('\n');
                      for (const line of lines) {
                          if (line.trim() !== '') {
                              const parsed = JSON.parse(line);
                              outputBox.innerHTML += parsed.response;
                          }
                      }
                  }
              } catch (error) {
                  outputBox.innerHTML = `<span style="color: #ef4444;">❌ 本地解盤連線失敗。請確認 Ollama 正在背景運行。</span>`;
              }
          }

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
