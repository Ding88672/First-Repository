<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Excel批量导入</title>
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
            max-width: 600px;
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
        .card-header h2 {
            font-size: 24px;
            font-weight: 600;
            margin-bottom: 6px;
        }
        .card-header p {
            opacity: 0.85;
            font-size: 14px;
        }
        .card-body {
            padding: 32px;
        }
        .message {
            padding: 12px 16px;
            border-radius: 12px;
            margin-bottom: 24px;
            font-size: 14px;
        }
        .message-success {
            background: #d1fae5;
            color: #065f46;
            border-left: 4px solid #10b981;
        }
        .message-error {
            background: #fee2e2;
            color: #991b1b;
            border-left: 4px solid #ef4444;
        }
        .upload-area {
            border: 2px dashed #e2e8f0;
            border-radius: 16px;
            padding: 32px;
            text-align: center;
            margin-bottom: 24px;
            transition: all 0.2s;
            cursor: pointer;
        }
        .upload-area:hover {
            border-color: #667eea;
            background: #f8fafc;
        }
        .upload-icon {
            font-size: 48px;
            margin-bottom: 12px;
        }
        .upload-text {
            color: #64748b;
            font-size: 14px;
        }
        .upload-text strong {
            color: #667eea;
        }
        input[type="file"] {
            display: none;
        }
        .file-name {
            margin-top: 12px;
            font-size: 13px;
            color: #10b981;
            display: none;
        }
        .tip {
            background: #f8fafc;
            padding: 16px 20px;
            border-radius: 16px;
            margin-bottom: 24px;
            font-size: 13px;
            border: 1px solid #e2e8f0;
        }
        .tip h4 {
            font-size: 14px;
            font-weight: 600;
            color: #1e293b;
            margin-bottom: 12px;
        }
        .tip table {
            width: 100%;
            font-size: 12px;
            border-collapse: collapse;
        }
        .tip th, .tip td {
            padding: 6px 8px;
            text-align: left;
            border-bottom: 1px solid #e2e8f0;
        }
        .tip th {
            background: #f1f5f9;
            font-weight: 500;
        }
        .tip-note {
            margin-top: 12px;
            color: #f59e0b;
            font-size: 12px;
        }
        .btn-group {
            display: flex;
            gap: 12px;
        }
        .btn-submit {
            flex: 1;
            background: #10b981;
            color: white;
            border: none;
            padding: 12px;
            border-radius: 12px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
        }
        .btn-submit:hover {
            background: #059669;
            transform: translateY(-1px);
        }
        .btn-back {
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
        .btn-back:hover {
            background: #e2e8f0;
        }
        .example-row {
            font-family: monospace;
            font-size: 12px;
            background: #f1f5f9;
            padding: 8px 12px;
            border-radius: 8px;
            margin-top: 8px;
        }
    </style>
</head>
<body>
    <div class="card">
        <div class="card-header">
            <h2>📎 Excel批量导入</h2>
            <p>上传Excel文件，一键批量添加学生</p>
        </div>
        <div class="card-body">
            <!-- 提示消息 -->
            <%
                String message = (String) request.getAttribute("message");
                String error = (String) request.getAttribute("error");
                if (message != null) {
            %>
            <div class="message message-success">✅ <%= message %></div>
            <%
                }
                if (error != null) {
            %>
            <div class="message message-error">❌ <%= error %></div>
            <%
                }
            %>
            
            <!-- 上传表单 -->
            <form id="uploadForm" action="/studentmanager/ImportExcelServlet.do" method="post" enctype="multipart/form-data">
                <div class="upload-area" onclick="document.getElementById('excelFile').click()">
                    <div class="upload-icon">📂</div>
                    <div class="upload-text">
                        点击选择 <strong>Excel文件</strong> 或拖拽至此
                    </div>
                    <div class="upload-text" style="font-size: 12px; margin-top: 8px;">
                        支持 .xlsx 和 .xls 格式
                    </div>
                    <div id="fileName" class="file-name"></div>
                </div>
                <input type="file" id="excelFile" name="excelFile" accept=".xlsx,.xls" onchange="showFileName()">
                <div class="btn-group">
                    <button type="submit" class="btn-submit">📤 开始导入</button>
                    <button type="button" class="btn-back" onclick="location.href='/studentmanager/ListStudentServlet.do'">← 返回列表</button>
                </div>
            </form>
            
            <!-- 模板说明 -->
            <div class="tip">
                <h4>📋 Excel模板格式</h4>
                <table>
                    <tr>
                        <th>学号</th>
                        <th>姓名</th>
                        <th>性别</th>
                        <th>年龄</th>
                        <th>专业</th>
                        <th>年级</th>
                    </tr>
                    <tr>
                        <td>20210001</td>
                        <td>张三</td>
                        <td>男</td>
                        <td>20</td>
                        <td>计算机科学与技术</td>
                        <td>2021级</td>
                    </tr>
                    <tr>
                        <td>20210002</td>
                        <td>李四</td>
                        <td>女</td>
                        <td>19</td>
                        <td>软件工程</td>
                        <td>2021级</td>
                    </tr>
                </table>
                <div class="tip-note">
                    ⚠️ 注意：第1行为标题行（自动跳过），学号和姓名不能为空
                </div>
            </div>
        </div>
    </div>
    
    <script>
        function showFileName() {
            var input = document.getElementById('excelFile');
            var fileNameDiv = document.getElementById('fileName');
            if (input.files && input.files.length > 0) {
                fileNameDiv.innerHTML = '✅ 已选择：' + input.files[0].name;
                fileNameDiv.style.display = 'block';
            }
        }
    </script>
</body>
</html>