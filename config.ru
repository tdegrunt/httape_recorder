#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/setup'
require 'httape_recorder'

run HttapeRecorder::Server.new
