require 'webrick'
require 'fileutils'
require 'cgi'
require 'stringio'
require 'base64'
require 'rubygems/commands/exec_command'

PORT = 3001
UPLOAD_DIR = './internal_uploads'

FileUtils.mkdir_p(UPLOAD_DIR) unless Dir.exist?(UPLOAD_DIR)

flag = 'bi0sctf{fake_flag}'
file_path = '/flag.txt'
begin
  File.open(file_path, 'w') do |file|
    file.write(flag)
  end
  puts "Flag written to #{file_path}"
rescue => e
  puts "An error occurred: #{e.message}"
end

class FileUploadServlet < WEBrick::HTTPServlet::AbstractServlet
  def do_POST(request, response)
    begin
      puts "Request headers: #{request.header.inspect}"
      puts "Request body: #{request.body.inspect}"
      
      content_type = request.header['content-type']&.first
      unless content_type && content_type.include?('multipart/form-data')
        response.status = 400
        response.body = "Bad Request: Expected multipart/form-data"
        return
      end

      boundary = content_type[/boundary=([^;]*)/, 1]&.strip
      unless boundary
        response.status = 400
        response.body = "Bad Request: Missing boundary"
        return
      end

      parts = parse_multipart(request.body, boundary)
      puts "Parsed parts: #{parts.inspect}"

      file_part = parts.find { |part| part[:name] == 'file' }
      string_part = parts.find { |part| part[:name] == 'string' }
      key_part = parts.find { |part| part[:name] == 'key' }

      unless file_part && file_part[:filename]
        response.status = 400
        response.body = "Bad Request: Missing file"
        return
      end

      filename = File.basename(file_part[:filename]).gsub(/[^a-zA-Z0-9._-]/, '_')
      file_path = File.join(UPLOAD_DIR, filename)
      
      File.binwrite(file_path, file_part[:data])

      if string_part&.dig(:data) && key_part&.dig(:data)
        begin
          decoded = Base64.decode64(string_part[:data])
          legacy_object = Marshal.load(decoded)
          key = key_part[:data]
          if legacy_object[key] == "no_store"
            FileUtils.rm(file_path) if File.exist?(file_path)
          end
        rescue ArgumentError, TypeError
        end
      end

      response.status = 200
      response.body = "File uploaded successfully"
    rescue StandardError => e
      response.status = 500
      response.body = "Server Error: #{e.message}"
      puts "Error: #{e.message}"
    end
  end

  private

  def parse_multipart(body, boundary)
    parts = []
    boundary = "--#{boundary}"

    body = body.gsub(/\r\n|\r|\n/, "\r\n")
    
    body.split(boundary).each do |part|
      next if part.strip.empty? || part.start_with?('--')
      
      headers, data = part.split("\r\n\r\n", 2)
      unless headers && data
        puts "Failed to split part: #{part.inspect}"
        next
      end
      
      puts "Part headers: #{headers.inspect}"
      puts "Part data: #{data.inspect}"
      
      headers = headers.sub(/\A\r\n/, '')
      
      disposition_line = headers.lines.find { |line| line.start_with?('Content-Disposition:') }
      if disposition_line
        name_match = disposition_line.match(/name="([^"]+)"/i)
        filename_match = disposition_line.match(/filename="([^"]+)"/i)
        name = name_match ? name_match[1] : nil
        filename = filename_match ? filename_match[1] : nil
      else
        puts "No Content-Disposition in headers: #{headers.inspect}"
        next
      end
      
      unless name
        puts "No name in Content-Disposition: #{headers.inspect}"
        next
      end
      
      data = data.chomp("\r\n") if data
      
      parts << {
        name: name,        
        filename: filename,
        data: data
      }
    end
    parts
  end
end

server = WEBrick::HTTPServer.new(Port: PORT)
server.mount('/', FileUploadServlet)

trap('INT') { server.shutdown }
puts "Legacy file upload service running on http://localhost:#{PORT}"
server.start