# Math Rock 1
# An “Angine de Poitrine” style loop written in 7/8 time,
# counted as 1-2-3, 1-2, 1-2
# (Think “Tom Sawyer” by Rush, “Them Bones” by Alice in Chains,
# “Money” by Pink Floyd, and “Spoonman” by Soundgarden)

use_bpm 140

# 1. Define a Custom Microtonal Scale (Quarter-Tones)
# Adding 0.5 to a MIDI note raises it by exactly a quarter-tone (50 cents)
# This creates a tense, dissonant Middle Eastern / Xenakis-style flavor
micro_scale = [60, 60.5, 63, 64.5, 66, 67.5, 71]

# 2. The 7/8 Frantic Math-Rock Drum Loop (3 + 2 + 2)
live_loop :math_drums do
  # Pattern: Kick on 1, Snare on 4 and 6
  # Beats:   1   2   3   | 4   5   | 6   7
  
  # Group of 3
  sample :bd_haus, amp: 1.5
  sleep 0.5
  sample :elec_tick, amp: 0.7
  sleep 0.5
  sample :elec_tick, amp: 0.7
  sleep 0.5
  
  # Group of 2
  sample :sn_dolf, amp: 1.2
  sleep 0.5
  sample :elec_tick, amp: 0.7
  sleep 0.5
  
  # Group of 2
  sample :sn_dolf, amp: 1.2, play: 62 # Slight pitch shift for urgency
  sleep 0.5
  sample :elec_tick, amp: 0.7
  sleep 0.5
end

# 3. The Algorithmic Microtonal Guitar/Bass Line
live_loop :micro_guitar do
  use_synth :supersaw
  use_synth_defaults release: 0.4, amp: 0.8
  
  # Sync perfectly with the start of the 7/8 drum measure
  sync :math_drums
  
  # Play 7 fast notes across the 7/8 bar (one note per eighth note)
  7.times do
    # Pick a random microtonal note from our custom array
    current_note = micro_scale.choose
    
    # Add aggressive math-rock accents randomly
    if one_in(3)
      play current_note + 12, pan: rrand(-0.5, 0.5), amp: 1.2 # Octave jump
    else
      play current_note, pan: rrand(-0.2, 0.2)
    end
    
    sleep 0.5
  end
end

# 4. Ambient Microtonal Drone (Creates a heavy, tense atmosphere)
live_loop :dissonant_drone do
  use_synth :supersaw
  # Play a constant quarter-tone clash (Root vs Root + 50 cents)
  with_fx :low_pass_filter, cutoff: 70 do
    play 48, sustain: 3.5, release: 0.5, amp: 0.3
    play 48.5, sustain: 3.5, release: 0.5, amp: 0.25
    sleep 3.5 # Total duration of one 7/8 bar (7 beats * 0.5 sleep = 3.5)
  end
end
