# 🚇 AI Metro Companion Assistant

A smart metro journey planning and ticket booking web application built using **Python, Flask, MySQL, HTML and CSS**.

The application helps users select a city, find metro routes between stations, calculate fare, distance and travel time, and book metro tickets with a QR code.

## ✨ Features

- 🏙️ Supports multiple metro cities
- 🚉 Source and destination station selection
- 🗺️ Metro route finding using BFS algorithm
- 💰 Automatic fare calculation
- 📏 Distance calculation
- ⏱️ Estimated travel time
- 🔄 Interchange station detection
- 🤖 AI-based travel suggestion
- 🎫 Metro ticket booking
- 💳 Payment method selection
- 🧾 Booking confirmation
- 📱 QR code ticket generation
- 🗄️ MySQL database integration
- 📱 Responsive web interface
- 🎨 City-specific metro theme colors

## 🏙️ Supported Cities

- Hyderabad
- Bengaluru
- Delhi
- Chennai

## 🛠️ Technologies Used

- Python
- Flask
- MySQL
- MySQL Workbench
- HTML5
- CSS3
- Jinja2
- BFS (Breadth-First Search)
- QR Code Generation

## 🧠 Route Finding Algorithm

The application uses the **Breadth-First Search (BFS)** algorithm to find a route between the selected source and destination stations.

The metro stations are represented as nodes and the connections between stations are represented as edges.

## 🗄️ Database

The application uses **MySQL** for storing metro station, route and booking information.

Main database:

```text
metro_companion