#!/usr/bin/env ruby

require 'bundler'
Bundler.require
require 'highline/import'
require_relative './running_stats'

c = LIFX::Client.lan
if device_id = ARGV.first
  puts "Searching for device with id #{device_id}"
  c.discover! do
    c.lights.with_id(device_id)
  end
  device = c.lights.with_id(device_id)
else
  puts "Scanning for devices..."
  c.discover!
  c.refresh
  sleep 2

  device = nil
  while !device
    choose do |menu|
      menu.prompt = "Select a device to ping:"
      c.lights.each do |l|
        menu.choice("#{l.id}: #{l.label || "<No label>"}") { device = l }
      end
      menu.choice(:refresh) { c.lights.refresh; sleep 1 }
    end
  end
end


TIMEOUT  = 3
seq      = 0
timeouts = 0
min      = TIMEOUT * 1_000 # ms
max      = 0               # ms
stats    = RunningStats.new

trap :INT do
  puts
  puts "--- #{device.id} ping statistics ---"
  transmitted = seq + 1
  lost = timeouts
  percent_lost = (lost / transmitted.to_f) * 100
  puts "%d messages transmitted, %d messages received, %.1f%% message loss" % [transmitted, lost, percent_lost]
  puts "round trip min/avg/max/std-dev %.3f/%.3f/%.3f/%.3f ms" % [min, stats.mean, max, stats.std_dev]
  exit
end

mutex = Mutex.new
signal = ConditionVariable.new

resp_seq = nil
device.add_hook(LIFX::Protocol::Light::State) do |payload|
  if payload.color.kelvin.to_i <= 1000
    resp_seq = payload.color.kelvin.to_i
    signal.broadcast
  end
end

puts "PING #{device.id}:"
loop do
  begin
    Timeout.timeout(TIMEOUT) do
      expected_seq = (seq % 1000) + 1
      start = Time.now
      device.send_message(LIFX::Protocol::Light::SetWaveform.new(
        waveform: LIFX::Protocol::Light::Waveform::SINE,
        transient: true,
        period: 0,
        duty_cycle: 0,
        cycles: 1,
        color: LIFX::Protocol::Light::Hsbk.new(kelvin: expected_seq)
      ))
      mutex.synchronize do
        signal.wait(mutex, TIMEOUT + 1)
      end
      latency_ms = (Time.now - start) * 1_000
      stats << latency_ms
      min = latency_ms if latency_ms < min
      max = latency_ms if latency_ms > max
      puts "Response: seq=%d time=%0.3f ms" % [seq, latency_ms]
      sleep 1
    end
  rescue Timeout::Error
    $stderr.puts "Ping timed out"
    timeouts += 1
  end
  seq += 1
end
