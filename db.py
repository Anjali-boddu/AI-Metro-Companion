import mysql.connector

def get_connection():
    connection = mysql.connector.connect(
        host="localhost",
        user="root",
        password="Anjali@2007",
        database="metro_companion"
    )
    return connection