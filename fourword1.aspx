<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="fourword1.aspx.vb" Inherits="homesomee.fourword1" maintainscrollpositiononpostback="true"  %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    <style type="text/css">

          
* {
  box-sizing: border-box;
}

                
         </style>
</head>
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
        <asp:Label ID="Label1" runat="server" Font-Names="標楷體" Font-Size="X-Large" ForeColor="#0000CC" Text="favor2留言版:"></asp:Label>
        <br />
        <br />
&nbsp;<asp:Label ID="資料起日" runat="server" Height="20px" Text="資料起日:" Width="108px"></asp:Label>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <asp:TextBox ID="起" runat="server" Height="25px" Width="100px" 
        style="margin-left: 0px" Font-Size="Medium" BackColor="#CCFFFF" ToolTip="用不同的查詢欄位,請搭配不同的資料型態,可參考顯示的資料表">1</asp:TextBox>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <asp:Label ID="迄日" runat="server" Height="20px" Text="迄日:" Width="100px"></asp:Label>
    <asp:TextBox ID="迄" runat="server" Height="25px" Width="100px" Font-Size="Medium" BackColor="#CCFFFF">100000</asp:TextBox>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <br />
    &nbsp;查詢欄位:<asp:DropDownList ID="查詢欄位名稱" runat="server" Font-Size="Medium" 
            Height="25px" Width="100px">
        <asp:ListItem Selected="True">識別碼</asp:ListItem>
            <asp:ListItem>備用</asp:ListItem>
            <asp:ListItem>註解</asp:ListItem>
            <asp:ListItem>程式碼</asp:ListItem>
            <asp:ListItem>日期</asp:ListItem>
    </asp:DropDownList>
