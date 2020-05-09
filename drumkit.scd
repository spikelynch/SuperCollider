(
SynthDef(\hihat,
	{ Out.ar(0, EnvGen.kr(Env.adsr(0, 0.2, 0, 0, 1)) * HPF.ar(WhiteNoise.ar(0.2), 10000)) }
).add;
)


Synth(\hihat);




