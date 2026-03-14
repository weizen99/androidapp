<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="hacker1.aspx.vb" Inherits="homesomee.hacker1" maintainscrollpositiononpostback="true"  %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
        <title>hacker</title>
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

        .auto-style2 {
            font-family: 標楷體;
            font-size: large;
            color:blue;
        }
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

        .auto-style4 {
            font-family: 標楷體;
            color: #0000FF;
        }

        </style>
  
</head>
<body>
    <form id="form1" runat="server" enctype="multipart/form-data">
       <br/>   
         <nav class="navbar navbar-expand-lg navbar-dark bg-dark ptest2" > 
                <a class="navbar-brand" href="http://220.134.245.185:8888/work/myherowars.aspx">首頁</a>
                <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent1" aria-controls="navbarSupportedContent1" aria-expanded="false" aria-label="Toggle navigation">
                  <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarSupportedContent1">
                  <ul class="navbar-nav mr-auto">

                    <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle"   id="navbarDropdown20" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                 分享區(sharing area)
                             
                          <div class="dropdown-menu" aria-labelledby="navbarDropdown12">                                                      

                              <a class="dropdown-item " href="https://youtu.be/0goqcGKM6yc">最後一章大魔王(eternal darkness boss)</a>      
                              <a class="dropdown-item " href="https://www.youtube.com/watch?v=AWY7iUHRz-k">Webpage Instructions</a> 
                               <div class="dropdown-divider"></div>                         
                                <a class="dropdown-item " href=""></a>   
                               <a class="dropdown-item " href=""></a>
                               <div class="dropdown-divider"></div> 
                               <a class="dropdown-item" href=""></a> 
                               <a class="dropdown-item" href=""></a>
                               <div class="dropdown-divider"></div>
                              
                                                                                     
                               <div class="dropdown-divider"></div>   
                                                              
                             
                            </div>
                             </li>
                        <div class="collapse navbar-collapse" id="navbarSupportedContent2">
                  <ul class="navbar-nav mr-auto">

                    <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle"   id="navbarDropdown31" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                 對戰區youtube
                                </a>             
                             
                          <div class="dropdown-menu" aria-labelledby="navbarDropdown12">
                             
                              <a class="dropdown-item " href="喀爾隊1youtube.aspx">【喀爾隊(卡星蒙)】K'arkh</a>      
                              <a class="dropdown-item " href="喀爾隊2youtube.aspx">【喀爾.蒙面.約爾根.天宇女,阿斯】K'arkh</a>                                    
                               <div class="dropdown-divider"></div>                         
                                <a class="dropdown-item " href="奧利安隊youtube.aspx">1.【奧利安】+【赫利俄斯】+【多里安】Orion+Helios+Dorian</a>   
                               <a class="dropdown-item " href="奧利安隊ODHyoutube.aspx">2.【奧利安】+【赫利俄斯】+【多里安】Orion+Helios+Dorian</a>
                               <div class="dropdown-divider"></div> 
                               <a class="dropdown-item" href="twinsyoutube.aspx">1.【冰&風隊】twins </a> 
                               <a class="dropdown-item" href="twins2youtube.aspx">2.【冰&風隊】twins </a>
                               <div class="dropdown-divider"></div>
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
                       題庫
                      </a>
                      <div class="dropdown-menu" aria-labelledby="navbarDropdown13">
                     <a class="dropdown-item " href="https://forum.gamer.com.tw/C.php?bsn=38273&snA=150&tnum=24">斯特蘭福德趣味問答題庫中文_巴哈討論區2021年9月</a> 
                     <a class="dropdown-item " href="https://m.facebook.com/nt/screen/?params=%7B%22note_id%22%3A414320156575022%7D&path=%2Fnotes%2Fnote%2F&_rdr">斯特蘭福德趣味問答題庫中文facebook</a> 
                         
                                <div class="dropdown-divider"></div>
                                <a class="dropdown-item " href="https://docs.google.com/spreadsheets/d/14Nl4GFUiVddT-nmHebpKgZNgQVL-on3E7imidsHRnXU/htmlview?pru=AAABeHG-VHs*nPqrXecIqYS0ceNd3L0ZVA#gid=0">斯特蘭福德趣味問答題庫英文</a>   
                                <a class="dropdown-item" href="">建置中(Under Construction)</a>                                                     
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
                                                        <a class="dropdown-item " href="">建置中</a>
                                                        <a class="dropdown-item " href="">建置中</a>
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
                              禮物(gift)
                            </a>
                            <div class="dropdown-menu" aria-labelledby="navbarDropdown14">
                             
                                <a class="dropdown-item" href="https://www.solfors.com/">The Smart Ones</a>
                                <a class="dropdown-item" href="https://alexhw.ru/category/gifts/">Chronicles Of Alex</a>
                                <a class="dropdown-item" href="https://www.peaceful.warriors.solfors.com/?source=web#">Peaceful Warriors</a>
                               <div class="dropdown-divider"></div>  
                                 <div class="btn-group dropright">
                                      <button type="button" class="btn btn-secondary dropdown5-toggle" data-toggle="dropdown5" aria-haspopup="true" aria-expanded="false">
                                       有用的連結(useful links)
                                      </button>
                                      <div class="dropdown5-menu">
                                                        <a class="dropdown-item " href="https://hero-wars.fandom.com/wiki/Special_Events/Calendar">Special Events Calendar</a>
                                                        <a class="dropdown-item " href="https://hwgame.top/events/wb">H.W.Game Events</a>
                                                        <a class="dropdown-item " href="https://www.herowarscentral.com/hero-positions">hero-positions</a>
                                                        <a class="dropdown-item " href="https://community.hero-wars.com/">community.hero</a>
                                                        <a class="dropdown-item " href="https://www.facebook.com/clanwarxyz">Hero Wars - Assistant</a>
                                                       <a class="dropdown-item " href="https://hero-wars.ji7.ru/heroes">hero simulator</a>
                                      </div>
                                    </div>
                                        <div class="dropdown-divider"></div>                  
                               <div class="btn-group dropright">
                                      <button type="button" class="btn btn-secondary dropdown6-toggle" data-toggle="dropdown6" aria-haspopup="true" aria-expanded="false">
                                        Youtuber
                                      </button>
                                      <div class="dropdown6-menu">
                                                     <a class="dropdown-item" href="https://www.youtube.com/channel/UCc8eilSLO498b1Bssb7UsQg">King</a>
                                                     <a class="dropdown-item " href="https://www.youtube.com/channel/UCdmvrAEG8ncJjUQsRzjeD3A">Misty Kathrine</a>
                                                     <a class="dropdown-item " href="">Under Construction</a>
                                                        
                                      </div> 
                                  </div> 
                                     <div class="dropdown-divider"></div>
                                
                                <a class="dropdown-item" href="">以下空白</a>    
                            </div>
                             </li>
                     
                       <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle"   id="navbarDropdown16" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                              page switch
                            </a>
                            <div class="dropdown-menu" aria-labelledby="navbarDropdown16">
                              <a class="dropdown-item " href="http://220.134.245.185:8888/work/myherowars.aspx">Home</a>
                                <div class="dropdown-divider"></div>
                                <a class="dropdown-item " href="http://220.134.245.185:8888/work/webpic5.aspx">Guild Raid</a>   
                                
                                <a class="dropdown-item" href="http://220.134.245.185:8888/work/heroedit.aspx">hero data update</a>
                                <a class="dropdown-item" href="">Under Construction</a>                                
                                <a class="dropdown-item" href="h">Under Construction</a>
                                <div class="dropdown-divider"></div>
                                
                                <a class="dropdown-item" href="https://discord.com/invite/uHKwr3VA">discard</a>
                                <a class="dropdown-item" href="">Under Construction</a>
                                <a class="dropdown-item" href="">Under Construction</a>
                                <div class="dropdown-divider"></div>
                                <a class="dropdown-item" href="">Under Construction</a>
                                <a class="dropdown-item" href="">建置中(Under Construction)</a>
                                <a class="dropdown-item" href="">建置中</a>
                                <a class="dropdown-item" href="">建置中</a>       

                                      <div class="btn-group dropright">
                                      <button type="button" class="btn btn-secondary dropdown5-toggle" data-toggle="dropdown5" aria-haspopup="true" aria-expanded="false">
                                       建置一
                                      </button>
                                      <div class="dropdown5-menu">
                                                        <a class="dropdown-item " href="">建置中</a>
                                                        <a class="dropdown-item " href="">建置中</a>
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
                              Message area
                            </a>
                            <div class="dropdown-menu" aria-labelledby="navbarDropdown14">
                              <a class="dropdown-item " href="message4.aspx">Message</a> 
                                <div class="dropdown-divider"></div>
                                  

                                      <div class="btn-group dropright">
                                      <button type="button" class="btn btn-secondary dropdown5-toggle" data-toggle="dropdown5" aria-haspopup="true" aria-expanded="false">
                                       招生區
                                      </button>
                                      <div class="dropdown5-menu">
                                                        <a class="dropdown-item " href="">建置中</a>
                                                       
                                      </div>
                                    </div>
                                       <div class="dropdown-divider"></div>                   
                               <div class="btn-group dropright">
                                      <button type="button" class="btn btn-secondary dropdown6-toggle" data-toggle="dropdown6" aria-haspopup="true" aria-expanded="false">
                                       影片區
                                      </button>
                                      <div class="dropdown6-menu">
                                                     <a class="dropdown-item" href="">建置中</a>
                                                     <a class="dropdown-item " href="">建置中</a>
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
             <li class="nav-item"><a class="nav-link active auto-style3" href="">首頁</a> </li> 
             <li class="nav-item"><a class="nav-link auto-style3" href="">連結一</a> </li>
             <li class="nav-item"><a class="nav-link auto-style3" href="">連結二</a> </li>
             <li class="nav-item"><a class="nav-link auto-style3" href="">連結三</a> </li>
            <li class="nav-item"><a class="nav-link auto-style3" href="">連結四</a> </li>
          <li class="nav-item"><a class="nav-link auto-style3" href="">連結五</a> </li>
          <li class="nav-item"><a class="nav-link auto-style3" href="">連結六</a> </li>
        <li class="nav-item"><a class="nav-link auto-style3" href="">連結七</a> </li>
          <li class="nav-item"><a class="nav-link auto-style3" href="">連結八</a> </li>
           </ul>     
      <br/>     
        <div>


                2.<asp:FileUpload ID="FileUpload2" runat="server" BackColor="Aqua" ToolTip="アップロードするファイルを選択します (できればすべて JPG ファイル)" />
            <asp:Button ID="Button67" runat="server" BackColor="#00FFCC" Text="1.クリアファイル" Width="101px" ToolTip="把uploadfile資料夾清空" Font-Names="標楷體" Font-Size="12pt" />
            <asp:Button ID="Button66" runat="server" BackColor="#00FFCC" Text="3.ファイルをアップロードする" Width="226px" ToolTip="可上傳多個檔再一起寫到資料庫(發行後抓www內資料夾,測試期間是專案目錄內資料夾)" Font-Names="標楷體" Font-Size="12pt" />
             =&gt;
                <asp:Button ID="修改內容0" runat="server" Text="4.新しいアップロード画像を追加" Width="149px" BackColor="#000066" Font-Names="標楷體" ForeColor="White" Height="28px" ToolTip="1.由上傳至uploadfile的檔案,建檔到資料庫,並將檔案寫到photoro資料夾再顯示最後三筆資料(完成後改自動清除uploadfile資料夾內檔案) 2.以檔案名稱建檔,memo預設為空白,自動判斷副檔名 3.要以你要順序建檔最好是一筆一筆建檔(整批會按檔名)" Font-Size="12pt" />
            
                <asp:Button ID="修改內容2" runat="server" Text="最新の3つの情報" Width="119px" BackColor="#000066" Font-Names="標楷體" ForeColor="White" Height="28px" Font-Size="12pt" ToolTip="只列出最前面的3筆(防止資料量過大),看是否有新增成功,進階查詢請選下方的查詢專區" />
            
         <asp:DropDownList ID="DropDownList5" runat="server" Height="28px" style="margin-bottom: 3px" Width="106px" BackColor="Yellow" Font-Size="12pt" ForeColor="#0000CC" Font-Names="標楷體">
                <asp:ListItem Value="asc">由小至大</asp:ListItem>
                <asp:ListItem Value="desc" Selected="True">由大至小</asp:ListItem>
            </asp:DropDownList>
            
                <asp:Button ID="修改內容3" runat="server" Text="ページを更新" Width="127px" BackColor="#000066" Font-Names="標楷體" ForeColor="White" Height="28px" Font-Size="12pt" ToolTip="重新整理網頁回到原狀態" />
            
                <br />
            <asp:datagrid id="DataGrid1" style="Z-INDEX: 106; LEFT: 24px; "

