
/*

Todo - name the sequences, make it easier to switch them on and off. maybe
add a drone.

intro and outro, structure.

*/

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
	arg out=0, filtbus=6, freq=220, amp=1, pan=1, atk=3, dec=0, sus=1.0,  rel=3, gate=1;
	var sig, noise, env, filtered;
	env = EnvGen.kr(Env.adsr(atk,dec, sus, rel), gate:gate, doneAction:Done.freeSelf);
	sig = Saw.ar(freq, mul:amp * 0.5) + SinOsc.ar(freq / 2, mul: amp * 0.3);
	noise = PinkNoise.ar(amp * 0.2);
	filtered = RLPF.ar(sig + noise, In.kr(filtbus, 1) + 500);
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


SynthDef(\breath,
	{
		arg out=0, filt=10000, amp=1, atk=0.1, rel=3, rq=1.0, pan=0.0;
		var noise, filtered, env;
		env = EnvGen.kr(Env.perc(atk,rel, amp), doneAction: Done.freeSelf);
		noise = WhiteNoise.ar(amp);
		filtered = BPF.ar(noise, filt, rq);
		Out.ar(out, Pan2.ar( env *filtered,pan));
}).add;

SynthDef(\lfok,
	{
		arg out=6,freq=0.5, mul=100, add=800;
		Out.kr(out, SinOsc.kr(freq,mul: mul, add:add))
	}
).add;
)



{ SinOsc.kr(0.5, 0, 100, 800).poll }.play;

~scale = Scale.minor(\pythagorean)


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

~lk = Synth(\lfok, [\out, 6, \freq, 1/24, \mul, 1000, \add, 1000]);

Synth(\reverb, [ \room, 0.45, \mix, 0.4 ], addAction: \addToTail);

~clock = TempoClock(60/60);

~scale = Scale.major(\pythagorean);


Pbind(
	\instrument, \warmpad,
	\scale, ~scale,
	\degree, Pfunc(~fibomaker.value(15), inf) - 8,
	\out, 4,
	\amp, 0.3,
	\dur, Pseq([3/2, 3/2, 2/2], inf),
	\filt, 400,
	\atk, 0.2,
	\rel, 3.5,
	\filtbus, 6,
	\legato, 0.4
).play(~clock);

Pbind(
	\instrument, \lead,
	\scale, ~scale,
	\degree, Pfunc(~fibomaker.value(17), inf),
    \out, 4,
	\amp, 0.1,
	\dur, Pseq([1/16, Rest(3/16)], inf),
	\filtmod, 200,
	\atk, 0.01,
	\dec, 0.05,
	\sus, 0.9,
	\rel, 0.2,
	\pan, Pwhite(-0.2, 0.7, inf),
	\detune, 0.004
).play(~clock);


Pbind(
	\instrument, \lead,
	\scale, ~scale,
	\degree, Pfunc(~fibomaker.value(11), inf) + 3,
    \out, 4,
	\amp, 0.1,
	\dur, Pseq([1/16, Rest(3/16)], inf),
	\filtmod, 200,
	\atk, 0.01,
	\dec, 0.05,
	\sus, 0.9,
	\rel, 0.2,
	\pan, Pwhite(-1.0, 0.3, inf),
	\detune, 0.004
).play(~clock);


Pbind(
	\instrument, \breath,
	\filt, Pwhite(5000,10000,inf),
	\dur, Pseq([1/16, Rest(1/16)], inf),
	\amp, Pfunc(~fibomaker.value(190), inf) / 400,
	\rel, 0.2,
	\atk, 0
).play(~clock);


)

