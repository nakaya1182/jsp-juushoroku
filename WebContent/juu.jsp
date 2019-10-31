<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    import="java.sql.*,
    java.text.*,
    juushoroku.MyDBAccess,
    java.util.ArrayList,
    javax.servlet.http.HttpSession,
    java.sql.Statement,
    java.sql.SQLException,
    java.io.UnsupportedEncodingException,
	java.net.URLEncoder,
	java.net.URLDecoder" %>

<!DOCTYPE html>

<html>
<head>
<meta name="viewport" charset='utf-8'content="width=device-width,initial-scale=1.0,minimum-scale=1.0">
</head>
<style>
@media (max-width: 320px) {
   div#sidebar { width: 100%; }
}
@media (min-width: 321px) and (max-width: 768px) {
   div#sidebar { width: 768px; }
}
@media (min-width: 769px) {
   div#sidebar { width: 960px; }
}
</style>
<title>住所録管理システム</title>
</head>
<body>

<div style="width: 100%; text-overflow: ellipsis ; overflow: hidden; white-space: nowrap;">
<tr><big><b>住所録管理システム：住所録一覧</b></big></tr>
<br>
<%
// データベースへのアクセス開始

/*MyDBAccess db = new MyDBAccess();
db.open();*/
Connection con = null;
Statement stmt = null;
ResultSet rs = null;

//変数宣言
request.setCharacterEncoding("utf-8");
String name;
String add;
String tel;
String sort;
String kensaku;
//現在ページid取得
String pageID = request.getParameter("pageID");
int page_now;
if(pageID==null){
	page_now = 1;
}else{
	try{
		page_now = Integer.parseInt(pageID);
	}catch (NumberFormatException e) {
		System.out.println("ID変換エラー");
		page_now = 1;
	}
}

//ソート値取得
sort = request.getParameter("sort");
if(sort==null)
	sort="id";
//検索結果の受け取り
kensaku = request.getParameter("kensaku");
String kensaku_enco="";
if(kensaku==null)
	kensaku = "";
if(kensaku!="")
	kensaku_enco = URLEncoder.encode(kensaku, "UTF-8");
if(kensaku.matches(".*%.*"))
	kensaku=URLDecoder.decode(kensaku, "UTF-8");
if(kensaku==null)
	kensaku=".*";
// データベースに接続するConnectionオブジェクトの取得
con = DriverManager.getConnection(
    "jdbc:mysql://localhost/juusho_db?characterEncoding=UTF-8&serverTimezone=JST",
    "root", "");
// データベース操作を行うためのStatementオブジェクトの取得
stmt = con.createStatement();
// SQL(セレクト文)を実行して、結果を得る(ソート)

if(sort.equals("id")){
	rs= stmt.executeQuery("select * from juusho_tbl ORDER BY id ASC");

}else if(sort.equals("add")){
	rs= stmt.executeQuery("select * from juusho_tbl ORDER BY 住所 ASC");

}else if(sort.equals("tel")){
	rs= stmt.executeQuery("select * from juusho_tbl ORDER BY 電話番号 ASC");

}

%>


<br>
<br>
<a href="touroku.jsp">
<button type="submit">新規登録</button>
</a>
<form action="http://localhost:8080/juushoroku/juu.jsp" accept-charset="UTF-8" method="post">
<p style="text-align: right">住所　：<input type="text" id="kensaku" name="kensaku">
<input name="submit" type="submit" value="検索"></p>
<input type="hidden" name=sort id= soat value="<%=sort%>">
</form>

<br>
<br>
<p>
<%

//------
//ページリンクのコード～
//------

String tableHTML = "<table border=1>";
//全ページ数取得
rs.last();
int date = rs.getRow();
int page_all = 0;

if(date != 0)
	page_all += date/10;

if(page_all%10 != 0)
	page_all++;


rs.first();  //DBカーそるを最初に戻す

//削除されたデータと検索除外を取得
int flag;
int p=1;
int sakujo_suu = 0;
int id;
int jogai_suu = 0;
for(; p<=date; p++){
	flag = rs.getInt("flag");
	add = rs.getString("住所");
	if(flag==1)
		sakujo_suu++;
	else if(!add.matches(".*"+kensaku+".*"))
		jogai_suu++;

	rs.next();
}
rs.first();


//データ数から削除、検索除外のデータ数を引く
date -= sakujo_suu;
date -= jogai_suu;
if(sakujo_suu != 0)
	page_all -= (sakujo_suu/10)+1;
