<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="maptest.aspx.vb" Inherits="homesomee.maptest" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>

    </title>
     <link href="Content/bootstrap.css" rel="stylesheet" />
    <style type="text/css">

    
        table {
  border-collapse: collapse;
}

table {
  caption-side: bottom;
  border-collapse: collapse;
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
  box-sizing: border-box;
}

thead,
tbody,
tfoot,
tr,
td,
th {
  border-color: inherit;
  border-style: solid;
  border-width: 0;
}

    </style>
</head>
<body>
    <form id="form1" runat="server">
                 <ul class="nav nav-tabs auto-style1">             
    <li class="nav-item"><a class="nav-link" href="https://emap.pcsc.com.tw/">7-11電子地圖</a> </li>                    
    <li class="nav-item"><a class="nav-link" href="https://www.ibon.com.tw/MOBILE/retail_inquiry.aspx#gsc.tab=0">ibon_電子地圖(區域)</a> </li>  
    <li class="nav-item"><a class="nav-link" href="http://www.hacker1.somee.com/mapsql2">完整版(較多資訊)</a> </li>
    <li class="nav-item"><a class="nav-link" href="http://www.hacker1.somee.com/maptest">完整新地圖</a> </li>
    <li class="nav-item"><a class="nav-link" href="http://www.hacker1.somee.com/guestmsg1.aspx">過渡暫存</a> </li>
    <li class="nav-item"><a class="nav-link" href="http://220.135.3.78:8888/androidapp/index.html">回區城首頁</a> </li>
</ul>
        <br/>
 <asp:HyperLink ID="mylink" runat="server" Target="_blank">Google搜尋連結</asp:HyperLink>


       
&nbsp; 
 <asp:HyperLink ID="mylink1" runat="server" Target="_blank">Google地圖連結</asp:HyperLink>
&nbsp;<asp:Button ID="Button1" runat="server" Text="查詢座標" Visible="False" />
<div>
    緯度: <asp:TextBox ID="txtLat" runat="server" Text="25.0339"></asp:TextBox>
    經度: <asp:TextBox ID="txtLng" runat="server" Text="121.5644"></asp:TextBox>
    <button type="button" onclick="loadMap()">座標位置</button>
</div>
<div id="map" style="height: 500px; width: 94%; margin-top: 10px;"></div>

<script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDystbcXoiY4Gdk22iOK_DZe0BoCSaRyk4&callback&callback=initMap" async defer></script>

