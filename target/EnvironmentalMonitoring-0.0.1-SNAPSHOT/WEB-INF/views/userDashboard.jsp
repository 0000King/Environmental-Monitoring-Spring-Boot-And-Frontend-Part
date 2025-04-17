<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>User Dashboard - EcoSense</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', sans-serif;
            background-color: #e9f5e9;
        }

        .container {
            padding: 40px;
        }

        .input-section {
            margin-bottom: 20px;
        }

        input[type="text"] {
            width: 300px;
            padding: 10px;
            border-radius: 8px;
            border: 1px solid #ccc;
            font-size: 14px;
        }

        #map {
            width: 300px;
            height: 250px;
            margin-top: 10px;
            border-radius: 10px;
            border: 2px solid #4CAF50;
        }

        .button-group {
            margin-top: 30px;
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
        }

        .action-btn {
            background-color: #4CAF50;
            color: white;
            padding: 12px 20px;
            font-size: 14px;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .action-btn:hover {
            background-color: #2e7d32;
        }

        .action-bt {
            background-color: #4CAF50;
            color: white;
            padding: 12px 20px;
            font-size: 14px;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .action-bt:hover {
            background-color: #2e7d32;
        }

        h2 {
            color: #2e7d32;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>Welcome to Your Environmental Dashboard 🌍</h2>

    <div class="input-section" style="display: flex; gap: 20px; align-items: flex-start;">
        <!-- Left: Map and Location -->
        <div>
            <form id="locationForm">
                <label for="location">Enter Location:</label><br>
                <input type="text" id="location" name="location" placeholder="e.g., New York, NY" required/>
                <div id="map"></div>
            </form>
        </div>

        <!-- Right: LLM Prompt Box -->
        <div style="flex-grow: 1;">
            <label for="userPrompt">Ask EcoBot (LLM):</label><br>
            <textarea id="userPrompt" placeholder="e.g., What can you tell me about the air quality trend here?" rows="5"
                      style="width: 100%; padding: 10px; border-radius: 8px; font-size: 14px; resize: vertical;"></textarea>
            <button type="button" id="getInsightsBtn" class="action-bt" style="margin-top: 10px;">Get Insights 🧠</button>

            <div id="aiResponse"
                 style="margin-top: 15px; padding: 15px; background: #f1f8e9; border-radius: 10px; border: 1px solid #c5e1a5; min-height: 80px; max-height: none; overflow-y: auto; white-space: pre-wrap;">
                <i>EcoBot insights will appear here...</i>
            </div>
        </div>
    </div>

    <div class="button-group">
        <button class="action-btn" data-field="1">Fetch Temperature 🌡️</button>
        <button class="action-btn" data-field="2">Fetch Humidity 💧</button>
        <button class="action-btn" data-field="3">Fetch Air Quality 🌫️</button>
        <button class="action-btn" data-field="4">Fetch Water Quality 🚰</button>
    </div>

    <div id="chartWrapper" style="position: relative; height: 400px; width: 100%; margin-top: 40px;">
        <canvas id="dataChart" style="background: #fff; border-radius: 12px;"></canvas>
    </div>
    <input type="range" id="chartSlider"
               min="0" max="0" value="0" step="1"
               style="width: 100%; margin-top: 10px; height: 8px; background: #c8e6c9; border-radius: 5px;">
</div>

<script>
    let latestTemperature = null;
    let latestHumidity = null;
    let latestAirQuality = null;
    let latestWaterQuality = null;
    let map, marker, geocoder, autocomplete;
    let maxVisiblePoints = 20;
    let allLabels = [], allValues = [];
    let chart;
    let isAutoScroll = true;
    let autoRefreshInterval;

    function initMap() {
        const defaultLoc = { lat: 28.6139, lng: 77.2090 };
        map = new google.maps.Map(document.getElementById("map"), { center: defaultLoc, zoom: 10 });
        geocoder = new google.maps.Geocoder();
        marker = new google.maps.Marker({ map: map, position: defaultLoc, draggable: true });

        marker.addListener("dragend", function () {
            const pos = marker.getPosition();
            geocoder.geocode({ location: pos }, function (results, status) {
                if (status === "OK" && results[0]) {
                    document.getElementById("location").value = results[0].formatted_address;
                } else {
                    document.getElementById("location").value = `${pos.lat()},${pos.lng()}`;
                }
            });
        });

        autocomplete = new google.maps.places.Autocomplete(document.getElementById("location"));
    }

    function fetchData(endpoint, chartLabel) {
        const location = document.getElementById("location").value;
        if (!location) {
            alert("Please enter a location first!");
            return;
        }

        $.post(endpoint, { location: location }, function (data) {
            isAutoScroll = true;
            updateChart(data.labels, data.values, chartLabel);
            autoScrollChart();
        }).fail(function () {
            alert("Error fetching data from " + endpoint);
        });
    }

    function updateChart(labels, values, labelName) {
        allLabels = labels;
        allValues = values;

        const ctx = document.getElementById("dataChart").getContext("2d");
        let yMin = Math.min(...allValues);
        let yMax = Math.max(...allValues);

        const startIndex = Math.max(0, allLabels.length - maxVisiblePoints);
        const endIndex = allLabels.length;

        const visibleLabels = allLabels.slice(startIndex, endIndex);
        const visibleValues = allValues.slice(startIndex, endIndex);

        if (!chart) {
            chart = new Chart(ctx, {
                type: 'line',
                data: {
                    labels: visibleLabels,
                    datasets: [{
                        label: labelName,
                        data: visibleValues,
                        fill: false,
                        borderColor: '#4CAF50',
                        tension: 0.4,
                        pointBackgroundColor: '#2e7d32'
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    animation: { duration: 300, easing: 'linear' },
                    scales: {
                        x: { title: { display: true, text: 'Time' } },
                        y: {
                            min: yMin - 2,
                            max: yMax + 2,
                            title: { display: true, text: 'Value' }
                        }
                    }
                }
            });
        } else {
            chart.data.labels = visibleLabels;
            chart.data.datasets[0].label = labelName;
            chart.data.datasets[0].data = visibleValues;
            chart.options.scales.y.min = yMin - 2;
            chart.options.scales.y.max = yMax + 2;
            chart.update();
        }
        setupSlider();
    }

    function setupSlider() {
        const slider = document.getElementById("chartSlider");
        const dataSize = allLabels.length;

        if (dataSize > maxVisiblePoints) {
            slider.style.display = "block";
            slider.max = dataSize - maxVisiblePoints;
            slider.value = isAutoScroll ? slider.max : slider.value;
        } else {
            slider.style.display = "none";
        }

        slider.oninput = function () {
            const startIndex = parseInt(this.value);
            const endIndex = startIndex + maxVisiblePoints;
            isAutoScroll = (startIndex >= slider.max);
            chart.data.labels = allLabels.slice(startIndex, endIndex);
            chart.data.datasets[0].data = allValues.slice(startIndex, endIndex);
            chart.update();
        };
    }

    function autoScrollChart() {
        const slider = document.getElementById("chartSlider");
        if (isAutoScroll) {
            slider.value = slider.max;
            slider.oninput();
        }
    }

    document.getElementById("chartSlider").addEventListener("wheel", e => e.preventDefault());

    document.querySelectorAll(".action-btn").forEach(btn => {
        btn.addEventListener("click", function () {
            document.querySelectorAll(".action-btn").forEach(b => b.classList.remove("active"));
            this.classList.add("active");
            const label = this.textContent.trim();
            const fieldNumber = this.dataset.field;
            fetchThingSpeakData(fieldNumber, label);
        });
    });

    setInterval(() => {
        const activeButton = document.querySelector(".action-btn.active");
        if (activeButton) {
            const label = activeButton.textContent.trim();
            const fieldNumber = activeButton.dataset.field;
            fetchThingSpeakData(fieldNumber, label);
        }
    }, 10000);

    let userEmail = null;

    function promptForEmailIfNeeded() {
        if (userEmail === null) {
            userEmail = prompt("Please enter your email address to receive alerts and reports:");
            if (!userEmail || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(userEmail)) {
                alert("Invalid or empty email. Please enter a valid email.");
                userEmail = null;
                return false; // Don't proceed with processSensorData
            }
        }
        return true;
    }

    setInterval(function () {
        if (!promptForEmailIfNeeded()) return;
        $.ajax({
            url: "${pageContext.request.contextPath}/processSensorData",
            type: "POST",
            data: { email: userEmail },
            success: function (response) {
                console.log("Successfully hit /processSensorData:", response);
            },
            error: function (xhr, status, error) {
                console.error("Error hitting /processSensorData:", error);
            }
        });
    }, 15000);

    document.getElementById("getInsightsBtn").addEventListener("click", function () {
        const prompt = document.getElementById("userPrompt").value;
        const location = document.getElementById("location").value;

        if (!location) {
            alert("Please enter both a location and a question for EcoBot.");
            return;
        }

        let missing = [];
        if (latestTemperature === null) missing.push("Temperature");
        if (latestHumidity === null) missing.push("Humidity");
        if (latestAirQuality === null) missing.push("Air Quality");
        if (latestWaterQuality === null) missing.push("Water Quality");

        if (missing.length > 0) {
            alert("Please fetch the following sensor data before generating insights: " + missing.join(", "));
            return;
        }

        $.ajax({
            url: "https://environmental-monitoring-flask-part.onrender.com/generate-insights",
            type: "POST",
            contentType: "application/json",
            data: JSON.stringify({
                location: location,
                temperature: latestTemperature,
                humidity: latestHumidity,
                air: latestAirQuality,
                water: latestWaterQuality,
                prompt: prompt
            }),
            success: function (response) {
                response = response.insight || '';
                response = response.replace(/^\s*(Mini)[:\s]?/i, '');   // Remove "Mini" from start
                response = response.replace(/^User[:\s]?/i, '');  // Remove "User" from start
                response = response.replace(/User\s*$/i, '');
                document.getElementById("aiResponse").innerText = response.trim() || "No insights returned.";
            },
            error: function (xhr) {
                document.getElementById("aiResponse").innerText = "Error: Could not get insights from EcoBot.";
            }
        });
    });

    function fetchThingSpeakData(fieldNumber, labelName) {
        const channelId = "2869574";
        const readApiKey = "L7SKXVT4NY6KGM8O";

        const locationInput = document.getElementById("location").value.toLowerCase();
        if (!locationInput.includes("yamuna bank")) {
            alert("Data for the given location is not available. Please enter a location containing 'Delhi'.");
            return;
        }

        const url = "https://api.thingspeak.com/channels/" + channelId + "/fields/" + fieldNumber +
            ".json?api_key=" + readApiKey;

        $.get(url, function (response) {
            const labels = [];
            const values = [];

            response.feeds.forEach(entry => {
                if (entry[`field`+fieldNumber]) {
                    labels.push(entry.created_at);
                    values.push(parseFloat(entry[`field`+fieldNumber]));
                }
            });

            if (fieldNumber == 1) latestTemperature = values[values.length - 1];
            if (fieldNumber == 2) latestHumidity = values[values.length - 1];
            if (fieldNumber == 3) latestAirQuality = values[values.length - 1];
            if (fieldNumber == 4) latestWaterQuality = values[values.length - 1];

            updateChart(labels, values, labelName);
            autoScrollChart();

            $.ajax({
                url: "${pageContext.request.contextPath}/saveData",
                method: "POST",
                contentType: "application/json",
                data: JSON.stringify({
                    labelName: labelName,
                    values: values,
                    labels: labels
                }),
                success: function (res) {
                    console.log("Data sent to backend successfully:", res);
                },
                error: function (err) {
                    console.error("Error sending data to backend:", err);
                }
            });

        }).fail(function () {
            alert("Failed to fetch data from ThingSpeak.");
        });
    }
</script>

<!-- Google Maps Script -->
<script async defer
        src="https://maps.googleapis.com/maps/api/js?key=${googleMapsKey}&libraries=places&callback=initMap">
</script>

</body>
</html>