&nbsp;排序欄位<asp:DropDownList ID="排序欄位" runat="server" 
            Font-Size="Medium" Height="25px" Width="100px">
        <asp:ListItem Selected="True">識別碼</asp:ListItem>
            <asp:ListItem>備用</asp:ListItem>
            <asp:ListItem>註解</asp:ListItem>
            <asp:ListItem>程式碼</asp:ListItem>
            <asp:ListItem>日期</asp:ListItem>
    </asp:DropDownList>
        &nbsp;排序方法:&nbsp;<asp:DropDownList 
            ID="DropDownList1" runat="server" Height="30px" style="margin-bottom: 3px" 
            Width="106px">
            <asp:ListItem Selected="True">由小至大</asp:ListItem>
            <asp:ListItem>由大至小</asp:ListItem>
        </asp:DropDownList>
        &nbsp;<asp:Button ID="Button2" runat="server" Height="30px" Text="可編輯用搜尋" Width="124px" BackColor="#CCFFFF" ToolTip="配合上方的資料起日及迄日,可控制只列出前二三筆資料,方便增加留言,或利用最下方做輸入" />
        &nbsp;( <asp:Button ID="Button6" runat="server" Height="30px" Text="程式碼複製用搜尋" Width="146px" BackColor="#99CCFF" />
        +<asp:Button ID="Button7" runat="server" Height="30px" Text="隱藏不要欄位" Width="117px" BackColor="#99CCFF" />
        或<asp:Button ID="Button8" runat="server" Height="30px" Text="顯示全部欄位" Width="111px" BackColor="#99CCFF" />
        ) (相似查詢:<asp:TextBox ID="keyword" 
            runat="server" Height="25px" Width="163px" Font-Size="Medium" ToolTip="輸入要查找的關鍵字後再按右邊的搜尋" BackColor="#FFFF99"></asp:TextBox>
        &nbsp;<asp:Button ID="Button5" runat="server" Height="30px" Text="相似字搜尋" 
            Width="89px" BackColor="#FFFF99" />
        )&nbsp;密碼:&nbsp;<span class="auto-style1"><asp:TextBox ID="TextBox14" runat="server" Height="21px" Width="135px" AccessKey="M" ToolTip="刪除要輸入密碼:密碼為 123" TextMode="Password" BackColor="#FFFF99"></asp:TextBox>
          </span><br />
        <br />
        <asp:GridView ID="GridView3" runat="server" CellPadding="4" ForeColor="#333333" GridLines="None" AutoGenerateColumns="False" DataKeyNames="識別碼">
            <AlternatingRowStyle BackColor="White" />
            <Columns>
                <asp:BoundField DataField="識別碼" HeaderText="識別碼" SortExpression="識別碼" />
                <asp:BoundField DataField="name1" HeaderText="備用" SortExpression="name1" />
                <asp:BoundField DataField="mail1" HeaderText="註解" SortExpression="mail1" />
                <asp:BoundField DataField="word1" HeaderText="程式碼" SortExpression="word1" />
                <asp:BoundField DataField="時間戳記" HeaderText="日期" SortExpression="時間戳記" />
            </Columns>
            <FooterStyle BackColor="#990000" Font-Bold="True" ForeColor="White" />
            <HeaderStyle BackColor="#990000" Font-Bold="True" ForeColor="White" />
            <PagerStyle BackColor="#FFCC66" ForeColor="#333333" HorizontalAlign="Center" />
            <RowStyle BackColor="#FFFBD6" ForeColor="#000099" Font-Names="標楷體" />
            <SelectedRowStyle BackColor="#FFCC66" Font-Bold="True" ForeColor="Navy" />
           
        </asp:GridView>
        <br />
        &nbsp;<br />    
                <asp:GridView ID="GridView1" runat="server" CellPadding="4" GridLines="None" AutoGenerateDeleteButton="True" 
            AutoGenerateEditButton="True" DataKeyNames="識別碼" ForeColor="#663300" AutoGenerateSelectButton="True">
            <RowStyle BackColor="#EFF3FB" Font-Names="標楷體" Font-Size="Larger" ForeColor="Red" Width="300px" />
                    <EditRowStyle BackColor="#99FF99" ForeColor="#CC0000" Font-Names="標楷體" Width="600px" />
            <FooterStyle BackColor="#507CD1" ForeColor="White" Font-Bold="True" />
            <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" />
            <SelectedRowStyle BackColor="#00FF99" Font-Bold="True" ForeColor="Red" Height="50px" />
            <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" Font-Names="標楷體" Font-Size="Large" />
            <AlternatingRowStyle BackColor="White" />
                   
        </asp:GridView>
                <asp:GridView ID="GridView2" runat="server" CellPadding="4" GridLines="None" AutoGenerateDeleteButton="True" 
            AutoGenerateEditButton="True" DataKeyNames="識別碼" ForeColor="#333333" AutoGenerateSelectButton="True">
            <RowStyle BackColor="#CCFFFF" Font-Names="標楷體" Font-Size="Larger" ForeColor="Blue" />
                    <EditRowStyle BackColor="#00FF99" ForeColor="#0000CC" />
            <FooterStyle BackColor="#1C5E55" ForeColor="White" Font-Bold="True" />
            <PagerStyle BackColor="#666666" ForeColor="White" HorizontalAlign="Center" />
            <SelectedRowStyle BackColor="#FFCCFF" Font-Bold="True" ForeColor="#0000CC" Height="50px" Width="300px" />
            <HeaderStyle BackColor="#1C5E55" Font-Bold="True" ForeColor="White" Font-Names="標楷體" Font-Size="Large" />
            <AlternatingRowStyle BackColor="White" />
                   
        </asp:GridView>
        <br />
        <br />
        增加留言(一)<br />
        <br />
         姓名:
        <asp:TextBox ID="poemname" runat="server" Width="147px"></asp:TextBox>&nbsp; 
        郵件地址 :
        <asp:TextBox ID="poemmail" runat="server" Width="238px"></asp:TextBox>&nbsp; 時間 :
        <asp:TextBox ID="poemtime" runat="server"></asp:TextBox>
        <br />
        請輸入留言內容:<br />
