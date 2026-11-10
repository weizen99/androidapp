<%@ Page Language="C#" AutoEventWireup="true" %>
<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Web.Script.Serialization" %>
<%@ Import Namespace="System.Collections.Generic" %>

<script runat="server">
protected void Page_Load(object sender, EventArgs e)
{
    Response.ContentType = "application/json";
    Response.Charset = "utf-8";

    // 跨域放行
    Response.AddHeader("Access-Control-Allow-Origin", "*");
    Response.AddHeader("Access-Control-Allow-Methods", "POST, GET, OPTIONS");
    Response.AddHeader("Access-Control-Allow-Headers", "Content-Type");
    if (Request.HttpMethod == "OPTIONS") { Response.End(); return; }

    string kw = Request.QueryString["kw"];
    if (string.IsNullOrEmpty(kw))
    {
        Response.Write("[]");
        return;
    }

    kw = kw.Trim();
    string connStr = "Data Source=localhost;Initial Catalog=stockchange;Integrated Security=True;";
    List<Dictionary<string, object>> list = new List<Dictionary<string, object>>();

    try
    {
        using (SqlConnection conn = new SqlConnection(connStr))
        {
            conn.Open();

            // 🌟 智慧判斷：若搜尋詞完全命中主題，開啟「全量無截斷模式 (TOP 2000)」
            string sql;
            bool isExactSession = false;

            // 先檢查是否是精確查詢某個聊天室
            using (SqlCommand checkCmd = new SqlCommand("SELECT COUNT(*) FROM dbo.AI_Studio_ChatLogs WHERE SessionTitle = @t", conn))
            {
                checkCmd.Parameters.Add("@t", SqlDbType.NVarChar).Value = kw;
                int count = (int)checkCmd.ExecuteScalar();
                if (count > 0) isExactSession = true;
            }

            if (isExactSession)
            {
                // 模式 A：主題完整回放 (取消 100 筆限制，上限放寬到 2000，按 MsgIndex 順序排列)
                sql = @"
                    SELECT TOP 2000 
                        SessionTitle, MsgIndex, Role, MsgTime, 
                        MentionedPrograms, ImageUrls, MsgContent,
                        CONVERT(varchar, FileModifyTime, 120) AS FileModifyTime
                    FROM dbo.AI_Studio_ChatLogs
                    WHERE SessionTitle = @kw
                    ORDER BY MsgIndex ASC";
            }
            else
            {
                // 模式 B：一般關鍵字全文檢索 (TOP 200)
                sql = @"
                    SELECT TOP 200 
                        SessionTitle, MsgIndex, Role, MsgTime, 
                        MentionedPrograms, ImageUrls, MsgContent,
                        CONVERT(varchar, FileModifyTime, 120) AS FileModifyTime
                    FROM dbo.AI_Studio_ChatLogs
                    WHERE MentionedPrograms LIKE @kwLike 
                       OR MsgContent LIKE @kwLike 
                       OR SessionTitle LIKE @kwLike
                    ORDER BY FileModifyTime DESC, MsgIndex ASC";
            }

            using (SqlCommand cmd = new SqlCommand(sql, conn))
            {
                if (isExactSession)
                {
                    cmd.Parameters.Add("@kw", SqlDbType.NVarChar).Value = kw;
                }
                else
                {
                    cmd.Parameters.Add("@kwLike", SqlDbType.NVarChar).Value = "%" + kw + "%";
                }

                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    while (dr.Read())
                    {
                        var row = new Dictionary<string, object>();
                        row["SessionTitle"] = dr["SessionTitle"].ToString();
                        row["MsgIndex"] = dr["MsgIndex"];
                        row["Role"] = dr["Role"].ToString();
                        row["MsgTime"] = dr["MsgTime"] != DBNull.Value ? dr["MsgTime"].ToString() : "";
                        row["MentionedPrograms"] = dr["MentionedPrograms"] != DBNull.Value ? dr["MentionedPrograms"].ToString() : "";
                        row["ImageUrls"] = dr["ImageUrls"] != DBNull.Value ? dr["ImageUrls"].ToString() : "";
                        row["MsgContent"] = dr["MsgContent"] != DBNull.Value ? dr["MsgContent"].ToString() : "";
                        row["FileModifyTime"] = dr["FileModifyTime"] != DBNull.Value ? dr["FileModifyTime"].ToString() : "";
                        list.Add(row);
                    }
                }
            }
        }
    }
    catch (Exception ex)
    {
        Response.Write("[]");
        return;
    }

    JavaScriptSerializer js = new JavaScriptSerializer();
    js.MaxJsonLength = int.MaxValue;
    Response.Write(js.Serialize(list));
}
</script>