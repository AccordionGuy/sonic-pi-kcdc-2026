live_loop :foo do
  play_chord [52, 55, 59]
  sleep sample_duration :loop_breakbeat
end

live_loop :rock do
  with_fx :reverb do
    ##| with_fx :distortion do
    sample :loop_breakbeat
    sleep sample_duration :loop_breakbeat
    ##| end
  end
end


