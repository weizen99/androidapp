Imports System.Web.Services
Imports System.Data
Imports System.Data.SqlClient
Imports System.IO
Imports Newtonsoft.Json
Imports Microsoft.Ajax.Utilities

Public Class DataService
    Inherits System.Web.UI.Page



    ' 接收一般 GET/POST 請求 (處理下載與上傳)
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        Dim action As String = Request.QueryString("action")

        'If action = "download" Then
        '    DownloadExcel(Request.QueryString("sql"), Request.QueryString("db"))
        'ElseIf action = "upload" Then
        '    UploadExcel()
        'End If
    End Sub

    ' AJAX 呼叫：執行 SQL 查詢
    <WebMethod()>
    Public Shared Function ExecuteSQL(sql As String, db As String, pwd As String) As String

        Dim connStr As String = ""
        Select Case db
            Case "stockchangedate"
                connStr = $"Data Source=pc048000110;Initial Catalog=stockchangedate;Integrated Security=True ;User ID=excelsql;Password=pw89133422pw.."
            Case "favor2"
                connStr = $"Data Source=pc048000110;Initial Catalog=favor2;Integrated Security=True ;User ID=excelsql;Password=pw89133422pw.."
            Case "stockchange"
                connStr = $"Data Source=pc048000110;Initial Catalog=stockchange;Integrated Security=True ;User ID=excelsql;Password=pw89133422pw.."
            Case "stockprice"
                connStr = $"Data Source=pc048000110;Initial Catalog=stockprice;Integrated Security=True ;User ID=excelsql;Password=pw89133422pw.."
            Case "stockinfo"
                connStr = $"Data Source=pc048000110;Initial Catalog=stockinfo;Integrated Security=True ;User ID=excelsql;Password=pw89133422pw.."
            Case "work"
                connStr = $"Data Source=pc048000110;Initial Catalog=work;Integrated Security=True ;User ID=excelsql;Password=pw89133422pw.."

            Case "stockchangefour"
                connStr = $"Data Source=pc048000110;Initial Catalog=stockchangefour;Integrated Security=True ;User ID=excelsql;Password=pw89133422pw.."
            Case "fromaccessdatabase"
                connStr = $"Data Source=pc048000110;Initial Catalog=fromaccessdatabase;Integrated Security=True ;User ID=excelsql;Password=pw89133422pw.."
            Case "pokopoko"
                connStr = $"Data Source=pc048000110;Initial Catalog=pokopoko;Integrated Security=True ;User ID=excelsql;Password=pw89133422pw.."
            Case "wordvoice"
                connStr = $"Data Source=pc048000110;Initial Catalog=wordvoice;Integrated Security=True ;User ID=excelsql;Password=pw89133422pw.."
            Case "favor1"
                connStr = $"Data Source=pc048000110;Initial Catalog=favor1;Integrated Security=True ;User ID=excelsql;Password=pw89133422pw.."

            Case Else
                MsgBox("error")
        End Select




        If pwd <> "2157" Then
            MsgBox("密碼錯誤")
            Return "密碼錯誤"

        Else

            Dim forbiddenWords As String() = {"UPDATE", "DELETE", "DROP", "ALTER", "INSERT", "TRUNCATE", "EXEC", "CREATE", "GRANT"}
            sql = "select " + sql
            Dim upperSQL As String = sql.ToUpper()

            For Each word In forbiddenWords
                If upperSQL.Contains(word) Then

                    MsgBox("錯誤：指令包含禁止字詞 " & word)

                    GoTo willstop

                End If
            Next



            Dim dt As New DataTable()

            Try
                Using conn As New SqlConnection(connStr)
                    Dim cmd As New SqlCommand(sql, conn)
                    Dim adapter As New SqlDataAdapter(cmd)
                    conn.Open()
                    adapter.Fill(dt)
                End Using
                ' 將結果轉為 JSON 傳回前端
                Return JsonConvert.SerializeObject(dt)
            Catch ex As Exception
                Return "[{""Error"":""" & ex.Message.Replace("""", "'") & """}]"
            End Try

            ' 建立一個清單來存放處理過的資料
            Dim rows As New List(Of Dictionary(Of String, Object))()

            For Each dr As DataRow In dt.Rows
                Dim row As New Dictionary(Of String, Object)()
                For Each col As DataColumn In dt.Columns
                    Dim cellValue As Object = dr(col)

                    ' 【關鍵修正】檢查這是不是圖片/二進位欄位
                    If Not Convert.IsDBNull(cellValue) AndAlso cellValue.GetType() Is GetType(Byte()) Then
                        ' 將二進位 Byte() 轉為 Base64 字串
                        row.Add(col.ColumnName, Convert.ToBase64String(CType(cellValue, Byte())))
                    Else
                        ' 一般文字直接加入
                        row.Add(col.ColumnName, cellValue)
                    End If
                Next
                rows.Add(row)
            Next

            ' 使用 Newtonsoft.Json 回傳
            Return Newtonsoft.Json.JsonConvert.SerializeObject(rows)






        End If

willstop:
        Return "含禁止字詞"

    End Function

    ' 處理 Excel 下載 (此處建議沿用你原本的 Excel 產生邏輯)
    Private Sub DownloadExcel(sql As String, db As String)
        ' ... 這裡放你原本 Button42 的 NPOI 或 EPPlus 程式碼 ...
        ' 最後用 Response.BinaryWrite 輸出檔案
    End Sub

    ' 處理 Excel 上傳
    Private Sub UploadExcel()
        Dim file As HttpPostedFile = Request.Files(0)
        Dim sheetIdx As String = Request.Form("sheetIdx")
        If file IsNot Nothing Then
            Dim savePath As String = Server.MapPath("~/Uploads/") & file.FileName
            file.SaveAs(savePath)
            ' ... 這裡執行將 Excel 寫入 SQL 的邏輯 ...
            Response.Write("Success")
            Response.End()
        End If
    End Sub



End Class