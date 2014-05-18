#!/usr/bin/env ruby

require 'bundler'
Bundler.require
require 'highline/import'
require_relative './running_stats'

c = LIFX::Client.lan
c.discover!

TIMEOUT  = 3
seq      = 0

resp_seq = nil
requests = {}

data = Hash.new do |h, k|
  h[k] = {
    stats: RunningStats.new,
    resp_seqs: []
  }
end

trap :INT do
  puts "Results:"
  rows = []
  c.lights.each do |l|
    stats = data[l.id][:stats]
    rows << [l.id, l.label, *[stats.min, stats.mean, stats.max, stats.std_dev].map { |f| f.round(3)}, stats.count, "#{(1 - data[l.id][:resp_seqs].count / requests.count.to_f).round(5) * 100}%"]
  end
  table = Terminal::Table.new(rows: rows, headings: ['ID', 'Label', 'Min', 'Avg', 'Max', 'Std-Dev', 'Total', 'Packet Loss'])
  (2..7).each do |i|
    table.align_column(i, :right)
  end
  puts table
  exit
end

c.context.transport_manager.add_observer(self, :message_received) do |message: nil, ip: nil, transport: nil|
  device_id = message.device_id
  if message.payload.is_a?(LIFX::Protocol::Light::State) && (resp_seq = message.payload.color.kelvin.to_i) <= 1000 && !data[device_id][:resp_seqs].include?(resp_seq)
    d = data[device_id]
    d[:resp_seqs] << resp_seq
    latency_ms = (Time.now - requests[resp_seq]) * 1_000 #ms
    d[:stats] << latency_ms
    puts "Response from #{message.device_id}: seq=%d time=%0.3f ms" % [resp_seq, latency_ms]
  end
end

puts "PING all:"
loop do
  break if seq == 1000
  expected_seq = (seq % 1000) + 1
  requests[expected_seq] = Time.now
  c.lights.send_message(LIFX::Protocol::Light::SetWaveform.new(
    waveform: LIFX::Protocol::Light::Waveform::SINE,
    transient: true,
    period: 0,
    duty_cycle: 0,
    cycles: 0,
    color: LIFX::Protocol::Light::Hsbk.new(kelvin: expected_seq)
  ), acknowledge: true)
  sleep 1
  seq += 1
end
