<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"
import="java.sql.*,
java.text.*,
juushoroku.MyDBAccess,
java.util.Optional,
java.util.ArrayList,
javax.servlet.http.HttpSession,
java.awt.Panel,
java.awt.event.ActionEvent,
java.awt.event.ActionListener,
java.sql.Connection,
java.sql.DriverManager,
java.sql.PreparedStatement,
java.sql.SQLException,
java.sql.Statement,
javax.swing.JButton,
javax.swing.JFrame,
javax.swing.JLabel,
javax.swing.JTextField,
java.io.UnsupportedEncodingException,
java.net.URLEncoder,
java.net.URLDecoder"
%>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN"
 "http://www.w3.org/TR/html4/strict.dtd">
<html lang="ja">
<head>
<meta name="viewport" content="width=width=960,initial-scale=1">
<link rel="stylesheet" media="(max-width: 768px)" href="style-768.css">
<link rel="stylesheet" media="(max-width: 320px)" href="style-320.css">
<%
//値の受け取り
request.setCharacterEncoding("utf-8");
String id = request.getParameter("id");
int no = Integer.parseInt(id);
String name = request.getParameter("name");
String add = request.getParameter("add");
String tel = request.getParameter("tel");
String nameENCO = URLEncoder.encode(name, "UTF-8");
String addENCO = URLEncoder.encode(add, "UTF-8");
String telENCO = URLEncoder.encode(tel, "UTF-8");
String e ="";
String tableHTML = null;

//エラーチェック
if(name=="")
	e+="name_kuuhaku";
if(add=="")
	e+="add_kuuhaku";
if(tel=="")
	e+="tel_kuuhaku";

if(name.length()>8)
	e+="name_nagai";
if(add.length()>64)
	e+="add_nagai";
if(tel.length()>20)
	e+="tel_nagai";
//エラーがあったらエラーを返して戻る
if(e!=""){
	tableHTML += "<META http-equiv='Refresh' content='0;URL=http://localhost:8080/juushoroku/hennshu.jsp?id="+ id +"&e=" + e +"&nameENCO="+nameENCO+"&addENCO="+addENCO+"&telENCO="+telENCO+"'>";

}else  tableHTML ="";
%>

<title>住所録管理システム</title>
<%= tableHTML %>
</head>
<body>
<tr><big><b>住所録管理システム：住所録編集確認</b></big></tr>
<body>

<p>
名前*　：<%=name%><br>
住所*　：<%=add%><br>
電話番号　：<%=tel%>

<%--DB接続 --%>
<form method="post" action="http://localhost:8080/juushoroku/hennshu">
<input type="hidden" name="id" value="<%=no%>">
<input type="hidden" name="name" value="<%=name%>">
<input type="hidden" name="add" value="<%=add%>">
<input type="hidden" name="tel" value="<%=tel%>">
<input type="submit" value="登録"">
</form>
<button onClick="history.back()" >戻る</button>

</body>
</html>