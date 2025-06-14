from playwright.sync_api import sync_playwright
import os

def visit(url):
    admin_password = os.getenv("ADMIN_PASSWORD", "admin")
    flag = os.getenv("FLAG", "bi0sctf{testflag}")

    with sync_playwright() as p:

        browser = p.chromium.launch(
            headless=True,
            args=[
                "--no-sandbox",
                "--disable-dev-shm-usage",
                "--disable-gpu"
            ]
        )
        page = browser.new_page()

        try:

            page.goto("http://localhost:5000/login", wait_until="networkidle")
            page.wait_for_timeout(1000)

            # Fill out the login form
            page.fill("#username", "admin")
            page.fill("#password", admin_password)
            page.click("button[type='submit']")
            print("Logged in as admin")

            page.wait_for_timeout(1000)  

            page.context.add_cookies([{
                'name': 'flag',
                'value': flag,
                'domain': 'localhost',
                'path': '/',
                'httpOnly': False,
                'sameSite': 'Lax',
                'secure': False
            }])

            print(f"Visiting URL: {url}")
            page.goto(url, wait_until="networkidle")
            page.wait_for_timeout(3000)  

        except Exception as e:
            print(f"Bot error: {str(e)}")
        finally:
            browser.close()