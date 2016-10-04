import psycopg2
from flask import Flask
app = Flask(__name__)

def greedy():
  host = "host="+'192.168.56.54'+" "
  port = "port="+str(5432)+" "
  db = "dbname="+'swn'+" "
  user = "user="+'pi'+" "
  passwd = "password="+'security++'+" "

  conn_string = host+port+db+user+passwd
  conn = psycopg2.connect(conn_string)
  cursor = conn.cursor()
  cursor.execute("SELECT * FROM devices")
  records = cursor.fetchall()
  return "value: "+str(records)

@app.route("/hi")
def hi():
    return "Hi!, I am a greedy algorithm"

@app.route("/greedy")
def greedy():
  host = "host="+'192.168.56.54'+" "
  port = "port="+str(5432)+" "
  db = "dbname="+'swn'+" "
  user = "user="+'pi'+" "
  passwd = "password="+'security++'+" "

  conn_string = host+port+db+user+passwd
  conn = psycopg2.connect(conn_string)
  cursor = conn.cursor()
  cursor.execute("SELECT * FROM devices")
  records = cursor.fetchall()
  return "value: "+str(records)

if __name__ == "__main__":
    app.run('192.168.56.51', port=80)