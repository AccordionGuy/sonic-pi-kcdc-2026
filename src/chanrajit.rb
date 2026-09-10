# chanrajit.rb
#
# An acid raga, in the spirit of Charanjit Singh's "Ten Ragas to a
# Disco Beat" (1982): TB-303 bassline, 808-ish drums, four on the
# floor, and melodic material drawn from a raga rather than a
# Western scale.
#
# Raga Bhairav, on C. Intervals from the tonic, in semitones:
#
# Swara	  Full name    Semitones from Sa
# Sa	    Shadja	     0
# re	    Rishabh	     1
# Ga	    Gandhar	     4
# ma	    Madhyam	     5
# Pa	    Pancham      7
# dha	    Dhaivat	     8
# Ni	    Nishad	     11
#
# The flat second and flat sixth against a major third are what give
# it its character. In Bhairav the ascending and descending forms are
# the same, which keeps the code simple -- many ragas use different
# note sets going up and down, and would need two rings.

use_bpm 122

set :sa, 36        # tonic, C2

# ----------------------------------------------------------------
# THE RAGA. Degrees beyond 6 wrap into the next octave -- the ring
# handles the pitch class, integer division handles the octave.
# ----------------------------------------------------------------
define :raga do |degree|
  intervals = (ring 0, 1, 4, 5, 7, 8, 11)
  get(:sa) + intervals[degree] + 12 * (degree / 7)
end

# ----------------------------------------------------------------
# THE 303 SEQUENCE -- 16 steps. gate says which steps sound,
# accent says which are louder and brighter. That accent pattern is
# most of what makes a 303 sound like a 303.
# ----------------------------------------------------------------
bass_deg = (ring 0, 0, 7, 0,  1, 0, 4, 0,  0, 5, 0, 2,  7, 0, 1, 0)
gate     = (bools 1,0,1,1, 1,0,1,0, 1,1,0,1, 1,0,1,1)
accent   = (bools 1,0,0,0, 0,0,1,0, 1,0,0,0, 0,0,1,0)

# ----------------------------------------------------------------
# DRUMS -- 16th grid.
# ----------------------------------------------------------------
kick_pat = (bools 1,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,0,0)
clap_pat = (bools 0,0,0,0, 1,0,0,0, 0,0,0,0, 1,0,0,0)
hat_pat  = (bools 0,0,1,0, 0,0,1,0, 0,0,1,0, 0,0,1,1)

# ----------------------------------------------------------------
# PAKAD -- a characteristic phrase of the raga, used by the lead.
# Descending through the flat sixth is the signature move.
# ----------------------------------------------------------------
pakad     = (ring 5, 4, 3, 2, 1, 0, 1, 4, 3, 2, 1, 0)
pakad_dur = (ring 1, 0.5, 0.5, 1, 1, 2, 0.5, 0.5, 1, 1, 1, 3)

live_loop :drums do
  tick
  sample :bd_haus,            amp: 4                  if kick_pat.look
  sample :sn_dolf,            amp: 1.8, cutoff: 115   if clap_pat.look
  sample :drum_cymbal_closed, amp: 0.7, rate: 1.3     if hat_pat.look
  sleep 0.25
end

# ----------------------------------------------------------------
# TANPURA -- the drone. Sa and Pa, always. This is what makes the
# raga's intervals mean anything; without it they are just notes.
# ----------------------------------------------------------------
live_loop :tanpura do
  use_synth :hollow
  play [raga(0), raga(4)], amp: 0.35, attack: 2, sustain: 12, release: 4
  sleep 16
end

# ----------------------------------------------------------------
# THE 303 -- the cutoff sweeps on a slow sine over roughly 30 bars,
# which is the knob-twiddling that gives acid its shape. Accented
# steps get a boost on top of that.
# ----------------------------------------------------------------
live_loop :acid do
  i = tick
  
  if gate.look
    use_synth :tb303
    hit = accent.look
    
    # Sweep range 20..100, plus 25 on accents. Clamped, because the
    # peak of the sine and an accented step can coincide and :cutoff
    # rejects anything above 130.
    co = 60 + 40 * Math.sin(i * 0.013) + (hit ? 25 : 0)
    co = [[co, 130].min, 30].max
    
    play raga(bass_deg.look),
      cutoff:  co,
      res:     0.88,
      release: hit ? 0.35 : 0.18,
      amp:     hit ? 2.2 : 1.3,
      wave:    0
  end
  sleep 0.25
end

# ----------------------------------------------------------------
# LEAD -- the pakad, an octave and a half above Sa. Enters after
# 16 bars and then plays every other cycle, leaving space.
# ----------------------------------------------------------------
live_loop :lead do
  sleep 64                       # sit out the opening
  
  use_synth :prophet
  with_fx :echo, phase: 0.75, decay: 4, mix: 0.3 do
    12.times do |n|
      play raga(pakad[n]) + 24,
        amp: 0.7, release: pakad_dur[n] * 0.9, cutoff: 105
      sleep pakad_dur[n]
    end
  end
  sleep 12                       # 12 beats of rest between statements
end