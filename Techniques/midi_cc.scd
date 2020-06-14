/**
 * Testbed for getting signals from the knobs on my Launchkey Mini to SC
 */

MIDIIn.connect;
s.boot;

Server.killAll;
// from https://carlcolglazier.com/notes/midi-instrument-control-supercollider/


(
SynthDef(\sinwobble, {
	arg out=0, amp=1, pan=0, freq=440.0, lfo=1, filter=900, filtamp=400, rq=0.1;
	var sig, filtered;
	sig = SinOsc.ar(freq, 0, amp);
	filtered = RLPF.ar(sig, SinOsc.kr(lfo) * filtamp + filter, rq);
	Out.ar(0, Pan2.ar(filtered, pan));
}).add;
)



~wobbler.set(\lfo, 2, \freq, 660, \filtamp, 500, \rq, 0.2);

(
~wobbler = Synth(\sinwobble, [ \amp, 0.2, \filtamp, 400, \lfo, 10]);

~wobbleLFO = MIDIFunc.cc({
	|value, channel|
	[ value, channel ].postln;
	~wobbler.set(\lfo, 40 * value / 127);
}, 21);

~wobbleFreq = MIDIFunc.cc({
	|value, channel|
	[ value, channel ].postln;
	~wobbler.set(\freq, 3 * value + 440);
}, 22);

~wobbleFiltamp = MIDIFunc.cc({
	|value, channel|
	[ value, channel ].postln;
	~wobbler.set(\filtamp, 3 * value + 200);
}, 23);

~wobbleRes = MIDIFunc.cc({
	|value, channel|
	[ value, channel ].postln;
	~wobbler.set(\rq, value / 127);
}, 24);

)

(
~wobbleLFO.free;
~wobbleFreq.free;
~wobbleFiltamp.free;
~wobbleRes.free;

)

MIDIIn.connect;

c =


)



MIDIIn.connect;

a = MIDIFunc.cc({arg ...args; args.postln}, 21); // match cc 1
a.free;

~pots = MIDIFunc.cc({arg ...args; args.postln}, (21..28));

~pots.free;

MIDIIn.disconnectAll

// cleanup
(
MIDIIn.removeFuncFrom(\noteOn, ~noteOnFunc);
MIDIIn.removeFuncFrom(\noteOff, ~noteOffFunc);
)