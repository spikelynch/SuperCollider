
(

SynthDef(\hihat,
	{
	arg amp = 1, pan = 0;
	Out.ar(0, Pan2.ar(
			HPF.ar(WhiteNoise.ar(0.2 * amp), Rand(800, 10000)) *
			Line.kr(0, 1, 0.04, doneAction: Done.freeSelf),
		pan
		))
	}
).add;

)


(
SynthDef(\snare,
{
	arg amp = 1, pan = 0;
	var snare, click;
	snare = { RLPF.ar(WhiteNoise.ar(0.4 * amp), XLine.kr(3000, 2500, 0.02)) * EnvGen.kr(Env.perc(0, 1, 1, -8), doneAction: Done.freeSelf) };
	click = { LPF.ar(WhiteNoise.ar(1 * amp), 1500) * Line.kr(1, 0, 0.09) };
		Out.ar(0, Pan2.ar(click + snare, pan));
}).add;
)

(

{
	arg amp = 1, pan = 0, release = 0.2;
	var snare, click, env;
	env = EnvGen.kr(Env.perc(0, release, amp), doneAction: Done.freeSelf);
	snare = {
		BPF.ar(PinkNoise.ar(1), XLine.kr(16000, 600, release) + SinOsc.kr(100, 0, 400))
	};
	Out.ar(0, Pan2.ar(env * snare, pan));
}.play

)
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


