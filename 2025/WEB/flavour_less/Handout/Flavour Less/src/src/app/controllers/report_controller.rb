class ReportController < ApplicationController
  require 'puppeteer-ruby'

  def visit
    url = params[:url]

    unless url.present? && url.match?(/\Ahttps?:\/\/localhost(:\d+)?(\/.*)?\z/)
      render json: { error: 'URL must point to localhost' }, status: :bad_request
      return
    end

    begin
      Puppeteer.launch(
        headless: true,
        args: [
          '--no-sandbox',
          '--disable-setuid-sandbox',
          '--disable-dev-shm-usage',
          '--disable-gpu',
          '--no-first-run',
          '--no-zygote'
        ]
      ) do |browser|
        page = browser.new_page

        page.set_cookie(
          name: 'flag',
          value: 'bi0sctf{fake_flag}',
          domain: 'localhost',
          path: '/',
          expires: Time.now.to_i + 3600,
          same_site: 'Lax'
        )

        page.goto(url, wait_until: 'networkidle2', timeout: 10000)

        render json: { message: "Successfully visited #{url}" }, status: :ok
      end
    rescue Puppeteer::TimeoutError
      render json: { error: 'Navigation timeout' }, status: :request_timeout
    rescue Puppeteer::NavigationError
      render json: { error: 'Navigation failed' }, status: :bad_request
    rescue StandardError => e
      render json: { error: "An error occurred: #{e.message}" }, status: :internal_server_error
    end
  end
end