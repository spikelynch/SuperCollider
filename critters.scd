
(
SynthDef(
	\critter6,
	{ arg filt0 = 900, filtamp = 400, rq = 0.1, mul = 0.1;
		var freq = IRand(21, 108).midicps, length = Rand(1.3, 8), sig;
		sig = Pan2.ar(
			RLPF.ar(
				SinOsc.ar(SinOsc.kr(Rand(1, 20)) * freq * Rand(0.03, 0.2) + freq, 0, mul),
				SinOsc.kr(Rand(1, 20)) * filtamp + filt0,
				rq
		) * EnvGen.kr(Env.linen(length, length, length), doneAction: Done.freeSelf),
			Line.kr(Rand(-1,1), Rand(-1, 1), length * 3)
		);
		Out.ar(0, sig);
	}
).add;
)


(
Routine({
	   loop({
		Synth(\critter6, ["mul", rrand(0.002, 0.05)]);
		   rrand(1.0, 12.0).wait;
	   });
    }).play;
)
