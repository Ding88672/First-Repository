package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import dbutil.Dbconn;
import entity.Student;

public class StudentModel {
    
    /**
     * 1. 查询所有学生
     */
    public List<Student> getAllStudents() {
        List<Student> list = new ArrayList<>();
        String sql = "SELECT * FROM student ORDER BY id";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = Dbconn.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Student stu = new Student();
                stu.setId(rs.getInt("id"));
                stu.setStudentId(rs.getString("student_id"));
                stu.setName(rs.getString("name"));
                stu.setGender(rs.getString("gender"));
                stu.setAge(rs.getInt("age"));
                stu.setMajor(rs.getString("major"));
                stu.setGrade(rs.getString("grade"));
                list.add(stu);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            Dbconn.close(conn, ps, rs);
        }
        return list;
    }
    
    /**
     * 2. 根据ID查询单个学生（用于修改前的回显）
     */
    public Student getStudentById(int id) {
        Student stu = null;
        String sql = "SELECT * FROM student WHERE id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = Dbconn.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                stu = new Student();
                stu.setId(rs.getInt("id"));
                stu.setStudentId(rs.getString("student_id"));
                stu.setName(rs.getString("name"));
                stu.setGender(rs.getString("gender"));
                stu.setAge(rs.getInt("age"));
                stu.setMajor(rs.getString("major"));
                stu.setGrade(rs.getString("grade"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            Dbconn.close(conn, ps, rs);
        }
        return stu;
    }
    
    /**
     * 3. 添加学生
     */
    public boolean addStudent(Student stu) {
        String sql = "INSERT INTO student (student_id, name, gender, age, major, grade) VALUES (?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            conn = Dbconn.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, stu.getStudentId());
            ps.setString(2, stu.getName());
            ps.setString(3, stu.getGender());
            ps.setInt(4, stu.getAge());
            ps.setString(5, stu.getMajor());
            ps.setString(6, stu.getGrade());
            
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            Dbconn.close(conn, ps);
        }
    }
    
    /**
     * 4. 修改学生信息
     */
    public boolean updateStudent(Student stu) {
        String sql = "UPDATE student SET student_id=?, name=?, gender=?, age=?, major=?, grade=? WHERE id=?";
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            conn = Dbconn.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, stu.getStudentId());
            ps.setString(2, stu.getName());
            ps.setString(3, stu.getGender());
            ps.setInt(4, stu.getAge());
            ps.setString(5, stu.getMajor());
            ps.setString(6, stu.getGrade());
            ps.setInt(7, stu.getId());
            
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            Dbconn.close(conn, ps);
        }
    }
    
    /**
     * 5. 删除学生
     */
    public boolean deleteStudent(int id) {
        String sql = "DELETE FROM student WHERE id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            conn = Dbconn.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            Dbconn.close(conn, ps);
        }
    }
    
    /**
     * 6. 批量插入学生（用于Excel导入）
     */
    public boolean batchInsert(List<Student> studentList) {
        String sql = "INSERT INTO student (student_id, name, gender, age, major, grade) VALUES (?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            conn = Dbconn.getConnection();
            // 关闭自动提交，开启事务
            conn.setAutoCommit(false);
            ps = conn.prepareStatement(sql);
            
            for (Student stu : studentList) {
                ps.setString(1, stu.getStudentId());
                ps.setString(2, stu.getName());
                ps.setString(3, stu.getGender());
                ps.setInt(4, stu.getAge());
                ps.setString(5, stu.getMajor());
                ps.setString(6, stu.getGrade());
                ps.addBatch();  // 添加到批处理
            }
            
            int[] results = ps.executeBatch();
            conn.commit();  // 提交事务
            
            return results.length > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            try {
                if (conn != null) conn.rollback();  // 出错回滚
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            return false;
        } finally {
            Dbconn.close(conn, ps);
        }
    }
}