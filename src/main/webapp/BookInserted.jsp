<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<html>
<head>
    <title>Book Inserted</title>
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
            max-width: 400px;
            width: 100%;
            text-align: center;
            margin: 20px 0;
            backdrop-filter: blur(10px);
            animation: fadeIn 1s ease-in-out;
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
    <%
        String url = "jdbc:postgresql://aws-0-eu-central-1.pooler.supabase.com:6543/postgres?prepareThreshold=0";
        String username = "postgres.qdjxxuwtzklxnjbmdbut";
        String password = "1Lmeknakh84!";

        String firstName = request.getParameter("first_name");
        String lastName = request.getParameter("last_name");
        String teacherName = request.getParameter("teacher_name");
        String schoolName = request.getParameter("school_name");
        String className = request.getParameter("class");
        String title = request.getParameter("title");
        String author = request.getParameter("author");
        String dateRead = request.getParameter("date_read");

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            Class.forName("org.postgresql.Driver");
            conn = DriverManager.getConnection(url, username, password);

            // Check if classschool entry exists
            String checkClassSchool = "SELECT class_id FROM classschool WHERE class_name = ? AND teacher_name = ? AND school_name = ?";
            pstmt = conn.prepareStatement(checkClassSchool);
            pstmt.setString(1, className);
            pstmt.setString(2, teacherName);
            pstmt.setString(3, schoolName);
            rs = pstmt.executeQuery();

            int classId;
            if (rs.next()) {
                classId = rs.getInt("class_id");
            } else {
                // Insert into classschool table if not exists
                String insertClassSchool = "INSERT INTO classschool (class_name, teacher_name, school_name) VALUES (?, ?, ?) RETURNING class_id";
                pstmt = conn.prepareStatement(insertClassSchool);
                pstmt.setString(1, className);
                pstmt.setString(2, teacherName);
                pstmt.setString(3, schoolName);
                rs = pstmt.executeQuery();
                rs.next();
                classId = rs.getInt("class_id");
            }

            // Insert into students table if not exists
            String insertStudent = "INSERT INTO students (first_name, last_name, class_id) VALUES (?, ?, ?) ON CONFLICT DO NOTHING";
            pstmt = conn.prepareStatement(insertStudent);
            pstmt.setString(1, firstName);
            pstmt.setString(2, lastName);
            pstmt.setInt(3, classId);
            pstmt.executeUpdate();

            // Insert into books table
            String insertBook = "INSERT INTO books (title, author, student_id, date_read) VALUES (?, ?, (SELECT student_id FROM students WHERE first_name = ? AND last_name = ? AND class_id = ? LIMIT 1), ?)";
            pstmt = conn.prepareStatement(insertBook);
            pstmt.setString(1, title);
            pstmt.setString(2, author);
            pstmt.setString(3, firstName);
            pstmt.setString(4, lastName);
            pstmt.setInt(5, classId);
            pstmt.setDate(6, Date.valueOf(dateRead));

            int bookRows = pstmt.executeUpdate();
            out.println("<p>Books rows affected: " + bookRows + "</p>");

            if (bookRows > 0) {
                out.println("<h1>Book inserted successfully!</h1>");
                out.println("<button class='back-button' onclick=\"window.location.href='MainMenu.html'\">Back to Main Menu</button>");
            } else {
                out.println("<h1>Failed to insert book.</h1>");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<h1>Error: " + e.getMessage() + "</h1>");
        } finally {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        }
    %>
</div>
</body>
</html>