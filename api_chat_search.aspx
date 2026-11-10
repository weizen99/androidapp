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

    string kw = Request.QueryString["kw"];
    if (string.IsNullOrEmpty(kw))
    {
        Response.Write("[]");
        return;
    }

    // 連線目標：本地 stockchange 資料庫
    string connStr = "Data Source=localhost;Initial Catalog=stockchange;Integrated Security=True;";
    List<Dictionary<string, object>> list = new List<Dictionary<string, object>>();

    try
    {
        using (SqlConnection conn = new SqlConnection(connStr))
        {
            conn.Open();
            // 三向極速檢索：標籤、對話正文、主題標題
            string sql = @"
                SELECT TOP 100 
                    SessionTitle, MsgIndex, Role, MsgTime, 
                    MentionedPrograms, ImageUrls, MsgContent,
                    CONVERT(varchar, FileModifyTime, 120) AS FileModifyTime
                FROM dbo.AI_Studio_ChatLogs
                WHERE MentionedPrograms LIKE @kw 
                   OR MsgContent LIKE @kw
                   OR SessionTitle LIKE @kw
                ORDER BY FileModifyTime DESC, MsgIndex ASC";

            using (SqlCommand cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.Add("@kw", SqlDbType.NVarChar).Value = "%" + kw.Trim() + "%";
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
        // 容錯防護：若發生異常回傳空陣列
        Response.Write("[]");
        return;
    }

    JavaScriptSerializer js = new JavaScriptSerializer();
    js.MaxJsonLength = int.MaxValue;
    Response.Write(js.Serialize(list));
}
</script>