if(jogai_suu != 0)
	page_all -= (jogai_suu/10);

//リンク数5つの数字決定

int page_mai = page_now - 2;
int page_tasu2= page_now + 2;
if(page_mai < 1 )
	page_mai = 1;
if(page_tasu2>page_all)
	page_tasu2=page_all;
int i=1;
int date_first=1;
int date_last=10;
int x=0;
//＜＜
if(page_now==1)
	tableHTML += "<<";
else
	tableHTML += "<a href=http://localhost:8080/juushoroku/juu.jsp?pageID=" + 1 + "&kensaku="+kensaku_enco+"&sort="+sort+">" + "<<" + "</a>";

//<
if(page_now==1){
	tableHTML += "&nbsp;";
	tableHTML += "&nbsp;";
	tableHTML += "<";
	tableHTML += "&nbsp;";
}

else{
	x = page_now-1;
	tableHTML += "&nbsp;";
	tableHTML += "&nbsp;";
	tableHTML += "<a href=http://localhost:8080/juushoroku/juu.jsp?pageID=" + x + "&kensaku="+kensaku_enco+"&sort="+sort+">" + "<" + "</a>";
	tableHTML += "&nbsp;";

}

//ページリンク表示

for(i=page_mai; page_mai<=i && i<=page_tasu2; i++){

	if(page_now==page_all &&  i== page_mai){
		tableHTML += "&nbsp;";
		tableHTML += "<a href=http://localhost:8080/juushoroku/juu.jsp?pageID=" + (i-2) + "&kensaku="+kensaku_enco+"&sort="+sort+">" + (i-2) + "</a>";
		tableHTML += "&nbsp;";
		tableHTML += "|";
		tableHTML += "&nbsp;";
	}
	if(page_now==page_all &&  i== page_mai){
		tableHTML += "&nbsp;";
		tableHTML += "<a href=http://localhost:8080/juushoroku/juu.jsp?pageID=" + (i-1) + "&kensaku="+kensaku_enco+"&sort="+sort+">" + (i-1) + "</a>";
		tableHTML += "&nbsp;";
		tableHTML += "|";
		tableHTML += "&nbsp;";
	}
	if(page_now==page_all-1 &&  i== page_mai){
		tableHTML += "&nbsp;";
		tableHTML += "<a href=http://localhost:8080/juushoroku/juu.jsp?pageID=" + (i-1) + "&kensaku="+kensaku_enco+"&sort="+sort+">" + (i-1) + "</a>";
		tableHTML += "&nbsp;";
		tableHTML += "|";
		tableHTML += "&nbsp;";
	}

	if(i==page_now){
		tableHTML += "&nbsp;";
		tableHTML += i;
		tableHTML += "&nbsp;";
		tableHTML += "|";
		tableHTML += "&nbsp;";
	}else{
		tableHTML += "&nbsp;";
		tableHTML += "<a href=http://localhost:8080/juushoroku/juu.jsp?pageID=" + i + "&kensaku="+kensaku_enco+"&sort="+sort+">" + i + "</a>";
		tableHTML += "&nbsp;";
		tableHTML += "|";
		tableHTML += "&nbsp;";

	}

	if(page_now==1 && i==3 && page_all>=4){
		tableHTML += "&nbsp;";
		tableHTML += "<a href=http://localhost:8080/juushoroku/juu.jsp?pageID=" + 4 + "&kensaku="+kensaku_enco+"&sort="+sort+">" + 4 + "</a>";
		tableHTML += "&nbsp;";
		tableHTML += "|";
		tableHTML += "&nbsp;";
	}
	if(page_now ==1 && i==3 && page_all>=5){
		tableHTML += "&nbsp;";
		tableHTML += "<a href=http://localhost:8080/juushoroku/juu.jsp?pageID=" + 5 + "&kensaku="+kensaku_enco+"&sort="+sort+">" + 5 + "</a>";
		tableHTML += "&nbsp;";
		tableHTML += "|";
		tableHTML += "&nbsp;";
	}else if(page_now ==2 && i==4 && page_all>=5){
		tableHTML += "&nbsp;";
		tableHTML += "<a href=http://localhost:8080/juushoroku/juu.jsp?pageID=" + 5 + "&kensaku="+kensaku_enco+"&sort="+sort+">" + 5 + "</a>";
		tableHTML += "&nbsp;";
		tableHTML += "|";
		tableHTML += "&nbsp;";
	}
}

//>
if(page_now==page_all){
	tableHTML += "&nbsp;";
	tableHTML += ">";
}

