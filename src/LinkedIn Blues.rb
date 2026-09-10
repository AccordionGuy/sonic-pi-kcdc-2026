# twelve_bar_blues.rb
#
# 12-bar blues in E, shuffle feel.
#
# Every voice keeps its own thread-local tick and works out its own bar
# number from it, so there is no shared state and nothing to race. Each
# loop sleeps exactly 4 beats per bar, so they stay locked forever.
#
# Patterns are parallel rings: tick ONCE per iteration, then .look for
# everything else. .look reads at the current tick index without
# advancing it -- ticking twice in one iteration is the classic bug.

use_bpm 100

# ----------------------------------------------------------------
# THE PROGRESSION -- 12 bars, quick change in bar 2.
# I  IV I  I  | IV IV I  I  | V  IV I  V
# ----------------------------------------------------------------
roots = (ring :e2, :a2, :e2, :e2,
         :a2, :a2, :e2, :e2,
         :b2, :a2, :e2, :b2)

# ----------------------------------------------------------------
# THE SHUFFLE -- eight slots per bar, long-short, long-short.
# 2/3 + 1/3 = one beat. Four pairs = four beats.
# Every loop below sleeps on this same ring, which is what makes
# them swing together.
# ----------------------------------------------------------------
swing = (ring 2.0 / 3, 1.0 / 3)

# ----------------------------------------------------------------
# PATTERNS -- bools on the same eight-slot grid.
# ----------------------------------------------------------------
kick_pat  = (bools 1, 0, 0, 0,  1, 0, 1, 0)
snare_pat = (bools 0, 0, 1, 0,  0, 0, 1, 0)
comp_pat  = (bools 0, 1, 0, 1,  0, 1, 0, 1)   # piano chops the upbeats
lead_pat  = (bools 1, 0, 1, 1,  0, 1, 0, 0)   # leaves room to breathe

# ----------------------------------------------------------------
# MELODIC MATERIAL
# ----------------------------------------------------------------
# Boogie bass: root, 3rd, 5th, 6th, b7, 6th, 5th, 3rd.
bass_line = (ring 0, 4, 7, 9, 10, 9, 7, 4)

# Dominant 7th shell -- root, 3rd, b7. No 5th; it just muddies things.
shell = [0, 4, 10]

# Degrees into the blues scale for the lead riff.
lead_degrees = (ring 0, 2, 3, 4, 3, 2, 1, 0)

# ----------------------------------------------------------------
# DRUMS
# ----------------------------------------------------------------
live_loop :drums do
  tick
  sample :bd_haus, amp: 3            if kick_pat.look
  sample :sn_dolf, amp: 2, cutoff: 110 if snare_pat.look
  sleep swing.look
end

# ----------------------------------------------------------------
# BASS
# ----------------------------------------------------------------
live_loop :bass do
  i   = tick
  bar = (i / 8) % 12
  
  use_synth :fm
  play note(roots[bar]) + bass_line.look,
    amp:     1.5,
    release: 0.35,
    divisor: 1.2
  sleep swing.look
end

# ----------------------------------------------------------------
# PIANO -- comping on the upbeats, an octave above the bass.
# ----------------------------------------------------------------
live_loop :piano do
  i   = tick
  bar = (i / 8) % 12
  
  if comp_pat.look
    use_synth :piano
    root = note(roots[bar]) + 24
    play shell.map { |iv| root + iv },
      amp:     0.7,
      release: 0.4
  end
  sleep swing.look
end

# ----------------------------------------------------------------
# LEAD -- blues scale, so the blue note is already in the box.
# Sits out the first chorus, then plays from bar 12 onward.
# ----------------------------------------------------------------
live_loop :lead do
  i    = tick
  bar  = (i / 8) % 12
  bars = i / 8
  
  if bars >= 12 && lead_pat.look
    use_synth :organ_tonewheel
    with_fx :reverb, room: 0.5, mix: 0.25 do
      play scale(:e5, :blues_minor)[lead_degrees.look],
        amp:     0.8,
        cutoff:  rrand(85, 110),
        release: 0.5
    end
  end
  sleep swing.look
end