(
SynthDef(\lead, {
	arg out=0, freq=440, detune=0.02, lfo=1, filt=4000, filtmod=2000, amp=1, pan=0, atk=0.1, dec=0.2, sus=0.7, rel=1, gate=1;
	var sig1, sig2, filtered, env;
	env = EnvGen.kr(Env.adsr(atk, dec, sus, rel), gate: gate, doneAction: Done.freeSelf);
	sig1 = Pulse.ar(freq,          0.5,  amp * 0.25);
	sig2 = Pulse.ar(freq * (1 + detune), 0.25, amp * 0.25);
	filtered = RLPF.ar(sig1 + sig2, filt + filtmod * env, 0.4);
	Out.ar(out, Pan2.ar(filtered, pan));
}).add;

SynthDef(\warmpad, {
	arg out=0, freq=220, lfo=3, filt=500, amp=1, pan=1, atk=3, dec=0, sus=1.0,  rel=3, gate=1;
	var sig, noise, env, filtered;
	env = EnvGen.kr(Env.adsr(atk,dec, sus, rel), gate:gate, doneAction:Done.freeSelf);
	sig = Saw.ar(freq, mul:amp * 0.5) + SinOsc.ar(freq / 2, mul: amp * 0.3);
	noise = PinkNoise.ar(amp * 0.2);
	filtered = RLPF.ar(sig + noise, filt);
	Out.ar(out, Pan2.ar(env * filtered, pan))
}).add;

SynthDef(\reverb,
	{
		arg in=4, out=0, mix=1.0, room=0.7, damp=0.2;
		var sig;
		sig = In.ar(in, 2);
		Out.ar(out, FreeVerb2.ar(sig[0], sig[1], mix, room, damp));
	}
).add;

)
(

SynthDef(\breath,
	{
		arg out=0, filt=10000, amp=1, atk=0.1, rel=3, rq=1.0, pan=0.0;
		var noise, filtered, env;
		env = EnvGen.kr(Env.perc(atk,rel, amp), doneAction: Done.freeSelf);
		noise = WhiteNoise.ar(amp);
		filtered = BPF.ar(noise, filt, rq);
		Out.ar(out, Pan2.ar( env *filtered,pan));
}).add;
)

Synth(\breath, [\amp, 0.3, \filt, 600, \atk, 1])

Synth(\lead, [\detune, 0.002, \amp, 0.2])

w = Synth(\warmpad, [\amp, 0.4, \filt, 1400]);

w.release;

(

~fibomaker = {
	arg m = 17;
	Routine {
		var i = 0, j = 1, k;
		loop {
			j.yield;
			k = j;
			j = (i + j) % m;
			i = k;
		};
	};
};

)

~fibomaker.value(17)


(

~modulo = 17;

~fibomaker = {
	arg m = 17;
	Routine {
		var i = 0, j = 1, k;
		loop {
			j.yield;
			k = j;
			j = (i + j) % m;
			i = k;
		};
	};
};

Synth(\reverb, [ \room, 0.45, \mix, 0.4 ], addAction: \addToTail);

~clock = TempoClock(70/60);

Pbind(
	\instrument, \warmpad,
	\degree, Pfunc(~fibomaker.value(15), inf) - 8,
	\out, 4,
	\amp, 0.3,
	\dur, Pseq([3/2, 3/2, 2/2], inf),
	\filt, 400,
	\atk, 0.2,
	\rel, 2,
	\filt, Pseq([ 500, 600, 700, 800, 700, 600], inf),
	\legato, 0.4
).play(~tc);



Pbind(
	\instrument, \lead,
	\degree, Pfunc(~fibomaker.value(17), inf),
    \out, 4,
	\amp, 0.1,
	\dur, Pfunc(~fibomaker.value(5)/8, inf),
	\filtmod, 200,
	\atk, 0.01,
	\dec, 0.05,
	\sus, 0.9,
	\rel, 0.2,
	\pan, Pwhite(-1.0, 0.3, inf),
	\detune, 0.004
).play(~tc);


Pbind(
	\instrument, \breath,
	\filt, 6000,
	\dur, Pseq([1/16, Rest(1/16)], inf),
	\amp, Pwhite(0, 0.2, inf),
	\rel, 0.2,
	\atk, 0
).play(~tc);

)

~modulo = 15

(

Pbind(
	\instrument, \lead,
	\degree, Pfunc(~fibomaker.value(17), inf),
    \out, 4,
	\amp, 0.2,
	\dur, Pseq([1/16, Rest(3/16)], inf),
	\filtmod, 1200,
	\atk, 0.01,
	\dec, 0.05,
	\sus, 0.9,
	\rel, 0.2,
	\pan, Pwhite(-0.2, 0.7, inf),
	\detune, 0.004
).play(~tc);
)