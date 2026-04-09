<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="gridview_template.aspx.vb" Inherits="excelimport.gridview_template" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>ASP.NET GridView 專業範本</title>
    <!-- 引入 Bootstrap 5 與 DataTables CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.1/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdn.datatables.net/1.11.5/css/dataTables.bootstrap5.min.css" rel="stylesheet" />
    
    <style>
        /* 凍結表頭的樣式 */
        .dataTables_scrollHead { background-color: #343a40 !important; }
        .dataTables_scrollHead th { color: white !important; white-space: nowrap; }
        .table-container { padding: 20px; background: white; border-radius: 10px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
    </style>
</head>
<body class="bg-light">
    <form id="form1" runat="server">
        <div class="container mt-5">
            <div class="table-container">
                <h2 class="mb-4">ASP.NET 數據管理 (分頁/凍結/排序/查詢)</h2>
                <asp:GridView ID="GridView1" runat="server"></asp:GridView>
            </div>
        </div>
        
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:favor2ConnectionString %>" ProviderName="<%$ ConnectionStrings:favor2ConnectionString.ProviderName %>" SelectCommand="select top 200 * from stockgod"></asp:SqlDataSource>
        <!-- JS 腳本 -->
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdn.datatables.net/1.11.5/js/jquery.dataTables.min.js"></script>
        <script src="https://cdn.datatables.net/1.11.5/js/dataTables.bootstrap5.min.js"></script>

        <script>
            $(document).ready(function () {
                bindDataTable();
            });

            function bindDataTable() {
                var table = $('#GridView1');
                if (table.find('tr').length > 0) {
                    // 關鍵：如果 GridView 沒有產生 thead，這段會幫忙修正
                    if (table.find('thead').length == 0) {
                        table.prepend($("<thead></thead>").append(table.find("tr:first")));
                    }

                    table.DataTable({
                        "language": { "url": "//cdn.datatables.net/plug-ins/1.11.5/i18n/zh-HANT.json" },
                        "scrollY": "400px",      // 凍結表頭的高度
                        "scrollX": true,         // 水平捲動
                        "scrollCollapse": true,
                        "paging": true,          // 分頁啟動
                        "pageLength": 10,        // 每頁 10 筆
                        "order": [[0, "asc"]],   // 預設排序
                        "searching": true,       // 查詢啟動
                        "destroy": true          // 避免重複初始化
                    });
                }
            }

            // 如果你有使用 UpdatePanel，這段能保證局部刷新後功能不失靈
            if (typeof (Sys) !== 'undefined') {
                var prm = Sys.WebForms.PageRequestManager.getInstance();
                prm.add_endRequest(bindDataTable);
            }
        </script>
    </form>
</body>
</html>


