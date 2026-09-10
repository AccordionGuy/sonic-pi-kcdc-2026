# Welcome to Sonic Pi

use_bpm 129

# -----------------------------------------
# DRUMS
# -----------------------------------------

live_loop :kick do
  sample :bd_haus, amp: 1.8
  sleep 1
end

live_loop :snare do
  sync :kick
  sleep 1
  sample :sn_dub, amp: 1.3
  sleep 2
  sample :sn_dub, amp: 1.3
  sleep 1
end

live_loop :hats do
  sync :kick
  
  8.times do |i|
    sample :drum_cymbal_closed,
      amp: (i.even? ? 0.45 : 0.7),
      finish: 0.12,
      rate: 1.5
    sleep 0.5
  end
end


# -----------------------------------------
# SYNTH-POP BASS
# -----------------------------------------

bass_notes = (ring
              :e2, :e2, :b2, :e2,
              :d2, :d2, :a2, :d2,
              :c2, :c2, :g2, :c2,
              :d2, :d2, :a2, :b2
              )

live_loop :bass do
  sync :kick
  use_synth :fm
  
  16.times do |i|
    play bass_notes[i],
      release: 0.18,
      depth: 1.5,
      divisor: 2,
      amp: 1.1
    sleep 0.25
  end
end


##| # -----------------------------------------
##| # BRIGHT POLYSYNTH CHORD STABS
##| # -----------------------------------------

##| chords = (ring
##|           chord(:e3, :minor),
##|           chord(:d3, :major),
##|           chord(:c3, :major),
##|           chord(:d3, :major)
##|           )

##| live_loop :chords do
##|   sync :kick
##|   use_synth :prophet

##|   chords.each do |c|
##|     2.times do
##|       play c,
##|         release: 0.25,
##|         cutoff: 105,
##|         amp: 0.8
##|       sleep 1
##|     end
##|   end
##| end


##| # -----------------------------------------
##| # MAD SCIENTIST ARPEGGIO
##| # -----------------------------------------

##| live_loop :science do
##|   sync :kick

##|   use_synth :pulse

##|   with_fx :echo, phase: 0.25, decay: 1.5, mix: 0.25 do
##|     notes = (scale :e4, :minor_pentatonic, num_octaves: 2)

##|     16.times do
##|       play notes.choose,
##|         release: 0.08,
##|         cutoff: rrand(80, 115),
##|         pulse_width: rrand(0.2, 0.5),
##|         amp: 0.35

##|       sleep 0.25
##|     end
##|   end
##| end


##| # -----------------------------------------
##| # OCCASIONAL SYNTH "SCIENCE!" STAB
##| # -----------------------------------------

##| live_loop :science_stab do
##|   sync :kick
##|   sleep 16

##|   with_fx :reverb, mix: 0.35 do
##|     use_synth :blade

##|     play chord(:e4, :minor),
##|       attack: 0,
##|       release: 0.5,
##|       cutoff: 120,
##|       amp: 1.2

##|     sleep 0.5

##|     play chord(:b4, :minor),
##|       attack: 0,
##|       release: 0.35,
##|       cutoff: 125,
##|       amp: 0.8
##|   end
##| end