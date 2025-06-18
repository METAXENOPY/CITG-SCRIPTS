use_bpm 125
use_synth :blade

# Define the main melody
define :main_melody do
  play_pattern_timed [:a4, :a4, :e4, :f4, :e4, :e4, :b3, :a3, :g3, :a3, :g3, :f4], [0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 1, 0.5, 0.5, 0.5, 0.5, 1]
  sleep 1
  play_pattern_timed [:a4, :a4, :e4, :f4, :e4, :e4, :b3, :a3, :g3, :a3, :g3, :f4], [0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 1, 0.5, 0.5, 0.5, 0.5, 1]
end

# Define the bassline
define :bassline do
  use_synth :fm
  play :a2, sustain: 1.5, release: 0.5
  sleep 2
  play :e2, sustain: 1.5, release: 0.5
  sleep 2
end

# Define the percussion
define :drums do
  sample :drum_bass_hard
  sleep 0.5
  sample :drum_snare_soft
  sleep 0.5
end

# Live loops
live_loop :drums_loop do
  drums
end

live_loop :bass_loop do
  sync :drums_loop
  bassline
end

live_loop :melody_loop do
  sync :drums_loop
  main_melody
end
