<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    import="java.sql.*,java.text.*,juushoroku.MyDBAccess,java.util.Optional,java.util.ArrayList,javax.servlet.http.HttpSession,java.io.*,java.io.UnsupportedEncodingException,java.net.URLEncoder,java.net.URLDecoder"

    %>

<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=width=960,initial-scale=1">
<link rel="stylesheet" media="(max-width: 768px)" href="style-768.css">
<link rel="stylesheet" media="(max-width: 320px)" href="style-320.css">
<title>住所録管理システム</title>
<style type="text/css">@import url(css/main.css);</style>
</head>
<body>
<tr><big><b>住所録管理システム：住所録編集</b></big></tr>

<%



//値の受け取り
String id = request.getParameter("id");
int no = Integer.parseInt(id);
// データベースへのアクセス開始

MyDBAccess db = new MyDBAccess();
db.open();

Connection con = null;
Statement stmt = null;
ResultSet rs = null;

try {
    Class.forName("com.mysql.jdbc.Driver");
	// データベースに接続するConnectionオブジェクトの取得
	con = DriverManager.getConnection(
	    "jdbc:mysql://localhost/juusho_db?characterEncoding=UTF-8&serverTimezone=JST",
	    "root", "");
	//sqlで実行する文
	String sql = "select * from juusho_tbl;";
	// データベース操作を行うためのStatementオブジェクトの取得
	stmt = con.createStatement();
	rs = stmt.executeQuery(sql);

	//DBで目的のデータにカーソルを合わせる
	for(rs.first(); no != rs.getInt("id"); rs.next()){
	}

}catch(Exception  e) {
	//out.println(e.getMessage());
	e.printStackTrace();
}


String name=rs.getString("名前");
String add=rs.getString("住所");
String tel=rs.getString("電話番号");

//確認からエラー受け取り
String e = request.getParameter("e");
String nameE="";
String addE="";
String telE="";
if(e==null)
	e="";
if(e.matches(".*name_kuuhaku.*"))
	nameE = "名前が空白です！";
if(e.matches(".*add_kuuhaku.*"))
	addE = "住所が空白です！";
if(e.matches(".*tel_kuuhaku.*"))
	telE = "電話番号が空白です！";

if(e.matches(".*name_nagai.*"))
	nameE = "名前が長すぎます！";
if(e.matches(".*add_nagai.*"))
	addE = "住所が長すぎます！";
if(e.matches(".*tel_nagai.*"))
	telE = "電話番号が長すぎます！";


///////

if(e!=""){
	name = request.getParameter("nameENCO");
	add = request.getParameter("addENCO");
	tel = request.getParameter("telENCO");
	if(name!=null)
		name = URLDecoder.decode(name, "UTF-8");
	if(add!=null)
		add = URLDecoder.decode(add, "UTF-8");
	if(tel!=null)
		tel = URLDecoder.decode(tel, "UTF-8");

}


%>



<form action="http://localhost:8080/juushoroku/hennshu_kaku.jsp" method="post">
<input type="hidden" name="id" value="<%=no%>">
<p style="text-align: Center">名前*　：<input type="text" id="name" name="name" value=<%=name%> ><font color="red"><%=nameE %></font><br>
<th style="text-align: Center">住所*　：<input size="70" type="text" id="add" name="add" value=<%=add%> ><font color="red"><%=addE %></font><br>
<th style="text-align: Center">電話番号　：<input type="text" id="tel" name="tel" value=<%=tel%> ><font color="red"><%=telE %></font><br>
<br>
<br>
<input  name="submit" type="submit" value="確認">
</form>
<a>
<button type="submit" onclick="location.href='juu.jsp'">戻る</button>
</a>

</head>
<body>

</body>
</html>