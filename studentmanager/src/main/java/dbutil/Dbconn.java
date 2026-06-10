package dbutil;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class Dbconn {
    
    // 数据库连接配置（根据你的实际情况修改）
    private static final String URL = "jdbc:mysql://localhost:3306/students?useSSL=false&serverTimezone=Asia/Shanghai&characterEncoding=utf8";
    private static final String USER = "root";      // MySQL用户名
    private static final String PASSWORD = "xsq!@123"; // MySQL密码
    
    // 静态代码块：注册驱动（只会执行一次）
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");  // MySQL 8.0驱动
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            throw new RuntimeException("MySQL驱动加载失败！");
        }
    }
    
    /**
     * 获取数据库连接
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
    
    /**
     * 关闭所有资源
     */
    public static void close(Connection conn, PreparedStatement ps, ResultSet rs) {
        try {
            if (rs != null) rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        try {
            if (ps != null) ps.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        try {
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    /**
     * 关闭连接和预处理对象（没有结果集时调用）
     */
    public static void close(Connection conn, PreparedStatement ps) {
        close(conn, ps, null);
    }
}