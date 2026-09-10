# ACIEEEEEEEED!
# Classic Chicago acid-house-inspired Sonic Pi jam
# ================================================
#
# The four parallel rings below are not an analogy for a TB-303.
# They ARE its data model: a 16-step sequencer where every step
# carries a note, a gate length, an accent, and a slide flag.
# Roland designed that struct-of-arrays in 1981. We're just typing it.

use_bpm 125

# Song settings. :acid_cutoff is written by the controller loop
# below, so this is only the value used before it first fires.
set :acid_cutoff, 65
set :acid_res, 0.92
set :acid_amp, 0.9


# CLOCK
# Everything syncs to this, not to the kick. One cue per bar, from a
# loop that makes no sound, so there's no race between a voice
# finishing its cycle and the cue that's meant to start the next one.
# Defined first, but it carries a delay so the voices below are
# already waiting on sync when the first cue fires.
# -----------------------------------------------------------------
live_loop :clock, delay: 4 do
  cue :bar
  sleep 4
end


# DRUMS
# =====

# Kick: four on the floor.
live_loop :kick do
  sync :bar
  4.times do
    sample :bd_haus, amp: 2.2
    sleep 1
  end
end

# Clap on beats 2 and 4.
live_loop :clap do
  sync :bar
  sleep 1
  sample :perc_snap, amp: 1.2, rate: 0.9
  sleep 2
  sample :perc_snap, amp: 1.2, rate: 0.9
  sleep 1
end

# Closed hats on 8ths. The rrand is deliberate imprecision --
# identical hits sound like a machine, and not in the good way.
live_loop :hats do
  sync :bar
  8.times do
    sample :drum_cymbal_closed,
      amp:    rrand(0.45, 0.7),
      finish: 0.15,
      rate:   rrand(1.5, 1.8)
    sleep 0.5
  end
end

# Open hats on the offbeats. Same instrument as :hats, different
# thread, interleaved subdivision -- what a drummer does with one hand.
live_loop :open_hat do
  sync :bar
  4.times do
    sleep 0.5
    sample :drum_cymbal_open,
      amp:    0.5,
      finish: 0.13,
      rate:   1.2
    sleep 0.5
  end
end


# THE ACID SEQUENCE
# =================
# nil = rest. A rest is data -- the sequencer has to know step 4 is
# silent, which is different from step 4 not existing.
# Octave jumps are VERY IMPORTANT for maximum dope stylee.
# -----------------------------------------------------------------

acid_notes = (ring
              :e2, :e2, :e3, nil,
              :g2, :e2, :b2, :d3,
              :e2, nil, :e3, :b2,
              :d3, :e2, :g2, :ds3
              )

acid_lengths = (ring
                0.25, 0.25, 0.5, 0.25,
                0.25, 0.5, 0.25, 0.25,
                0.25, 0.25, 0.5, 0.25,
                0.25, 0.5, 0.25, 0.25
                )

acid_accents = (ring
                1.4, 0.8, 1.5, 0,
                0.7, 1.3, 0.8, 1.4,
                0.9, 0, 1.5, 0.8,
                1.4, 0.8, 1.0, 1.5
                )

acid_slides = (ring
               0, 0, 1, 0,
               0, 1, 0, 1,
               0, 0, 1, 0,
               1, 0, 0, 1
               )


# THE 303
# The bass machine that's the heart of acid house.
#
# Slides are real here: the note is held as a running synth node and
# then controlled toward the next pitch. Slide opts only set the
# interpolation time for LATER control calls -- passing note_slide on
# the initial play does nothing on its own.
# -----------------------------------------------------------------

live_loop :acid do
  sync :bar
  
  use_synth :tb303
  
  16.times do |i|
    this_note = acid_notes[i]
    len       = acid_lengths[i]
    accent    = acid_accents[i]
    slide     = acid_slides[i]
    
    unless this_note.nil?
      # Random movement on top of the swept cutoff keeps it alive.
      co = [[get(:acid_cutoff) + rrand(-8, 15), 130].min, 30].max
      
      n = play this_note,
        release:    len * 1.8,
        cutoff:     co,
        res:        get(:acid_res),
        wave:       0,
        amp:        get(:acid_amp) * accent,
        note_slide: 0.12
      
      # If this step slides, glide to the next sounding note.
      if slide == 1
        nxt = acid_notes[i + 1] || acid_notes[i + 2]
        control n, note: nxt if nxt
      end
    end
    
    sleep 0.25
  end
end


# ACID FX CONTROLLER
# A loop whose entire job is to write shared state that another loop
# reads. It makes no sound. This is an automation lane expressed as
# a thread.
#
# Continuous sweep rather than eight-beat steps -- real acid is a
# knob being turned, not a staircase. Period is 64 beats.
# -----------------------------------------------------------------

live_loop :acid_fx_controller do
  sync :bar
  64.times do |i|
    set :acid_cutoff, 60 + 45 * Math.sin(i * Math::PI / 32)
    sleep 1
  end
end


# ACIEEEEEEEED VOCAL STAB
# Sonic Pi-generated approximation, not a sample.
# Sleeps sum to exactly 32 beats so it lands on the bar.
# -----------------------------------------------------------------

live_loop :acieeeed do
  sync :bar
  sleep 30.75
  
  with_fx :reverb, room: 0.8, mix: 0.5 do
    with_fx :echo, phase: 0.25, decay: 2 do
      use_synth :prophet
      
      play :e4,
        attack: 0, sustain: 0.1, release: 0.6,
        cutoff: 100, res: 0.7, amp: 0.8
      sleep 0.25
      
      play :e5,
        attack: 0, sustain: 0.1, release: 0.8,
        cutoff: 115, res: 0.8, amp: 0.7
      sleep 1
    end
  end
end