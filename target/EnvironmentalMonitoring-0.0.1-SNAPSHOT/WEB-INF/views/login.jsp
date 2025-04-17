<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Login - Environmental Monitoring</title>
    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', sans-serif;
            background-color: #d4edda; /* soft light green */
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        .login-container {
            background-color: #ffffff;
            padding: 40px 50px;
            border-radius: 20px;
            box-shadow: 0 8px 16px rgba(0,0,0,0.2);
            text-align: center;
            width: 350px;
        }

        .login-container h2 {
            color: #2e7d32;
            margin-bottom: 30px;
        }

        input[type="text"], input[type="password"] {
            width: 100%;
            padding: 12px;
            margin: 10px 0 20px;
            border: 1px solid #ccc;
            border-radius: 10px;
            font-size: 14px;
        }

        .login-btn {
            background-color: #2e7d32;
            color: white;
            border: none;
            padding: 12px 20px;
            width: 100%;
            font-size: 16px;
            border-radius: 10px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .login-btn:hover {
            background-color: #1b5e20;
        }

        .eco-icon {
            width: 60px;
            height: 60px;
            margin-bottom: 15px;
        }

        .error {
            color: red;
            font-size: 14px;
            text-align: center;
            margin-top: 10px;
        }

        .footer {
            margin-top: 20px;
            font-size: 12px;
            color: #666;
        }
    </style>
</head>
<body>
<div class="login-container">
    <img src="https://cdn-icons-png.flaticon.com/512/2920/2920069.png" class="eco-icon" alt="Eco Icon">
    <h2>Login to EcoSense</h2>

    <% String error = (String) request.getAttribute("error"); %>
    <% if (error != null) { %>
    <p class="error"><%= error %></p>
    <% } %>

    <form action="/login" method="post">
        <input type="text" name="username" placeholder="Username" required />
        <input type="password" name="password" placeholder="Password" required />
        <button class="login-btn" type="submit">Login</button>
    </form>

    <div class="footer">
        <p>Keeping you connected to nature 🌿</p>
    </div>
</div>
</body>
</html>
