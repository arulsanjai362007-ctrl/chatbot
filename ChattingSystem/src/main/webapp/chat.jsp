<%@ page session="true" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Chat System</title>
<style>
*{box-sizing:border-box}
body{margin:0;font-family:Arial,sans-serif;background:#eef2f7}
.chat{width:min(700px,95%);margin:30px auto;background:#fff;border-radius:18px;overflow:hidden;box-shadow:0 10px 35px rgba(0,0,0,.15)}
.header{background:#4f6df5;color:white;padding:18px 22px}
.header h2{margin:0}.header small{opacity:.9}
.top{padding:15px;background:#f8f9fc;border-bottom:1px solid #eee}
.top input{width:100%;padding:12px;border:1px solid #ddd;border-radius:8px}
#messages{height:430px;overflow-y:auto;padding:20px;background:#f4f6f8}
.msg{max-width:70%;padding:10px 13px;margin:8px 0;border-radius:13px;word-wrap:break-word}
.sent{margin-left:auto;background:#d9e6ff}.received{background:#fff}
.name{font-weight:bold;font-size:12px;color:#555}.time{font-size:10px;color:#888}
.send{display:flex;gap:10px;padding:15px;border-top:1px solid #eee}
.send input{flex:1;padding:12px;border:1px solid #ddd;border-radius:8px}
.send button{padding:12px 20px;border:0;border-radius:8px;background:#4f6df5;color:white;cursor:pointer}
.hint{text-align:center;color:#888;padding:40px}
</style>
</head>
<body>
<div class="chat">
    <div class="header">
        <h2>💬 Chat System</h2>
        <small>Logged in as <b><%= username %></b></small>
    </div>

    <div class="top">
        <input id="receiver" type="text" placeholder="Enter receiver username" oninput="loadMessages()">
    </div>

    <div id="messages">
        <div class="hint">Enter a receiver username to start chatting.</div>
    </div>

    <div class="send">
        <input id="message" type="text" placeholder="Type your message..." onkeypress="handleEnter(event)">
        <button onclick="sendMessage()">Send</button>
    </div>
</div>

<script>
const currentUser = "<%= username %>";

function sendMessage(){
    const receiver=document.getElementById("receiver").value.trim();
    const message=document.getElementById("message").value.trim();

    if(!receiver || !message){
        alert("Enter receiver and message");
        return;
    }

    const xhr=new XMLHttpRequest();
    xhr.open("POST","sendMessage",true);
    xhr.setRequestHeader("Content-Type","application/x-www-form-urlencoded");

    xhr.onload=function(){
        if(xhr.responseText==="success"){
            document.getElementById("message").value="";
            loadMessages();
        }else if(xhr.responseText==="login"){
            window.location="login.jsp";
        }else{
            alert("Message could not be sent");
        }
    };

    xhr.send("receiver="+encodeURIComponent(receiver)+"&message="+encodeURIComponent(message));
}

function loadMessages(){
    const receiver=document.getElementById("receiver").value.trim();
    if(!receiver) return;

    const xhr=new XMLHttpRequest();
    xhr.open("GET","getMessages?receiver="+encodeURIComponent(receiver),true);

    xhr.onload=function(){
        if(xhr.status!==200) return;

        const messages=JSON.parse(xhr.responseText);
        let html="";

        if(messages.length===0){
            html='<div class="hint">No messages yet. Send the first message!</div>';
        }else{
            messages.forEach(function(msg){
                const cls=msg.sender===currentUser ? "sent" : "received";
                html+='<div class="msg '+cls+'">';
                html+='<div class="name">'+escapeHtml(msg.sender)+'</div>';
                html+='<div>'+escapeHtml(msg.message)+'</div>';
                html+='<div class="time">'+escapeHtml(msg.time)+'</div>';
                html+='</div>';
            });
        }

        document.getElementById("messages").innerHTML=html;
        const box=document.getElementById("messages");
        box.scrollTop=box.scrollHeight;
    };

    xhr.send();
}

function escapeHtml(text){
    const div=document.createElement("div");
    div.textContent=text;
    return div.innerHTML;
}

function handleEnter(event){
    if(event.key==="Enter") sendMessage();
}

setInterval(loadMessages,2000);
</script>
</body>
</html>
