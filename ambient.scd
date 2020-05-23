



(
SynthDef("filthum", {
	arg out=0, freq=440, gate=1, amp=0.1, pan=0;
	var sig, env;
	sig = Klank.ar(`[(1..7) * freq, nil, nil],BrownNoise.ar(0.009));
	env = EnvGen.kr(Env.adsr(2.3, 0.3, 0.4, 2.6, amp, -4), gate, doneAction: 2);
	sig = sig * env;
	Out.ar(0, Pan2.ar(sig, pan));
}).add;

SynthDef(\fm, {
	arg out=0, freq=500, mRatio=1, cRatio=1, index=1, iScale=5,
	amp=0.2, atk=0.01, rel=3, pan=0;
	var car, mod, env, iEnv;
	env = EnvGen.kr(Env.perc(atk, rel), doneAction:2);
	iEnv = EnvGen.kr(Env.new([index, index * iScale, index], [atk, rel]));
	mod = SinOsc.ar(freq * mRatio, mul:freq * mRatio * iEnv);
	car = SinOsc.ar(freq * cRatio + mod) * env * amp;
	car = Pan2.ar(car, pan);
	Out.ar(out, car);
}).add;

// dusty metallic drone
SynthDef(\dustdrone,
    {
	arg out=0;
    var x, y;
	x = LPF.ar(SinOsc.ar(110, mul:0.03) + PinkNoise.ar(0.12) + Dust.ar(4, 2), SinOsc.kr(1/5,phase:0.3) * 2500 + 5000);
	y = LPF.ar(SinOsc.ar(114, mul:0.03) + PinkNoise.ar(0.12) + Dust.ar(4, 2), SinOsc.kr(1/3) * 2500 + 5000);
    x = Pan2.ar(x, -0.7);
	y = Pan2.ar(y, 0.3);
	x = [x[0] + DelayC.ar(y[0], 0.02, 0.01), y[1] + DelayC.ar(x[1], 0.01, 0.01)]; // de-correlate
	Out.ar(out, x);
}).add;

SynthDef(\reverb,
	{
		arg in=2, out=0, mix=1.0, room=0.7, damp=0.2;
		var sig;
		sig = In.ar(in, 2);
		Out.ar(out, FreeVerb2.ar(sig[0], sig[1], mix, room, damp));
	}
).add;

)


(
Synth(\reverb, [ \in: 4, \out: 0], addAction:\addToTail);

Synth(\dustdrone, [ \out: 4]);


p = Pbind(
	\instrument, \filthum,
	\out, 4,
	\amp, 0.1,
	\pan, Pwhite(-0.3, 0.3),
	\freq, Pseq([Pshuf([35, 36, 37, 39].midicps), [ Rest(1) ]], inf),
	\dur, Pseq([Pwhite(3, 4, 4), Rest(rrand(4, 7))], inf)
).play;

p = Pbind(
	\instrument, \fm,
	\out, 0,
	\amp, 0.02,
	\index, 4,
	\cRatio, Pwhite(4.0, 4.5),
	\mRatio, Pwhite(1.3, 2.3),
	\pan, Pwhite(-0.5, -0.45),
	\freq, Prand([71, 73, 75, 77, 79].midicps, inf),
	\dur, 1
).play;
)






