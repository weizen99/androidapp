<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="fourword.aspx.vb" Inherits="homesomee.fourword"  maintainscrollpositiononpostback="true" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <style>
          
* {
  box-sizing: border-box;
}

                
         </style>
</head>
<html xmlns="http://www.w3.org/1999/xhtml">
<body>
    <form id="form1" runat="server">
        
        <span class="auto-style10">
    
       <asp:menu runat="server" ID="menu1" BackColor="#FFFBD6" DynamicHorizontalOffset="2" Font-Names="標楷體" Font-Size="Large" ForeColor="#990000" Orientation="Horizontal" StaticSubMenuIndent="50px" Font-Underline="True" ToolTip="功能表常更新,以此表為最新資料,先按此表一次再找">
            <DynamicHoverStyle BackColor="#990000" ForeColor="White" />
            <DynamicMenuItemStyle HorizontalPadding="5px" VerticalPadding="10px" />
            <DynamicMenuStyle BackColor="#FFFBD6" />
            <DynamicSelectedStyle BackColor="#FFCC66" />
            <Items>
                 <asp:MenuItem Text=" 切換至 " Value="切換至">
                   
                        <asp:MenuItem Text="DS215_index首頁(加密版)" Value="DS215_index首頁(加密版)" NavigateUrl="https://weizen2965.synology.me/androidapp/index.html"></asp:MenuItem>
                        <asp:MenuItem Text="凡科手機版" Value="凡科手機版" NavigateUrl="https://fi23818394.m.icoc.cc"></asp:MenuItem>                        
                       <asp:MenuItem Text="凡科電腦版" Value="凡科電腦版" NavigateUrl="https://fi23818394.icoc.cc"></asp:MenuItem> 
                         <asp:MenuItem Text="電腦行動版首頁" Value="電腦行動版首頁" NavigateUrl="http://220.134.245.185:8888/androidapp/index.html"></asp:MenuItem> 
                      <asp:MenuItem Text="本機電腦股票首頁" Value="本機電腦股票首頁" NavigateUrl="http://220.134.245.185:8888/fishnew5/poemaccesshistory"></asp:MenuItem> 
                      <asp:MenuItem Text="somee_index首頁" Value="somee_index首頁" NavigateUrl="http://www.sachi.somee.com/index.html"></asp:MenuItem> 
                      <asp:MenuItem Text="到成語查詢eddyweb_somee(第二區)" Value="到成語查詢eddyweb_somee(第二區)" NavigateUrl="http://www.eddyweb.somee.com/fourword.aspx"></asp:MenuItem> 
                   </asp:MenuItem>
                <asp:MenuItem Text=" 成語 " Value="股票">
                   
                        <asp:MenuItem Text="成語(分年級)" Value="成語(分年級)" NavigateUrl="http://www.eddyweb.somee.com/fourword.aspx"></asp:MenuItem>
                        <asp:MenuItem Text="成語(全部題目)" Value="成語(全部題目)" NavigateUrl="http://www.eddyweb.somee.com/fourword1.aspx"></asp:MenuItem>                        
                       <asp:MenuItem Text="成語(存在瀏覽器內)" Value="成語(存在瀏覽器內)" NavigateUrl="http://www.sachi.somee.com/fourword.html"></asp:MenuItem>
                       <asp:MenuItem Text="瀏覽器內(全國景點)本機" Value="瀏覽器內(全國景點)本機" NavigateUrl="http://220.134.245.185:8888/androidapp/travel.html"></asp:MenuItem>
                       <asp:MenuItem Text="瀏覽器內(YouBike大台北座標)本機" Value="瀏覽器內(YouBike大台北座標)本機" NavigateUrl="http://220.134.245.185:8888/androidapp/youbike.html"></asp:MenuItem>                    
                       <asp:MenuItem Text="瀏覽器內(全國景點)" Value="瀏覽器內(全國景點)本站備用" NavigateUrl="travel.html"></asp:MenuItem>
                       <asp:MenuItem Text="瀏覽器內(YouBike大台北座標)" Value="瀏覽器內(YouBike大台北座標)本站備用" NavigateUrl="youbike.html"></asp:MenuItem>
                   </asp:MenuItem>
              
                <asp:MenuItem Text=" 景點座標 " Value="景點座標">
                    
                    <asp:MenuItem NavigateUrl="http://www.sachi.somee.com/mapsql1" Text="全國景點座標查詢編輯somee" Value="全國景點座標查詢編輯somee"> </asp:MenuItem>   
                    <asp:MenuItem NavigateUrl="http://220.134.245.185:8888/someepokomap1/mapsql1" Text="本機全國景點座標查詢編輯(會關機)" Value="本機全國景點座標查詢編輯220"> </asp:MenuItem>                 
                     <asp:MenuItem NavigateUrl="http://220.134.245.185:8888/fishnew5/selfpokesql" Text="本機座標(會關機)" Value="本機座標(會關機)"> </asp:MenuItem>
                    <asp:MenuItem NavigateUrl="http://www.sachi.somee.com/websqlpoko.html" Text="座標(存在瀏覽器內)" Value="座標(存在瀏覽器內)"> </asp:MenuItem>
                    <asp:MenuItem NavigateUrl="http://220.134.245.185:8888/someepokomap1/YouBikeTP" Text="本機YouBike大台北座標" Value="YouBike大台北座標"> </asp:MenuItem>
                    <asp:MenuItem NavigateUrl="http://220.134.245.185:8888/someepokomap1/YouBikeTP" Text="somee_YouBike大台北座標" Value="YouBike大台北座標"> </asp:MenuItem>
                </asp:MenuItem>
               
                <asp:MenuItem Text=" 股票自選股建檔 " Value="自選股建檔">
                    
                    <asp:MenuItem NavigateUrl="incomeedit.aspx" Text="自選股編輯" Value="自選股編輯"> </asp:MenuItem>
                     <asp:MenuItem NavigateUrl="http://220.134.245.185:8888/fishnew5/incomeedit" Text="本機自選股編輯(會關機)" Value="本機自選股編輯"> </asp:MenuItem>
                     <asp:MenuItem NavigateUrl="http://220.134.245.185:8888/fishnew5/selfselected" Text="本機自選股內容說明編輯(會關機)" Value="本機自選股內容說明編輯(會關機)"> </asp:MenuItem>
                    <asp:MenuItem NavigateUrl="http://www.sachi.somee.com/index.html" Text="somee首頁(index)" Value="somee首頁(sachi)"> </asp:MenuItem>
                    <asp:MenuItem NavigateUrl="http://www.sachi.somee.com/poemaccess" Text="somee首頁(poemaccess)" Value="somee首頁(poemaccess)"> </asp:MenuItem>
                    <asp:MenuItem NavigateUrl="http://220.134.245.185:8888/androidapp/index.html" Text="本機手機版首頁(220會關機)" Value="本機手機版首頁(220)"> </asp:MenuItem>
                    <asp:MenuItem NavigateUrl="http://220.134.245.185:8888/fishnew5/poemaccesshistory" Text="本機股票首頁(220會關機)" Value="本機股票首頁(220)"> </asp:MenuItem>
                    <asp:MenuItem NavigateUrl="https://fi23818394.m.icoc.cc" Text="凡科手機版" Value="凡科手機版"> </asp:MenuItem>
                    <asp:MenuItem NavigateUrl="http://fi23818394.icoc.cc/" Text="凡科電腦版" Value="凡科電腦版"> </asp:MenuItem>
                </asp:MenuItem>
                <asp:MenuItem Text=" youtube影片區 " Value="youtube影片">
                    
                    <asp:MenuItem NavigateUrl="https://youtu.be/6xG3BBVz8P0" Text="利用excel讀取檔案並上傳到資料庫" Value="利用excel讀取檔案並上傳到資料庫"> </asp:MenuItem>
                    <asp:MenuItem NavigateUrl="https://youtu.be/hU5FeCBCtqA" Text="excel讀取SQL資料庫檔案並以圖形顯示" Value="excel讀取SQL資料庫檔案並以圖形顯示"> </asp:MenuItem>
                    <asp:MenuItem NavigateUrl="https://youtu.be/KBzFUzE0agQ" Text="圖片上傳至SQLServer建檔,網頁內可作單筆上傳或整批上傳並提供簡易的新增及刪除修改" Value="圖片上傳至SQLServer建檔,網頁內可作單筆上傳或整批上傳並提供簡易的新增及刪除修改"> </asp:MenuItem>
                    <asp:MenuItem NavigateUrl="https://youtu.be/VCyPjXlIouM" Text="使用excel讀取巳下載的15個excel表(也可以寫入)" Value="使用excel讀取巳下載的15個excel表(也可以寫入)"> </asp:MenuItem>
                    <asp:MenuItem NavigateUrl="https://youtu.be/ywOt29Niy5E" Text="把櫃買中心的分價資料也拿來作資料庫" Value="把櫃買中心的分價資料也拿來作資料庫"> </asp:MenuItem>
                    <asp:MenuItem NavigateUrl="https://youtu.be/EdWNpqBC0p8" Text="excel整批刪除空白資料列以利上傳資料" Value="刪除空白資料列"> </asp:MenuItem>
                    <asp:MenuItem NavigateUrl="https://youtu.be/CJp4wYUHsdE" Text="Android App製作" Value="Android App製作"> </asp:MenuItem>
                    <asp:MenuItem NavigateUrl="https://youtu.be/EByR-306tek" Text="蘋果ios App製作" Value="蘋果ios App製作"> </asp:MenuItem>
                    <asp:MenuItem NavigateUrl="https://youtu.be/0XLmquzupys" Text="Excel與Access連動,可快速簡易的進行新增、刪除跟修改" Value="Excel與Access連動,可快速簡易的進行新增、刪除跟修改"> </asp:MenuItem>
                  
                </asp:MenuItem>

                 <asp:MenuItem Text=" youtube實作區 " Value="youtube實作區">
                    
                    <asp:MenuItem NavigateUrl="webyu.aspx" Text="圖片上傳至SQLServer建檔,網頁內可作單筆上傳或整批上傳並提供簡易的新增及刪除修改somee" Value="圖片上傳至SQLServer建檔,網頁內可作單筆上傳或整批上傳並提供簡易的新增及刪除修改somee"> </asp:MenuItem>
                    <asp:MenuItem NavigateUrl="http://220.134.245.185:8888/lookpicture/webyu.aspx" Text="圖片上傳至SQLServer建檔demo檔(會關機)" Value="圖片上傳至SQLServer建檔demo檔(會關機)"> </asp:MenuItem>
                    <asp:MenuItem NavigateUrl="http://220.134.245.185:8888/work/favorites2.aspx" Text="本機圖片上傳至SQLServer建檔進階版(會關機共連號四個)" Value="本機圖片上傳至SQLServer建檔進階版(會關機共四個)"> </asp:MenuItem>
                    <asp:MenuItem NavigateUrl="http://220.134.245.185:8888/fishnew5/stockgodpc1" Text="本機圖片上傳至SQLServer股票進階版(股神)" Value="本機圖片上傳至SQLServer股票進階版(會關機)"> </asp:MenuItem>
                    <asp:MenuItem NavigateUrl="http://220.134.245.185:8888/fishnew5/trend" Text="excel讀取SQL資料庫檔案並以圖形顯示網頁進階(趨勢)" Value="excel讀取SQL資料庫檔案並以圖形顯示(趨勢)"> </asp:MenuItem>
                    <asp:MenuItem NavigateUrl="http://220.134.245.185:8888/webchart/webcatch8" Text="把櫃買中心的分價資料也拿來作資料庫網頁版" Value="把櫃買中心的分價資料也拿來作資料庫網頁版"> </asp:MenuItem>
                    <asp:MenuItem NavigateUrl="http://220.134.245.185:8888/webchart/equity" Text="利用excel讀取檔案並上傳(股權分散表)" Value="利用excel讀取檔案並上傳(股權分散表)"> </asp:MenuItem>
                    
                 </asp:MenuItem>
                <asp:MenuItem Text=" 數據看台灣 " Value="數據看台灣">
                    
                    <asp:MenuItem NavigateUrl="https://water.taiwanstat.com/#reservoir6" Text="台灣水庫即時水情" Value="台灣水庫即時水情"> </asp:MenuItem>
                    <asp:MenuItem NavigateUrl="https://www.taiwanstat.com/realtime/rain/" Text="台灣即時雨量資訊" Value="台灣即時雨量資訊"> </asp:MenuItem>
                    <asp:MenuItem NavigateUrl="https://www.taiwanstat.com/realtime/power/" Text="台灣即時用電資訊" Value="台灣即時用電資訊"> </asp:MenuItem>
                    <asp:MenuItem NavigateUrl="https://www.taiwanstat.com/realtime/pm2.5/" Text="台灣即時 PM2.5" Value="台灣即時 PM2.5"> </asp:MenuItem>
                    <asp:MenuItem NavigateUrl="https://www.taiwanstat.com/realtime/uv/" Text="台灣紫外線指數監測" Value="台灣紫外線指數監測"> </asp:MenuItem>
                    <asp:MenuItem NavigateUrl="https://www.taiwanstat.com/realtime/" Text="用數據看台灣" Value="用數據看台灣"> </asp:MenuItem>
                    <asp:MenuItem NavigateUrl="https://www.taiwanstat.com/global/r/indcmap/#/tw" Text="世界各國減碳承諾地圖" Value="世界各國減碳承諾地圖"> </asp:MenuItem>
                    <asp:MenuItem NavigateUrl="https://www.taiwanstat.com/global/r/travel-safety-guide/" Text="世界旅遊警示圖" Value="世界旅遊警示圖"> </asp:MenuItem>
                    <asp:MenuItem NavigateUrl="https://www.myvideo.net.tw/LiveChannel" Text="myvideo直播" Value="myvideo"> </asp:MenuItem>
                 </asp:MenuItem>


            </Items>
            <StaticHoverStyle BackColor="#990000" ForeColor="White" />
            <StaticMenuItemStyle HorizontalPadding="5px" VerticalPadding="2px" />
            <StaticSelectedStyle BackColor="#FFCC66" />
        </asp:menu>
             </span>
        
        <br />
         <br />

        <span class="style1"><span class="auto-style2"> <span class="auto-style4"> 

        <asp:Button ID="Button88" runat="server" Height="28px" Text="不分頁" Width="100px" BackColor="#003300" Font-Names="標楷體" Font-Size="Medium" ForeColor="White" Visible="True" />

        <asp:Button ID="Button87" runat="server" Height="28px" Text="分頁(15筆)" Width="100px" BackColor="#003300" Font-Names="標楷體" Font-Size="Medium" ForeColor="White" Visible="True" />

        &nbsp;</span></span></span><asp:HyperLink ID="HyperLink1" runat="server" Font-Names="標楷體" Font-Size="X-Large"  Height="16px" Width="149px" NavigateUrl="~/fourword1.aspx">觀看全部題目</asp:HyperLink>
         <br />
         <br/>

         <span class="style1"><span class="auto-style2"><span class="auto-style4"><span class="auto-style10"><span class="auto-style2 btn-default"><asp:DropDownList ID="tablename2" runat="server" 

            Font-Size="Large" Height="30px" Width="125px" BackColor="Yellow" ToolTip="查詢出來後再從右3寫入" style="margin-left: 12px" Font-Names="標楷體">

                   
             <asp:ListItem Selected="True" Value="全部"></asp:ListItem>

                   
            <asp:ListItem Value="1">國小一年級</asp:ListItem>                   
            <asp:ListItem Value="2">國小二年級</asp:ListItem>
             <asp:ListItem Value="3">國小三年級</asp:ListItem>
             <asp:ListItem Value="4">國小四年級</asp:ListItem>
             <asp:ListItem Value="5">國小五年級</asp:ListItem>
             <asp:ListItem Value="6">國小六年級</asp:ListItem>
             <asp:ListItem Value="7">國中</asp:ListItem>
              <asp:ListItem Value="8">成語題庫</asp:ListItem>
    </asp:DropDownList>

                          </span></span></span></span></span><asp:Button ID="Button5" runat="server" BackColor="#990000" Font-Names="標楷體" Font-Size="Large" ForeColor="White" Text="挑年級查詢" Width="111px" ToolTip="可分開挑選,預設全部資料" />
         <span class="style1"><span class="auto-style2"><span class="auto-style4"> <asp:Button ID="Button89" runat="server" Height="28px" Text="隠藏年級(切換)" Width="136px" BackColor="#003300" Font-Names="標楷體" Font-Size="Medium" ForeColor="White" Visible="True" />

         </span></span></span>
         <br />
      
         <br/>
        <asp:GridView ID="GridView2" runat="server" CellPadding="4" EnableModelValidation="True" ForeColor="#333333" GridLines="None" Font-Names="標楷體" Font-Size="X-Large">
            <AlternatingRowStyle BackColor="White" />
            <EditRowStyle BackColor="#7C6F57" />
            <FooterStyle BackColor="#1C5E55" Font-Bold="True" ForeColor="White" />
            <HeaderStyle BackColor="#1C5E55" Font-Bold="True" ForeColor="White" />
            <PagerStyle BackColor="#666666" ForeColor="White" HorizontalAlign="Center" />
            <RowStyle BackColor="#E3EAEB" />
            <SelectedRowStyle BackColor="#C5BBAF" Font-Bold="True" ForeColor="#333333" />
        </asp:GridView>
        <br/>
        <asp:Button ID="Button1" runat="server" Text="一字提示" Font-Names="標楷體" Font-Size="Large" BackColor="#0000CC" ForeColor="White" Width="100px" />
         &nbsp;<asp:Button ID="Button3" runat="server" Text="二字" Font-Names="標楷體" Font-Size="Large" BackColor="#663300" ForeColor="White" Width="50px" />
         &nbsp;<asp:Button ID="Button4" runat="server" Text="三字" Font-Names="標楷體" Font-Size="Large" BackColor="#006600" ForeColor="White" Width="50px" />
        &nbsp;<asp:Button ID="Button2" runat="server" Text="直接解答" Font-Names="標楷體" Font-Size="Large" BackColor="Red" ForeColor="White" Width="100px" />
        <br/>
         <asp:GridView ID="GridView1" runat="server"  AllowPaging="True" CellPadding="4" ForeColor="#333333" GridLines="None" AutoGenerateColumns="False" DataKeyNames="流水序號" DataSourceID="SqlDataSource1" Font-Names="標楷體" Font-Size="Large">
                          <AlternatingRowStyle BackColor="White" />
                          <Columns>
                              <asp:CommandField SelectText="選擇題目" ShowSelectButton="True" />
                              <asp:BoundField DataField="流水序號" HeaderText="流水序號" ReadOnly="True" SortExpression="流水序號" />
                              <asp:BoundField DataField="年級" HeaderText="年級" SortExpression="年級" />
                              <asp:BoundField DataField="成語的解釋" HeaderText="成語的解釋" SortExpression="成語的解釋" />
                          </Columns>
                          <FooterStyle BackColor="#990000" Font-Bold="True" ForeColor="White" />
                          <HeaderStyle BackColor="#990000" Font-Bold="True" ForeColor="White" />
                          <PagerSettings Mode="NumericFirstLast" FirstPageImageUrl="~/image/最左.JPG" LastPageImageUrl="~/image/最右.JPG " NextPageImageUrl="~/image/右.JPG" PreviousPageImageUrl="~/image/左.JPG" />
                          <PagerStyle BackColor="#FFCC66" ForeColor="#333333" HorizontalAlign="Center" />
                        
                          
                        
                          <PagerTemplate>
                              <asp:Label ID="Label11" runat="server" Text="請選擇頁數:"></asp:Label>
                              <asp:DropDownList ID="DropDownListone" runat="server" AutoPostBack="True" OnSelectedIndexChanged="DropDownListone_SelectedIndexChanged">
                              </asp:DropDownList>
                              <asp:Label ID="Labelpage" runat="server" Text="Label"></asp:Label>
                              <br />  
                          </PagerTemplate>
                          <RowStyle BackColor="#FFFBD6" ForeColor="#333333" />
                          <SelectedRowStyle BackColor="#FFCC66" Font-Bold="True" ForeColor="Navy" />
                                                


                      </asp:GridView>
                   
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:newmessageConnectionString %>" ProviderName="<%$ ConnectionStrings:newmessageConnectionString.ProviderName %>" SelectCommand="SELECT 識別碼 as 流水序號, mail1 AS 年級, word1 AS 成語的解釋 FROM guestinfo4"></asp:SqlDataSource>
   




         <br/>
   




    </form>
</body>
</html>
