# Randomly plays one of five chords (E, D, A, B, G major triads).
# Each bar is 4 beats in 4/4 time:
#   - the chord rings out for the full 4 beats
#   - the bass alternates between the chord's root note and the fifth
#     above it, two octaves down, 16 notes across the bar

# Make sure you’ve got a synth, whether physical or virtual
# connected to MIDI channel 1!

use_midi_defaults port: "*", channel: 1

define :midi_chord do |notes, *args|
  notes.each do |note|
    midi note, *args
  end
end

chords = [:e, :d, :a, :b, :g, :cs]
prev_chord = nil

live_loop :random_chords_with_bass do
  # pick from every chord except the one just played, so it never repeats back-to-back
  
  
  
  # Bass alternates root / fifth, two octaves down (16 notes x 0.25 beat = 4 beats)
  with_synth :mod_beep do
    chosen = (chords - [prev_chord]).choose
    puts(chosen.to_s)
    prev_chord = chosen
    midi_chord(chord(chosen, :maj9), release: 3.5)
    
    bass_root = note(chosen) - 24  # two octaves down (12 semitones per octave)
    bass_fifth = bass_root + 7     # perfect fifth above the root
    
    16.times do |i|
      play (i.even? ? bass_root : bass_fifth), amp: 1.5, release: 0.4
      sleep 0.25
    end
  end
end