else{
	x = page_now+1;
	tableHTML += "&nbsp;";
	tableHTML += "&nbsp;";
	tableHTML += "<a href=http://localhost:8080/juushoroku/juu.jsp?pageID=" + x + "&kensaku="+kensaku_enco+"&sort="+sort+">" + ">" + "</a>";


}

//>>
if(page_now==page_all){
	tableHTML += "&nbsp;";
	tableHTML += "&nbsp;";
	tableHTML += ">>";
}else{
	tableHTML += "&nbsp;";
	tableHTML += "&nbsp;";
	tableHTML += "<a href=http://localhost:8080/juushoroku/juu.jsp?pageID=" + page_all + "&kensaku="+kensaku_enco+"&sort="+sort+">" + ">>" + "</a>";
}


%>
   </p>



<%
//----
//表の表示～
//-------
rs.first();
//表一行目とサイズ
tableHTML += "<tr  height=40 bgcolor=cornflowerblue>"
	+ "<th width=3% >No.<form method='post' action='http://localhost:8080/juushoroku/juu.jsp?kensaku="+kensaku_enco+"&sort=id'>"
		+"<input  name='submit' type='submit' value='▲'></form></th>"
	+ "<th width=16% >名前</th>"
	+ "<th width=46% >住所<form method='post' action='http://localhost:8080/juushoroku/juu.jsp?kensaku="+kensaku_enco+"&sort=add'>"
		+"<input  name='submit' type='submit' value='▲'></form></th>"
	+ "<th width=20% >電話番号<form method='post' action='http://localhost:8080/juushoroku/juu.jsp?kensaku="+kensaku_enco+"&sort=tel'>"
		+"<input  name='submit' type='submit' value='▲'></form></th>"
	+ "<th width=6% ></th>"
	+ "<th width=6% ></th>"
	+ "</tr>";


	// 表示データの最初と最後の番号を決める
	date_first=1;
	date_first+=(page_now-1)*10;
	date_last=page_now*10;
	if(date_last>date)
		date_last=date;
	//カーソル合わせ
	for(int k=1;k<date_first;k++){
		flag = rs.getInt("flag");
		add = rs.getString("住所");
		if(flag == 1) k--;
		else if(!add.matches(".*"+kensaku+".*")) k--;

		rs.next();
	}
	for(;date_first<=date_last;date_first++) {

		//DBからデータ取得
			id = rs.getInt("id");
		    name = rs.getString("名前");
		    add = rs.getString("住所");
		    tel = rs.getString("電話番号");
		    flag = rs.getInt("flag");
		if(flag != 1){
			if(add.matches(".*"+kensaku+".*")){		//削除フラグがなく、検索値なら表示


	  		 // 表データHTMLを作成
	  			  tableHTML += "<tr><td align=\"right\">"
	    		+ id + "</td>" + "<td>"
	    		+ name + "</td><td title="+add+"><div class='santen' style='width:90%' overflow: hidden; white-space: nowrap;' onmouseover='$(this).attr('title',$(this).text())'>"
	    		+ add + "</div></td><td>"
	            + tel +"</td><td>"
	            + "<a href=hennshu.jsp?id="+ id +"><button type=submit>編集</button></a>" +"</td><td>"
	            + "<a href=sakujo.jsp?id="+ id +"><button type=submit>削除</button></a>" +"</td>";
			}else if(!add.matches(".*"+kensaku+".*")){	//検索値でないならカウントしない
				date_first--;
			}
		}else if(flag==1){		//削除フラグならカウントしない
			date_first--;
	}
	    rs.next();	//次カーソル

	}

	tableHTML += "</table><br>";

%>
<%
//ページリンク

//＜＜
if(page_now==1)
	tableHTML += "<<";
else
	tableHTML += "<a href=http://localhost:8080/juushoroku/juu.jsp?pageID=" + 1 + "&kensaku="+kensaku_enco+"&sort="+sort+">" + "<<" + "</a>";

//<
if(page_now==1){
	tableHTML += "&nbsp;";
	tableHTML += "&nbsp;";
	tableHTML += "<";
	tableHTML += "&nbsp;";
}

else{
	x = page_now-1;
	tableHTML += "&nbsp;";
	tableHTML += "&nbsp;";
	tableHTML += "<a href=http://localhost:8080/juushoroku/juu.jsp?pageID=" + x + "&kensaku="+kensaku_enco+"&sort="+sort+">" + "<" + "</a>";
	tableHTML += "&nbsp;";

}

