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
javax.swing.JTextField"
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


//データベースへのアクセス開始

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


}catch(Exception  e) {
	//out.println(e.getMessage());
	e.printStackTrace();
}

//DBで目的のデータにカーソルを合わせ

/*for(int i=1;i<=no;i++)
	rs.next();*/
for(rs.first(); no != rs.getInt("id"); rs.next()){
}



//DBからデータ引き出し
String name = rs.getString("名前");
String add = rs.getString("住所");
String tel = rs.getString("電話番号");
%>
<title>住所録管理システム</title>
</head>
<body>
<tr><big><b>住所録管理システム：住所録削除確認</b></big></tr>
<body>
<br>
<br>

<tr>下記住所録を削除します。　よろしいですか？</tr>

<p>
名前*　：<%=name%><br>
住所*　：<%=add%><br>
電話番号　：<%=tel%>

<%--DB接続 --%>
<form method="post" action="http://localhost:8080/juushoroku/sakujo">
<input type="hidden" name="id" value="<%=no%>">
<input type="hidden" name="name" value="<%=name%>">
<input type="hidden" name="add" value="<%=add%>">
<input type="hidden" name="tel" value="<%=tel%>">
<input type="submit" value="削除" >
</form>
<button type="submit" onclick="history.back()">キャンセル</button>

</body>
</html>