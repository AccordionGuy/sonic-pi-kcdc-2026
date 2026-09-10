# Twinkle Twinkle Little Star
# (Rings and Live Loops version)
# ==============================
#
# This version uses three rings to store song info:
# - melody: Which notes to play for the melody
# - durations: How long to play each note in the melody
# - chords: Which chords to play
# 42 notes x their durations = 48 beats. 24 chords x 2 beats = 48 beats.
# They line up, which is why the accompaniment never drifts.

use_bpm 100

# Melody
melody = (ring
          :c4, :c4, :g4, :g4, :a4, :a4, :g4,   # Twinkle, twinkle, little star
          :f4, :f4, :e4, :e4, :d4, :d4, :c4,   # How I wonder what you are
          :g4, :g4, :f4, :f4, :e4, :e4, :d4,   # Up above the world so high
          :g4, :g4, :f4, :f4, :e4, :e4, :d4,   # Like a diamond in the sky
          :c4, :c4, :g4, :g4, :a4, :a4, :g4,   # Twinkle, twinkle, little star
          :f4, :f4, :e4, :e4, :d4, :d4, :c4)   # How I wonder what you are

# Six quarters and a half. Seven values, reused for all six phrases.
durations = (ring 1, 1, 1, 1, 1, 1, 2)

live_loop :melody do
  use_synth :pretty_bell
  tick
  play melody.look, release: durations.look * 0.9, amp: 0.8
  sleep durations.look
end

# Accompaniment
##| chords = (ring
##|           :c, :c,   :f, :c,   :f, :c,   :g, :c,
##|           :c, :f,   :c, :g,   :c, :f,   :c, :g,
##|           :c, :c,   :f, :c,   :f, :c,   :g, :c)

##| live_loop :harmony do
##|   use_synth :piano
##|   play chord(chords.tick, :major, num_octaves: 1),
##|     amp: 0.4, release: 1.8
##|   sleep 2
##| end