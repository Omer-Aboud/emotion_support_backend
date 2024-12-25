from flask import Flask, request, jsonify
from flask_mysql import MySQL
import pandas as pd

app = Flask(__name__)

# MySQL Configuration
app.config.from_pyfile('config.py')
mysql = MySQL(app)

@app.route('/')
def home():
    return 'Emotion Support Bot Backend Running!'

# Route to add a new user
@app.route('/add_user', methods=['POST'])
def add_user():
    data = request.get_json()
    name = data['name']
    email = data['email']
    password_hash = data['password_hash']
    
    conn = mysql.connect()
    cursor = conn.cursor()
    cursor.execute("INSERT INTO Users (name, email, password_hash) VALUES (%s, %s, %s)", (name, email, password_hash))
    conn.commit()
    cursor.close()
    conn.close()
    
    return jsonify({"message": "User added successfully!"}), 201

# Route to get user interactions
@app.route('/get_interactions', methods=['GET'])
def get_interactions():
    user_id = request.args.get('user_id')
    
    conn = mysql.connect()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM Interactions WHERE user_id = %s", (user_id,))
    result = cursor.fetchall()
    cursor.close()
    conn.close()
    
    return jsonify(result), 200

# Route to import CSV data into the database
@app.route('/import_csv', methods=['POST'])
def import_csv():
    file = request.files['file']
    if file:
        df = pd.read_csv(file)
        # Assuming the CSV has the same structure as the Interactions table
        conn = mysql.connect()
        cursor = conn.cursor()
        for index, row in df.iterrows():
            cursor.execute("INSERT INTO Interactions (user_id, interaction_type, emotion_detected, response_generated) VALUES (%s, %s, %s, %s)",
                           (row['user_id'], row['interaction_type'], row['emotion_detected'], row['response_generated']))
        conn.commit()
        cursor.close()
        conn.close()
        return jsonify({"message": "CSV data imported successfully!"}), 200
    return jsonify({"message": "No file provided"}), 400

if __name__ == '__main__':
    app.run(debug=True)
