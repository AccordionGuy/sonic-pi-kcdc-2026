# Twinkle Twinkle Little Star
# (DRY version)
# ===========================
# There’s a lot of repetition in the song.
# Let’s DRY up its code with some functions!

use_bpm 100

define :twinkle_twinkle do
  # Twinkle, twinkle, little star
  play :c4
  sleep 1
  play :c4
  sleep 1
  play :g4
  sleep 1
  play :g4
  sleep 1
  play :a4
  sleep 1
  play :a4
  sleep 1
  play :g4
  sleep 2
end

define :how_i_wonder do
  # How I wonder what you are
  play :f4
  sleep 1
  play :f4
  sleep 1
  play :e4
  sleep 1
  play :e4
  sleep 1
  play :d4
  sleep 1
  play :d4
  sleep 1
  play :c4
  sleep 2
end

define :up_above do
  # Up above the world so high
  play :g4
  sleep 1
  play :g4
  sleep 1
  play :f4
  sleep 1
  play :f4
  sleep 1
  play :e4
  sleep 1
  play :e4
  sleep 1
  play :d4
  sleep 2
end

# Main
##| 2.times do |round|
##|   use_bpm_mul (round + 3)
  twinkle_twinkle
  how_i_wonder
  up_above
  up_above
  twinkle_twinkle
  how_i_wonder
##| end