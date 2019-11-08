# frozen_string_literal: true

# Puma configuration file

rackup 'config.ru'

workers 1
threads 1, 1

tcp_mode
port 3000
