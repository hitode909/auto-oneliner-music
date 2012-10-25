# -*- coding: utf-8 -*-
require 'rubygems'
require 'bundler/setup'

Bundler.require

monitor = Mac::EventMonitor::Monitor.new

monitor.add_listener(:mouse_move) do |event|
  puts
  STDOUT.flush
end

monitor.add_listener(:mouse_down) do |event|
  puts 'reset'
  STDOUT.flush
end

monitor.add_listener(:key_down) do |event|
  puts
  STDOUT.flush
end

monitor.run