//ページリンク表示

for(i=page_mai; page_mai<=i && i<=page_tasu2; i++){

	if(page_now==page_all &&  i== page_mai){
		tableHTML += "&nbsp;";
		tableHTML += "<a href=http://localhost:8080/juushoroku/juu.jsp?pageID=" + (i-2) + "&kensaku="+kensaku_enco+"&sort="+sort+">" + (i-2) + "</a>";
		tableHTML += "&nbsp;";
		tableHTML += "|";
		tableHTML += "&nbsp;";
	}
	if(page_now==page_all &&  i== page_mai){
		tableHTML += "&nbsp;";
		tableHTML += "<a href=http://localhost:8080/juushoroku/juu.jsp?pageID=" + (i-1) + "&kensaku="+kensaku_enco+"&sort="+sort+">" + (i-1) + "</a>";
		tableHTML += "&nbsp;";
		tableHTML += "|";
		tableHTML += "&nbsp;";
	}
	if(page_now==page_all-1 &&  i== page_mai){
		tableHTML += "&nbsp;";
		tableHTML += "<a href=http://localhost:8080/juushoroku/juu.jsp?pageID=" + (i-1) + "&kensaku="+kensaku_enco+"&sort="+sort+">" + (i-1) + "</a>";
		tableHTML += "&nbsp;";
		tableHTML += "|";
		tableHTML += "&nbsp;";
	}

	if(i==page_now){
		tableHTML += "&nbsp;";
		tableHTML += i;
		tableHTML += "&nbsp;";
		tableHTML += "|";
		tableHTML += "&nbsp;";
	}else{
		tableHTML += "&nbsp;";
		tableHTML += "<a href=http://localhost:8080/juushoroku/juu.jsp?pageID=" + i + "&kensaku="+kensaku_enco+"&sort="+sort+">" + i + "</a>";
		tableHTML += "&nbsp;";
		tableHTML += "|";
		tableHTML += "&nbsp;";

	}

	if(page_now==1 && i==3 && page_all>=4){
		tableHTML += "&nbsp;";
		tableHTML += "<a href=http://localhost:8080/juushoroku/juu.jsp?pageID=" + 4 + "&kensaku="+kensaku_enco+"&sort="+sort+">" + 4 + "</a>";
		tableHTML += "&nbsp;";
		tableHTML += "|";
		tableHTML += "&nbsp;";
	}
	if(page_now ==1 && i==3 && page_all>=5){
		tableHTML += "&nbsp;";
		tableHTML += "<a href=http://localhost:8080/juushoroku/juu.jsp?pageID=" + 5 + "&kensaku="+kensaku_enco+"&sort="+sort+">" + 5 + "</a>";
		tableHTML += "&nbsp;";
		tableHTML += "|";
		tableHTML += "&nbsp;";
	}else if(page_now ==2 && i==4 && page_all>=5){
		tableHTML += "&nbsp;";
		tableHTML += "<a href=http://localhost:8080/juushoroku/juu.jsp?pageID=" + 5 + "&kensaku="+kensaku_enco+"&sort="+sort+">" + 5 + "</a>";
		tableHTML += "&nbsp;";
		tableHTML += "|";
		tableHTML += "&nbsp;";
	}
}
//>
if(page_now==page_all){
	tableHTML += "&nbsp;";
	tableHTML += ">";
}

else{
	x = page_now+1;
	tableHTML += "&nbsp;";
	tableHTML += "&nbsp;";
	tableHTML += "<a href=http://localhost:8080/juushoroku/juu.jsp?pageID=" + x + "&kensaku="+kensaku_enco+"&sort="+sort+">" + ">" + "</a>";


}

//>>
if(page_now==page_all){
	tableHTML += "&nbsp;";
	tableHTML += "&nbsp;";
	tableHTML += ">>";
}else{
	tableHTML += "&nbsp;";
	tableHTML += "&nbsp;";
	tableHTML += "<a href=http://localhost:8080/juushoroku/juu.jsp?pageID=" + page_all + "&kensaku="+kensaku_enco+"&sort="+sort+">" + ">>" + "</a>";
}
%>
<%--CSS --%>
<style>
div.santen{
  text-overflow: ellipsis;
  overflow: hidden;
  white-space: nowrap;
}

</style>

<%--表示の実行   --%>
<%= tableHTML %>
<br>
<br><br>
<a href="touroku.jsp">
<button type="submit">新規登録</button>
</a>
</div>
<p>

</p>
</body>
</html>