<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Chat Login</title>
<style>
*{box-sizing:border-box}
body{margin:0;font-family:Arial,sans-serif;background:linear-gradient(135deg,#667eea,#764ba2);
display:flex;justify-content:center;align-items:center;min-height:100vh}
.card{width:360px;background:#fff;padding:35px;border-radius:18px;box-shadow:0 15px 40px rgba(0,0,0,.25)}
h1{text-align:center;margin:0 0 8px;color:#222}
p{text-align:center;color:#777}
input{width:100%;padding:13px;margin:15px 0;border:1px solid #ddd;border-radius:8px;font-size:15px}
button{width:100%;padding:13px;border:0;border-radius:8px;background:#4f6df5;color:#fff;font-size:16px;cursor:pointer}
.error{color:#d93025!important;font-size:14px}
</style>
</head>
<body>
<div class="card">
    <h1>💬 Chat System</h1>
    <p>Login to start chatting</p>
    <form action="login" method="post">
        <input type="text" name="username" placeholder="Enter username" required>
        <button type="submit">Login</button>
    </form>
    <%
        String error = request.getParameter("error");
        if (error != null) {
    %>
        <p class="error"><%= error %></p>
    <% } %>
</div>
</body>
</html>
