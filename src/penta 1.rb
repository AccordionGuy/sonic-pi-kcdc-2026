# pentatonic.rb
#
# The whole point: every note in a pentatonic scale sounds fine
# against every other one. Pick at random, it still works.

use_bpm 96
##| kick_pat  = (bools 1,1,1,1, 1,1,1,1)
kick_pat  = (bools 1,0,0,1, 0,0,1,0)
snare_pat = (bools 0,0,1,0, 0,0,1,0)
hat_pat   = (bools 1,0,1,1, 1,0,1,1)

live_loop :drums do
  tick
  ##| cue :beat
  sample :bd_haus,            amp: 3               if kick_pat.look
  sample :sn_dolf,            amp: 1.5             if snare_pat.look
  sample :hat_gnu, amp: 3.0, rate: 1.2  if hat_pat.look
  sleep 0.25
end

##| live_loop :melody do
##|   ##| sync :beat
##|   use_synth :pluck
##|   play scale(:e4, :minor_pentatonic).choose, release: 0.4, amp: 0.9
##|   sleep 0.125
##| end

##| live_loop :bass do
##|   use_synth :fm
##|   sync :beat
##|   play scale(:e2, :minor_pentatonic).choose, release: 0.6, amp: 1.5
##|   sleep 0.5
##|   end
