#!/usr/bin/python3

from server import Server
import pandas as pd

try:
    df = pd.read_csv("../database/currency-rates.csv")
    server = Server()
    server.set_header("Content-Type", "text/html")
    params = server.get_params()
    assert "currency_name" in params
    currency_code = params["currency_name"]
    results = df.query(f"currency == '{currency_code}'")
    server.add_body(results.to_html())
    server.send_response()
except Exception as e:
    print("Content-Type: text/html")
    print()
    print("Exception")
    print(str(e))
