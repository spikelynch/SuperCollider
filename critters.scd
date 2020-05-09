(
// a synthdef browser
SynthDescLib.global.read;
SynthDescLib.global.browse;
)


(
SynthDef(
	\lfofilter,
	{ arg freq = 440, filt0 = 900, filtamp = 400, rq = 0.1, rate = 1, mul = 0.2;
		Out.ar(0,
			RLPF.ar(
				SinOsc.ar(freq, 0, mul),
				SinOsc.kr(rate) * filtamp + filt0,
				rq
			)
		)
	}
).add;
)

61.midicps;

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

Synth(\critter6);

(
    Routine({
	   loop({
		Synth(\critter6, ["mul", rrand(0.002, 0.05)]);
		   rrand(1.0, 12.0).wait;
	   });
    }).play;
)
Server.killAll


rrand(2.0, 10)


Synth(\lfofilter).play

Synth(\lfofilter, ["freq", 440, "rate", 2]).play


{ RLPF.ar(SinOsc.ar(SinOsc.kr(SinOsc.kr(0.3) * 5 + 6) * 100 + 300, 0.2), SinOsc.kr(SinOsc.kr(0.5) * 3 + 4) * 700 + 900, SinOsc.kr(0.4) * 0.2 + 0.5) }.play;