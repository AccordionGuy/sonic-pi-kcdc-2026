use_bpm 97

live_loop :kick do
  sample :bd_haus
  sleep (sample_duration :loop_electric) / 4
end

live_loop :hihat do
  sample :hat_tap, amp: 0.8
  sleep (sample_duration :loop_electric) / 16
end

live_loop :rock do
  sample :loop_electric
  sleep sample_duration :loop_electric
end