notes_1 = (ring :e3, :g3, :a3, :b3, :d4)
notes_2 = (ring :e2, :e3, :g3, :a3, :b3, :e4, :d4)

live_loop :my_melody do
  use_synth :beep
  play notes_1[tick]
  sleep 0.5
end

live_loop :my_melody_faster do
  use_synth :pluck
  with_swing offset: 2, shift: 1 do
    play notes_1.choose, amp:0.8
  end
  sleep 0.25
  
end


##| live_loop :kick_snare do

##|   with_swing pulse: 8, offset: 1, shift: 1.0 / 4 do

##|     if (ring :kick, :snare).tick == :kick
##|       sample :bd_haus
##|     else
##|       sample :sn_dolf
##|     end

##|   end

##| sleep 0.5

##| end