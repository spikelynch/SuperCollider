
// resonator synth

(

SynthDef(\clinker,
	{
		arg out=0, freq=440, cutoff=8000, amp=0.1, harmonic=1, partials=0.6, atk=0.01, rel=2, pan=0;
		var e = EnvGen.kr(Env.perc(atk, rel, 1), doneAction: Done.freeSelf);
		var i = WhiteNoise.ar(amp * 0.35);
		//var i = Impulse.ar(0, 0, amp * 0.5);
		var nharms = 10;
		var bank = `[ freq * Array.series(nharms, harmonic), Array.geom(nharms, 1 / nharms, 0.8), Array.geom(nharms, 1, partials) ];
		var sig = RLPF.ar(Klank.ar(bank, i), cutoff, 0.6);
		Out.ar(out, Pan2.ar(e * sig, pan));
	}
).add;


)