runat="server" Width="520px" Height="136px" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None">

    <AlternatingItemStyle BackColor="White" />

<Columns>

<asp:BoundColumn DataField="識別碼" HeaderText="識別碼"></asp:BoundColumn>

    <asp:BoundColumn DataField="name1" HeaderText="主旨"></asp:BoundColumn>
    <asp:BoundColumn DataField="mail1" HeaderText="原檔名"></asp:BoundColumn>
    <asp:BoundColumn DataField="memo" HeaderText="備註"></asp:BoundColumn>

<asp:TemplateColumn HeaderText="圖片">

<ItemTemplate>

<asp:Image ID="Photo" Runat="server"></asp:Image>

</ItemTemplate>

<HeaderStyle Width="160px" />

</asp:TemplateColumn>

    <asp:BoundColumn DataField="word1" HeaderText="日期或數字"></asp:BoundColumn>

</Columns>

    <FooterStyle BackColor="#990000" Font-Bold="True" ForeColor="White" />
    <HeaderStyle BackColor="#990000" Font-Bold="True" ForeColor="White" />
    <ItemStyle BackColor="#FFFBD6" ForeColor="#333333" />
    <PagerStyle BackColor="#FFCC66" ForeColor="#333333" HorizontalAlign="Center" />
    <SelectedItemStyle BackColor="#FFCC66" Font-Bold="True" ForeColor="Navy" />

