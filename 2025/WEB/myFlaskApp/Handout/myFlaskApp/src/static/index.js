window.name="notadmin";

const login = async function() {
    const username = document.getElementById("username").value;
    const password = document.getElementById("password").value;

    if (username === "" || password === "") {
        alert("Please enter both username and password.");
        return;
    }
    const response = await fetch("/login", {
        method: "POST",
        headers: {
            "Content-Type": "application/json"
        },
        body: JSON.stringify({ username, password })
    });
    const data = await response.json();
    if (response.ok) {
        window.location = "/";
    } else {
        alert(data.message);
    }
}

const register = async function() {
    const username = document.getElementById("username").value;
    const password = document.getElementById("password").value;

    if (username === "" || password === "") {
        alert("Please enter both username and password.");
        return;
    }
    const response = await fetch("/register", {
        method: "POST",
        headers: {
            "Content-Type": "application/json"
        },
        body: JSON.stringify({ username, password })
    });
    const data = await response.json();
    if (response.ok) {
        window.location = "/";
    } else {
        alert(data.message);
    }
}

const bio = async function() {
    const bio = document.getElementById("bio").value;
    const response = await fetch("/update_bio", {
        method: "POST",
        headers: {
            "Content-Type": "application/json"
        },
        body: JSON.stringify({ bio })
    });
    const data = await response.json();
    if (response.ok) {
        alert("Bio updated successfully!");
    } else {
        alert(data.message);
    }
}

const report = async function() {
    const username = document.getElementById('username').value;
    const messageDiv = document.getElementById('message');
    
    try {
        const response = await fetch('/report', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ name: username })
        });
        const result = await response.json();
        
        if (response.ok) {
            messageDiv.textContent = result.message;
            messageDiv.style.color = 'green';
        } else {
            messageDiv.textContent = result.error;
            messageDiv.style.color = 'red';
        }
    } catch (error) {
        messageDiv.textContent = 'Error: Failed to submit report';
        messageDiv.style.color = 'red';
    }
}


document.addEventListener("DOMContentLoaded", function() {

    const login_form = document.getElementById("login-form");
    const register_form = document.getElementById("register-form");
    const bio_form = document.getElementById("bio-form");
    const report_form = document.getElementById("reportForm");

    if (login_form) {
        login_form.addEventListener("submit", function(event) {
            event.preventDefault();
            login();
        });
    }
    if (register_form) {
        register_form.addEventListener("submit", function(event) {
            event.preventDefault();
            register();
        });
    }
    if (bio_form) {
        bio_form.addEventListener("submit", function(event) {
            event.preventDefault();
            bio();
        });
    }
    if (report_form) {
        report_form.addEventListener("submit", function(event) {
            event.preventDefault();
            report();
        });
    }
});
