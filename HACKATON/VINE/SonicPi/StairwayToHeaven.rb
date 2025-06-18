tempo = 0.5

# Lead melody
live_loop :stairway_lead do
  use_synth :piano
  # Play all notes exactly as given, with proper timing
  
  play :c4; sleep tempo
  play :e4; sleep tempo
  play :a4; sleep tempo
  play :b4; sleep tempo
  play :e4; sleep tempo
  play :c4; sleep tempo
  play :b4; sleep tempo
  play :c5; sleep tempo
  play :e4; sleep tempo
  play :c4; sleep tempo
  play :c5; sleep tempo
  play :fs4; sleep tempo
  play :d4; sleep tempo
  play :a3; sleep tempo
  play :f4; sleep tempo
  play :e4; sleep tempo
  play :c4; sleep tempo
  play :a3; sleep tempo
  play :e4; sleep tempo
  play :c4; sleep tempo
  play :a3; sleep tempo
  play :e4; sleep tempo
  play :a3; sleep tempo
  play :g3; sleep tempo
  play :a3; sleep tempo
  play :a3; sleep tempo * 5
end

# Bass line
live_loop :stairway_bass do
  use_synth :fm
  sync :stairway_lead
  
  play :a3; sleep tempo*4
  play :gs3; sleep tempo*4
  play :g3; sleep tempo*4
  play :fs3; sleep tempo*4
  play :fs3; sleep tempo*8
  play :b3; sleep tempo
  play :a3; sleep tempo
  play :a3; sleep tempo
  play :a3; sleep tempo
  play :f3; sleep tempo
  play :e3; sleep tempo
end

# Drum groove
live_loop :drums do
  sync :stairway_lead
  sample :bd_haus, amp: 1.5
  sleep tempo * 2
  sample :sn_dub, amp: 0.6
  sleep tempo * 2
end

# Gentle pad for atmosphere
live_loop :pad do
  sync :stairway_lead
  use_synth :hollow
  play :a3, sustain: tempo * 16, release: tempo * 16, amp: 0.3
  sleep tempo * 16
  play :f3, sustain: tempo * 8, release: tempo * 8, amp: 0.3
  sleep tempo * 8
end
