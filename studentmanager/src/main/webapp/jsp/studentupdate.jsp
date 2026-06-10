<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="entity.Student"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>修改学生信息</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .container { width: 500px; margin: 0 auto; padding: 20px; border: 1px solid #ddd; border-radius: 5px; }
        h2 { text-align: center; color: #2196F3; }
        .form-group { margin-bottom: 15px; }
        label { display: inline-block; width: 80px; font-weight: bold; }
        input, select { width: 250px; padding: 8px; border: 1px solid #ddd; border-radius: 4px; }
        .btn { padding: 10px 20px; border: none; border-radius: 4px; cursor: pointer; }
        .btn-submit { background-color: #2196F3; color: white; }
        .btn-cancel { background-color: #f44336; color: white; }
        .error { color: red; text-align: center; margin-bottom: 10px; }
    </style>
</head>
<body>
    <div class="container">
        <h2>修改学生信息</h2>
        
        <%
            String error = (String) request.getAttribute("error");
            if (error != null) {
        %>
        <div class="error"><%= error %></div>
        <%
            }
            
            Student stu = (Student) request.getAttribute("student");
            if (stu != null) {
        %>
        <form action="DoUpdateStudentServlet.do" method="post">
            <input type="hidden" name="id" value="<%= stu.getId() %>">
            <div class="form-group">
                <label>学号：</label>
                <input type="text" name="studentId" value="<%= stu.getStudentId() %>" required>
            </div>
            <div class="form-group">
                <label>姓名：</label>
                <input type="text" name="name" value="<%= stu.getName() %>" required>
            </div>
            <div class="form-group">
                <label>性别：</label>
                <select name="gender">
                    <option value="男" <%= "男".equals(stu.getGender()) ? "selected" : "" %>>男</option>
                    <option value="女" <%= "女".equals(stu.getGender()) ? "selected" : "" %>>女</option>
                </select>
            </div>
            <div class="form-group">
                <label>年龄：</label>
                <input type="number" name="age" min="0" max="100" value="<%= stu.getAge() > 0 ? stu.getAge() : "" %>">
            </div>
            <div class="form-group">
                <label>专业：</label>
                <input type="text" name="major" value="<%= stu.getMajor() != null ? stu.getMajor() : "" %>">
            </div>
            <div class="form-group">
                <label>年级：</label>
                <input type="text" name="grade" value="<%= stu.getGrade() != null ? stu.getGrade() : "" %>">
            </div>
            <div style="text-align: center;">
                <button type="submit" class="btn btn-submit">保存修改</button>
                <button type="button" class="btn btn-cancel" onclick="location.href='ListStudentServlet.do'">取消</button>
            </div>
        </form>
        <%
            } else {
        %>
        <div class="error">未找到该学生信息！</div>
        <div style="text-align: center;">
            <button onclick="location.href='ListStudentServlet.do'">返回列表</button>
        </div>
        <%
            }
        %>
    </div>
</body>
</html>