&nbsp;<asp:TextBox ID="poemcontent" runat="server" Height="110px" TextMode="MultiLine" 
            Width="522px"></asp:TextBox><br />
        &nbsp; &nbsp;
        <asp:Button ID="增加留言" runat="server" Text="增加留言" /><br />
        <br />
        <hr />
        <br />
        <br />
        增加留言(二)<br />
        請由此新增 修改 刪除資料   如:<span class="auto-style4">上面修改後請重新整理網頁才能更新資料</span><asp:ListView ID="ListView1" runat="server" DataKeyNames="識別碼" 
            DataSourceID="AccessDataSource1" InsertItemPosition="LastItem">
            <ItemTemplate>
                <tr style="background-color:#E0FFFF; color: #333333;">
                    <td>
                        <asp:Button ID="EditButton" runat="server" CommandName="Edit" Text="編輯" />
                    </td>
                    <td>
                        <asp:Label ID="識別碼Label" runat="server" Text='<%# Eval("識別碼") %>' />
                    </td>
                    <td>
                        <asp:Label ID="name1Label" runat="server" Text='<%# Eval("name1") %>' />
                    </td>
                    <td>
                        <asp:Label ID="mail1Label" runat="server" Text='<%# Eval("mail1") %>' />
                    </td>
                    <td>
                        <asp:Label ID="word1Label" runat="server" Text='<%# Eval("word1") %>' />
                    </td>
                    <td>
                        <asp:Label ID="時間戳記Label" runat="server" Text='<%# Eval("時間戳記") %>' />
                    </td>
                </tr>
            </ItemTemplate>
            <AlternatingItemTemplate>
                <tr style="background-color:#FFFFFF; color: #284775;">
                    <td>
                        <asp:Button ID="EditButton" runat="server" CommandName="Edit" Text="編輯" />
                    </td>
                    <td>
                        <asp:Label ID="識別碼Label" runat="server" Text='<%# Eval("識別碼") %>' />
                    </td>
                    <td>
                        <asp:Label ID="name1Label" runat="server" Text='<%# Eval("name1") %>' />
                    </td>
                    <td>
                        <asp:Label ID="mail1Label" runat="server" Text='<%# Eval("mail1") %>' />
                    </td>
                    <td>
                        <asp:Label ID="word1Label" runat="server" Text='<%# Eval("word1") %>' />
                    </td>
                    <td>
                        <asp:Label ID="時間戳記Label" runat="server" Text='<%# Eval("時間戳記") %>' />
                    </td>
                </tr>
            </AlternatingItemTemplate>
            <EmptyDataTemplate>
                <table runat="server" 
                    style="background-color: #FFFFFF;border-collapse: collapse;border-color: #999999;border-style:none;border-width:1px;">
                    <tr>
                        <td>
                            未傳回資料。</td>
                    </tr>
                </table>
            </EmptyDataTemplate>
            <InsertItemTemplate>
                <tr style="">
                    <td>
                        <asp:Button ID="InsertButton" runat="server" CommandName="Insert" Text="插入" />
                        <asp:Button ID="CancelButton" runat="server" CommandName="Cancel" Text="清除" />
                    </td>
                    <td>
                        <asp:TextBox ID="識別碼TextBox" runat="server" Text='<%# Bind("識別碼") %>' />
                    </td>
                    <td>
                        <asp:TextBox ID="name1TextBox" runat="server" Text='<%# Bind("name1") %>' />
                    </td>
                    <td>
                        <asp:TextBox ID="mail1TextBox" runat="server" Text='<%# Bind("mail1") %>' />
                    </td>
                    <td>
                        <asp:TextBox ID="word1TextBox" runat="server" Text='<%# Bind("word1") %>' Width="700" />
                    </td>
                    <td>
                        <asp:TextBox ID="時間戳記TextBox" runat="server" Text='<%# Bind("時間戳記") %>' />
                    </td>
                </tr>
            </InsertItemTemplate>
            <LayoutTemplate>
                <table runat="server">
                    <tr runat="server">
                        <td runat="server">
                            <table ID="itemPlaceholderContainer" runat="server" border="1" 
                                style="background-color: #FFFFFF;border-collapse: collapse;border-color: #999999;border-style:none;border-width:1px;font-family: Verdana, Arial, Helvetica, sans-serif;">
                                <tr runat="server" style="background-color:#E0FFFF; color: #333333;">
                                    <th runat="server">
                                    </th>
                                    <th runat="server">
                                        識別碼</th>
                                    <th runat="server">
                                        name1</th>
                                    <th runat="server">
                                        mail1</th>
                                    <th runat="server">
                                        word1</th>
                                    <th runat="server">
                                        時間戳記</th>
                                </tr>
                                <tr ID="itemPlaceholder" runat="server">
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr runat="server">
                        <td runat="server" 
                            style="text-align: center;background-color: #5D7B9D; font-family: Verdana, Arial, Helvetica, sans-serif;color: #FFFFFF;">
                            <asp:DataPager ID="DataPager1" runat="server">
                                <Fields>
                                    <asp:NextPreviousPagerField ButtonType="Button" ShowFirstPageButton="True" 
                                        ShowNextPageButton="False" ShowPreviousPageButton="False" />
                                    <asp:NumericPagerField />
                                    <asp:NextPreviousPagerField ButtonType="Button" ShowLastPageButton="True" 
                                        ShowNextPageButton="False" ShowPreviousPageButton="False" />
                                </Fields>
                            </asp:DataPager>
                        </td>
                    </tr>
                </table>
            </LayoutTemplate>
            <EditItemTemplate>
                <tr style="background-color:#999999;">
                    <td>
                        <asp:Button ID="UpdateButton" runat="server" CommandName="Update" Text="更新" />
                        <asp:Button ID="CancelButton" runat="server" CommandName="Cancel" Text="取消" />
                    </td>
                    <td>
                        <asp:Label ID="識別碼Label1" runat="server" Text='<%# Eval("識別碼") %>' />
                    </td>
                    <td>
                        <asp:TextBox ID="name1TextBox" runat="server" Text='<%# Bind("name1") %>' />
                    </td>
                    <td>
                        <asp:TextBox ID="mail1TextBox" runat="server" Text='<%# Bind("mail1") %>'/>
                    </td>
                    <td>
                        <asp:TextBox ID="word1TextBox" runat="server" Text='<%# Bind("word1") %>' Width="500" />
                    </td>
                    <td>
                        <asp:TextBox ID="時間戳記TextBox" runat="server" Text='<%# Bind("時間戳記") %>' />
                    </td>
                </tr>
            </EditItemTemplate>
            <SelectedItemTemplate>
                <tr style="background-color:#E2DED6; font-weight: bold;color: #333333;">
                    <td>
                        <asp:Button ID="EditButton" runat="server" CommandName="Edit" Text="編輯" />
                    </td>
                    <td>
                        <asp:Label ID="識別碼Label" runat="server" Text='<%# Eval("識別碼") %>' />
                    </td>
                    <td>
                        <asp:Label ID="name1Label" runat="server" Text='<%# Eval("name1") %>' />
                    </td>
                    <td>
                        <asp:Label ID="mail1Label" runat="server" Text='<%# Eval("mail1") %>' />
                    </td>
                    <td>
                        <asp:Label ID="word1Label" runat="server" Text='<%# Eval("word1") %>' />
                    </td>
                    <td>
                        <asp:Label ID="時間戳記Label" runat="server" Text='<%# Eval("時間戳記") %>' />
                    </td>
                </tr>
            </SelectedItemTemplate>
        </asp:ListView>
        <asp:AccessDataSource ID="AccessDataSource1" runat="server" 
            DataFile="D:\DZHosts\LocalUser\eddy\www.eddyweb.somee.com\mdffile\newmessage.mdb" DeleteCommand="DELETE FROM guestinfo3 WHERE (識別碼 = ?)" 
            InsertCommand="INSERT INTO guestinfo3(name1, mail1, word1, 時間戳記) VALUES (?, ?, ?, ?)" 
            SelectCommand="SELECT 識別碼, name1, mail1, word1, 時間戳記 FROM guestinfo3 ORDER BY 識別碼 desc" 
            
            UpdateCommand="UPDATE guestinfo3 SET name1 = ?, mail1 = ?, word1 = ?, 時間戳記 = ? WHERE (識別碼 = ?)">
        </asp:AccessDataSource>
    
        <br />
        <br />
        <br />



   
    </form>
  
</body>
</html>