</asp:datagrid>
            
                <br />


    </div>
        
         <div>
        <p>
           
            (2. <asp:FileUpload ID="FileUpload1" runat="server" BackColor="Aqua" ToolTip="上傳檔名為流水號碼 如:1.jpg  5.jpg,請依序編號可按搜尋有圖,查最後一筆的編號" Width="199px" />
            &nbsp;<asp:Button ID="Button68" runat="server" BackColor="#00FFCC" Text="1.清空檔案" Width="101px" ToolTip="把uploadfile2資料夾清空" Font-Names="標楷體" Font-Size="12pt" Visible="False" />
            &nbsp;<asp:Button ID="Button5" runat="server" BackColor="#00FFCC" Text="ローカルファイルを選択してアップロード" Width="350px" Font-Names="標楷體" Font-Size="12pt" ToolTip="請將檔案名稱修改成當筆的檔案識別碼(如:100.jpg 包括副檔名),並在下一列的檔案類型的下拉選單挑選正確的副檔名" />
            )&nbsp;&nbsp;テキスト入力をアップロードする(目的：
            <asp:TextBox ID="name1" runat="server" Height="72px" Width="159px" TextMode="MultiLine" BackColor="#66FF66" ToolTip="下方5.新增及更新文字資料在此輸入(主旨)及上方的4.新增上傳圖片(主旨欄位)">名前を入力(英語を使用してください)</asp:TextBox>
&nbsp;述べる:
            <asp:TextBox ID="memo" runat="server" Height="50px" Width="226px" TextMode="MultiLine" BackColor="#66FF66" ToolTip="下方5.新增及更新文字資料在此輸入(備註)及上方的4.新增上傳圖片先不使用以原檔名建檔)">內容memo</asp:TextBox>
            番号（ソート用）:<asp:TextBox ID="word1" runat="server" Height="24px" Width="93px" BackColor="#66FF66" ToolTip="留言日期:新增同類型檔案但序號但巳不能連號時,可透過此(數字)並把排序欄位改為本欄位內的數字,就能按自己給定的數字大小來依序顯示,上方的4.新增上傳圖片及下方5.新增及更新文字資料(數字欄位)">100</asp:TextBox>
        &nbsp;)&nbsp;原檔名:&nbsp;<asp:TextBox ID="engfilename" runat="server" Height="50px" Width="204px" TextMode="MultiLine" BackColor="#66FF66" ToolTip="下方5.新增及更新文字資料在此輸入(原檔名),目前規劃可輸入英文欄位,直接蓋掉上傳建檔的原檔名成為英文資訊(透過上方uploady建檔時預設為檔案名稱不需使用,修改才要輸入)">アップロードされたファイル名</asp:TextBox>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </p>
        <p>
            &nbsp;5. (&nbsp;起號starting number: <asp:TextBox ID="start" runat="server" Height="28px" Width="59px" BackColor="#FFFF66" ToolTip="識別碼:資料庫主鍵==>新增 更改 刪除的範圍,為區間的起號(如果起號及迄號相同表示只有一筆)">100</asp:TextBox>
        &nbsp;迄號stop number:
            <asp:TextBox ID="end" runat="server" Height="28px" Width="52px" BackColor="#FFFF66" ToolTip="新增 更改 刪除的範圍,為區間的訖號(如果起號及迄號相同表示只有一筆)">100</asp:TextBox>
        &nbsp;<asp:Button ID="新增manyinser" runat="server" Text="整批新增圖片" Width="124px" ToolTip="檔案是流水序號且同未來的主鍵並為jpg類型(如:600.jpg),完成後改自動清除uploadfile2資料夾內檔案" BackColor="Black" ForeColor="White" Font-Names="標楷體" Font-Size="12pt" Height="28px" />
        &nbsp;<asp:Button ID="新增manyupdatesachi" runat="server" Text="整批修改含圖片" Width="144px" BackColor="#990000" ForeColor="White" Font-Names="標楷體" Font-Size="12pt" Height="28px" ToolTip="右側的起迄號要輸入(可單筆或連號),上傳的檔案要與欲更改的檔名一樣包含副檔名(如100.gif),右側的檔案類型要選擇須為上傳檔案的副檔名,文字部份參考整批更新文字說明,會一併更新圖片及文字" />
        &nbsp;<asp:Button ID="整批刪除" runat="server" Text="写真や情報を一括削除する" Width="216px" BackColor="Black" ForeColor="White" Font-Names="標楷體" Font-Size="12pt" Height="28px" ToolTip="輸入左邊圖片起號~圖片訖號(識別碼上的數字),範圍內的資料會被刪除,要在下方的密碼內輸入密碼才能完成刪除,畫面的最上方會出現成功或失敗的訊息" />
        &nbsp;<asp:Button ID="整批更新只文字" runat="server" Text="整批更新只文字(batch update text)" Width="284px" BackColor="Black" ForeColor="White" Font-Names="標楷體" Font-Size="12pt" Height="28px" ToolTip="輸入左邊圖片起號~圖片訖號(識別碼上的數字),範圍內的資料會被更新,更新的資料來源在上方的綠色空格內輸入=>姓名 內容 數字 (當起號跟訖號一樣時係刪除當筆資料)" />
            &nbsp;<asp:Button ID="新增manyupdate" runat="server" Text="整批更新只圖片" Width="144px" BackColor="#990000" ForeColor="White" Font-Names="標楷體" Font-Size="12pt" Height="28px" ToolTip="右側的起迄號要輸入(可單筆或連號),上傳的檔案要與欲更改的檔名一樣包含副檔名(如100.gif),右側的檔案類型要選擇須為上傳檔案的副檔名" />
&nbsp;)<asp:Label ID="Label1" runat="server" BackColor="#0000CC" Font-Names="標楷體" Font-Size="Large" ForeColor="White" Text="檔案類型:"></asp:Label>
            <asp:DropDownList ID="filekind" runat="server" Font-Size="Medium" Height="25px" Width="100px" BackColor="#66FFFF" ToolTip="檔案類型==>左邊更新或新增時所要上傳檔案的副檔名(須一致)">
                <asp:ListItem Selected="True">jpg</asp:ListItem>
                <asp:ListItem>gif</asp:ListItem>
                <asp:ListItem>png</asp:ListItem>
            </asp:DropDownList>
             </p>
        <p>
         
            &nbsp;<asp:Label ID="資料起日" runat="server" Height="20px" Text="開始番号(starting No):" Width="160px"></asp:Label>
            &nbsp;<asp:TextBox ID="起" runat="server" Font-Size="Medium" Height="25px" style="margin-left: 0px" Width="70px" BackColor="#66FFFF">1</asp:TextBox>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <asp:Label ID="迄日" runat="server" Height="20px" Text="終了番号(top No):" Width="133px"></asp:Label>
            <asp:TextBox ID="迄" runat="server" Font-Size="Medium" Height="25px" Width="66px" BackColor="#66FFFF">200000</asp:TextBox>
            &nbsp;&nbsp;(一般查詢範圍請設小一點否則會等很久,相似則範圍大一點否則可能找不到)&nbsp;&nbsp;&nbsp;パスワードpws:&nbsp;<span class="auto-style1"><asp:TextBox ID="TextBox14" runat="server" Height="21px" Width="135px" AccessKey="M" ToolTip="hacker" TextMode="Password" BackColor="#FFFF66"></asp:TextBox>
          </span>&nbsp; <asp:Button ID="整批刪除0" runat="server" Text="備份資料表" Width="111px" BackColor="Black" ForeColor="White" Font-Names="標楷體" Font-Size="12pt" Height="28px" ToolTip="要密碼,預存程式的data table backup,以附加在最後一筆後面,不清除資料 " />
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <br />
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <br />
            &nbsp;查詢欄位:<asp:DropDownList ID="查詢欄位名稱" runat="server" Font-Size="Medium" Height="25px" Width="100px">
                <asp:ListItem Selected="True">識別碼</asp:ListItem>
            </asp:DropDownList>
            &nbsp;排序欄位:<asp:DropDownList ID="排序欄位" runat="server" Font-Size="Medium" Height="25px" Width="100px" BackColor="#66FFFF" ToolTip="搭配word1內的數字大小的不同,可讓顯示的順序按數字大小來排列(下拉選單要先選word1)">
                <asp:ListItem Selected="True">識別碼</asp:ListItem>
                <asp:ListItem>name1</asp:ListItem>
                <asp:ListItem>mail1</asp:ListItem>
                <asp:ListItem>word1</asp:ListItem>
            </asp:DropDownList>
            &nbsp;選別方法(Sort method):&nbsp;&nbsp;<asp:DropDownList ID="DropDownList1" runat="server" Height="30px" style="margin-bottom: 3px" Width="106px" BackColor="#66FFFF">
                <asp:ListItem>由小至大</asp:ListItem>
                <asp:ListItem>由大至小</asp:ListItem>
            </asp:DropDownList>
            <span class="auto-style1"><asp:Button ID="poem1_stock搜尋" 
            runat="server" Height="30px" 
            Text="範囲検索" Width="136px" BackColor="#CC0000" ToolTip="可搭配上方的 資料起日 迄日 排序欄位 排序方法" ForeColor="White" />

        </span>&nbsp;(同様のクエリテキストを入力してください:<asp:TextBox ID="keyword" runat="server" Font-Size="Medium" Height="25px" Width="140px" BackColor="#66FFFF" ToolTip="keyword要查詢的關鍵字,常常後面有很多空鍵未清空(巳自動清除)">英雄hero</asp:TextBox>
            <span class="auto-style2"><asp:Button ID="poem1_stock相似搜尋" runat="server" Height="30px" Text="似た言葉検索" 

            Width="151px" BackColor="#CC0000" ForeColor="#66FFFF" ToolTip="相似字搜尋,在左方查詢文字上輸入關鍵字或按下拉選單選取(自動搜尋資料庫內容來呈現),可搭配上方的 資料起日 迄日 排序欄位 排序方法(限定在起迄日之間的資料,放大區間可查較多資料,縮小區間速度較快並排除不要資料)" />

            &nbsp;)</span>
        
            <br />
          </p>
           
             <span class="auto-style1">
              <asp:Label ID="inputinfo" runat="server" Text="下方為留言的輸入區(上方為該筆留言的全部資料)" CssClass="auto-style4" Visible="False" ToolTip="新增留言輸入區(按自動編號由小而大顯示),最新的資料會出現在最下頁(先跳到最後一頁)"></asp:Label>
            </span>
              <br />
               <br />
            <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" CellPadding="4" EnableModelValidation="True" ForeColor="#333333" GridLines="None" DataKeyNames="識別碼" ToolTip="討論巳可以使用,會在上方顯示該筆留內容,也可以新增 刪除 編輯">
                <AlternatingRowStyle BackColor="White" />
                <Columns>
                    <asp:BoundField DataField="識別碼" HeaderText="識別碼" />
                    <asp:BoundField DataField="name1" HeaderText="主旨" />
                    <asp:BoundField DataField="mail1" HeaderText="原檔名" />
                    <asp:BoundField DataField="memo" HeaderText="備註" />
                    <asp:TemplateField HeaderText="圖片">
                        <EditItemTemplate>
                            <asp:TextBox ID="TextBox1" runat="server" Text='<%# Eval("photo") %>'></asp:TextBox>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Image ID="photo" runat="server" ImageUrl='<%# Eval("photo") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="word1" HeaderText="日期或數字" />
                    <asp:CommandField ShowSelectButton="True" ButtonType="Button" HeaderText="點我討論" SelectText="討論" />
                </Columns>
                <FooterStyle BackColor="#990000" Font-Bold="True" ForeColor="White" />
                <HeaderStyle BackColor="#990000" Font-Bold="True" ForeColor="White" />
                <PagerStyle BackColor="#FFCC66" ForeColor="#333333" HorizontalAlign="Center" />
                <RowStyle BackColor="#FFFBD6" ForeColor="#333333" />
                <SelectedRowStyle BackColor="#FFCC66" Font-Bold="True" ForeColor="Navy" />
            </asp:GridView>
             <br />
             <asp:Label ID="Label2" runat="server" Font-Names="標楷體" Font-Size="Large" ForeColor="#0000CC" Text="修改edit 選取資料select" ToolTip="delete replace select"></asp:Label>
             (也可直接在此處編輯資料,須在相似查詢文字:輸入主旨內容 如:亡靈隊等)<asp:GridView ID="GridView15" runat="server" AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False" BackColor="White" BorderColor="#E7E7FF" BorderStyle="None" BorderWidth="1px" CellPadding="3" GridLines="Horizontal" PageSize="5" ToolTip="以相似查詢內的關鍵字作為查詢的內容,其內容須為主旨欄內可查詢到的資料,並在此更新文字">
                 <AlternatingRowStyle BackColor="#F7F7F7" />
                 <FooterStyle BackColor="#B5C7DE" ForeColor="#4A3C8C" />
                 <HeaderStyle BackColor="#4A3C8C" Font-Bold="True" ForeColor="#F7F7F7" />
                 <PagerStyle BackColor="#E7E7FF" ForeColor="#4A3C8C" HorizontalAlign="Right" />
                 <RowStyle BackColor="#E7E7FF" ForeColor="#4A3C8C" />
                 <SelectedRowStyle BackColor="#738A9C" Font-Bold="True" ForeColor="#F7F7F7" />
             </asp:GridView>
             <br />
          </div>


         <asp:GridView ID="GridView14" runat="server" Visible="False">
        </asp:GridView>














    <%--<script src="Scripts/jquery-3.4.1.js"></script>   
    <script src="Scripts/popper.js"></script>
    <script src="Scripts/bootstrap.js"></script>--%>
      <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/js/bootstrap.min.js" integrity="sha384-smHYKdLADwkXOn1EmN1qk/HfnUcbVRZyYmZ4qpPea6sjB/pTJ0euyQp0Mk8ck+5T" crossorigin="anonymous"></script>
        <br />














        </form>

    </body>
</html>
