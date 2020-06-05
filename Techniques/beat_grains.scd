

// Do this and reboot the server to make sure input just comes from the Scarlett

Server.default.options.inDevice_("Scarlett 2i2 USB")



// simple beat

(
SynthDef(\hihat,
	{
	arg out = 0, amp = 1, pan = 0, release = 0.05, freq = 10000;
	Out.ar(out, Pan2.ar(
			HPF.ar(WhiteNoise.ar(amp), freq) * EnvGen.kr(Env.perc(0, release, amp), doneAction: Done.freeSelf),
		pan
		))
	}
).add;
)

(
SynthDef(\kick,
	{
		arg out = 0, amp = 1, pan = 0;
		Out.ar(0, Pan2.ar(
		   SinOsc.ar(XLine.kr(6000, 60, 0.01), 1) *
           Line.kr(0.2 * amp, 0, 0.5, doneAction:Done.freeSelf),
			pan))
	}
).add;
)

(
SynthDef(\snare,
{
	arg out = 0, amp = 1, pan = 0;
	var snare, click;
	snare = { RLPF.ar(WhiteNoise.ar(0.4 * amp), XLine.kr(13000, 2500, 0.02)) * EnvGen.kr(Env.perc(0, 1, 1, -8), doneAction: Done.freeSelf) };
	click = { LPF.ar(WhiteNoise.ar(1 * amp), 1500) * Line.kr(1, 0, 0.09) };
		Out.ar(out, Pan2.ar(click + snare, pan));
}).add;
)


(

~hatAmps =   [ 0.3, 0.3, 0.3, 0, 0.3, 0, 0.3, 0, 0.3, 0.3, 0, 0.3, 0.3, 0, 0.3, 0  ];
~kickAmps =  [ 1,   0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1, 0 ];
~snareAmps = [ 0,   0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0 ];

~grainAmps = [ 2, 0, 2, 0, 2, 0, 2, 0, 2, 0, 2, 0, 2, 0, 2, 0 ];

~tc = TempoClock(90/120);

Pbind(
	\instrument, \hihat,
	\dur, 1/8,
	\amp, 0.5 * Pseq(~hatAmps, inf),
	\pan, 0.2
).play(~tc);


Pbind(
	\instrument, \kick,
	\dur, 1/8,
	\amp, 0.5 * Pseq(~kickAmps, inf)
).play(~tc);

Pbind(
	\instrument, \grains,
	\dur, 1/8,
	\release, 1,
	\bufnum, b,
	\amp, Pseq(~grainAmps, inf),
	\pos, Pseq([Pshuf([0, 0.125, 0.25, 0.375, 0.5, 0.625, 0.75, 0.825])], inf)
).play(~tc);


)

Pseq([Pshuf([1,2, 3, 4])], inf).asStream.nextN(10)





Server.default.options.inDevice_("Scarlett 2i2 USB")


// grain sample buffer

(
b = Buffer.alloc(s, s.sampleRate * 2.166666, 1);
)

b.free;
b.plot


// record USB input to the sample buffer loop
(
SynthDef(\recordIn, { arg in = 2, out = 0, bufnum = 0;
	RecordBuf.ar(In.ar(in, 1), bufnum, 0, 0.5, 0.5, loop: 1)
}).add;

)



// granular synth -
(
SynthDef(\grains, {
	arg out = 0, bufnum = 0, pos = 0.5, amp = 1.0, attack = 0.01, release = 0.5, pan = 0;
    var dur, blen, clk, env;
    trate = MouseY.kr(8,120,1);
    dur = 12 / trate;
    clk = Impulse.kr(trate);
	blen = BufDur.kr(bufnum);
	env = EnvGen.kr(Env.perc(attack, release), doneAction: Done.freeSelf);
	Out.ar(out, env * TGrains.ar(2, clk, bufnum, 1, pos * blen, dur, pan, amp));
}).add;
)

// passthrough

{ Out.ar(0, In.ar(2) ! 2) }.play

~recorder = Synth(\recordIn, [ \in, 2, \bufnum, b ], addAction: \addToTail)
~recorder.free;
Synth(\grains, [ \bufnum, b ])



