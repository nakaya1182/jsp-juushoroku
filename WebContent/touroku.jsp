<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    import="java.sql.*,java.text.*,juushoroku.MyDBAccess,java.util.Optional,java.util.ArrayList,javax.servlet.http.HttpSession,java.io.*"
    %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
<tr><big><b>住所録管理システム：住所録登録</b></big></tr>

<div id="global">


<%
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

%>


<form action="http://localhost:8080/juushoroku/touroku_kaku.jsp" method="post">
<p style="text-align: Center">名前*　：<input type="text" id="name" name="name"><font color="red"><%=nameE %></font><br>
<th style="text-align: Center">住所*　：<input size="70" type="text" id="add" name="add"><font color="red"><%=addE %></font><br>
<th style="text-align: Center">電話番号　：<textarea id="tel" name="tel" cols="30" rows="1"></textarea><font color="red"><%=telE %></font><br>

<br>
<br>
<input  name="submit" type="submit" value="確認" />
</form>
<a>
<button type="submit" onclick="location.href='juu.jsp'">戻る</button>
</a>

</head>
<body>

</body>
</html>