# kpop.rb
#
# An original K-pop-flavoured track. Not a transcription of anything --
# it's built from genre conventions: four-on-the-floor, a i-VI-III-VII
# loop, offbeat supersaw stabs, a bright 16th-note pluck hook, and a
# pentatonic topline that enters after eight bars.
#
# Same idiom as the blues script: tick once, .look for everything else,
# bools for the drum grid. Everything runs on a 16th-note grid, so each
# loop sleeps 0.25 and every bar is 16 slots.

use_bpm 124

# ----------------------------------------------------------------
# HARMONY -- A minor: i VI III VII. One chord per bar.
# ----------------------------------------------------------------
bass_roots  = (ring :a1, :f1, :c2, :g1)
chord_roots = (ring :a3, :f3, :c4, :g3)
chord_types = (ring :minor, :major, :major, :major)

# ----------------------------------------------------------------
# DRUM GRID -- 16 slots per bar.
# ----------------------------------------------------------------
kick_pat = (bools 1,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,1,0)
clap_pat = (bools 0,0,0,0, 1,0,0,0, 0,0,0,0, 1,0,0,0)
hat_pat  = (bools 1,0,1,0, 1,0,1,1, 1,0,1,0, 1,1,1,1)
stab_pat = (bools 0,0,1,0, 0,0,1,0, 0,0,1,0, 0,1,0,1)
hook_pat = (bools 1,0,1,1, 0,1,1,0, 1,0,1,1, 0,1,0,1)
lead_pat = (bools 1,0,0,0, 0,1,0,0, 1,0,0,1, 0,0,0,0)

# Which chord tone the hook lands on, cycling independently of the
# 16-slot bar. 7 against 16 means the hook never repeats identically
# across the 4-bar loop -- polyrhythm for free.
hook_degrees = (ring 0, 2, 1, 3, 2, 4, 1)

# Topline shape, in scale degrees.
lead_degrees = (ring 9, 7, 8, 7)

# ----------------------------------------------------------------
# Fake sidechain. Real sidechain ducks a signal when the kick hits;
# here it's just arithmetic on the 16th index -- quiet on the beat,
# swelling back before the next one.
# ----------------------------------------------------------------
define :duck do |i|
  0.25 + 0.75 * ((i % 4) / 4.0)
end

# ----------------------------------------------------------------
# DRUMS
# ----------------------------------------------------------------
live_loop :drums do
  tick
  sample :bd_haus,            amp: 4                if kick_pat.look
  sample :sn_dolf,            amp: 2, cutoff: 120   if clap_pat.look
  sample :drum_cymbal_closed, amp: 0.8, rate: 1.2   if hat_pat.look
  sleep 0.25
end

# ----------------------------------------------------------------
# BASS -- straight 8ths on the root, sub-heavy.
# ----------------------------------------------------------------
live_loop :bass do
  i   = tick
  bar = (i / 16) % 4
  
  if i % 2 == 0
    use_synth :fm
    play note(bass_roots[bar]),
      amp: 2, release: 0.4, divisor: 0.8, depth: 1.5
  end
  sleep 0.25
end

# ----------------------------------------------------------------
# STABS -- supersaw on the offbeats, ducked under the kick.
# ----------------------------------------------------------------
live_loop :stabs do
  i   = tick
  bar = (i / 16) % 4
  
  if stab_pat.look
    use_synth :tri
    play chord(chord_roots[bar], chord_types[bar]),
      amp: 0.5 * duck(i), release: 0.25, cutoff: 100
  end
  sleep 0.25
end

# ----------------------------------------------------------------
# HOOK -- bright pluck arpeggio. The 7-note degree ring runs against
# the 16-slot bar, so it phases through the loop.
# ----------------------------------------------------------------
live_loop :hook do
  i   = tick
  bar = (i / 16) % 4
  
  if hook_pat.look
    use_synth :pluck
    notes = chord(chord_roots[bar], chord_types[bar], num_octaves: 2)
    play notes[hook_degrees.look] + 12,
      amp: 0.9 * duck(i), release: 0.3
  end
  sleep 0.25
end

