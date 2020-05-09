(
var midi, dur;
t = TempoClock.new;

t.tempo_(210/60);


midi = Pseq([60, 58, 60, 55, 51, 55, 48], 1).asStream;
dur = Pseq([1, 1, 1, 1, 1, 1, 1], 1).asStream;


SynthDef(\simple, { |out, freq = 440, sustain = 1, amp = 0.4|
	var sig;
	sig = Saw.ar(freq, amp) * EnvGen.kr(Env.linen(0.0, sustain, 0.1), doneAction: Done.freeSelf);
    Out.ar(out, sig ! 2)
}).add;

r = Task({
    var delta;
    while {
        delta = dur.next;
        delta.notNil
    } {
        Synth(\simple, [freq: midi.next.midicps, sustain: 0.1]);
        delta.yield;
    }
}).play(argClock:t, quant: t.beats + 130.0);




)

