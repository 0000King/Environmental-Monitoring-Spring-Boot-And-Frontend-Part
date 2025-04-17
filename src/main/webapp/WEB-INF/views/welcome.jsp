<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Welcome to Environmental Monitoring</title>
    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(to bottom right, #a8edea, #fed6e3);
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        .welcome-container {
            text-align: center;
            background-color: rgba(255,255,255,0.85);
            padding: 40px;
            border-radius: 25px;
            box-shadow: 0 8px 16px rgba(0,0,0,0.2);
        }

        h1 {
            font-size: 36px;
            margin-bottom: 20px;
            color: #2c3e50;
        }

        p {
            font-size: 18px;
            color: #34495e;
            margin-bottom: 30px;
        }

        .env-images {
            display: flex;
            justify-content: center;
            gap: 15px;
            flex-wrap: wrap;
            margin-bottom: 30px;
        }

        .env-images img {
            width: 120px;
            height: 120px;
            object-fit: cover;
            border-radius: 12px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }

        .login-btn {
            padding: 12px 30px;
            font-size: 16px;
            border: none;
            background-color: #27ae60;
            color: white;
            border-radius: 10px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .login-btn:hover {
            background-color: #1e8449;
        }
    </style>
</head>
<body>
<div class="welcome-container">
    <h1>Welcome to EcoSense</h1>
    <p>Your smart companion for monitoring the environment in real-time.<br>
        Stay informed. Stay safe. Stay sustainable.</p>
    <div class="env-images">
        <div class="env-images">
            <img src="<%= request.getContextPath() %>/images/first.jpg" alt="Air Quality">
            <img src="<%= request.getContextPath() %>/images/second.jpg" alt="Water Quality">
            <img src="<%= request.getContextPath() %>/images/third.jpg" alt="Humidity">
            <img src="<%= request.getContextPath() %>/images/fourth.jpg" alt="Temperature">
        </div>
    </div>

    <form action="/login" method="get">
        <button class="login-btn">Get Started</button>
    </form>
</div>
</body>
</html>
