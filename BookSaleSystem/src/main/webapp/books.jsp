<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>书籍浏览 - 图书销售系统</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="container">
        <h1 class="header">书籍浏览</h1>
        
        <div class="nav">
            <a href="index.jsp">首页</a>
            <a href="books.jsp">书籍浏览</a>
            <a href="cart.jsp">购物车</a>
        </div>

        <div class="user-info">
            <% 
                String username = (String) session.getAttribute("username");
                if(username != null) { 
            %>
                欢迎您，<%=username%>！<a href="logout">【退出登录】</a>
            <% } else { %>
                您还未登录！<a href="login.jsp">【立即登录】</a>
            <% } %>
        </div>

        <div style="margin-top: 50px; text-align: center;">
            <h3>热门图书列表</h3>
            <p>Java编程思想、Spring实战、MySQL从入门到精通...</p>
        </div>
    </div>
</body>
</html>