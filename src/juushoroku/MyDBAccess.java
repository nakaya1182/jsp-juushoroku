package juushoroku;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/MyDBAccess")
public class MyDBAccess extends HttpServlet {
	private static final long serialVersionUID = 1L;


    private String driver;
    private String url;
    private String user;
    private String password;
    private Connection connection;
    private Statement statement;
    private ResultSet resultset;


    public MyDBAccess(String driver, String url, String user, String password) {
        this.driver = driver;
        this.url = url;
        this.user = user;
        this.password = password;
    }

    /**
     * 引数なしのコンストラクタ
     * 既定値を使用する
     */

    public MyDBAccess() {
        driver = "com.mysql.jdbc.Driver";
        url = "jdbc:mysql://localhost:3306/juusho_db?serverTimezone=JST";
        user = "root";
        password = "";
    }

    /**
     * データベースへの接続を行う
     */
    public synchronized void open() throws Exception {
        Class.forName(driver);
        connection = DriverManager.getConnection(url, user, password);
        statement = connection.createStatement();
    }

    /**
     * SQL 文を実行した結果の ResultSet を返す
     * @param sql SQL 文
     */
    public ResultSet getResultSet(String sql) throws Exception {
        if ( statement.execute(sql) ) {
            return statement.getResultSet();
        }
        return null;
    }
    //セッション
    public void doGet(HttpServletRequest request,
            HttpServletResponse response)
        throws ServletException, IOException {
    	String name = null;
    	String add = null;
    	String tel = null;
    	HttpSession session = request.getSession();
    	 session.setAttribute("name",name);
    	 session.setAttribute("add",add);
    	 session.setAttribute("tel",tel);
    }

    /**
     * SQL 文の実行
     * @param sql SQL 文
     */
    public void execute(String sql) throws Exception {
        statement.execute(sql);
    }



    /**
     * データベースへのコネクションのクローズ
     */
    public synchronized void close() throws Exception {
        if ( resultset != null ) resultset.close();
        if ( statement != null ) statement.close();
        if ( connection != null ) connection.close();
    }
}