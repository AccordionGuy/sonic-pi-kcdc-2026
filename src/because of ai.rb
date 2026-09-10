##| lazy_acoustic_vamp.rb
##| A laid-back acoustic-hip-hop loop for Sonic Pi.
##| Four-chord vamp, brushed strum pattern, boom-bap kit, open lead slot.
##| Everything is live-codeable: edit and hit Run without stopping.

use_bpm 78
use_random_seed 420

##| ---------------------------------------------------------------
##| Harmony. Each entry is [root, beats] -- chord lengths vary, so
##| the loops read the duration rather than assuming one bar each.
##| 32 beats = 8 bars per verse; the last two bars are half-bar
##| G/D changes, with the final D as the turnaround.
##| Stored with set/get so live_loops pick up edits next pass.
##| ---------------------------------------------------------------
set :prog, [
  [:g3, 4],
  [:c3, 4],
  [:d3, 4],
  [:g3, 8],
  [:c3, 4],
  [:g3, 2],
  [:d3, 2],
  [:g3, 2],
  [:d3, 2]
]

##| ---------------------------------------------------------------
##| A strum = the same chord, notes offset by a few milliseconds.
##| `at` schedules relative to now without consuming loop time, so
##| the caller's sleep math stays clean.
##| ---------------------------------------------------------------
define :strum do |notes, amp: 0.6, spread: 0.018, up: false, release: 1.8|
  ns = up ? notes.reverse : notes
  ns.each_with_index do |n, i|
    at i * spread do
      synth :pluck,
        note: n,
        amp: amp * rrand(0.88, 1.12),
        release: release,
        coef: rrand(0.2, 0.4)
    end
  end
end

##| ---------------------------------------------------------------
##| Guitar: D D U _ D U _ U on an eighth-note grid.
##| The `nil` slots are the muted ghost strokes -- they're what
##| makes it sound like a person and not a sequencer.
##| ---------------------------------------------------------------
live_loop :guitar do
  pattern = [:d, :d, :u, nil, :d, :u, nil, :u]   ##| one bar, in eighths
  get(:prog).each do |root, beats|
    ch = chord(root, :major)
    (beats * 2).times do |i|                     ##| beats -> eighth slots
      hit = pattern[i % pattern.length]
      unless hit.nil?
        strum ch,
          up: (hit == :u),
          amp: (hit == :d ? 0.70 : 0.40),
          release: (hit == :d ? 2.0 : 1.2)
      end
      sleep 0.5
    end
  end
end

##| ---------------------------------------------------------------
##| Bass: root, root, fifth. Two octaves down, fat and short.
##| ---------------------------------------------------------------
##| One bar of bass: root, root, fifth.
define :bass_bar do |root|
  synth :square, note: root,     amp: 0.85, release: 1.2, divisor: 1, depth: 1.2
  sleep 1.5
  synth :square, note: root,     amp: 0.55, release: 0.7, divisor: 1, depth: 1.2
  sleep 1.5
  synth :square, note: root + 7, amp: 0.45, release: 0.7, divisor: 1, depth: 1.2
  sleep 1.0
end

live_loop :bass, sync: :guitar do
  get(:prog).each do |root, beats|
    n = note(root) - 24
    if beats >= 4
      (beats / 4).times { bass_bar n }           ##| full bars
    else
      synth :fm, note: n, amp: 0.85,             ##| half-bar stabs
        release: beats * 0.8, divisor: 1, depth: 1.2
      sleep beats
    end
  end
end

##| ---------------------------------------------------------------
##| Drums. Snare a hair late on 2 and 4 -- that's the whole feel.
##| ---------------------------------------------------------------
live_loop :drums, sync: :guitar do
  4.times do |beat|
    if beat.even?                                   ##| beats 1 and 3
      sample :bd_tek, amp: (beat.zero? ? 2.0 : 1.6)
    else                                            ##| beats 2 and 4
      at(0.02) { sample :drum_snare_soft, amp: 1.1 }
    end
    sleep 1
  end
end

live_loop :hats, sync: :guitar do
  8.times do |i|
    sample :drum_cymbal_closed,
      amp: (i.even? ? 0.45 : 0.22),
      rate: 1.2,
      start: 0.02
    sleep 0.5
  end
end

##| ---------------------------------------------------------------
##| Lead slot. Put your own top line here -- degrees, not absolute
##| notes, so it follows whatever the vamp is doing.
##| Commented out; uncomment when you've got something.
##| ---------------------------------------------------------------
# live_loop :lead, sync: :guitar do
#   use_synth :hollow
#   get(:prog).each do |root, beats|
#     ch = chord(root, :major)
#     beats.times do |i|
#       play ch[i % ch.length], amp: 0.5, release: 0.9
#       sleep 1
#     end
#   end
# end

##| ---------------------------------------------------------------
##| Or play the lead live off a MIDI accordion:
##| ---------------------------------------------------------------
# live_loop :squeezebox do
#   use_real_time
#   n, v = sync "/midi:*/note_on"
#   synth :prophet, note: n, amp: v / 127.0, release: 0.6 if v > 0
# end

with_fx :reverb, room: 0.55, mix: 0.25 do
  # wrap loops here if you want the whole thing in a room --
  # or leave it dry, it sits better in the pocket
end
