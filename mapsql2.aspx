<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="mapsql2.aspx.vb" Inherits="homesomee.mapsql2"  maintainscrollpositiononpostback="true"  %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
     <title></title>
      <link href="Content/bootstrap.css" rel="stylesheet" />
    <style type="text/css">

         html, body,form,#map-canvas {
              height: 100%;
              margin: 0px;
              padding: 3px
            }  


.leftaddmg {
            padding-left: 5px;
            padding-right: 20px;
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
.auto-style1 {
            font-family: 標楷體;
            font-size:x-large;
            color: #FF0000;
        }
 .auto-style1 {
            font-family: 標楷體;
            color: #FF0000;
            font-size: large;
        }

        .auto-style2 {
            font-family: 標楷體;
            font-size:xx-large;
            color: #FF0000;
        }
    
        table {
  border-collapse: collapse;
}

th {
  text-align: inherit;
}

a {
  color: #007bff;
  text-decoration: none;
  background-color: transparent;
  -webkit-text-decoration-skip: objects;
}


    </style>
    <%--getElementById("map") ""內是要在下戶顯示的名字 ,而 function load() 的 load()要放在<body onload = "load()">  內, 另html, body,form,#map-canvas{},要加上form,不然可能無法顯示 --%><%--下以這版有問題  src="http://maps.google.com/maps/api/js?v=3.1&amp;sensor=false"--%>
    <script type="text/javascript" >

         function load() {
             if (GBrowserIsCompatible()) {
                 var map = new GMap2(document.getElementById("map"));
                 map.addControl(new GSmallMapControl());
                 map.addControl(new GMapTypeControl());
                 var center = new GLatLng(23.672931, 120.48088);
                 map.setCenter(center, 14);
                 map.setMapType(G_SATELLITE_MAP);
                 geocoder = new GClientGeocoder();
                 
                 var marker = new GMarker(center, { draggable: true });
                 map.addOverlay(marker);
                
                 //document.getElementById("lat").value = center.lat();
                 //document.getElementById("lng").value = center.lng();

                 geocoder = new GClientGeocoder();

                 GEvent.addListener(marker, "dragend", function() {
                     var point = marker.getPoint();
                     map.panTo(point);
                     alert(point);
                     //document.getElementById("lat").value = point.lat();
                     //document.getElementById("lng").value = point.lng();
                 });

                 GEvent.addListener(map, "moveend", function() {
                     map.clearOverlays();
                     var center = map.getCenter();
                     var marker = new GMarker(center, { draggable: true });
                     map.addOverlay(marker);
                     document.getElementById("lat").value = center.lat();
                     document.getElementById("lng").value = center.lng();

                     GEvent.addListener(marker, "dragend", function() {
                     var point = marker.getPoint();
                    
                         map.panTo(point);
                         //document.getElementById("lat").value = point.lat();
                         //document.getElementById("lng").value = point.lng();
                     });
                 });
             }
         }

         function showAddress(address) {
             
             var map = new GMap2(document.getElementById("map"));
             map.addControl(new GSmallMapControl());
             map.addControl(new GMapTypeControl());
             if (geocoder) {
                 geocoder.getLatLng(
address,
function(point) {
    if (!point) {
        alert(address + " city not found !");
    }
    else {
        document.getElementById("lat").value = point.lat();
        document.getElementById("lng").value = point.lng();
        map.clearOverlays()
        map.setCenter(point, 14);
        var marker = new GMarker(point, { draggable: true });
        map.addOverlay(marker);

        GEvent.addListener(marker, "dragend", function() {
            var pt = marker.getPoint();
            map.panTo(pt);
            document.getElementById("lat").value = pt.lat();
            document.getElementById("lng").value = pt.lng();
        });

        GEvent.addListener(map, "moveend", function() {
            map.clearOverlays();
            var center = map.getCenter();
            var marker = new GMarker(center, { draggable: true });
            map.addOverlay(marker);
            document.getElementById("lat").value = center.lat();
            document.getElementById("lng").value = center.lng();

            GEvent.addListener(marker, "dragend", function() {
                var pt = marker.getPoint();
                map.panTo(pt);
                document.getElementById("lat").value = pt.lat();
                document.getElementById("lng").value = pt.lng();
            });
        });
    } 
}
);
             } 
         }


         //第二種方式  開始  
         var x = document.getElementById("nowaddress1");

         function getLocation() {
             if (navigator.geolocation) {
                 navigator.geolocation.getCurrentPosition(showPosition, showError);

             } else {
                 x.innerHTML = "Geolocation is not supported by this browser.";
             }
         }

         function showPosition(position) {
             var latlon = position.coords.latitude + "," + position.coords.longitude;

             document.getElementById("valuex").value = position.coords.latitude;
             document.getElementById("valuey").value = position.coords.longitude;

             var img_url = "https://maps.googleapis.com/maps/api/staticmap?center="
             //+ latlon + "&zoom=14&size=400x300&key=AIzaSyBu-916DdpKAjTmJNIgngS6HL_kDIKU0aU";
             +latlon + "&zoom=14&size=400x300&key=AIzaSyDystbcXoiY4Gdk22iOK_DZe0BoCSaRyk4";
             document.getElementById("map不在表頭").innerHTML = "<img src='" + img_url + "'>";
             //alert("chrome有點偏離目標,Internet Explorer有準");
         }
         //To use this code on your website, get a free API key from Google.
         //Read more at: https://www.w3schools.com/graphics/google_maps_basic.asp

         function showError(error) {
             switch (error.code) {
                 case error.PERMISSION_DENIED:
                     x.innerHTML = "User denied the request for Geolocation."
                     break;
                 case error.POSITION_UNAVAILABLE:
                     x.innerHTML = "Location information is unavailable."
                     break;
                 case error.TIMEOUT:
                     x.innerHTML = "The request to get user location timed out."
                     break;
                 case error.UNKNOWN_ERROR:
                     x.innerHTML = "An unknown error occurred."
                     break;
             }
         }
         //第二種方式  結束
       
        //function searchGoogle() {
        //    var searchQuery = Session("myword");
        //    var googleSearchUrl = "https://www.google.com/search?q=" + encodeURIComponent(searchQuery);
        //    window.open(googleSearchUrl, "_blank");
        //}

        //function openGoogleMaps() { var googleMapsUrl = "https://www.google.com/maps?q=" + encodeURIComponent(coordinates); window.open(googleMapsUrl, "_blank"); }



    </script>



</head>
<body onload = "initMap()">
    <%-- <body onload = "initMapnowaddress()">--%>
    <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDystbcXoiY4Gdk22iOK_DZe0BoCSaRyk4&callback&callback=initMap" async defer></script>
   <script language="JavaScript">
<!--
         var message = "";
         function clickIE() { if (document.all) { (message); return false; } }
         function clickNS(e) {
             if
(document.layers || (document.getElementById && !document.all)) {
                 if (e.which == 2 || e.which == 3) { (message); return false; }
             }
         }
         if (document.layers)
         { document.captureEvents(Event.MOUSEDOWN); document.onmousedown = clickNS; }
         else { document.onmouseup = clickNS; document.oncontextmenu = clickIE; }
         document.oncontextmenu = new Function("return false")
// -->
    </script>
     <form id="form1" runat="server">
  
        <span class="auto-style10">
    
       <asp:menu runat="server" ID="menu1" BackColor="#FFFBD6" DynamicHorizontalOffset="2" Font-Names="標楷體" Font-Size="Large" ForeColor="#990000" Orientation="Horizontal" StaticSubMenuIndent="50px" Font-Underline="True" ToolTip="功能表常更新,以此表為最新資料,先按此表一次再找">
            <DynamicHoverStyle BackColor="#990000" ForeColor="White" />
            <DynamicMenuItemStyle HorizontalPadding="5px" VerticalPadding="10px" />
            <DynamicMenuStyle BackColor="#FFFBD6" />
            <DynamicSelectedStyle BackColor="#FFCC66" />
            <Items>
                <asp:MenuItem Text=" 成語 " Value="股票">
                   
                        <asp:MenuItem Text="成語(分年級)" Value="成語(分年級)" NavigateUrl="fourword.aspx"></asp:MenuItem>
                        <asp:MenuItem Text="成語(全部題目)" Value="成語(全部題目)" NavigateUrl="fourword1.aspx"></asp:MenuItem>                        
                       <asp:MenuItem Text="成語(存在瀏覽器內)" Value="成語(存在瀏覽器內)" NavigateUrl="http://www.sachi.somee.com/fourword.html"></asp:MenuItem> 
                        
                   </asp:MenuItem>
              
                <asp:MenuItem Text=" 景點座標 " Value="景點座標">
                    
                    <asp:MenuItem NavigateUrl="http://www.sachi.somee.com/mapsql1" Text="全國景點座標查詢編輯somee" Value="全國景點座標查詢編輯somee"> </asp:MenuItem>   
                    <asp:MenuItem NavigateUrl="http://220.134.245.185:8888/someepokomap1/mapsql1" Text="本機全國景點座標查詢編輯(會關機)" Value="本機全國景點座標查詢編輯220"> </asp:MenuItem>                 
                     <asp:MenuItem NavigateUrl="http://220.134.245.185:8888/fishnew5/selfpokesql" Text="本機座標(會關機)" Value="本機座標(會關機)"> </asp:MenuItem>
                    <asp:MenuItem NavigateUrl="http://www.sachi.somee.com/websqlpoko.html" Text="座標(存在瀏覽器內)" Value="座標(存在瀏覽器內)"> </asp:MenuItem>
                </asp:MenuItem>
               
                <asp:MenuItem Text=" 股票自選股建檔 " Value="自選股建檔">
                    
                    <asp:MenuItem NavigateUrl="incomeedit.aspx" Text="自選股編輯" Value="自選股編輯"> </asp:MenuItem>
                     <asp:MenuItem NavigateUrl="http://220.134.245.185:8888/fishnew5/incomeedit" Text="本機自選股編輯(會關機)" Value="本機自選股編輯"> </asp:MenuItem>
                     <asp:MenuItem NavigateUrl="http://220.134.245.185:8888/fishnew5/selfselected" Text="本機自選股內容說明編輯(會關機)" Value="本機自選股內容說明編輯(會關機)"> </asp:MenuItem>
                    <asp:MenuItem NavigateUrl="http://www.sachi.somee.com/index.html" Text="somee首頁(index)" Value="somee首頁(sachi)"> </asp:MenuItem>
                    <asp:MenuItem NavigateUrl="http://www.sachi.somee.com/poemaccess" Text="somee首頁(poemaccess)" Value="somee首頁(poemaccess)"> </asp:MenuItem>
                    <asp:MenuItem NavigateUrl="http://220.134.245.185:8888/androidapp/index.html" Text="本機手機版首頁(220會關機)" Value="本機手機版首頁(220)"> </asp:MenuItem>
                    <asp:MenuItem NavigateUrl="http://220.134.245.185:8888/fishnew5/poemaccesshistory" Text="本機股票首頁(220會關機)" Value="本機股票首頁(220)"> </asp:MenuItem>
                </asp:MenuItem>
                <asp:MenuItem Text=" youtube影片區 " Value="youtube影片">
                    
                    <asp:MenuItem NavigateUrl="https://youtu.be/6xG3BBVz8P0" Text="利用excel讀取檔案並上傳到資料庫" Value="利用excel讀取檔案並上傳到資料庫"> </asp:MenuItem>
                    <asp:MenuItem NavigateUrl="https://youtu.be/hU5FeCBCtqA" Text="excel讀取SQL資料庫檔案並以圖形顯示" Value="excel讀取SQL資料庫檔案並以圖形顯示"> </asp:MenuItem>
                    <asp:MenuItem NavigateUrl="https://youtu.be/KBzFUzE0agQ" Text="圖片上傳至SQLServer建檔,網頁內可作單筆上傳或整批上傳並提供簡易的新增及刪除修改" Value="圖片上傳至SQLServer建檔,網頁內可作單筆上傳或整批上傳並提供簡易的新增及刪除修改"> </asp:MenuItem>
                    <asp:MenuItem NavigateUrl="https://youtu.be/VCyPjXlIouM" Text="使用excel讀取巳下載的15個excel表(也可以寫入)" Value="使用excel讀取巳下載的15個excel表(也可以寫入)"> </asp:MenuItem>
                    <asp:MenuItem NavigateUrl="https://youtu.be/ywOt29Niy5E" Text="把櫃買中心的分價資料也拿來作資料庫" Value="把櫃買中心的分價資料也拿來作資料庫"> </asp:MenuItem>
                    <asp:MenuItem NavigateUrl="https://youtu.be/EdWNpqBC0p8" Text="excel整批刪除空白資料列以利上傳資料" Value="刪除空白資料列"> </asp:MenuItem>
                  
                  
                </asp:MenuItem>

                 <asp:MenuItem Text=" youtube實作區 " Value="youtube實作區">
                    
                    <asp:MenuItem NavigateUrl="webyu.aspx" Text="圖片上傳至SQLServer建檔,網頁內可作單筆上傳或整批上傳並提供簡易的新增及刪除修改somee" Value="圖片上傳至SQLServer建檔,網頁內可作單筆上傳或整批上傳並提供簡易的新增及刪除修改somee"> </asp:MenuItem>
                    <asp:MenuItem NavigateUrl="http://220.134.245.185:8888/lookpicture/webyu.aspx" Text="圖片上傳至SQLServer建檔demo檔(會關機)" Value="圖片上傳至SQLServer建檔demo檔(會關機)"> </asp:MenuItem>
                    <asp:MenuItem NavigateUrl="http://220.134.245.185:8888/work/favorites2.aspx" Text="本機圖片上傳至SQLServer建檔進階版(會關機共連號四個)" Value="本機圖片上傳至SQLServer建檔進階版(會關機共四個)"> </asp:MenuItem>
                    <asp:MenuItem NavigateUrl="http://220.134.245.185:8888/fishnew5/stockgodpc1" Text="本機圖片上傳至SQLServer股票進階版(會關機)" Value="本機圖片上傳至SQLServer股票進階版(會關機)"> </asp:MenuItem>
                    <asp:MenuItem NavigateUrl="http://220.134.245.185:8888/fishnew5/trend" Text="excel讀取SQL資料庫檔案並以圖形顯示網頁進階版" Value="excel讀取SQL資料庫檔案並以圖形顯示網頁進階"> </asp:MenuItem>
                    <asp:MenuItem NavigateUrl="http://220.134.245.185:8888/webchart/webcatch8" Text="把櫃買中心的分價資料也拿來作資料庫網頁版" Value="把櫃買中心的分價資料也拿來作資料庫網頁版"> </asp:MenuItem>
                    <asp:MenuItem NavigateUrl="http://220.134.245.185:8888/webchart/equity" Text="利用excel讀取檔案並上傳到資料庫網頁版應用" Value="利用excel讀取檔案並上傳到資料庫網頁版應用"> </asp:MenuItem>

                 </asp:MenuItem>

            </Items>
            <StaticHoverStyle BackColor="#990000" ForeColor="White" />
            <StaticMenuItemStyle HorizontalPadding="5px" VerticalPadding="2px" />
            <StaticSelectedStyle BackColor="#FFCC66" />
        </asp:menu>
             </span>
      
       <%--  <br />--%><%-- <div class="container-fluid col-xs-6 col-sm-6 col-md-3">--%>
                           <ul class="nav nav-tabs auto-style1">             
    <li class="nav-item"><a class="nav-link" href="https://emap.pcsc.com.tw/">7-11電子地圖</a> </li>                    
    <li class="nav-item"><a class="nav-link" href="https://www.ibon.com.tw/MOBILE/retail_inquiry.aspx#gsc.tab=0">ibon_電子地圖(區域)</a> </li>  
    <li class="nav-item"><a class="nav-link" href="http://www.hacker1.somee.com/mapsql2">完整版(較多資訊)</a> </li>
    <li class="nav-item"><a class="nav-link" href="http://www.hacker1.somee.com/maptest">完整新地圖</a> </li>
    <li class="nav-item"><a class="nav-link" href="http://www.hacker1.somee.com/guestmsg1.aspx">過渡暫存</a> </li>
    <li class="nav-item"><a class="nav-link" href="http://220.135.3.78:8888/androidapp/index.html">回區城首頁</a> </li>
</ul>

         <%-- </div>--%>
        <br />
        &nbsp;&nbsp;<asp:Label ID="Label1" runat="server" Font-Names="標楷體" Font-Size="X-Large" ForeColor="#CC0000" Text="全國景點座標" ToolTip="按選取顯示出地圖位置可按距離排序"></asp:Label>
       &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
         <asp:HyperLink ID="mylink" runat="server" Target="_blank">Google搜尋連結</asp:HyperLink>


       
        &nbsp; 
         <asp:HyperLink ID="mylink1" runat="server" Target="_blank">Google地圖連結</asp:HyperLink>
        <br />

          <div class="container-fluid  leftaddmg">
            <div class="row">
                <div class="col-xs-6 col-sm-6 col-md-3 cotext-left btn-default">
              
                    <asp:TextBox ID="keyword" runat="server" BackColor="Aqua" CssClass="auto-style5" Font-Size="XX-Large" Height="50px" Width="122px" ToolTip="輸入相似字或按右邊的下拉選單輸入,也可以空白">宮</asp:TextBox>
            
                </div>
               <div class="col-xs-6 col-sm-6 col-md-3 tcotext-left  btn-default">
                   
         <asp:DropDownList ID="DropDownList2" class="btn btn-primary " runat="server" AutoPostBack="True" Width="115px" BackColor="#99FF66" Font-Names="標楷體" ForeColor="#003300" Height="50px" Font-Size="X-Large" DataSourceID="SqlDataSource3" DataTextField="name" DataValueField="name">
         </asp:DropDownList>

              </div>

              <div class="col-xs-6 col-sm-6 col-md-3 cotext-left  btn-default">
            <span class="auto-style2"> <asp:Button ID="poem1_stock相似搜尋" runat="server" Height="50px" Text="相似搜尋" 

            Width="153px" CssClass="auto-style5" ToolTip="輸入相似字並列出符合的道館名稱" BackColor="#000066" Font-Size="XX-Large" ForeColor="White" />
             </span>           
            
           </div>

<div class="col-xs-6 col-sm-6 col-md-3 tcotext-left  btn-default">
              
                   <span class="btn btn-default" style="width: 104px"><span class="auto-style1"><span class="auto-style9"><span class="auto-style10">
         <asp:DropDownList ID="DropDownList1" runat="server" AutoPostBack="True" Width="115px" BackColor="Maroon" Font-Names="標楷體" ForeColor="White" Height="50px" Font-Size="X-Large" ToolTip="下拉選擇含有此字的道館">
         </asp:DropDownList>
         </span></span></span></span>

              </div>
               
            </div>
        </div>  
                <br />          

          <div class="container-fluid  leftaddmg">
            <div class="row">
                <div class="col-xs-6 col-sm-6 col-md-3 cotext-left btn-default">
           

         <asp:Label ID="Label2" runat="server" Text="x值:" Font-Names="標楷體" Font-Size="XX-Large"></asp:Label>

                    <asp:TextBox ID="valuex" runat="server" BackColor="Aqua" CssClass="auto-style5" Font-Size="XX-Large" Height="50px" Width="193px" ToolTip="地圖的x軸座標可連動顯示地圖">24.974584</asp:TextBox>

                </div>
              
               <div class="col-xs-6 col-sm-6 col-md-3 tcotext-left  btn-default">

         <asp:Label ID="Label3" runat="server" Text="y值:" Font-Names="標楷體" Font-Size="XX-Large"></asp:Label>


                   <asp:TextBox ID="valuey" runat="server" BackColor="Aqua" CssClass="auto-style5" Font-Size="XX-Large" Height="50px" Width="190px" ToolTip="地圖的y軸座標可連動顯示地圖">121.547902</asp:TextBox>

              </div>

             <div class="col-xs-6 col-sm-6 col-md-3 tcotext-left  btn-default">
                   <asp:Label ID="Label4" runat="server" Text="景點:" Font-Names="標楷體" Font-Size="XX-Large"></asp:Label>

                  <asp:TextBox ID="valuename" runat="server" BackColor="Aqua" CssClass="auto-style5" Font-Size="XX-Large" Height="50px" Width="190px" ToolTip="地圖顯示的名稱,可連動顯示地圖">HOME</asp:TextBox>

                    </div>

<div class="col-xs-6 col-sm-6 col-md-3 tcotext-left  btn-default">
              
                   <span class="auto-style2"> <asp:Button ID="Button2" runat="server" Height="50px" Text="依距離" 

            Width="153px" CssClass="auto-style5" ToolTip="依距離所選取的道館的遠近排序" BackColor="#000066" Font-Size="XX-Large" ForeColor="White" />
             </span>  
            
           </div>
       </div>
             
        <div class="container-fluid leftaddmg">
        <span class="style1"><span class="auto-style2"> <span class="auto-style4"> 

        <span class="auto-style1"><span class="auto-style9">

        <span class="auto-style10">(<asp:TextBox ID="totolpage" 

            runat="server" Height="25px" Width="81px" Font-Size="Medium" ToolTip="股票名稱(由選取產生),空白表示列出全部資料,可使用排序及分頁功能(點兩次改變,再點選標題重新列出資料)" BackColor="#CCFFFF" Font-Names="標楷體" ForeColor="#0000CC">10</asp:TextBox>

            </span></span></span> 

              <asp:Button ID="Button87" runat="server" Height="28px" Text="分頁(N筆)" Width="100px" BackColor="#003300" Font-Names="標楷體" Font-Size="Medium" ForeColor="White" Visible="True" ToolTip="按到分頁為止,先輸入分頁筆數" />

              )<asp:Button ID="Button88" runat="server" Height="28px" Text="不分頁" Width="100px" BackColor="#003300" Font-Names="標楷體" Font-Size="Medium" ForeColor="White" Visible="True" ToolTip="按到分頁不見為止" />

              <asp:Button ID="Button89" runat="server" Height="28px" Text="顯示全部" Width="88px" BackColor="#003300" Font-Names="標楷體" Font-Size="Medium" ForeColor="White" Visible="True" />

              <asp:Button ID="Button90" runat="server" Height="28px" Text="隱藏部份" Width="98px" BackColor="#003300" Font-Names="標楷體" Font-Size="Medium" ForeColor="White" Visible="True" />

              <asp:Button ID="Button92" runat="server" Height="28px" Text="隱藏主表格" Width="103px" BackColor="Maroon" Font-Names="標楷體" Font-Size="Medium" ForeColor="White" Visible="True" ToolTip="不分頁顯示筆數過多,或分頁筆數多時,可按此先隱藏主表格去看圖形,或新增資料時" />

              </span></span></span>
              </div>
                <asp:GridView ID="GridView4" runat="server" AutoGenerateColumns="False" CellPadding="4" Font-Names="標楷體" Font-Size="Large" ForeColor="#333333" GridLines="None" ToolTip="按選取下方地圖會連動並可另顯示衛星地圖,下方的看圖也會連動顯示" AllowPaging="True" PageSize="5">
                    <AlternatingRowStyle BackColor="White" />
                    <Columns>
                        <asp:CommandField ShowSelectButton="True" />
                        <asp:BoundField DataField="name1" HeaderText="景點" SortExpression="name1" />
                        <asp:TemplateField HeaderText="座標" SortExpression="mail1">
                            <EditItemTemplate>
                                <asp:TextBox ID="TextBox1" runat="server" Text='<%# Bind("mail1") %>'></asp:TextBox>
                            </EditItemTemplate>
                            <ItemTemplate>
                                <asp:TextBox ID="TextBox2" runat="server" Height="42px" Text='<%# Bind("mail1") %>' Width="250px"></asp:TextBox>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="x軸" HeaderText="x軸" SortExpression="x軸" />
                        <asp:BoundField DataField="y軸" HeaderText="y軸" SortExpression="y軸" />
                        <asp:BoundField DataField="識別碼" HeaderText="識別碼" SortExpression="識別碼" />
                        <asp:BoundField DataField="x加y" HeaderText="試算後距離" SortExpression="x加y" />
                        <asp:BoundField DataField="word1" HeaderText="地址" />
                    </Columns>
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
                  
        <div class="container-fluid">
          <span class="style1"><span class="auto-style2"><span class="auto-style4"><span class="auto-style1"><span class="auto-style9">
                    <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:pokomonConnectionString %>" SelectCommand="SELECT [name1], [mail1], [word1], [識別碼], [x軸], [y軸] FROM [textmsg]" ProviderName="<%$ ConnectionStrings:pokomonConnectionString.ProviderName %>"></asp:SqlDataSource>
                    </span></span></span></span></span>
                </div>
      
</div>
      
         <!-- 宣告使用新版的地圖不用key v3 -->
    <script src="https://maps.googleapis.com/maps/api/js?v=3.exp&sensor=false"></script>
          <script type="text/javascript">             

              var map;

              function initMapnowaddress() {

                  navigator.geolocation.getCurrentPosition(function (position) {
                      var pos = {
                          lat: position.coords.latitude,
                          lng: position.coords.longitude
                      };
                      document.getElementById("valuex").value = pos.lat;
                      document.getElementById("valuey").value = pos.lng;

                  });



                  var latlng;

                  latlng = new google.maps.LatLng(document.getElementById("valuex").value, document.getElementById("valuey").value);
                  //alert(latlng);

                  var mapOptions = {
                      zoom: 15, //地圖縮放的層級
                      center: latlng,
                      mapTypeId: google.maps.MapTypeId.ROADMAP,                            //地圖呈現的方式  document.getElementById("maptext").textContent,  google.maps.MapTypeId.TERRAIN,   ROADMAP：一般的 2D 地圖模式（預設樣式）SATELLITE：衛星空拍圖  HYBRID：衛星空拍圖加上道路、城市名稱等的顯著圖層 TERRAIN：地形圖
                      //mapTypeId: google.maps.MapTypeId.HYBRID,
                      mapTypeControl: true,
                      fullscreenControl: true,
                      rotateControl: true,
                      scaleControl: true,
                      streetViewControl: true,
                      zoomControl: true,
                      mapTypeControlOptions: { position: google.maps.ControlPosition.TOP_CENTER },
                      fullscreenControlOptions: { position: google.maps.ControlPosition.TOP_RIGHT },
                      rotateControlOptions: { position: google.maps.ControlPosition.RIGHT_CENTER },
                      scaleControlOptions: { position: google.maps.ControlPosition.RIGHT_BOTTOM },
                      streetViewControlOptions: { position: google.maps.ControlPosition.TOP_LEFT },
                      zoomControlOptions: { position: google.maps.ControlPosition.RIGHT_BOTTOM },

                  };

                  //把地圖放在頁面的 div 裡
                  var map = new google.maps.Map(document.getElementById('map不在表頭'), mapOptions);
                  //var newlatlng;
                  //newlatlng = document.getElementById("valuex").value + ", " + document.getElementById("valuey").value;
                  map.setCenter(new google.maps.LatLng(document.getElementById("valuex").value, document.getElementById("valuey").value), 13);
                  //map.setMapTypeId(document.getElementById("maptext"));
                  //map.setMapTypeId(google.maps.MapTypeId.CONSTANT);            
                  //宣告地圖標記選項
                  var markerOptions = {
                      //地圖標記位置
                      position: latlng,
                      //設定要套用的地圖
                      map: map,
                      //地圖標記要顯示的文字
                      //title: "斗南火車站"
                      title: document.getElementById("valuename").value,
                      //map不在表頭.value = document.getElementById("valuename").value
                      //mapTypeId: document.getElementById("maptext").value,
                      //setMapTypeId(document.getElementById("maptext")),          setMapTypeId(MapTypeId)
                      mapTypeControl: true,
                      fullscreenControl: true,
                      rotateControl: true,
                      scaleControl: true,
                      streetViewControl: true,
                      zoomControl: true,
                      mapTypeControlOptions: { position: google.maps.ControlPosition.TOP_CENTER },
                      fullscreenControlOptions: { position: google.maps.ControlPosition.TOP_RIGHT },
                      rotateControlOptions: { position: google.maps.ControlPosition.RIGHT_CENTER },
                      scaleControlOptions: { position: google.maps.ControlPosition.RIGHT_BOTTOM },
                      streetViewControlOptions: { position: google.maps.ControlPosition.TOP_LEFT },
                      zoomControlOptions: { position: google.maps.ControlPosition.RIGHT_BOTTOM },
                  }

                  //把地圖標記標示在地圖上
                  //var marker = new google.maps.Marker(map);
                  var marker = new google.maps.Marker({
                      position: map.center,
                      map: map,
                      animation: google.maps.Animation.BOUNCE,
                      //label: '看',
                      title: document.getElementById("valuename").value,
                      //icon: 'http://www.oxxostudio.tw/img/articles/201801/google-maps-3-marker-icon.png',

                  });

                  //攔截 map 的 click event
                  google.maps.event.addListener(map, 'click', function (event) {
                      var location = event.latLng;
                      alert(location.lat() + ',' + location.lng() + " 確認後表單的x軸 y軸巳改變,加入名稱可加入資料庫");
                      document.getElementById("lat").value = location.lat();
                      document.getElementById("lng").value = location.lng();
                  });

                  //document.getElementById('map不在表頭1').style.visibility = "hidden";
                  //document.getElementById('map不在表頭').style.display = "";

              }





        function initMap() {
            //map = new google.maps.Map(document.getElementById('map'), {
            //  center: {lat: 23.672931, lng: 120.48088},
            //   zoom: 16,         

            //取得目標的經緯度 23.672931	120.48088
            //map不在表頭.event.event.latLng.lat() = document.getElementById("valuex").value
            //map不在表頭.event.event.latLng.lng() = document.getElementById("valuey").value
            //map不在表頭.title = document.getElementById("valuename").value

            //var latlng = new google.maps.LatLng(23.672931, 120.48088);


            //var newlatlng ;
            //newlatlng = document.getElementById("valuex").value + ", " + document.getElementById("valuey").value;
            //var latlng = new google.maps.LatLng(newlatlng);

            //alert("地圖座標是: google.maps.latling(" + newlatlng + " )");

            var latlng = new google.maps.LatLng(24.974584, 121.547902);
            //latlng.lat = document.getElementById("valuex").value;
            //latlng.lng = document.getElementById("valuey").value;
            latlng = new google.maps.LatLng(24.974584, 121.547902);

            //var latlngx = new google.maps.LatLng.lat() = 23.672931;
            //var latlngy = new google.maps.LatLng.lng() = 120.48088;
            //latlng.lat() = 23.672931
                //document.getElementById("valuex").value
            //latlng.lng() = 120.48088
                //document.getElementById("valuey").value
            //標記在 Google 地圖上的經緯度
            //alert(document.getElementById("maptext").value)
            //map.latLng.lng() = document.getElementById("valuey").value
            //設定地圖的選項
            var mapOptions = {
                zoom: 15, //地圖縮放的層級
                center:latlng,
                mapTypeId: google.maps.MapTypeId.ROADMAP,                            //地圖呈現的方式  document.getElementById("maptext").textContent,  google.maps.MapTypeId.TERRAIN,   ROADMAP：一般的 2D 地圖模式（預設樣式）SATELLITE：衛星空拍圖  HYBRID：衛星空拍圖加上道路、城市名稱等的顯著圖層 TERRAIN：地形圖
                    //mapTypeId: google.maps.MapTypeId.HYBRID,
                mapTypeControl:true,
                fullscreenControl:true,
                rotateControl:true,
                scaleControl:true,
                streetViewControl:true,
                zoomControl:true,
                mapTypeControlOptions:{position:google.maps.ControlPosition.TOP_CENTER},
                fullscreenControlOptions:{position:google.maps.ControlPosition.TOP_RIGHT},
                rotateControlOptions:{position:google.maps.ControlPosition.RIGHT_CENTER},
                scaleControlOptions:{position:google.maps.ControlPosition.RIGHT_BOTTOM},
                streetViewControlOptions:{position:google.maps.ControlPosition.TOP_LEFT},
                zoomControlOptions: { position: google.maps.ControlPosition.RIGHT_BOTTOM },

            };
           
            //把地圖放在頁面的 div 裡
            var map = new google.maps.Map(document.getElementById('map不在表頭'), mapOptions);
            var newlatlng ;
            newlatlng = document.getElementById("valuex").value + ", " + document.getElementById("valuey").value;           
            map.setCenter(new google.maps.LatLng(document.getElementById("valuex").value, document.getElementById("valuey").value), 13);
            //map.setMapTypeId(document.getElementById("maptext"));
            //map.setMapTypeId(google.maps.MapTypeId.CONSTANT);            
            //宣告地圖標記選項
            var markerOptions = {
                //地圖標記位置
                position: latlng,
                //設定要套用的地圖
                map: map,
                //地圖標記要顯示的文字
                //title: "斗南火車站"
                title: document.getElementById("valuename").value,
                //map不在表頭.value = document.getElementById("valuename").value
                //mapTypeId: document.getElementById("maptext").value,
                //setMapTypeId(document.getElementById("maptext")),          setMapTypeId(MapTypeId)
                
            }

            //把地圖標記標示在地圖上
            //var marker = new google.maps.Marker(map);
            var marker = new google.maps.Marker({
                position: map.center,
                map: map,
                animation: google.maps.Animation.BOUNCE,
                //label: '看',
                title: document.getElementById("valuename").value,
                //icon: 'http://www.oxxostudio.tw/img/articles/201801/google-maps-3-marker-icon.png',
                
            });

            //攔截 map 的 click event
            google.maps.event.addListener(map, 'click', function (event) {
                var location = event.latLng;
                alert(location.lat() + ',' + location.lng() + " 確認後表單的x軸 y軸巳改變,加入名稱可加入資料庫");
                document.getElementById("lat").value = location.lat();
                document.getElementById("lng").value = location.lng();
            });

            //document.getElementById('map不在表頭1').style.visibility = "hidden";
            //document.getElementById('map不在表頭').style.display = "";
           

        }

              //SetMapType(document.getElementById("maptext").value);
        //$("div").("#map不在表頭"){
        //    setmapTypeId: "google.maps.MapTypeId." + typemap;        //}
        function SetMapType() {
            var latlng = new google.maps.LatLng(23.6729, 120.48088);
            var mapOptions = {
                zoom: 15, //地圖縮放的層級
                center: latlng,
                mapTypeId: google.maps.MapTypeId.HYBRID,                            //地圖呈現的方式  document.getElementById("maptext").textContent,  google.maps.MapTypeId.TERRAIN,   ROADMAP：一般的 2D 地圖模式（預設樣式）SATELLITE：衛星空拍圖  HYBRID：衛星空拍圖加上道路、城市名稱等的顯著圖層 TERRAIN：地形圖
                //mapTypeId: google.maps.MapTypeId.HYBRID,
                mapTypeControl: true,
                fullscreenControl: true,
                rotateControl: true,
                scaleControl: true,
                streetViewControl: true,
                zoomControl: true,
                mapTypeControlOptions: { position: google.maps.ControlPosition.TOP_CENTER },
                fullscreenControlOptions: { position: google.maps.ControlPosition.TOP_RIGHT },
                rotateControlOptions: { position: google.maps.ControlPosition.RIGHT_CENTER },
                scaleControlOptions: { position: google.maps.ControlPosition.RIGHT_BOTTOM },
                streetViewControlOptions: { position: google.maps.ControlPosition.TOP_LEFT },
                zoomControlOptions: { position: google.maps.ControlPosition.RIGHT_BOTTOM },
            };

            var map1 = new google.maps.Map(document.getElementById('map不在表頭1'), mapOptions);
            var newlatln2;
            newlatlng2 = document.getElementById("valuex").value + ", " + document.getElementById("valuey").value;
            map1.setCenter(new google.maps.LatLng(document.getElementById("valuex").value, document.getElementById("valuey").value), 13);

            var markerOptions = {
                position: newlatln2,
                map: map1,
                title: document.getElementById("valuename").value,
            }

            //把地圖標記標示在地圖上
            //var marker = new google.maps.Marker(map);
            var marker = new google.maps.Marker({
                position: map1.center,
                map: map1,
                animation: google.maps.Animation.BOUNCE,
                //label: '看',
                title: document.getElementById("valuename").value,
                //icon: 'http://www.oxxostudio.tw/img/articles/201801/google-maps-3-marker-icon.png',

            });

            //攔截 map 的 click event
            google.maps.event.addListener(map, 'click', function (event) {
                var location = map1.event.latLng;
                alert(location.lat() + ',' + location.lng() + " 確認後表單的x軸 y軸巳改變,加入名稱可加入資料庫");
                document.getElementById("lat").value = location.lat();
                document.getElementById("lng").value = location.lng();
            });
            //document.getElementById('map不在表頭').style.visibility = "hidden";
            //document.getElementById('map不在表頭1').style.display = "";

            showmap1();
        }

        function hidemap1() {
            alert("再按上方的下拉選單(另外一個)會再次顯示");
            document.getElementById('map不在表頭1').css(style.height = "0px");
            document.getElementById('map不在表頭1').css(style.display = "none");
            document.getElementById('hidemap1btn').css(style.height = "0px");
            document.getElementById('hidemap1btn').css(style.text = "顯示地圖");

            //document.getElementById('map不在表頭1').style.display = "none";
            //"map不在表頭1"style="width: 600px; height:500px"
            //document.getElementById('map不在表頭1').style.height = "2px"
            //document.getElementById('hidemap1btn').style.display = "none";
            //document.getElementById('hidemap1btn').style.height = "0px";
            //document.getElementById('hidemap1btn').text = "顯示地圖";

        }
        function showmap1() {
            document.getElementById('map不在表頭1').style.display = "";
            document.getElementById('map不在表頭1').style.height = "500px"
            document.getElementById('hidemap1btn').style.display = "";
            document.getElementById('hidemap1btn').style.height = "30px";
            document.getElementById('hidemap1btn').text = "不顯示地圖";
        }


          </script>
         <%--舊版宣告要key:   <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDystbcXoiY4Gdk22iOK_DZe0BoCSaRyk4&callback=initMap"  async defer></script>--%>        <%--<br />--%><%-- <div id="map1_stop"style="width: 300px; height:300px">
                     </div>--%>
         
        <asp:DropDownList ID="mapkind" runat="server" Width="180px" AutoPostBack="True" onChange="SetMapType()" BackColor="#FFFF66" >
                      <asp:ListItem Value="ROADMAP" Selected="True" >顯示衛星空拍加上道路城市名稱等</asp:ListItem>                     
                      <asp:ListItem Value="HYBRID">再一次顯示衛星空拍加上道路城市名稱等</asp:ListItem>                     
                 </asp:DropDownList>
        <asp:TextBox ID="maptext" runat="server" Width="50px" Visible="False">google.maps.MapTypeId.HYBRID</asp:TextBox>
          &nbsp;

        <span class="style1">

        <span class="auto-style1"><span class="auto-style9">

         <span class="auto-style2">

        <span class="auto-style10"><span class="auto-style4">

              <asp:Button ID="Button93" runat="server" Height="28px" Text="顯式主表格" Width="119px" BackColor="Maroon" Font-Names="標楷體" Font-Size="Medium" ForeColor="White" Visible="True" />
       
         &nbsp;</span></span></span></span></span><span class="auto-style9"><span class="auto-style10"><span class="auto-style4"><span class="auto-style5"><span class="auto-style1">(刪除主鍵:</span></span><span class="auto-style2"><span class="auto-style1"><asp:TextBox   runat="server" id="lng0" name="longitude" Width="116px" BackColor="#FF6666" ToolTip="新增不用輸入,刪除才要" CssClass="auto-style6" Height="27px" style="font-size: large">查詢後輸入</asp:TextBox>
  
         <asp:Button ID="Button94" runat="server" BackColor="Maroon" Height="30px" Text="查詢最後序號" Width="108px" ToolTip="查詢出最後一筆資料的刪除序號(識別碼)" CssClass="auto-style5" ForeColor="White" Font-Names="標楷體" Font-Size="Medium" />

         <asp:Button ID="Button91" runat="server" BackColor="Maroon" Height="30px" Text="刪除壹筆" Width="108px" ToolTip="輸入主鍵號碼(最下面有十筆增加後的資料)" CssClass="auto-style5" ForeColor="White" Font-Names="標楷體" Font-Size="Medium" />

         )</span></span></span></span></span></span><br/>
                <asp:Label ID="Label7" runat="server" Text="x軸:"></asp:Label><asp:TextBox    runat="server" id="lat" name="latitude" Width="125px" BackColor="#66FFFF">資料庫的x欄位</asp:TextBox>
               +<asp:Label ID="Label8" runat="server" Text="y軸:"></asp:Label><asp:TextBox   runat="server" id="lng" name="longitude" Width="125px" BackColor="#66FFFF">資料庫的y欄位</asp:TextBox>
  
         +<%-- &nbsp;<input list="inputmap" />--%><%-- <datalist id ="mapkind">
            
             <option value="一般的2D地圖模式"></option>
             <option value="衛星空拍圖"></option>
             <option value="衛星空拍加上道路城市名稱等"></option>
            <option value="地形圖"></option>
         </datalist>--%><%-- <asp:Label ID="Label5" runat="server" Text="x軸:"></asp:Label>
&nbsp;<asp:TextBox ID="lat1" runat="server"></asp:TextBox>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
         <asp:Label ID="Label6" runat="server" Text="y軸:"></asp:Label>
         <asp:TextBox ID="lng1" runat="server"></asp:TextBox>--%><%--<br/>--%><%--   <input type="radio" name ="mapkind1" value="一般的2D地圖模式" checked="checked"/>一般的2D地圖模式          
        <input type="radio" name ="mapkind2" value="衛星空拍圖"  />衛星空拍圖
         <input type="radio" name ="mapkind3" value="衛星空拍加上道路城市名稱等"  />衛星空拍加上道路城市名稱等
         <input type="radio" name ="mapkind4" value="地形圖"  />地形圖--%>景點:<asp:TextBox   runat="server" id="Titles2" name="Titles" BackColor="#66FFFF" ToolTip="空白會顯示全部落title搜尋" TextMode="MultiLine" Width="145px" Height="40px">景點名稱</asp:TextBox>
             +地址:<asp:TextBox   runat="server" id="Description2" name="Description" BackColor="#66FFFF" ToolTip="空白會顯示全部落title搜尋" TextMode="MultiLine" Width="224px">景點的地址</asp:TextBox>

         <span class="auto-style1"><span class="style1"><span class="auto-style2"><span class="auto-style9">

         <span class="auto-style10"><span class="auto-style4">=&gt;<asp:Button ID="Button83" runat="server" BackColor="#000099" Height="30px" Text="增加到資料庫" Width="117px" ToolTip="點地圖產生x軸 y軸 景點名稱 景點地址,插入主鍵不用輸入會自動產生,上方的資料須按個查詢,否則無法獲取分頁資料" CssClass="auto-style5" ForeColor="White" Font-Names="標楷體" Font-Size="Medium" />

         </span></span></span></span></span></span>
         
                    <br/>
                     <div  class="leftaddmg container-fluid float-left" id="map不在表頭"style="width: 95%; height:50%">                     
                     </div>
         &nbsp;<%--<asp:Button ID="hidemap1btn" runat="server" Text="隱藏下方地圖" onclick="hidemap1"/>--%>
         <button id="hidemap1btn" onclick="hidemap1()">隱藏下方地圖</button> <button id="nowaddress" onclick="initMapnowaddress()">現在位置</button><button id="nowaddress1" onclick="getLocation()">現在位置2</button>

                     <div  class="leftaddmg container-fluid float-left" id="map不在表頭1"style="width: 95%; height:50%">  </div>

         <%--function processFormData() {
  const form = document.forms['form'];    // 取得 name 屬性為 form 的表單
  const name = form.elements.name.value;  // 取得 elements 集合中 name 屬性為 name 的值
  const email = form.elements.email.value;// 取得 elements 集合中 name 屬性為 email 的值
  alert("你的姓名是 " + name + "\n電子郵件是 " + email);
}--%><%--   <input type="text" id="iconUrl" value="http://api.tgos.tw/TGOSMAPAPI/images/marker.png"size="80"/>
                  <br>
              //標題:
                  <input type="text" id="title" value="標記一"size="20"/>
                      //Marker大小:
              <input type="text" id="SizeW"value="33" size="1"/>
                             <input type="text" id="SizeH" value="33"size="1"/>px<br>
                                 //Marker位移:
              <input type="text" id="anchorX"value="16" size="1"/>px *
                             <input type="text" id="anchorY" value="33"size="1"/>px<br>
                  <input type="checkbox" id="shadow"/>是否移除陰影
                  <input type="checkbox" id="draggable" />是否可以拖曳<br>
                  <input type="button" value="加入標記點"onclick="AddMarker();"/>
                             <input type="button" value="清除所有標記點" onclick="RmvMarker();"/>--%>
  <br />
         <br />
            Title:
             <asp:TextBox   runat="server" id="Titles" name="Titles" BackColor="#66FFFF" ToolTip="空白會顯示全部落title搜尋">景點名稱</asp:TextBox>
             &nbsp;+  Description:
             <asp:TextBox   runat="server" id="Description" name="Description" BackColor="#66FFFF" ToolTip="空白會顯示全部落title搜尋">備用說明欄位</asp:TextBox>

            <br />
            <asp:Button ID="Button1" runat="server" Text="加到資料庫" OnClick="Button1_Click" BackColor="Maroon" Font-Names="標楷體" Font-Size="X-Large" ForeColor="White" Width="148px" Height="35px" ToolTip="藍底的文字方塊共四個要輸入是資料庫的欄位,座標可以點擊位置輸入"/>
           
      
         &nbsp;<span class="auto-style2"><asp:Button ID="Button3" runat="server" Height="35px" Text="title搜尋" 

            Width="153px"  ToolTip="以title description的資料來找,請再上方的title或descriptio輸入相以查詢的文字" BackColor="#000066" Font-Size="X-Large" ForeColor="White" />
             </span>  
            
      
         <br/>

          <asp:GridView ID="GridView1" runat="server"  AllowPaging="True" AllowSorting="True" CellPadding="4" ForeColor="#333333" GridLines="None" AutoGenerateColumns="False" DataKeyNames="id" DataSourceID="SqlDataSource1" ToolTip="去看圖會連動顯示地圖,並可新增修改資料,最後建檔的資料顯示在最前面">
                          <AlternatingRowStyle BackColor="White" />
                          <Columns>
                              <asp:CommandField SelectText="去看圖" ShowDeleteButton="True" ShowEditButton="True" ShowSelectButton="True" />
                              <asp:BoundField DataField="id" HeaderText="編號" InsertVisible="False" ReadOnly="True" SortExpression="id" />
                              <asp:BoundField DataField="lat" HeaderText="X軸" SortExpression="lat" />
                              <asp:BoundField DataField="lng" HeaderText="Y軸" SortExpression="lng" />
                              <asp:BoundField DataField="Description" HeaderText="Description" SortExpression="Description" />
                              <asp:BoundField DataField="Titles" HeaderText="Titles" SortExpression="Titles" />
                          </Columns>
                          <FooterStyle BackColor="#990000" Font-Bold="True" ForeColor="White" />
                          <HeaderStyle BackColor="#990000" Font-Bold="True" ForeColor="White" />
                          <PagerSettings Mode="NumericFirstLast" FirstPageImageUrl="~/image/最左.JPG" LastPageImageUrl="~/image/最右.JPG " NextPageImageUrl="~/image/右.JPG" PreviousPageImageUrl="~/image/左.JPG" />
                          <PagerStyle BackColor="#FFCC66" ForeColor="#333333" HorizontalAlign="Center" />
                        
                          
                        
                          <PagerTemplate>
                              <asp:Label ID="Label11" runat="server" Text="請選擇頁數:"></asp:Label>
                              <asp:DropDownList ID="DropDownListone" runat="server" AutoPostBack="True" OnSelectedIndexChanged="DropDownListone_SelectedIndexChanged">
                              </asp:DropDownList>
                              <asp:Label ID="Labelpage" runat="server" Text="頁"></asp:Label>
                              <br />  
                          </PagerTemplate>
                          <RowStyle BackColor="#FFFBD6" ForeColor="#333333" />
                          <SelectedRowStyle BackColor="#FFCC66" Font-Bold="True" ForeColor="Navy" />
                          <SortedAscendingCellStyle BackColor="#FDF5AC" />
                          <SortedAscendingHeaderStyle BackColor="#4D0000" />
                          <SortedDescendingCellStyle BackColor="#FCF6C0" />
                          <SortedDescendingHeaderStyle BackColor="#820000" />       
                      </asp:GridView>   
          <br/>
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
            ConflictDetection="CompareAllValues" 
            ConnectionString="<%$ ConnectionStrings:pokomonConnectionString %>" 
            DeleteCommand="DELETE FROM [Google map info] WHERE [id] = @original_id AND (([lat] = @original_lat) OR ([lat] IS NULL AND @original_lat IS NULL)) AND (([lng] = @original_lng) OR ([lng] IS NULL AND @original_lng IS NULL)) AND (([Description] = @original_Description) OR ([Description] IS NULL AND @original_Description IS NULL)) AND (([Titles] = @original_Titles) OR ([Titles] IS NULL AND @original_Titles IS NULL))" 
            InsertCommand="INSERT INTO [Google map info] ([lat], [lng], [Description], [Titles]) VALUES (@lat, @lng, @Description, @Titles)" 
            OldValuesParameterFormatString="original_{0}" 
            SelectCommand="SELECT * FROM [Google map info] ORDER BY [id] DESC" 
            UpdateCommand="UPDATE [Google map info] SET [lat] = @lat, [lng] = @lng, [Description] = @Description, [Titles] = @Titles WHERE [id] = @original_id AND (([lat] = @original_lat) OR ([lat] IS NULL AND @original_lat IS NULL)) AND (([lng] = @original_lng) OR ([lng] IS NULL AND @original_lng IS NULL)) AND (([Description] = @original_Description) OR ([Description] IS NULL AND @original_Description IS NULL)) AND (([Titles] = @original_Titles) OR ([Titles] IS NULL AND @original_Titles IS NULL))">
            <DeleteParameters>
                <asp:Parameter Name="original_id" Type="Int32" />
                <asp:Parameter Name="original_lat" Type="String" />
                <asp:Parameter Name="original_lng" Type="String" />
                <asp:Parameter Name="original_Description" Type="String" />
                <asp:Parameter Name="original_Titles" Type="String" />
            </DeleteParameters>
            <InsertParameters>
                <asp:Parameter Name="lat" Type="String" />
                <asp:Parameter Name="lng" Type="String" />
                <asp:Parameter Name="Description" Type="String" />
                <asp:Parameter Name="Titles" Type="String" />
            </InsertParameters>
            <UpdateParameters>
                <asp:Parameter Name="lat" Type="String" />
                <asp:Parameter Name="lng" Type="String" />
                <asp:Parameter Name="Description" Type="String" />
                <asp:Parameter Name="Titles" Type="String" />
                <asp:Parameter Name="original_id" Type="Int32" />
                <asp:Parameter Name="original_lat" Type="String" />
                <asp:Parameter Name="original_lng" Type="String" />
                <asp:Parameter Name="original_Description" Type="String" />
                <asp:Parameter Name="original_Titles" Type="String" />
            </UpdateParameters>
        </asp:SqlDataSource>
          <span class="style1"><span class="auto-style2"><span class="auto-style4"><span class="auto-style1"><span class="auto-style9">
                    <asp:SqlDataSource ID="SqlDataSource3" runat="server" ConnectionString="<%$ ConnectionStrings:pokomonConnectionString %>" SelectCommand="SELECT DISTINCT LEFT (name1, 1) AS name FROM textmsg ORDER BY name"></asp:SqlDataSource>
                    </span>
         </span></span></span></span>
       <br />
              <asp:Label ID="Label9" runat="server" Text="刪除可看此序號(刪除序號是識別碼)" CssClass="auto-style7"></asp:Label>              
         <asp:GridView ID="GridView15" runat="server" Font-Size="Medium" BackColor="White" BorderColor="#999999" BorderStyle="Solid" BorderWidth="1px" CellPadding="3" ForeColor="Black" GridLines="Vertical" PageSize="3">
              <AlternatingRowStyle BackColor="#CCCCCC" />
              <FooterStyle BackColor="#CCCCCC" />
              <HeaderStyle BackColor="Black" Font-Bold="True" ForeColor="White" />
              <PagerSettings FirstPageImageUrl="~/image/最左.JPG" LastPageImageUrl="~/image/最右.JPG " NextPageImageUrl="~/image/右.JPG" PreviousPageImageUrl="~/image/左.JPG" />
                          <PagerStyle BackColor="#999999" ForeColor="Black" HorizontalAlign="Center" />
              <SelectedRowStyle BackColor="#000099" Font-Bold="True" ForeColor="White" />
              <SortedAscendingCellStyle BackColor="#F1F1F1" />
              <SortedAscendingHeaderStyle BackColor="#808080" />
              <SortedDescendingCellStyle BackColor="#CAC9C9" />
              <SortedDescendingHeaderStyle BackColor="#383838" />
         </asp:GridView>
          <br />
         <asp:Label ID="Label5" runat="server" Text="編輯或刪除用,上面新增此地不會顯示須重新整理才會更新" CssClass="auto-style8"></asp:Label>              
         <asp:GridView ID="GridView16" runat="server" AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False" CellPadding="4" DataKeyNames="識別碼" DataSourceID="SqlDataSource4" Font-Names="標楷體" Font-Size="Large" ForeColor="#333333" GridLines="None" PageSize="5">
             <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
             <Columns>
                 <asp:TemplateField ShowHeader="False">
                     <EditItemTemplate>
                         <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="True" CommandName="Update" Text="更新"></asp:LinkButton>
                         &nbsp;<asp:LinkButton ID="LinkButton2" runat="server" CausesValidation="False" CommandName="Cancel" Text="取消"></asp:LinkButton>
                     </EditItemTemplate>
                     <ItemTemplate>
                         <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="False" CommandName="Edit" Text="編輯"></asp:LinkButton>
                         &nbsp;<asp:LinkButton ID="LinkButton2" runat="server" CausesValidation="False" CommandName="Select" Text="選取"></asp:LinkButton>
                         &nbsp;<asp:LinkButton ID="LinkButton3" runat="server" CausesValidation="False" CommandName="Delete" Text="刪除" onclientclick="return confirm('再次確認,你要刪除這筆資料嗎?')"></asp:LinkButton>
                     </ItemTemplate>
                 </asp:TemplateField>
                 <asp:BoundField DataField="識別碼" HeaderText="識別碼" InsertVisible="False" ReadOnly="True" SortExpression="識別碼" />
                 <asp:BoundField DataField="name1" HeaderText="景點名稱" SortExpression="name1" />
                 <asp:TemplateField HeaderText="座標" SortExpression="mail1">
                     <EditItemTemplate>
                         <asp:TextBox ID="TextBox1" runat="server" Height="30px" Text='<%# Bind("mail1") %>' Width="300px"></asp:TextBox>
                     </EditItemTemplate>
                     <ItemTemplate>
                         <asp:Label ID="Label1" runat="server" Text='<%# Bind("mail1") %>'></asp:Label>
                     </ItemTemplate>
                 </asp:TemplateField>
                 <asp:BoundField DataField="word1" HeaderText="地址等" SortExpression="word1" />
                 <asp:BoundField DataField="時間戳記" HeaderText="時間戳記" SortExpression="時間戳記" />
                 <asp:BoundField DataField="x軸" HeaderText="x軸" SortExpression="x軸" />
                 <asp:BoundField DataField="y軸" HeaderText="y軸" SortExpression="y軸" />
                 <asp:BoundField DataField="x加y" HeaderText="離所選景點的距離" SortExpression="x加y" />
             </Columns>
             <EditRowStyle BackColor="#999999" />
             <FooterStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
             <HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
             <PagerStyle BackColor="#284775" Font-Names="標楷體" Font-Size="Large" ForeColor="White" HorizontalAlign="Center" />
             <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
             <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
             <SortedAscendingCellStyle BackColor="#E9E7E2" />
             <SortedAscendingHeaderStyle BackColor="#506C8C" />
             <SortedDescendingCellStyle BackColor="#FFFDF8" />
             <SortedDescendingHeaderStyle BackColor="#6F8DAE" />
         </asp:GridView>
         </span>
         <asp:SqlDataSource ID="SqlDataSource4" runat="server" ConnectionString="<%$ ConnectionStrings:pokomonConnectionString %>" DeleteCommand="DELETE FROM [textmsg] WHERE [識別碼] = @識別碼" InsertCommand="INSERT INTO [textmsg] ([name1], [mail1], [word1], [時間戳記], [x軸], [y軸], [x軸距離], [y軸距離], [x軸絶對距離], [y軸絶對距離], [x加y]) VALUES (@name1, @mail1, @word1, @時間戳記, @x軸, @y軸, @x軸距離, @y軸距離, @x軸絶對距離, @y軸絶對距離, @x加y)" SelectCommand="SELECT 識別碼, name1, mail1, word1, 時間戳記, x軸, y軸, x加y FROM textmsg ORDER BY 識別碼 DESC" UpdateCommand="UPDATE [textmsg] SET [name1] = @name1, [mail1] = @mail1, [word1] = @word1, [時間戳記] = @時間戳記, [x軸] = @x軸, [y軸] = @y軸, [x軸距離] = @x軸距離, [y軸距離] = @y軸距離, [x軸絶對距離] = @x軸絶對距離, [y軸絶對距離] = @y軸絶對距離, [x加y] = @x加y WHERE [識別碼] = @識別碼">
             <DeleteParameters>
                 <asp:Parameter Name="識別碼" Type="Int32" />
             </DeleteParameters>
             <InsertParameters>
                 <asp:Parameter Name="name1" Type="String" />
                 <asp:Parameter Name="mail1" Type="String" />
                 <asp:Parameter Name="word1" Type="String" />
                 <asp:Parameter Name="時間戳記" Type="Double" />
                 <asp:Parameter Name="x軸" Type="Double" />
                 <asp:Parameter Name="y軸" Type="Double" />
                 <asp:Parameter Name="x軸距離" Type="Double" />
                 <asp:Parameter Name="y軸距離" Type="Double" />
                 <asp:Parameter Name="x軸絶對距離" Type="Double" />
                 <asp:Parameter Name="y軸絶對距離" Type="Double" />
                 <asp:Parameter Name="x加y" Type="Double" />
             </InsertParameters>
             <UpdateParameters>
                 <asp:Parameter Name="name1" Type="String" />
                 <asp:Parameter Name="mail1" Type="String" />
                 <asp:Parameter Name="word1" Type="String" />
                 <asp:Parameter Name="時間戳記" Type="Double" />
                 <asp:Parameter Name="x軸" Type="Double" />
                 <asp:Parameter Name="y軸" Type="Double" />
                 <asp:Parameter Name="x軸距離" Type="Double" />
                 <asp:Parameter Name="y軸距離" Type="Double" />
                 <asp:Parameter Name="x軸絶對距離" Type="Double" />
                 <asp:Parameter Name="y軸絶對距離" Type="Double" />
                 <asp:Parameter Name="x加y" Type="Double" />
                 <asp:Parameter Name="識別碼" Type="Int32" />
             </UpdateParameters>
         </asp:SqlDataSource>
       
        <br />

    <div>
    </div>
    </form>
     <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/js/bootstrap.min.js" integrity="sha384-smHYKdLADwkXOn1EmN1qk/HfnUcbVRZyYmZ4qpPea6sjB/pTJ0euyQp0Mk8ck+5T" crossorigin="anonymous"></script>
    <script src="Scripts/jquery-3.3.1.js"></script>   
    <script src="Scripts/bootstrap.js"></script>
</body>

</html>
