# frozen_string_literal: true

require 'logger'
require 'pry'

module HttapeRecorder
  class Server
    attr_reader :logger, :redis, :influxdb

    def initialize; end

    def call(env, socket)
      file_name = "raw#{Time.now.to_f.to_s.gsub('.', '')}.http"
      body_file_name = "#{file_name}body"
      puts "Request from #{env['REMOTE_ADDR']} => #{file_name}"
      response = "OK\r\n"

      File.open(file_name, 'w') do |file|
        content_length = 0
        while line = socket.readline
          file.write line
          break if line == "\r\n"

          if line.split(':')[0] == 'Content-Length'
            content_length = line.split(':')[1].to_i
          end
        end

        if content_length.positive?
          body = socket.read(content_length)
          file.write body
          File.open(body_file_name, 'w') do |body_file|
            body_file.write body
          end
        end
      end
      socket.print "HTTP/1.1 200 OK\r\n" \
                  "Content-Type: text/plain\r\n" \
                  "Content-Length: #{response.bytesize}\r\n" \
                  "Connection: close\r\n"

      socket.print "\r\n"
      socket.print response
    end
  end
end
