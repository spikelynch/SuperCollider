/**
 * A simple example of MIDI Keyboard for SuperCollider 3.6.x
 */

MIDIIn.connect;
s.boot;

Server.killAll;
// from https://carlcolglazier.com/notes/midi-instrument-control-supercollider/


(
SynthDef("umbSinewave",{
	arg freq=440, gate=1, amp=1, pan=0;
	var x;
	x = SinOsc.ar(freq, 0, amp);
	x = EnvGen.kr(Env.adsr(0.1,0.3,0.5,1,0.6,-4),gate,doneAction: 2) * x;
	Out.ar(0, Pan2.ar(x,pan));
}).add;
)


(
SynthDef("klank", {
	arg freq=440, gate=1, amp=1, pan=0;
	var x;
	x = Klank.ar(`[[freq * 2, freq, freq / 3], nil, [1, 1, 1, 1]],BrownNoise.ar(0.009));
	x = EnvGen.kr(Env.adsr(0.02, 0.3, 0.5, 1, 0.2, -4), gate, doneAction: 2) * x;
	Out.ar(0, Pan2.ar(x, pan));
}).add;
)

Synth("klank")


(
var keys;
keys = Array.newClear(128);

~noteOnFunc = {arg src, chan, num, vel;
	var node;
	node = keys.at(num);
	if (node.notNil, {
		node.release;
		keys.put(num, nil);
	});
	node = Synth.tail(nil, "klank", [\freq, num.midicps, \amp, vel/127]);
	keys.put(num, node);
	[chan,num,vel/127].postln;
};
MIDIIn.addFuncTo(\noteOn, ~noteOnFunc);

~noteOffFunc = {arg src, chan, num, vel;
	var node;
	node = keys.at(num);
	if (node.notNil, {
		node.release;
		keys.put(num, nil);
	});
};
MIDIIn.addFuncTo(\noteOff, ~noteOffFunc);

)

MIDIIn.connect;


MIDIIn.disconnectAll

// cleanup
(
MIDIIn.removeFuncFrom(\noteOn, ~noteOnFunc);
MIDIIn.removeFuncFrom(\noteOff, ~noteOffFunc);
)