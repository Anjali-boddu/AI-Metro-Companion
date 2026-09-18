from flask import Flask, render_template, request
from db import get_connection
from collections import deque
import qrcode
import os

app = Flask(__name__)

# ---------------- BFS Algorithm ----------------
def bfs(graph, start, end):

    queue = deque([[start]])
    visited = set()

    while queue:

        path = queue.popleft()
        node = path[-1]

        if node == end:
            return path

        if node not in visited:
            visited.add(node)

            for neighbour in graph.get(node, []):
                new_path = list(path)
                new_path.append(neighbour)
                queue.append(new_path)

    return None


# ---------------- Home Page ----------------
@app.route("/")
def home():
    return render_template("index.html")


# ---------------- City Selection ----------------
@app.route("/stations", methods=["POST"])
def stations():

    city = request.form["city"]

    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute(
        "SELECT station_name FROM stations1 WHERE city=%s ORDER BY station_name",
        (city,)
    )

    stations = cursor.fetchall()

    cursor.close()
    conn.close()

    return render_template(
        "stations.html",
        city=city,
        stations=stations
    )

# ---------------- Route Finder ----------------
@app.route("/route", methods=["POST"])
def route():

    source = request.form["source"]
    destination = request.form["destination"]

    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        SELECT
            s1.station_name AS source,
            s2.station_name AS destination
        FROM routes1 r
        JOIN stations1 s1
            ON r.source_station = s1.station_id
        JOIN stations1 s2
            ON r.destination_station = s2.station_id
    """)

    graph = {}

    for row in cursor.fetchall():
        graph.setdefault(row["source"], []).append(row["destination"])
        graph.setdefault(row["destination"], []).append(row["source"])

    path = bfs(graph, source, destination)

    if path is None:
        cursor.close()
        conn.close()

        return render_template(
            "result.html",
            source=source,
            destination=destination,
            path=[]
        )

    total_fare = 0
    total_distance = 0
    total_time = 0

    for i in range(len(path)-1):

        cursor.execute("""
            SELECT fare, distance, travel_time
            FROM routes1 r
            JOIN stations1 s1
                ON r.source_station = s1.station_id
            JOIN stations1 s2
                ON r.destination_station = s2.station_id
            WHERE
            (s1.station_name=%s AND s2.station_name=%s)
            OR
            (s1.station_name=%s AND s2.station_name=%s)
        """, (path[i], path[i+1], path[i+1], path[i]))

        row = cursor.fetchone()

        if row:
            total_fare += row["fare"]
            total_distance += row["distance"]
            total_time += row["travel_time"]

    total_stations = len(path) - 1

    interchange_stations = []

    red_line = [
        "Miyapur","JNTU College","KPHB Colony","Kukatpally","Balanagar",
        "Moosapet","Bharat Nagar","Erragadda","ESI Hospital","SR Nagar",
        "Ameerpet","Punjagutta","Irrum Manzil","Khairatabad","Lakdikapul",
        "Assembly","Nampally","Gandhi Bhavan","Osmania Medical College",
        "MG Bus Station","Malakpet","New Market","Musarambagh",
        "Dilsukhnagar","Chaitanyapuri","Victoria Memorial","LB Nagar"
    ]

    blue_line = [
        "Begumpet","Prakash Nagar","Rasoolpura","Paradise",
        "Secunderabad East","Mettuguda","Tarnaka","Habsiguda",
        "NGRI","Stadium","Uppal","Nagole",
        "Madhura Nagar","Yousufguda",
        "Jubilee Hills Check Post","Pedamma Temple",
        "Madhapur","Durgam Cheruvu","Hitech City","Raidurg"
    ]

    has_red = any(station in red_line for station in path)
    has_blue = any(station in blue_line for station in path)

    if has_red and has_blue:
        interchange_stations.append("Ameerpet")

    if total_time <= 20:
        suggestion = "Short journey. Have a safe trip."
    elif total_time <= 45:
        suggestion = "Moderate journey. Reach station 5 minutes early."
    else:
        suggestion = "Long journey. Plan extra travel time."

    cursor.close()
    conn.close()

    return render_template(
        "result.html",
        source=source,
        destination=destination,
        path=path,
        total_fare=total_fare,
        total_distance=total_distance,
        total_time=total_time,
        total_stations=total_stations,
        interchange=interchange_stations,
        suggestion=suggestion
    )
    
@app.route("/ticket", methods=["POST"])
def ticket():

    source = request.form["source"]
    destination = request.form["destination"]
    fare = request.form["fare"]

    return render_template(
        "ticket.html",
        source=source,
        destination=destination,
        fare=fare
    )

@app.route("/payment", methods=["POST"])
def payment():

    name = request.form["name"]
    tickets = int(request.form["tickets"])
    source = request.form["source"]
    destination = request.form["destination"]
    fare = float(request.form["fare"])

    total_fare = fare * tickets

    return render_template(
        "payment.html",
        name=name,
        source=source,
        destination=destination,
        tickets=tickets,
        fare=fare,
        total_fare=total_fare
    )


@app.route("/confirm_booking", methods=["POST"])
def confirm_booking():

    print(request.form)
    
    name = request.form["name"]
    tickets = int(request.form["tickets"])
    source = request.form["source"]
    destination = request.form["destination"]
    fare = float(request.form["fare"])
    payment_method = request.form["payment"]
    total_fare = fare* tickets
    conn = get_connection()
    cursor = conn.cursor()

    cursor.execute("""
        INSERT INTO bookings
        (passenger_name, source_station, destination_station,
         tickets, total_fare, payment_method, booking_date, booking_time)
        VALUES (%s,%s,%s,%s,%s,%s,CURDATE(),CURTIME())
    """, (
        name,
        source,
        destination,
        tickets,
        total_fare,
        payment_method
    ))

    conn.commit()

    booking_id = cursor.lastrowid

        # -------- Generate QR Code --------
    qr_data = f"""
Booking ID: {booking_id}
Passenger: {name}
From: {source}
To: {destination}
Tickets: {tickets}
Total Fare: ₹{total_fare}
"""

    img = qrcode.make(qr_data)

    os.makedirs("static/qr_codes", exist_ok=True)

    qr_filename = f"booking_{booking_id}.png"

    img.save(f"static/qr_codes/{qr_filename}")

    cursor.close()
    conn.close()

    return render_template(
       "booking_success.html",
        booking_id=booking_id,
        name=name,
        source=source,
        destination=destination,
        tickets=tickets,
        total_fare=total_fare,
        payment_method=payment_method,
        qr_filename=qr_filename
    )

if __name__=="__main__":
    app.run(debug=True)