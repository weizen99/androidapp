<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="guestinfowd1.aspx.vb" Inherits="homesomee.guestinfowd1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
           <title>留言板1</title>
    <link href="Content/bootstrap.css" rel="stylesheet" />
    <link rel="stylesheet" href="http://code.jquery.com/ui/1.10.4/themes/trontastic/jquery-ui.css"/>
  <script src="http://code.jquery.com/jquery-1.10.2.js"></script>
  <script src="http://code.jquery.com/ui/1.10.4/jquery-ui.js"></script>
  <script type="text/javascript">
      $(function () {
          $.noConflict();    // 让jQuery放弃$变量的控制  不同版本會相沖
          $(".datepickerinput").datepicker({
              dateFormat: "yymmdd"
          });
      });
  </script>

    <style type="text/css">

        .auto-style3 {
            font-family: 標楷體;
            font-size: large;
            color:#800000;
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
        .ptest{color: saddlebrown;font-family: "標楷體", Helvetica, sans-serif;font-size: 20px; }
        .ptest1{color:blue;font-family: "標楷體", Helvetica, sans-serif;font-size: 20px;}
        .ptest2{color: red;font-family: "標楷體", Helvetica, sans-serif;font-size: 20px;}
        .ptest3{color:green;font-family: "標楷體", Helvetica, sans-serif;font-size: 20px;}

            a:link, a:visited {
            border-style: solid;
            border-width: 5px;
            border-color: transparent;
            }
            a:hover {border:3px red;text-decoration:none;}

        </style>
  
</head>
<body>
    <form id="form1" runat="server" enctype="multipart/form-data">
       
        <%--<br/>--%>
        
        <br/>   
         <nav class="navbar navbar-expand-lg navbar-dark bg-dark ptest2" > 
                <a class="navbar-brand" href="">空白首頁</a>
                <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent1" aria-controls="navbarSupportedContent1" aria-expanded="false" aria-label="Toggle navigation">
                  <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarSupportedContent1">
                  <ul class="navbar-nav mr-auto">

                    <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle"   id="navbarDropdown20" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                 &nbsp;&nbsp;對戰區
                                </a>             
                             
                          <div class="dropdown-menu" aria-labelledby="navbarDropdown12">
                              <a class="dropdown-item " href="喀爾隊1.aspx">喀爾隊(卡星蒙)</a>
                                <div class="dropdown-divider"></div>
                                <a class="dropdown-item " href="">建置中</a>   
                                <a class="dropdown-item" href="">建置中</a>                                                     
                                <a class="dropdown-item" href="">建置中</a>                                                        
                                <a class="dropdown-item " href="">建置中</a>
                                <a class="dropdown-item" href="">建置中</a> 
                                <a class="dropdown-item" href="">建置中</a>     
                                                                                     
                               <div class="dropdown-divider"></div>                                     
                             
                            </div>
                             </li>

                    <li class="nav-item dropdown">
                      <a class="nav-link dropdown-toggle"   id="navbarDropdown13" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                        建置中1
                      </a>
                      <div class="dropdown-menu" aria-labelledby="navbarDropdown13">
                       <a class="dropdown-item " href="">建置中</a>
                                <div class="dropdown-divider"></div>
                                <a class="dropdown-item " href="">建置中</a>   
                                <a class="dropdown-item" href="">建置中</a>                                                     
                                <a class="dropdown-item" href="">建置中</a>                                                        
                                <a class="dropdown-item " href="">建置中</a>
                                <a class="dropdown-item" href="">建置中</a> 
                                <a class="dropdown-item" href="">建置中</a>     
                                                                                     
                               <div class="dropdown-divider"></div>       

                                      <div class="btn-group dropright">
                                      <button type="button" class="btn btn-secondary dropdown5-toggle" data-toggle="dropdown5" aria-haspopup="true" aria-expanded="false">
                                       建置一
                                      </button>
                                      <div class="dropdown5-menu">
                                                        <a class="dropdown-item " href="http://220.134.245.185:8888/fishnew5/poem_stock11update.aspx">建置中</a>
                                                        <a class="dropdown-item " href="http://220.134.245.185:8888/fishnew5sql/poem_stock11update9">建置中</a>
                                      </div>
                                    </div>
                                                         
                               <div class="btn-group dropright">
                                      <button type="button" class="btn btn-secondary dropdown6-toggle" data-toggle="dropdown6" aria-haspopup="true" aria-expanded="false">
                                        建置二
                                      </button>
                                      <div class="dropdown6-menu">
                                                     <a class="dropdown-item" href="">建置中</a>
                                                     <a class="dropdown-item " href="">建置中</a>
                                                     <a class="dropdown-item " href="">建置中</a>
                                                        
                                      </div>
                                  </div> 
                                   
                            </div>
                             </li>

                    <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle"   id="navbarDropdown14" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                              建置中2
                            </a>
                            <div class="dropdown-menu" aria-labelledby="navbarDropdown14">
                             
                                <a class="dropdown-item" href="https://ro.tsu299.com/">素質計算機</a>
                                <a class="dropdown-item" href="https://landgris.github.io/ROCalculator/">計算機</a>
                                <a class="dropdown-item" href="https://irowiki.org/wiki/Classes">職業介紹(按右鍵翻譯成中文)</a>
                               <div class="dropdown-divider"></div>  
                                 <div class="btn-group dropright">
                                      <button type="button" class="btn btn-secondary dropdown5-toggle" data-toggle="dropdown5" aria-haspopup="true" aria-expanded="false">
                                       幻想廳
                                      </button>
                                      <div class="dropdown5-menu">
                                                        <a class="dropdown-item " href="https://rd.fharr.com/item_search">道具搜尋</a>
                                                        <a class="dropdown-item " href="https://rd.fharr.com/mob_search.php?txtSearch=%E8%9E%B3&orderby=ID&adesc=ASC&minLevel=1&maxLevel=200&selType=%E5%85%A8%E9%83%A8&selAttr=%E5%85%A8%E9%83%A8&selSize=%E5%85%A8%E9%83%A8">魔物搜尋</a>
                                                        <a class="dropdown-item " href="https://rs.fharr.com/">職業技能模擬器</a>
                                                        <a class="dropdown-item " href="https://rd.fharr.com/itemlist">道具導覽</a>
                                                        <a class="dropdown-item " href="https://rd.fharr.com/moblist">魔物資料表</a>
                                                        <a class="dropdown-item " href="https://rd.fharr.com/world">世界地圖導覽</a>
                                      </div>
                                    </div>
                                        <div class="dropdown-divider"></div>                  
                               <div class="btn-group dropright">
                                      <button type="button" class="btn btn-secondary dropdown6-toggle" data-toggle="dropdown6" aria-haspopup="true" aria-expanded="false">
                                        巴哈
                                      </button>
                                      <div class="dropdown6-menu">
                                                     <a class="dropdown-item" href="https://forum.gamer.com.tw/B.php?bsn=4212&qt=2">巴哈精華區</a>
                                                     <a class="dropdown-item " href="https://forum.gamer.com.tw/B.php?bsn=4212&qt=3">巴哈達人區</a>
                                                     <a class="dropdown-item " href="https://forum.gamer.com.tw/B.php?bsn=4212&subbsn=11">任務副本</a>
                                                        
                                      </div> 
                                  </div> 
                                     <div class="dropdown-divider"></div>
                                
                                <a class="dropdown-item" href="">以下空白</a>    
                            </div>
                             </li>
                     
                       <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle"   id="navbarDropdown16" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                              建置中3
                            </a>
                            <div class="dropdown-menu" aria-labelledby="navbarDropdown16">
                              <a class="dropdown-item " href="http://220.134.245.185:8888/fishnew5/message">卡片查詢</a>
                                <div class="dropdown-divider"></div>
                                <a class="dropdown-item " href="https://ro.gnjoy.com.tw/notice/notice_list.aspx">官網</a>   
                                <a class="dropdown-item" href="https://forum.gamer.com.tw/B.php?bsn=04212">巴哈討論區</a>                                                     
                                <a class="dropdown-item" href="https://member.gnjoy.com.tw/signin.aspx">會員儲值</a>                                                        
                                <a class="dropdown-item " href="https://rd.fharr.com/">幻想廳</a>
                                <a class="dropdown-item" href="http://rowestgirl.blogspot.com/2018/08/RO-Equip-Refine.html">精煉UI介面</a> 
                                <a class="dropdown-item" href="https://forum.gamer.com.tw/C.php?bsn=4212&snA=422520">精煉素材</a>     
                                <a class="dropdown-item" href="https://ro.gnjoy.com.tw/notice/notice_view.aspx?id=3661#tab04">虛幻浮現</a>
                                <a class="dropdown-item" href="https://forum.gamer.com.tw/Co.php?bsn=04212&sn=2277192">RO指令</a>                                
                                <a class="dropdown-item" href="https://ro.ginyuki.com/2018/12/30/post_1583.html">寵物</a>
                                <div class="dropdown-divider"></div>
                                <a class="dropdown-item" href="https://forum.gamer.com.tw/Co.php?bsn=04212&sn=2786207">秒7條件</a>
                                <a class="dropdown-item" href="https://forum.gamer.com.tw/Co.php?bsn=04212&sn=2791896">埃克拉珠 BUFF </a>
                                <a class="dropdown-item" href="http://www.8591.com.tw/mallList-list.html?searchGame=22&searchServer=1778&searchKey=齊爾">8591數字網</a>
                                <a class="dropdown-item" href="https://home.gamer.com.tw/creationDetail.php?sn=3525744">艾克賽利翁套裝</a>
                                <a class="dropdown-item" href="https://forum.gamer.com.tw/C.php?bsn=4212&snA=424078&page=1&gothis=2847660#2847660">攻擊力和防禦力的計算</a>
                                <a class="dropdown-item" href="https://m.gamer.com.tw/forum/Co.php?bsn=4212&snB=2811278">料理、補品統整</a>
                                <div class="dropdown-divider"></div>
                                <a class="dropdown-item" href="https://drive.google.com/drive/folders/1lZQI35vtotPzbAMV5J6-Q5i4_5M5dBh4">修正檔</a>
                                <a class="dropdown-item" href="">建置中</a>
                                <a class="dropdown-item" href="">建置中</a>
                                <a class="dropdown-item" href="">建置中</a>       

                                      <div class="btn-group dropright">
                                      <button type="button" class="btn btn-secondary dropdown5-toggle" data-toggle="dropdown5" aria-haspopup="true" aria-expanded="false">
                                       建置一
                                      </button>
                                      <div class="dropdown5-menu">
                                                        <a class="dropdown-item " href="http://220.134.245.185:8888/fishnew5/poem_stock11update.aspx">建置中</a>
                                                        <a class="dropdown-item " href="http://220.134.245.185:8888/fishnew5sql/poem_stock11update9">建置中</a>
                                      </div>
                                    </div>
                                                         
                               <div class="btn-group dropright">
                                      <button type="button" class="btn btn-secondary dropdown6-toggle" data-toggle="dropdown6" aria-haspopup="true" aria-expanded="false">
                                        建置二
                                      </button>
                                      <div class="dropdown6-menu">
                                                     <a class="dropdown-item" href="">建置中</a>
                                                     <a class="dropdown-item " href="">建置中</a>
                                                     <a class="dropdown-item " href="">建置中</a>
                                                        
                                      </div>
                                  </div> 
                                   
                            </div>
                             </li>
                     <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle"   id="navbarDropdown17 " role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                              留言區
                            </a>
                            <div class="dropdown-menu" aria-labelledby="navbarDropdown14">
                              <a class="dropdown-item " href="message4.aspx">AVA留言板</a> 
                                <div class="dropdown-divider"></div>
                                  

                                      <div class="btn-group dropright">
                                      <button type="button" class="btn btn-secondary dropdown5-toggle" data-toggle="dropdown5" aria-haspopup="true" aria-expanded="false">
                                       招生區
                                      </button>
                                      <div class="dropdown5-menu">
                                                        <a class="dropdown-item " href="https://forum.gamer.com.tw/C.php?page=1&bsn=4212&snA=422502">巴哈招募連結</a>
                                                       
                                      </div>
                                    </div>
                                       <div class="dropdown-divider"></div>                   
                               <div class="btn-group dropright">
                                      <button type="button" class="btn btn-secondary dropdown6-toggle" data-toggle="dropdown6" aria-haspopup="true" aria-expanded="false">
                                       影片區
                                      </button>
                                      <div class="dropdown6-menu">
                                                     <a class="dropdown-item" href="ro影片區.aspx">影片區一</a>
                                                     <a class="dropdown-item " href="ro任務區.aspx">任務區</a>
                                                     <a class="dropdown-item " href="">建置中</a>
                                                        
                                      </div>
                                  </div> 
                                   
                            </div>
                             </li>
                     
                     
                  </ul>
                 
                </div>




              </nav>
      
       <br/>
      <ul class="nav nav-tabs auto-style3">
       <li class="nav-item"><a class="nav-link active auto-style3" href="http://220.134.245.185:8888/Mvc%20web/pricepicking.aspx">MVC首頁</a> </li>            
       <li class="nav-item"><a class="nav-link auto-style3" href="http://220.134.245.185:8888/androidapp/myweb/sidebars/index.html">Sidebars</a> </li>
       <li class="nav-item"><a class="nav-link auto-style3" href="http://220.134.245.185:8888/androidapp/index.html">我的寶可夢首頁</a> </li>
       <li class="nav-item"><a class="nav-link auto-style3" href="https://sites.google.com/view/weizenyan/%E9%A6%96%E9%A0%81">Google_script首頁</a> </li>
      
   </ul>  
   
        <br />
        <asp:Label ID="Label1" runat="server" Font-Names="標楷體" Font-Size="X-Large" ForeColor="#0000CC" Text="網址及音樂查詢:"></asp:Label>
        <br />
      
<asp:Label ID="資料起日" runat="server" Height="20px" Text="資料起日:" Width="74px" Visible="False"></asp:Label>

    &nbsp;<asp:TextBox ID="起" runat="server" Height="25px" Width="80px" 
        style="margin-left: 0px" Font-Size="Medium" BackColor="#CCFFFF" ToolTip="用不同的查詢欄位,請搭配不同的資料型態,可參考顯示的資料表" Visible="False">1</asp:TextBox>
        &nbsp;&nbsp;<asp:Label ID="迄日" runat="server" Height="20px" Text="迄日:" Width="46px" Visible="False"></asp:Label>
    <asp:TextBox ID="迄" runat="server" Height="25px" Width="80px" Font-Size="Medium" BackColor="#CCFFFF" Visible="False">100000</asp:TextBox>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <br />
    <asp:Label ID="Label2" runat="server" Text="查詢欄位:" Visible="False"></asp:Label>
        <asp:DropDownList ID="查詢欄位名稱" runat="server" Font-Size="Medium" 
            Height="25px" Width="100px" Visible="False">
        <asp:ListItem Selected="True">識別碼</asp:ListItem>
            <asp:ListItem>姓名</asp:ListItem>
            <asp:ListItem>郵件</asp:ListItem>
            <asp:ListItem>留言內容</asp:ListItem>
            <asp:ListItem>日期</asp:ListItem>
    </asp:DropDownList>
        <asp:Label ID="Label3" runat="server" Text="排序:" Visible="False"></asp:Label>
        <asp:DropDownList ID="排序欄位" runat="server" 
            Font-Size="Medium" Height="25px" Width="100px" Visible="False">
        <asp:ListItem Selected="True">識別碼</asp:ListItem>
            <asp:ListItem>姓名</asp:ListItem>
            <asp:ListItem>郵件</asp:ListItem>
            <asp:ListItem>留言內容</asp:ListItem>
            <asp:ListItem>日期</asp:ListItem>
    </asp:DropDownList>
        <asp:Label ID="Label4" runat="server" Text="排序:" Font-Names="標楷體"></asp:Label>
        <asp:DropDownList 
            ID="DropDownList1" runat="server" Height="30px" style="margin-bottom: 3px" 
            Width="106px" Font-Names="標楷體">
            <asp:ListItem Value="asc">由小至大</asp:ListItem>
            <asp:ListItem Selected="True" Value="desc">由大至小</asp:ListItem>
        </asp:DropDownList>
        &nbsp;<asp:Button ID="Button2" runat="server" Height="30px" Text="兩欄搜尋" Width="80px" BackColor="Blue" ToolTip="配合上方的資料起日及迄日,可控制只列出前二三筆資料,方便增加留言,或利用最下方做輸入" Font-Names="標楷體" ForeColor="White" />
        &nbsp; <asp:Button ID="Button6" runat="server" Height="30px" Text="五欄位搜尋" Width="92px" BackColor="#CC3300" Font-Names="標楷體" ForeColor="White" />
        <asp:Button ID="Button7" runat="server" Height="30px" Text="隱藏" Width="52px" BackColor="#99CCFF" Visible="False" />
        <asp:Button ID="Button8" runat="server" Height="30px" Text="顯示" Width="53px" BackColor="#99CCFF" Visible="False" />
        <br/> <asp:Label ID="Label5" runat="server" Text="相似查詢:" Visible="False" Font-Names="標楷體"></asp:Label>
        (<asp:TextBox ID="keyword" 
            runat="server" Height="25px" Width="127px" Font-Size="Medium" ToolTip="輸入要查找的關鍵字後再按右邊的搜尋" BackColor="White" Font-Names="標楷體" ForeColor="#660033">上慶</asp:TextBox>
        &nbsp;<asp:Label ID="Label6" runat="server" Text="第一字:" Visible="False" Font-Names="標楷體"></asp:Label>
        
                    <asp:DropDownList ID="mystockname" runat="server" AutoPostBack="True" DataSourceID="SqlDataSource1" DataTextField="name1" DataValueField="name1" ToolTip="選單改變只能改變上方的名稱,請再按名稱查詢再按選取同時攺變名稱及代號" Width="100px" Font-Names="標楷體">
                    </asp:DropDownList>
        <asp:Button ID="Button5" runat="server" Height="30px" Text="關鍵字搜尋" 
            Width="90px" BackColor="#660033" Font-Names="標楷體" ForeColor="White" />      
        
        )&nbsp;&nbsp;<span class="auto-style1"><asp:TextBox ID="TextBox14" runat="server" Height="21px" Width="135px" AccessKey="M" ToolTip="刪除要輸入密碼:密碼為 123" TextMode="Password" BackColor="#FFFF99" Visible="False"></asp:TextBox>
          </span><br /> <br/>
         <asp:HyperLink ID="HyperLink1" runat="server" Font-Names="標楷體" Font-Size="Large">網址</asp:HyperLink>
        <br />
      
      
        <asp:GridView ID="GridView3" runat="server" CellPadding="3" ForeColor="Black" GridLines="Vertical" AutoGenerateColumns="False" DataKeyNames="識別碼" BackColor="White" BorderColor="#999999" BorderStyle="Solid" BorderWidth="1px" >
            <AlternatingRowStyle BackColor="#CCCCCC" />
            <Columns>
                <asp:ButtonField CommandName="Select" Text="網址" />
                <asp:BoundField DataField="識別碼" HeaderText="識別碼" SortExpression="識別碼" />
                <asp:BoundField DataField="name1" HeaderText="名稱" SortExpression="name1" />
                <asp:BoundField DataField="mail1" HeaderText="備註" SortExpression="mail1" />
                <asp:BoundField DataField="word1" HeaderText="網址" SortExpression="word1" />
                <asp:BoundField DataField="時間戳記" HeaderText="日期" SortExpression="時間戳記" />
            </Columns>
            <FooterStyle BackColor="#CCCCCC" />
            <HeaderStyle BackColor="Black" Font-Bold="True" ForeColor="White" />
            <PagerStyle BackColor="#999999" ForeColor="Black" HorizontalAlign="Center" />
            <RowStyle Font-Names="標楷體" />
            <SelectedRowStyle BackColor="#000099" Font-Bold="True" ForeColor="White" />
           
        </asp:GridView>
            
        <br />
       
         <asp:GridView ID="GridView1" runat="server" CellPadding="4" ForeColor="#333333" GridLines="None">
     <AlternatingRowStyle BackColor="White" />
       <Columns>
           <asp:ButtonField CommandName="Select" Text="網址" />
     </Columns>
       <FooterStyle BackColor="#990000" Font-Bold="True" ForeColor="White" />
       <HeaderStyle BackColor="#990000" Font-Bold="True" ForeColor="White" />
       <PagerStyle BackColor="#FFCC66" ForeColor="#333333" HorizontalAlign="Center" />
       <RowStyle Font-Names="標楷體" BackColor="#FFFBD6" ForeColor="#333333" />
       <SelectedRowStyle BackColor="#FFCC66" Font-Bold="True" ForeColor="Navy" />

     <SortedAscendingCellStyle BackColor="#FDF5AC" />
     <SortedAscendingHeaderStyle BackColor="#4D0000" />
     <SortedDescendingCellStyle BackColor="#FCF6C0" />
     <SortedDescendingHeaderStyle BackColor="#820000" />

 </asp:GridView>   
           
        <br />   
        
              <asp:GridView ID="GridView2" runat="server" CellPadding="4" ForeColor="#333333" GridLines="None">
                  <AlternatingRowStyle BackColor="White" />
                    <Columns>
                        <asp:ButtonField CommandName="Select" Text="網址" />
                  </Columns>
                  <EditRowStyle BackColor="#2461BF" />
                    <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                    <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                    <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" />
                    <RowStyle Font-Names="標楷體" BackColor="#EFF3FB" />
                    <SelectedRowStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />

                  <SortedAscendingCellStyle BackColor="#F5F7FB" />
                  <SortedAscendingHeaderStyle BackColor="#6D95E1" />
                  <SortedDescendingCellStyle BackColor="#E9EBEF" />
                  <SortedDescendingHeaderStyle BackColor="#4870BE" />

              </asp:GridView>   
               
        <br />
        <br /><hr>
        <asp:Label ID="Label7" runat="server" BackColor="Red" Font-Names="標楷體" Font-Size="Large" ForeColor="White" Text="新增資料區add message"></asp:Label>
        <br />
        <br />
         名稱(name)&nbsp; :
        <asp:TextBox ID="poemname" runat="server" Width="220px"></asp:TextBox>
        <br/><br/>備註(email) :
        <asp:TextBox ID="poemmail" runat="server" Width="428px"></asp:TextBox><br/><br/>時間(date)&nbsp;&nbsp; :
        <asp:TextBox ID="poemtime" runat="server" Width="118px"></asp:TextBox>
        <br /><br/>
        網址內容(word message content):<br />
<asp:TextBox ID="poemcontent" runat="server" Height="110px" TextMode="MultiLine" 
            Width="522px"></asp:TextBox><br />
        <br/>
        <asp:Button ID="增加留言" runat="server" Text="新增資料(add message)" Width="197px" BackColor="#660066" Font-Names="標楷體" ForeColor="White" /><br />
        
        <hr />
        <br />
        <br />
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:fromaccessdatabaseConnectionString4 %>" SelectCommand="SELECT DISTINCT LEFT (name1, 1) AS name1 FROM guestinfowd1 ORDER BY name1"></asp:SqlDataSource>
        
    
        <br />
        <br />
        <br />



   
    </form>
      <script src="Scripts/jquery-3.4.1.js"></script>   
    <script src="Scripts/popper.js"></script>
    <script src="Scripts/bootstrap.js"></script>
</body>
</html>
