# pentatonic.rb
#
# The whole point: every note in a pentatonic scale sounds fine
# against every other one. Pick at random, it still works.
#
# Built for live uncommenting. Every loop syncs to :bar at the top,
# so a loop you start mid-performance waits for the next bar boundary
# instead of entering wherever you happened to hit Run.
#
# The rule that makes this work: every loop's sleeps sum to EXACTLY
# 4 beats, the same as the clock's period. Sync for alignment,
# sleeps for rhythm, and the two never fight.

use_bpm 96

##| kick_pat  = (bools 1,1,1,1, 1,1,1,1)
kick_pat  = (bools 1,0,0,1, 0,0,1,0)
snare_pat = (bools 0,0,1,0, 0,0,1,0)
hat_pat   = (bools 1,0,1,1, 1,0,1,1)


# DRUMS -- 16 x 0.25 = 4 beats
live_loop :drums do
  sync :bar
  16.times do
    tick
    ##| sample :bd_haus, amp: 3                if kick_pat.look
    sample :sn_dolf, amp: 1.5                  if snare_pat.look
    sample :hat_gnu, amp: 3.0, rate: 1.2       if hat_pat.look
    sleep 0.25
  end
end


# MELODY -- 32 x 0.25 = 8 beats
live_loop :melody do
  sync :bar
  use_synth :pluck
  32.times do
    play scale(:e4, :minor_pentatonic).choose, release: 0.4, amp: 0.9
    sleep 0.25
  end
end


# BASS -- 8 x 0.5 = 4 beats
live_loop :bass do
  sync :bar
  use_synth :fm
  8.times do
    play scale(:e2, :minor_pentatonic).choose, release: 0.6, amp: 1.5
    sleep 0.5
  end
end


# CLOCK
# Makes no sound. Fires once per bar, and everything above waits on it.
#
# Defined LAST on purpose: sync only catches cues sent after it is
# called, so a clock defined first would fire before the voices above
# reached their sync and they'd all sit out a bar. delay: 4 removes
# the race entirely.
live_loop :clock, delay: 4 do
  cue :bar
  sleep 4
end