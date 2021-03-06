
(

SynthDef(\hihat,
	{
	arg amp = 1, pan = 0, gate = 1;
	Out.ar(0, Pan2.ar(
			HPF.ar(WhiteNoise.ar(0.2 * amp), Rand(800, 10000)) *
			EnvGen.kr(Env.adsr(0.02, 0, 0, 0, 1), gate, doneAction: Done.freeSelf),
		pan
		))
	}
).add;

)

h = Synth(\hihat, ["gate" ,1])

h.set(\gate, 0)



(
SynthDef(\env_help, { |out, gate = 1, amp = 0.1, release = 0.1|
    var env = Env.adsr(0.02, release, amp);
    var gen = EnvGen.kr(env, gate, doneAction: Done.freeSelf);
    Out.ar(out, PinkNoise.ar(1 ! 2) * gen)
}).add
)

a = Synth(\env_help)

a.set(\gate, 0)



{ SinOsc.ar(440, 0.2) * EnvGen.kr(Env.adsr(0.02, 0, 0, 0), doneAction: Done.freeSelf) }.play







(
SynthDef(\kick,
	{
		arg amp = 1, pan = 0;
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
	arg amp = 1, pan = 0;
	var snare, click;
	snare = { RLPF.ar(WhiteNoise.ar(0.4 * amp), XLine.kr(13000, 2500, 0.02)) * EnvGen.kr(Env.perc(0, 1, 1, -8), doneAction: Done.freeSelf) };
	click = { LPF.ar(WhiteNoise.ar(1 * amp), 1500) * Line.kr(1, 0, 0.09) };
		Out.ar(0, Pan2.ar(click + snare, pan));
}).add;
)

(

~hatAmps = [ 0, 0, 0.6, 1, 0, 0, 1, 0, 0, 0, 0.6, 1, 0, 1, 0, 0.6 ];
~hatPans = [ -0.8, 0.7, -0.6, 0.5, -0.4, 0.3, -0.2, 0.1, 0, -0.1, 0.2, -0.3, 0.4, -0.5, 0.6, -0.7 ];

~snareAmps = [ 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0 ];
~snarePans = [ 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2 ];

~kickAmps = [ 1, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 0,0.6 ];


Pbind(
	\instrument, \hihat,
	\dur, 1/8,
	\amp, Pseq(~hatAmps, inf),
	\pan, Pseq(~hatPans, inf)
).play();

Pbind(
	\instrument, \snare,
	\dur, 1/8,
	\amp, Pseq(~snareAmps, inf),
	\pan, Pseq(~snarePans, inf)
).play();

Pbind(
	\instrument, \kick,
	\dur, 1/8,
	\amp, Pseq(~kickAmps, inf)
).play();



)

