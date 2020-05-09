(
SynthDef(\hihat,
	{
	arg pan = 0;
	Out.ar(0, Pan2.ar(
		HPF.ar(WhiteNoise.ar(0.2), 10000) *
			EnvGen.kr(Env.adsr(0.02, 0, 0, 0, 1), doneAction: Done.freeSelf),
		pan
		))
	}
).add;
)



Synth(\hihat, ["pan", 0.2]);


(
SynthDef(\kick,
	{
		arg pan = 0;
		Out.ar(0, Pan2.ar(
		   SinOsc.ar(XLine.kr(6000, 60, 0.01), 1) *
           Line.kr(0.2, 0, 0.5, doneAction:Done.freeSelf),
			pan))
	}
).add;
)

Synth(\kick, ["pan", -0.8]);

(
SynthDef(\snare,
{
	arg pan = 0;
	var snare, click;
	snare = { RLPF.ar(WhiteNoise.ar(0.4), XLine.kr(13000, 2500, 0.02)) * EnvGen.kr(Env.perc(0, 1, 1, -8), doneAction: Done.freeSelf) };
	click = { LPF.ar(WhiteNoise.ar(1), 1500) * Line.kr(1, 0, 0.09) };
		Out.ar(0, Pan2.ar(click + snare, pan));
}).add
)



Synth(\snare)

