
from flask import request, jsonify
from app import  app

# For simplicity, let's create a mock user database as a dictionary
users = {
    "user@example.com": "password123"
}

@app.route('/login', methods=['POST'])
def login():
    email = request.json.get('email')
    password = request.json.get('password')
    
    # Check if the user exists and the password is correct
    if email in users and users[email] == password:
        return jsonify({"status": "success", "message": "Logged in successfully"}), 200
    else:
        return jsonify({"status": "error", "message": "Invalid credentials"}), 401

if __name__ == '__main__':
    app.run(debug=True)
