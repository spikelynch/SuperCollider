


// grain sample buffer

b = Buffer.readChannel(s, "/Users/mike/Music/SuperCollider/guitar.wav", channels: [0]);


b.free;
b.plot
b.play


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
	RecordBuf.ar(In.ar(in, 1), bufnum, 0, 0.25, 0.75, loop: 1)
}).add;

)

~recorder = Synth(\recordIn, [ \in, 2, \bufnum, b ], addAction: \addToTail)
~recorder.free;



// granular synth -
(
SynthDef(\grains, {
	arg out = 0, bufnum = 0, pos = 0.5, amp = 1.0, attack = 0.01, release = 1.5, pan = 0;
    var blen, clk, env, trate;
    trate = 10;
    clk = Impulse.kr(trate);
	blen = BufDur.kr(bufnum);
	env = EnvGen.kr(Env.perc(attack, release), doneAction: Done.freeSelf);
	Out.ar(out, env * TGrains.ar(2, clk, bufnum, 0.5, pos * blen, 0.1, WhiteNoise.kr() - 0.5, amp));
}).add;
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


~grainAmps = [ 1, 0, 0, 1,    0, 0, 1,  0, 0, 0, 1,   0, 1, 0, 0, 0 ];
~grainPos =  [ 0, 0, 0, 3/16, 0, 0, 3/8,0, 0, 0, 5/8, 0, 3/4, 0, 0, 0 ];
~kickAmps =  [ 1,   0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0 ];

~tc = TempoClock(90/120);


Pbind(
	\instrument, \grains,
	\dur, 1/8,
	\release, 1.4,
	\bufnum, b,
	\amp, Pseq(~grainAmps, inf),
	\pos, Pseq(~grainPos, inf)
).play(~tc);
Pbind(
	\instrument, \kick,
	\dur, 1/8,
	\amp, 0.5 * Pseq(~kickAmps, inf)
).play(~tc);


)

{ Out.ar(0, 0.5 * (In.ar(2) ! 2)) }.play









