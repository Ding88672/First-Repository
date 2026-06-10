<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>新增学生</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 20px;
        }
        .card {
            max-width: 550px;
            width: 100%;
            background: white;
            border-radius: 28px;
            box-shadow: 0 25px 50px -12px rgba(0,0,0,0.25);
            overflow: hidden;
        }
        .card-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 28px 32px;
            color: white;
        }
        .card-header h2 { font-size: 24px; font-weight: 600; margin-bottom: 6px; }
        .card-header p { opacity: 0.85; font-size: 14px; }
        .card-body { padding: 32px; }
        .form-group { margin-bottom: 20px; }
        label { display: block; font-weight: 500; color: #1e293b; margin-bottom: 8px; font-size: 14px; }
        input, select {
            width: 100%;
            padding: 12px 16px;
            border: 1.5px solid #e2e8f0;
            border-radius: 12px;
            font-size: 14px;
            font-family: inherit;
            transition: all 0.2s;
        }
        input:focus, select:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        .error {
            background: #fee2e2;
            color: #dc2626;
            padding: 12px 16px;
            border-radius: 12px;
            margin-bottom: 20px;
            font-size: 14px;
        }
        .btn-group { display: flex; gap: 12px; margin-top: 28px; }
        .btn-submit {
            flex: 1;
            background: #667eea;
            color: white;
            border: none;
            padding: 12px;
            border-radius: 12px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
        }
        .btn-submit:hover { background: #5a67d8; transform: translateY(-1px); }
        .btn-cancel {
            flex: 1;
            background: #f1f5f9;
            color: #475569;
            border: none;
            padding: 12px;
            border-radius: 12px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
        }
        .btn-cancel:hover { background: #e2e8f0; }
    </style>
</head>
<body>
    <div class="card">
        <div class="card-header">
            <h2>➕ 新增学生</h2>
            <p>填写学生信息，点击提交保存</p>
        </div>
        <div class="card-body">
            <% if (request.getAttribute("error") != null) { %>
                <div class="error">⚠️ <%= request.getAttribute("error") %></div>
            <% } %>
            <form action="DoInsertStudentServlet.do" method="post">
                <div class="form-group">
                    <label>学号 <span style="color:#ef4444;">*</span></label>
                    <input type="text" name="studentId" placeholder="例：20210001" required>
                </div>
                <div class="form-group">
                    <label>姓名 <span style="color:#ef4444;">*</span></label>
                    <input type="text" name="name" placeholder="例：张三" required>
                </div>
                <div class="form-group">
                    <label>性别</label>
                    <select name="gender">
                        <option value="男">男</option>
                        <option value="女">女</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>年龄</label>
                    <input type="number" name="age" placeholder="例：20">
                </div>
                <div class="form-group">
                    <label>专业</label>
                    <input type="text" name="major" placeholder="例：计算机科学与技术">
                </div>
                <div class="form-group">
                    <label>年级</label>
                    <input type="text" name="grade" placeholder="例：2021级">
                </div>
                <div class="btn-group">
                    <button type="submit" class="btn-submit">✓ 提交</button>
                    <button type="button" class="btn-cancel" onclick="location.href='ListStudentServlet.do'">↩ 返回</button>
                </div>
            </form>
        </div>
    </div>
</body>
</html>