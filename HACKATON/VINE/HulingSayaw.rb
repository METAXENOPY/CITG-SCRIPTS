use_bpm 78

# Chord progression based on the song (simplified)
chords = [
  chord(:e3, :minor),   # Em
  chord(:c3, :major),   # C
  chord(:g3, :major),   # G
  chord(:d3, :major)    # D
]

# Simple drum pattern
live_loop :drums do
  sample :bd_tek, amp: 2
  sleep 1
  sample :sn_generic, amp: 1.2, rate: 1.2
  sleep 1
end

# Chords progression loop
live_loop :chords do
  chords.each do |c|
    use_synth :piano
    play c, release: 4, amp: 0.6
    sleep 4
  end
end

# Melody line (simplified and inspired by vocal melody)
melody_notes = [:e4, :g4, :b4, :a4, :g4, :e4, :d4, :b3]

live_loop :melody do
  sync :chords
  use_synth :pretty_bell
  melody_notes.each do |note|
    play note, release: 0.8, amp: 1.2
    sleep 0.5
  end
  sleep 2
end
