
// resonator synth

(

SynthDef(\clinker_stereo,
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


(

SynthDef(\clinker,
	{
		arg out=0, freq=440, cutoff=8000, amp=0.1, harmonic=1, partials=0.6, atk=0.01, rel=2;
		var e = EnvGen.kr(Env.perc(atk, rel, 1), doneAction: Done.freeSelf);
		var i = WhiteNoise.ar(amp * 0.35);
		//var i = Impulse.ar(0, 0, amp * 0.5);
		var nharms = 10;
		var bank = `[ freq * Array.series(nharms, harmonic), Array.geom(nharms, 1 / nharms, 0.8), Array.geom(nharms, 1, partials) ];
		var sig = RLPF.ar(Klank.ar(bank, i), cutoff, 0.6);

		Out.ar(out, e * sig);
	}
).add;


)

440 * Array.series(40, 1, 2.2)





// fibonacci harmonics which sound like a toy piano

(

SynthDef(\tinkle,
	{
		arg out=0, freq=440, cutoff=8000, amp=0.1, harmonic=1, fade=1.0, partials=0.6, atk=0.01, rel=2, pan=0;
		var e = EnvGen.kr(Env.perc(atk, rel, 1), doneAction: Done.freeSelf);
		var noiseamp = 0.15;
		var i = e * RLPF.ar(WhiteNoise.ar(amp * noiseamp), cutoff, 0.6);
		var nharms = 40;
		var harmonics = freq * harmonic * Array.fib(nharms, 1, 1);
		var amplitudes = Array.geom(nharms, 1 / nharms, fade);
		var rings = Array.geom(nharms, 1, partials);
		var bank = `[ harmonics, amplitudes, rings ];
		//var sig = RLPF.ar(Klank.ar(bank, i), cutoff, 0.2);
		var sig = Klank.ar(bank, i);
		Out.ar(out, Pan2.ar(e * sig, pan));
	}
).add;


)


Array.geom(40, 1/40, 1)

// try fibo frequencis
Array.fib(10, 0.1, 0.2) - 1

~h = 6

440 * Array.fib(10, 1, 1)

440 * (~h - Array.geom(10, (~h - 1), 0.5))

// this is a bit boring and resonates too much
// var harmonics = freq * (harmonic - Array.geom(nharms, (harmonic - 1), 0.5));