<script>
    let map, userMarker, lastManualMarker = null;

    function initMap() {
        const initialPos = { lat: 25.0339, lng: 121.5644 };
        map = new google.maps.Map(document.getElementById('map'), { zoom: 16, center: initialPos });

        // 藍色目前位置標記
        userMarker = new google.maps.Marker({
            position: initialPos, map: map,
            icon: { path: google.maps.SymbolPath.CIRCLE, scale: 8, fillColor: '#4285F4', fillOpacity: 1, strokeColor: 'white', strokeWeight: 2 }
        });


        // 2. 建立「回到目前位置」按鈕 [[1](https://developers.google.com/maps/documentation/javascript/controls)]
        const btn = document.createElement("button");
        btn.textContent = "回到目前位置";
        btn.style.cssText = "margin: 10px; padding: 8px; cursor: pointer; background: white; border: 2px solid #ccc;";
        map.controls[google.maps.ControlPosition.TOP_CENTER].push(btn);

        btn.onclick = () => {
            if (navigator.geolocation) {
                navigator.geolocation.getCurrentPosition((p) => {
                    const pos = { lat: p.coords.latitude, lng: p.coords.longitude };
                    map.panTo(pos);
                    userMarker.setPosition(pos);

                });
           /* }*/
        /*}*/;

        <%--// 1. 紅色目前位置標記
        userMarker = new google.maps.Marker({
            position: initialPos,
            map: map,
            icon: {
                path: google.maps.SymbolPath.CIRCLE,
                scale: 8,
                fillColor: '#FF0000', // 修改為紅色 [[3](https://developers.google.com/maps/documentation/javascript/advanced-markers/basic-customization)]
                fillOpacity: 1,
                strokeColor: 'white',
                strokeWeight: 2
            }
        });

        // 2. 建立「回到目前位置」按鈕
        const btn = document.createElement('button');
        btn.textContent = '回到目前位置';
        btn.style.cssText = 'margin: 10px; padding: 8px; cursor: pointer; background: white; border: 2px solid #ccc;';
        map.controls[google.maps.ControlPosition.TOP_CENTER].push(btn);

        btn.onclick = () => {
            if (navigator.geolocation) {
                navigator.geolocation.getCurrentPosition((p) => {
                    const lat = p.coords.latitude.toFixed(6);
                    const lng = p.coords.longitude.toFixed(6);
                    const pos = { lat: parseFloat(lat), lng: parseFloat(lng) };

                    map.panTo(pos);
                    userMarker.setPosition(pos);

                    // 更新 TextBox 顯示
                    document.getElementById('<%= txtLat.ClientID %>').value = lat;
            document.getElementById('<%= txtLng.ClientID %>').value = lng;

            // 顯示目前位置資訊
            alert(`目前定位座標：\n緯度: ${lat}\n經度: ${lng}`);
        });--%>
    }
};

        // 監聽點擊地圖
        map.addListener("click", (e) => {
            updateMarker(e.latLng);
            alert(`已選取座標：\n緯度: ${e.latLng.lat().toFixed(6)}\n經度: ${e.latLng.lng().toFixed(6)}\n加上名稱及備註並按下下方的"加到資料庫"即可加入資料`);
           
        });

        if (navigator.geolocation) {
            navigator.geolocation.watchPosition((p) => {
                const pos = { lat: p.coords.latitude, lng: p.coords.longitude };
                userMarker.setPosition(pos);
            }, null, { enableHighAccuracy: true });
        }        
    }

    function loadMap() {
        const lat = parseFloat(document.getElementById('<%= txtLat.ClientID %>').value);
        const lng = parseFloat(document.getElementById('<%= txtLng.ClientID %>').value);
        updateMarker(new google.maps.LatLng(lat, lng));
    }

    function updateMarker(latLng) {
        // 1. 清除舊標記 [[2](https://developers.google.com/maps/documentation/javascript/examples/marker-animations)]
        if (lastManualMarker) lastManualMarker.setMap(null);

        // 2. 更新 TextBox
        document.getElementById('<%= txtLat.ClientID %>').value = latLng.lat().toFixed(6);
        document.getElementById('<%= txtLng.ClientID %>').value = latLng.lng().toFixed(6);

        document.getElementById('<%= mylat.ClientID %>').value = latLng.lat().toFixed(6);
        document.getElementById('<%= mylng.ClientID %>').value = latLng.lng().toFixed(6);

        document.getElementById('<%= Titles.ClientID %>').value = "新地點"
        document.getElementById('<%= Description.ClientID %>').value = "新備註"

        // 3. 建立新標記並設置「持續跳動」[[5](https://reintech.io/blog/animating-markers-movements-google-maps)]
        lastManualMarker = new google.maps.Marker({
            position: latLng,
            map: map,
            animation: google.maps.Animation.BOUNCE
        });
        map.panTo(latLng);
    }
</script>

        <br />
        <br />
        <br />
            <asp:Label ID="Label7" runat="server" Text="x軸:"></asp:Label><asp:TextBox    runat="server" id="mylat" name="latitude" Width="125px" BackColor="#66FFFF">資料庫的x欄位</asp:TextBox>
+<asp:Label ID="Label8" runat="server" Text="y軸:"></asp:Label><asp:TextBox   runat="server" id="mylng" name="longitude" Width="125px" BackColor="#66FFFF">資料庫的y欄位</asp:TextBox><br/>
        Title:
    <asp:TextBox   runat="server" id="Titles" name="Titles" BackColor="#66FFFF" ToolTip="空白會顯示全部落title搜尋">景點名稱</asp:TextBox>
    &nbsp;+  Description:
    <asp:TextBox   runat="server" id="Description" name="Description" BackColor="#66FFFF" ToolTip="空白會顯示全部落title搜尋">備用說明欄位</asp:TextBox>

   <%--<br />--%>
   <asp:Button ID="Button2" runat="server" Text="加到資料庫" OnClick="Button1_Click" BackColor="Maroon" Font-Names="標楷體" Font-Size="X-Large" ForeColor="White" Width="148px" Height="35px" ToolTip="藍底的文字方塊共四個要輸入是資料庫的欄位,座標可以點擊位置輸入"/>
  
      
<asp:Button ID="Button3" runat="server" Height="35px" Text="景點搜尋" Width="153px"  ToolTip="以title description的資料來找,請再上方的title或descriptio輸入相以查詢的文字" BackColor="#000066" Font-Size="X-Large" ForeColor="White" />
   
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
          <br />
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



        <link rel="stylesheet" href="https://unpkg.com/leaflet/dist/leaflet.css" />
<link rel="stylesheet" href="https://unpkg.com/leaflet-control-geocoder/dist/Control.Geocoder.css" />

    <link rel="stylesheet" href="https://unpkg.com/leaflet/dist/leaflet.css" />
<link rel="stylesheet" href="https://unpkg.com/leaflet-control-geocoder/dist/Control.Geocoder.css" />
        <asp:Label ID="Label1" runat="server" Text="以名稱來搜尋座標並建檔" ToolTip="座標會連動到上方的x軸y軸,也可輸入景點名稱後加入資料庫" Font-Size="X-Large"></asp:Label>
<div id="map1" style="height: 500px; width: 94%;"></div>
<div>
    緯度: <input type="text" id="lat" /> 經度: <input type="text" id="lng" />
</div>

<script src="https://unpkg.com/leaflet/dist/leaflet.js"></script>
<script src="https://unpkg.com/leaflet-control-geocoder/dist/Control.Geocoder.js"></script>
<script>
    const map1 = L.map('map1').setView([25.0339, 121.5644], 13);
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png').addTo(map1);

    let marker = L.marker([25.0339, 121.5644], { draggable: true }).addTo(map1);



    // 1. 關鍵字搜尋功能 [[1](https://docs.maptiler.com/leaflet/examples/geocoding-control/)]
    const geocoder = L.Control.geocoder({ defaultMarkGeocode: false })
        .on('markgeocode', function (e) {
            const bbox = e.geocode.bbox;
            const center = e.geocode.center;
            updateMarker1(center.lat, center.lng);
            map1.fitBounds(bbox);
        }).addTo(map1);








    // 2. 點擊與拖動更新座標 [[5](https://dev.to/geoapify-maps-api/leaflet-location-picker-with-address-autocomplete-geolocation-and-draggable-pin-with-geoapify-1gfa)]
    map1.on('click', (e) => updateMarker1(e.latlng.lat, e.latlng.lng));
    marker.on('dragend', () => {
        const pos = marker.getLatLng();

        updateMarker1(pos.lat, pos.lng);
    });

    function updateMarker1(lat, lng) {
        marker.setLatLng([lat, lng]);
        document.getElementById('lat').value = lat.toFixed(6);
        document.getElementById('lng').value = lng.toFixed(6);

        document.getElementById('<%= txtLat.ClientID %>').value = lat.toFixed(6);
        document.getElementById('<%= txtLng.ClientID %>').value = lng.toFixed(6);
        document.getElementById('<%= myLat.ClientID %>').value = lat.toFixed(6);
        document.getElementById('<%= myLng.ClientID %>').value = lng.toFixed(6);
        document.getElementById('<%= Titles.ClientID %>').value = "新地點";
        document.getElementById('<%= Description.ClientID %>').value = "新備註";
        alert(`已選取座標：\n緯度: ${lat.toFixed(6)}\n經度: ${lng.toFixed(6) }\n加上名稱及備註並按下上方的"加入資料庫"即可加入資料`);
////////document.getElementById('<%= txtLat.ClientID %>').value = latLng.lat().toFixed(6);
    }
</script>








    </form>
     <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/js/bootstrap.min.js" integrity="sha384-smHYKdLADwkXOn1EmN1qk/HfnUcbVRZyYmZ4qpPea6sjB/pTJ0euyQp0Mk8ck+5T" crossorigin="anonymous"></script>
<script src="Scripts/jquery-3.3.1.js"></script>   
<script src="Scripts/bootstrap.js"></script>
</body>
</html>
