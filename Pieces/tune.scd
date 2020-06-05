
(

SynthDef(\hihat,
	{
	arg out=0, amp = 1, pan = 0;
	Out.ar(out, Pan2.ar(
			HPF.ar(WhiteNoise.ar(0.2 * amp), Rand(800, 10000)) *
			Line.kr(0, 1, 0.04, doneAction: Done.freeSelf),
		pan
		))
	}
).add;

SynthDef(\kick,
	{
		arg out=0, amp=1, pan = 0;
		Out.ar(out, Pan2.ar(
			( SinOsc.ar(XLine.kr(6000, 60, 0.01), amp * 0.7) + BrownNoise.ar(Line.kr(amp * 0.3, 0, 0.1))) *
           Line.kr(0.2 * amp, 0, 0.2, doneAction:Done.freeSelf),
			pan))
	}
).add;


SynthDef(\snare,
{
	arg out=0, amp = 1, pan = 0;
	var snare, click;
	snare = { RLPF.ar(PinkNoise.ar(0.4 * amp), XLine.kr(13000, 2500, 0.02)) * EnvGen.kr(Env.perc(0, 1, 1, -8), doneAction: Done.freeSelf) };
	click = { LPF.ar(WhiteNoise.ar(1 * amp), 1500) * Line.kr(1, 0, 0.09) };
		Out.ar(out, Pan2.ar(click + snare, pan));
}).add;

SynthDef(\fm, {
	arg out=0, freq=500, mRatio=1, cRatio=1, index=1, iScale=5,
	amp=0.2, atk=0.01, rel=3, pan=0;
	var car, mod, env, iEnv;
	env = EnvGen.kr(Env.perc(atk, rel), doneAction:2);
	iEnv = EnvGen.kr(Env.new([index, index * iScale, index], [atk, rel]));
	mod = SinOsc.ar(freq * mRatio, mul:freq * mRatio * iEnv);
	car = SinOsc.ar(freq * cRatio + mod) * env * amp;
	car = Pan2.ar(car, pan);
	Out.ar(out, car);
}).add;


SynthDef("filthum", {
	arg out=0, freq=440, gate=1, amp=0.1, pan=0;
	var sig, env;
	sig = Klank.ar(`[(1..7) * freq, nil, nil], PinkNoise.ar(0.009));
	env = EnvGen.kr(Env.adsr(2.3, 0.3, 0.4, 2.6, amp, -4), gate, doneAction: 2);
	sig = sig * env;
	Out.ar(out, Pan2.ar(sig, pan));
}).add;

SynthDef(\reverb,
	{
		arg in=2, out=0, mix=1.0, room=0.7, damp=0.2;
		var sig;
		sig = In.ar(in, 2);
		Out.ar(out, FreeVerb2.ar(sig[0], sig[1], mix, room, damp));
	}
).add;


)







(
// reverb
)

(
Synth(\reverb, [ \in: 4, \out: 0, \mix: 0.2, \room: 0.4], addAction:\addToTail);
)


(
Synth(\fm, [\freq: 440, \atk: 0.5, \rel: 1.5, \index:33, \iScale:1,\cRatio:2, \mRatio:3, \amp: 0.2])
)


Synth(\hihat)

Synth(\kick)

Synth(\snare)

(

Synth(\reverb, [ \in: 4, \out: 0, \mix: 0.2, \room: 0.4], addAction:\addToTail);

~hatAmps = [ 0, 0, 0.6, 1, 0, 0, 1, 0, 0, 0, 0.6, 1, 0, 1, 0, 0.6 ];
~hatPans = [ -0.8, 0.7, -0.6, 0.5, -0.4, 0.3, -0.2, 0.1, 0, -0.1, 0.2, -0.3, 0.4, -0.5, 0.6, -0.7 ];

~snareAmps = [ 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0 ];
~snarePans = [ 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2 ];

~kickAmps = [ 1, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 0,0.6 ];

~bassNotes = [ 30, 30, 22, 22, Rest(1) ];
~bassDur = [ 5/8, 3/8, 3/8, 3/8, 2/8 ];

~humNotes = [ 54, 56 ];


~tc = TempoClock(40/60);



Pbind(
	\instrument, \hihat,
	\out, 4,
	\dur, 1/8,
	\amp, Pseq(~hatAmps, inf),
	\pan, Pseq(~hatPans, inf)
).play(~tc);

Pbind(
	\instrument, \snare,
	\dur, 1/8,
	\out, 4,
	\amp, Pseq(~snareAmps, inf),
	\pan, Pseq(~snarePans, inf)
).play(~tc);

Pbind(
	\instrument, \kick,
	\out, 4,
	\dur, 1/8,
	\amp, Pseq(~kickAmps, inf)
).play(~tc);

Pbind(
	\instrument, \fm,
	\out, 4,
	\iScale, 5,
	\cRatio, 1,
	\mRatio, 0.25,

	\dur, Pseq(~bassDur, inf),
	\freq, Pseq(~bassNotes.midicps * 4, inf),
	\amp, 0.2
).play(~tc);


Pbind(
	\instrument, \filthum,
	\out, 4,
	\dur, 4,
	\freq, Pseq(~humNotes.midicps, inf)
).play(~tc);


)



{ CombC.ar(Decay.ar(Dust.ar(1,0.5), 0.2, WhiteNoise.ar), 0.2, 0.2, 3) }.scope(1, zoom:4);
