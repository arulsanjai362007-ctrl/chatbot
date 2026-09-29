package com.chat;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/getMessages")
public class GetMessagesServlet extends HttpServlet {

    private String jsonEscape(String value) {
        if (value == null) return "";
        return value.replace("\\", "\\\\")
                    .replace("\"", "\\\"")
                    .replace("\r", "\\r")
                    .replace("\n", "\\n");
    }

    @Override
    protected void doGet(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().print("[]");
            return;
        }

        String sender = (String) session.getAttribute("username");
        String receiver = request.getParameter("receiver");

        if (receiver == null || receiver.trim().isEmpty()) {
            response.getWriter().print("[]");
            return;
        }

        String sql =
            "SELECT sender, receiver, message, message_time " +
            "FROM messages " +
            "WHERE (sender=? AND receiver=?) OR (sender=? AND receiver=?) " +
            "ORDER BY message_time ASC";

        StringBuilder json = new StringBuilder("[");
        boolean first = true;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, sender);
            ps.setString(2, receiver.trim());
            ps.setString(3, receiver.trim());
            ps.setString(4, sender);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    if (!first) json.append(",");
                    first = false;

                    json.append("{")
                        .append("\"sender\":\"").append(jsonEscape(rs.getString("sender"))).append("\",")
                        .append("\"receiver\":\"").append(jsonEscape(rs.getString("receiver"))).append("\",")
                        .append("\"message\":\"").append(jsonEscape(rs.getString("message"))).append("\",")
                        .append("\"time\":\"").append(jsonEscape(rs.getTimestamp("message_time").toString())).append("\"")
                        .append("}");
                }
            }

            json.append("]");
            response.getWriter().print(json);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().print("[]");
        }
    }
}
