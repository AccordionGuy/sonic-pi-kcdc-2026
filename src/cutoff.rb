use_bpm 90

live_loop :amen do
  sample :loop_amen, beat_stretch: 2, cutoff: range(60, 130, 10).tick
  sleep 2
end