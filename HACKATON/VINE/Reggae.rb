use_bpm 75  # Reggae tempo

# Chord progression for reggae (in C major)
chords = [:C, :G, :Am, :F]

# Function: Reggae Skank (offbeat guitar)
define :skank do |chord|
  sync :beat
  use_synth :pluck
  play_chord chord, release: 0.2, amp: 0.8
end

# Function: Bassline
define :bassline do |root|
  use_synth :fm
  play root, release: 0.4, amp: 1.2
  sleep 0.5
  play root - 5, release: 0.4, amp: 1
  sleep 0.5
end

# Function: Drums
define :drums do
  sample :bd_tek, amp: 1.5
  sleep 1
end

define :hihat do
  sleep 0.5
  sample :drum_cymbal_closed, amp: 0.3
  sleep 0.5
end

# Start drums loop
live_loop :drums do
  drums
end

# Hi-hat loop
live_loop :hihat do
  hihat
end

# Skank guitar loop
live_loop :skank do
  chords.each do |ch|
    4.times do
      sleep 0.25
      skank(ch)
      sleep 0.75
    end
  end
end

# Bassline loop
live_loop :bass do
  chords.each do |ch|
    4.times do
      bassline(ch)
    end
  end
end

# Melody / Lead (optional)
define :lead_melody do
  use_synth :blade
  play_pattern_timed [:e4, :g4, :b4, :a4], [0.5, 0.5, 1, 1], release: 0.5, amp: 0.6
end

live_loop :melody do
  sync :bass
  lead_melody
  sleep 4
end

# Run for ~4 minutes (32 bars of 4 chords, each bar ~4 sec at 75bpm)
with_fx :reverb, mix: 0.4 do
  32.times do
    cue :beat
    sleep 4 * 4  # Each chord played for 4 beats, 4 chords = 16 seconds
  end
  # Fade out
  stop
end
