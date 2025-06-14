from playwright.sync_api import sync_playwright
import os

flag = os.getenv("FLAG", "bi0sctf{m0m_1_th1nk_i_cl0bb3r3d_th3_DOM}")

def visit_url(url):
    with sync_playwright() as p:
        browser = p.chromium.launch(
            headless=True,
            args=[
                "--no-sandbox",
                "--disable-dev-shm-usage",
                "--disable-gpu",
                '--js-flags=--noexpose_wasm'
            ]
        )
        page = browser.new_page()
        page.context.add_cookies([{
            'name': 'flag',
            'value': flag,
            'path': '/',
            'domain': 'localhost',
            'httpOnly': False,
            'sameSite': 'Lax',
            'secure': False
        }])
        page.goto(url, wait_until='networkidle')
        page.wait_for_timeout(5000)
        browser.close()
