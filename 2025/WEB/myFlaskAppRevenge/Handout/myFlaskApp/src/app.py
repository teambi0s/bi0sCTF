from flask import Flask, request, jsonify, session, render_template, redirect
from functools import wraps
from pymongo import MongoClient
from bson.objectid import ObjectId
import os
from bot import visit

# Initialize MongoDB

client = MongoClient(os.getenv("MONGO_URI", "mongodb://localhost:27017/"))


def init_db():
    db = client["user_db"]
    users_collection = db["users"]
    # create an admin user if it doesn't exist
    if not users_collection.find_one({"username": "admin"}):
        users_collection.insert_one(
            {
                "username": "admin",
                "password": os.getenv("ADMIN_PASSWORD", "admin"),
                "bio": "",
            }
        )
        print("Admin user created with default password.")
    return users_collection


app = Flask(__name__)

# set session sercret key
app.config["SECRET_KEY"] = os.urandom(24)


# set CSP header for all responses
@app.after_request
def set_csp(response):
    response.headers["Content-Security-Policy"] = (
        "default-src 'self'; script-src 'self' 'unsafe-eval'; style-src 'self' ;"
    )
    return response


def login_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if "username" not in session:  # Check if user is logged in
            return jsonify({"error": "Unauthorized access"}), 401
        return f(*args, **kwargs)

    return decorated_function


def check_admin(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if session.get("username") != "admin":  # Check if user is admin
            return jsonify({"error": "Unauthorized access"}), 401
        return f(*args, **kwargs)

    return decorated_function


@app.route("/")
def index():
    return render_template("index.html")


@app.route("/register", methods=["GET", "POST"])
def register():
    if request.method == "GET":
        return render_template("register.html")

    data = request.json
    username = data.get("username")
    password = data.get("password")

    # only alphanumeric characters and spaces in username
    username = "".join(filter(lambda x: x.isalnum() or x.isspace(), username))

    if not username or not password:
        return jsonify({"error": "Username and password are required"}), 400
    try:
        if users_collection.find_one({"username": username}):
            return jsonify({"error": "Username already exists"}), 400
        users_collection.insert_one(
            {"username": username, "password": password, "bio": ""}
        )
        session["username"] = username  # Log the user in after registration
        return jsonify({"message": "User registered successfully"}), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route("/login", methods=["GET", "POST"])
def login():
    # Handle user login with session management
    if request.method == "GET":
        return render_template("login.html")

    data = request.json
    username = data.get("username")
    password = data.get("password")
    if not username or not password:
        return jsonify({"error": "Username and password are required"}), 400
    user = users_collection.find_one({"username": username, "password": password})
    if user:
        session["username"] = username  # Store username in session
        return jsonify({"message": "Login successful"}), 200
    else:
        return jsonify({"error": "Invalid credentials"}), 401


@app.route("/update_bio", methods=["POST"])
@login_required
def update_bio():

    username = session.get("username")
    if not username or username == "admin":
        return jsonify({"error": "Invalid user"}), 401

    data = request.json
    if "username" in data or "password" in data:
        return jsonify({"error": "Cannot update username or password"}), 400
    bio = data.get("bio", "")   
    if not bio or any(
        char not in "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 "
        for char in bio
    ):
        return jsonify({"error": "Invalid bio"}), 400

    result = users_collection.update_one({"username": username}, {"$set": data})
    if result.matched_count > 0:
        return jsonify({"message": "Bio updated successfully"}), 200
    else:
        return jsonify({"error": "Failed to update bio"}), 500


@app.route("/users")
@login_required
@check_admin
def users():
    return render_template("users.html")


@app.route("/api/users", methods=["GET"])
@login_required
@check_admin
def get_users():
    name = request.args.get("name")
    print(f"Searching for users with name: {name}")
    if name:
        users = list(
            users_collection.find(
                {"username": {"$regex": name, "$options": "i"}},
                {"_id": 0, "password": 0},
            )
        )
    else:
        return jsonify({"error": "Name is required"}), 400
    return jsonify(users), 200


@app.route("/render")
@login_required
@check_admin
def render_page():
    return render_template("render.html")


@app.route("/report", methods=["GET", "POST"])
@login_required
def report():
    if request.method == "GET":
        return render_template("report.html")

    data = request.json
    name = data.get("name")
    if not name:
        return jsonify({"error": "Name is required"}), 400
    url = f"http://localhost:5000/users?name={name}"
    try:
        visit(url)
        return jsonify({"message": f"Bot visited /users?name={name}"}), 200
    except Exception as e:
        return jsonify({"error": f"Bot failed to visit URL: {str(e)}"}), 500


if __name__ == "__main__":
    users_collection = init_db()
    app.run(host="0.0.0.0", port=int(os.getenv("PORT", 5000)))
