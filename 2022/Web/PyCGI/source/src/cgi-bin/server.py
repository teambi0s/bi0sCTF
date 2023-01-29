from os import environ

class Server:
    def __init__(self):
        self.response_headers = {}
        self.response_body = ""
        self.post_body = ""
        self.request_method = self.get_var("REQUEST_METHOD")
        self.content_length = 0
            
    def get_params(self):
        request_uri = self.get_var("REQUEST_URI") if  self.get_var("REQUEST_URI") else ""
        params_dict = {}
        if "?" in request_uri:
            params = request_uri.split("?")[1]
            if "&" in params:
                params = params.split("&")
                for param in params:
                    params_dict[param.split("=")[0]] = param.split("=")[1]
            else:
                params_dict[params.split("=")[0]] = params.split("=")[1]
        return params_dict

    def get_var(self, variable):
        return environ.get(variable)

    def set_header(self, header, value):
        self.response_headers[header] = value

    def add_body(self, value):
        self.response_body += value

    def send_file(self, filename):
        self.response_body += open(filename, "r").read()

    def send_response(self):
        for header in self.response_headers:
            print(f"{header}: {self.response_headers[header]}\n")

        print("\n")
        print(self.response_body)
        print("\n")
