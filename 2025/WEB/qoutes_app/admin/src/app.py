from flask import Flask, jsonify, render_template,request
import bot

app = Flask(__name__)


quotes = {
    "f47ac10b-58cc-4372-a567-0e02b2c3d479": "The only limit to our realization of tomorrow is our doubts of today. - Franklin D. Roosevelt",
    "c9bf9e57-1685-4c89-bafb-ff5af830be8a": "Success is not final, failure is not fatal: it is the courage to continue that counts. - Winston Churchill",
    "e4eaaaf2-d142-11e1-b3e4-080027620cdd": "Do what you can, with what you have, where you are. - Theodore Roosevelt",
    "6ba7b810-9dad-11d1-80b4-00c04fd430c8": "It does not matter how slowly you go as long as you do not stop. - Confucius",
    "1b9d6bcd-bbfd-4b2d-9b5d-ab8dfbbd4bed": "Believe you can and you're halfway there. - Theodore Roosevelt"
}

@app.route("/", methods=["GET"])
def index():
    return render_template("index.html")

@app.route("/api/quotes/<uuid:quote_uuid_arg>", methods=['GET'])
def get_quote(quote_uuid_arg):
    
    quote_uuid = str(quote_uuid_arg)

    
    if quote_uuid in quotes:
        return jsonify({"uuid": quote_uuid, "quote": quotes[quote_uuid]})
    else:
        return jsonify({"error": "Invalid uuid"}), 404

@app.route("/report", methods=["GET", "POST"])
def report():
    if request.method == "GET":
        return render_template("report.html")

    data = request.get_json()
    url = data.get('url')

    if not url:
        return jsonify({"success": False, "error": "Missing URL"}), 400

    try:
        bot.visit_url(url)
        return jsonify({"success": True, "message": "Bot visited the URL"})
    except Exception as e:
        return jsonify({"success": False, "error": str(e)}), 500


if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=False, port=4000)