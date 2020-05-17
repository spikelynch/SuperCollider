
m = 34;

(
f = Routine {
    var i = 0, j = 1, k;
    loop {
		j.yield;
	    k = j;
	    j = (i + j) % m;
	    i = k;
    };
};
)





t = 10;

(t + 1).midicps

Pbind(\freq, Pfunc(f, inf), \dur, 0.3).play;


Pbind(\freq, Prand([300, 500, 231.2, 399.2], inf), \dur, 0.1).play;

(
// a SynthDef
SynthDef(\test, { | out, freq = 440, amp = 0.1, nharms = 10, pan = 0, gate = 1 |
	var audio = Blip.ar(freq, Rand(2, 10), amp);
    var env = Linen.kr(gate, doneAction: Done.freeSelf);
    OffsetOut.ar(out, Pan2.ar(audio, pan, env) );
}).add;
)


Pbind(\instrument, \test, \freq, (Pfunc(f, inf) + 40).midicps , \dur, 1/8).play;

m = 30;

f

// modulate frequency
{ Blip.ar(XLine.kr(20000,200,6),100,0.2) }.play;

// modulate numharmonics
{ Blip.ar(200,Line.kr(1,100,20),0.2) }.play;