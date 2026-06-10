<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, entity.Student"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>学生信息管理系统</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 40px 20px;
        }
        
        .container {
            max-width: 1400px;
            margin: 0 auto;
            background: white;
            border-radius: 24px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.15);
            overflow: hidden;
        }
        
        /* 头部区域 */
        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 30px 32px;
            color: white;
        }
        
        .header h1 {
            font-size: 28px;
            font-weight: 600;
            margin-bottom: 8px;
        }
        
        .header p {
            opacity: 0.9;
            font-size: 14px;
        }
        
        /* 操作栏 */
        .action-bar {
            padding: 20px 32px;
            background: #f8fafc;
            border-bottom: 1px solid #e2e8f0;
            display: flex;
            justify-content: flex-end;
            gap: 12px;
            flex-wrap: wrap;
        }
        
        /* 按钮样式 */
        .btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 20px;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 500;
            text-decoration: none;
            cursor: pointer;
            transition: all 0.2s ease;
            border: none;
            font-family: inherit;
        }
        
        .btn-primary {
            background: #667eea;
            color: white;
        }
        
        .btn-primary:hover {
            background: #5a67d8;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
        }
        
        .btn-excel {
            background: #10b981;
            color: white;
        }
        
        .btn-excel:hover {
            background: #059669;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(16, 185, 129, 0.4);
        }
        
        .btn-edit {
            background: #3b82f6;
            color: white;
            padding: 6px 14px;
            font-size: 13px;
        }
        
        .btn-edit:hover {
            background: #2563eb;
        }
        
        .btn-delete {
            background: #ef4444;
            color: white;
            padding: 6px 14px;
            font-size: 13px;
        }
        
        .btn-delete:hover {
            background: #dc2626;
        }
        
        /* 表格样式 */
        .table-wrapper {
            overflow-x: auto;
            padding: 0 32px 32px 32px;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
            font-size: 14px;
        }
        
        th {
            text-align: left;
            padding: 16px 12px;
            background: #f1f5f9;
            color: #1e293b;
            font-weight: 600;
            border-bottom: 2px solid #e2e8f0;
        }
        
        td {
            padding: 14px 12px;
            border-bottom: 1px solid #e2e8f0;
            color: #334155;
        }
        
        tr:hover {
            background: #f8fafc;
        }
        
        /* 空状态 */
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #94a3b8;
        }
        
        .empty-state svg {
            width: 80px;
            height: 80px;
            margin-bottom: 16px;
            opacity: 0.5;
        }
        
        /* 统计栏 */
        .stats {
            padding: 16px 32px;
            background: #f1f5f9;
            font-size: 14px;
            color: #475569;
            border-top: 1px solid #e2e8f0;
            display: flex;
            justify-content: space-between;
        }
        
        .badge {
            background: #667eea;
            color: white;
            padding: 2px 8px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 500;
        }
        
        @media (max-width: 768px) {
            .header, .action-bar, .table-wrapper, .stats {
                padding-left: 20px;
                padding-right: 20px;
            }
            
            th, td {
                padding: 10px 8px;
            }
            
            .btn-edit, .btn-delete {
                padding: 4px 10px;
                font-size: 12px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- 头部 -->
        <div class="header">
            <h1>📚 学生信息管理系统</h1>
            <p>管理学生信息 · 支持增删改查及批量导入</p>
        </div>
        
        <!-- 操作栏 -->
        <div class="action-bar">
            <a href="InsertStudentServlet.do" class="btn btn-primary">
                <span>+</span> 新增学生
            </a>
            <a href="jsp/upload.jsp" class="btn btn-excel">
                <span>📎</span> Excel批量导入
            </a>
        </div>
        
        <!-- 表格 -->
        <div class="table-wrapper">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>学号</th>
                        <th>姓名</th>
                        <th>性别</th>
                        <th>年龄</th>
                        <th>专业</th>
                        <th>年级</th>
                        <th style="text-align: center;">操作</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        List<Student> list = (List<Student>) request.getAttribute("studentList");
                        if (list != null && !list.isEmpty()) {
                            for (Student stu : list) {
                    %>
                    <tr>
                        <td><span class="badge"><%= stu.getId() %></span></td>
                        <td><%= stu.getStudentId() %></td>
                        <td><strong><%= stu.getName() %></strong></td>
                        <td><%= stu.getGender() != null ? stu.getGender() : "--" %></td>
                        <td><%= stu.getAge() > 0 ? stu.getAge() : "--" %></td>
                        <td><%= stu.getMajor() != null ? stu.getMajor() : "--" %></td>
                        <td><%= stu.getGrade() != null ? stu.getGrade() : "--" %></td>
                        <td style="text-align: center;">
                            <a href="ShowUpdateStudentServlet.do?id=<%= stu.getId() %>" class="btn btn-edit">修改</a>
                            <a href="DeleteStudentServlet.do?id=<%= stu.getId() %>" class="btn btn-delete" 
                               onclick="return confirm('确定要删除学生「<%= stu.getName() %>」吗？')">删除</a>
                        </td>
                    </tr>
                    <%
                            }
                        } else {
                    %>
                    <tr>
                        <td colspan="8">
                            <div class="empty-state">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                                    <path d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                                </svg>
                                <p>暂无学生数据</p>
                                <p style="font-size: 12px; margin-top: 8px;">点击「新增学生」或「Excel批量导入」添加</p>
                            </div>
                        </td>
                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
        </div>
        
        <!-- 统计栏 -->
        <div class="stats">
            <span>📊 共 <strong><%= list != null ? list.size() : 0 %></strong> 名学生</span>
            <span>💡 点击「修改」可编辑学生信息 · 「删除」可移除记录</span>
        </div>
    </div>
</body>
</html>