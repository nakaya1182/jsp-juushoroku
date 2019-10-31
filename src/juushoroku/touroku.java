package juushoroku;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


@WebServlet("/touroku")
public class touroku extends HttpServlet {
	private static final long serialVersionUID = 1L;


    public touroku() {

    	//super();
    }

	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		Connection conn = null;
    	PreparedStatement ps = null;
		HttpSession seccion = request.getSession();
    	String URL = "jdbc:mysql://localhost:3306/juusho_db?serverTimezone=JST";
    	String USER = "root";
    	String PASS = "";
    	String sql = "INSERT INTO juusho_tbl(名前,住所,電話番号) values(?,?,?)";
    	request.setCharacterEncoding("utf-8");
    	String name = request.getParameter("name");
    	String add = request.getParameter("add");
    	String tel = request.getParameter("tel");
    	try{

    		Class.forName("com.mysql.cj.jdbc.Driver");

    	    conn = DriverManager.getConnection(URL,USER, PASS);
    	    conn.setAutoCommit(false);

    	    ps = conn.prepareStatement(sql);
    	    ps.setString(1,name);
    	    ps.setString(2,add);
    	    ps.setString(3,tel);

    	    //INSERT文を実行する
    	    int i = ps.executeUpdate();

    	    conn.commit();

    	    response.sendRedirect("http://localhost:8080/juushoroku/juu.jsp");



    	} catch (Exception ex) {
    	    //例外発生時の処理
    	//	conn.rollback();      //ロールバックする
    	    ex.printStackTrace();  //エラー内容をコンソールに出力する
    	  //エラー表示
    	    response.sendRedirect("http://localhost:8080/juushoroku/result.jsp");
    	} finally {
    		 //クローズ処理
    	   // if (ps != null) ps.close();
    	  //  if (conn != null) conn.close();
    	}

    }
}
