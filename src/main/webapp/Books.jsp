<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>See What Others Are Reading</title>
  <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&family=Pacifico&display=swap" rel="stylesheet">
  <style>
    body {
      margin: 0;
      padding: 0;
      font-family: 'Roboto', sans-serif;
      background: url('https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcTh7Cwi2JNkXsec4EzZYU1X4i5AuvebmgXsetOI6zGpSP6Z0huJ') no-repeat center center fixed;
      background-size: cover;
      display: flex;
      justify-content: center;
      align-items: center;
      height: 100vh;
      color: #333;
    }
    .form-container {
      background: rgba(255, 255, 255, 0.8);
      padding: 40px;
      border-radius: 10px;
      box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
      max-width: 90%; /* Adjusted width */
      width: 100%;
      text-align: center;
      margin: 20px 0;
      backdrop-filter: blur(10px);
      animation: fadeIn 1s ease-in-out;
      overflow-x: auto; /* Added horizontal scrolling */
    }
    @keyframes fadeIn {
      from { opacity: 0; }
      to { opacity: 1; }
    }
    .form-container h1 {
      font-family: 'Pacifico';
      color: #4CAF50;
      margin-bottom: 20px;
    }
    .form-container input, .form-container button {
      width: 100%;
      padding: 10px;
      margin: 10px 0;
      border: 1px solid #ccc;
      border-radius: 5px;
    }
    .form-container button {
      background-color: #4CAF50;
      color: white;
      border: none;
      cursor: pointer;
    }
    .form-container button:hover {
      background-color: #45a049;
    }
    table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 20px;
    }
    table, th, td {
      border: 1px solid #ccc;
    }
    th, td {
      padding: 10px;
      text-align: left;
    }
    th {
      background-color: #f2f2f2;
    }
    .back-button {
      margin-top: 20px;
      background-color: #008080;
      color: white;
      border: none;
      padding: 10px 20px;
      border-radius: 5px;
      cursor: pointer;
    }
    .back-button:hover {
      background-color: #006666;
    }
  </style>
</head>
<body>
<div class="form-container">
  <h1>See What Others Are Reading</h1>
  <form method="post">
    <input type="text" name="class_name" placeholder="Class Name" required>
    <button type="submit">Search</button>
  </form>

  <%
    String url = "jdbc:postgresql://aws-0-eu-central-1.pooler.supabase.com:6543/postgres?prepareThreshold=0";
    String username = "postgres.qdjxxuwtzklxnjbmdbut";
    String password = "1Lmeknakh84!";

    String className = request.getParameter("class_name");

    if (className != null) {
      Connection conn = null;
      PreparedStatement pstmt = null;
      ResultSet rs = null;

      try {
        Class.forName("org.postgresql.Driver");
        conn = DriverManager.getConnection(url, username, password);

        String sql = "SELECT s.first_name, s.last_name, cs.class_name AS class, b.title, b.author, b.date_read, cs.teacher_name AS teacher, cs.school_name AS school " +
                "FROM books b " +
                "JOIN students s ON b.student_id = s.student_id " +
                "JOIN classschool cs ON s.class_id = cs.class_id " +
                "WHERE cs.class_name = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, className);
        rs = pstmt.executeQuery();

        out.println("<table>");
        out.println("<tr><th>First Name</th><th>Last Name</th><th>Class</th><th>Title</th><th>Author</th><th>Date Read</th><th>Teacher</th><th>School</th></tr>");
        while (rs.next()) {
          out.println("<tr>");
          out.println("<td>" + rs.getString("first_name") + "</td>");
          out.println("<td>" + rs.getString("last_name") + "</td>");
          out.println("<td>" + rs.getString("class") + "</td>");
          out.println("<td>" + rs.getString("title") + "</td>");
          out.println("<td>" + rs.getString("author") + "</td>");
          out.println("<td>" + rs.getDate("date_read") + "</td>");
          out.println("<td>" + rs.getString("teacher") + "</td>");
          out.println("<td>" + rs.getString("school") + "</td>");
          out.println("</tr>");
        }
        out.println("</table>");
      } catch (Exception e) {
        e.printStackTrace();
        out.println("<h1>Error: " + e.getMessage() + "</h1>");
      } finally {
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
      }
    }
  %>
  <button class="back-button" onclick="window.location.href='MainMenu.html'">Back to Main Menu</button>
</div>
</body>
</html>