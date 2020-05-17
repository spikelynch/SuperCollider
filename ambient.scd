


// Note: put the FreeVerb outside of the SynthDef because it's being cut off.

(
SynthDef("filthum", {
	arg freq=440, gate=1, amp=0.1, pan=0;
	var sig, env;
	sig = Klank.ar(`[(1..7) * freq, nil, nil],BrownNoise.ar(0.009));
	env = EnvGen.kr(Env.adsr(2.3, 0.3, 0.4, 2.6, amp, -4), gate, doneAction: 2);
	sig = sig * env;
	Out.ar(0, FreeVerb.ar(Pan2.ar(sig, pan), 1.0, 1.0, 0.1));
}).add;
)



Synth("filthum", [\freq: 65])

(
p = Pbind(
	\instrument, \filthum,
	\amp, 0.1,
	\pan, Pwhite(-0.3, 0.3),
	\freq, Pseq([Pshuf([35, 36, 37, 39].midicps), [ Rest(1) ]], inf),
	\dur, Pseq([Pwhite(3, 4, 4), Rest(rrand(4, 7))], inf)
).play;
)

35.midicps

65.cpsmidi
[1,2,3].cpsmidi

(
SynthDef(\dustdrone,
    {
    // dusty metallic drone
    var x, y;
	x = LPF.ar(SinOsc.ar(110, mul:0.03) + PinkNoise.ar(0.12) + Dust.ar(4, 2), SinOsc.kr(1/5,phase:0.3) * 2500 + 5000);
	y = LPF.ar(SinOsc.ar(114, mul:0.03) + PinkNoise.ar(0.12) + Dust.ar(4, 2), SinOsc.kr(1/3) * 2500 + 5000);
    x = Pan2.ar(x, -0.7);
	y = Pan2.ar(y, 0.3);
	x = [x[0] + DelayC.ar(y[0], 0.02, 0.01), y[1] + DelayC.ar(x[1], 0.01, 0.01)]; // de-correlate
	Out.ar(0, FreeVerb.ar(x, 1, 0.2));
}).add;
)

Synth(\dustdrone)


(
SynthDef(\fm, {
	arg freq=500, mRatio=1, cRatio=1, index=1, iScale=5,
	amp=0.2, atk=0.01, rel=3, pan=0;
	var car, mod, env, iEnv;
	env = EnvGen.kr(Env.perc(atk, rel), doneAction:2);
	iEnv = EnvGen.kr(Env.new([index, index * iScale, index], [atk, rel]));
	mod = SinOsc.ar(freq * mRatio, mul:freq * mRatio * iEnv);
	car = SinOsc.ar(freq * cRatio + mod) * env * amp;
	car = Pan2.ar(car, pan);
	Out.ar(0, car);
}).add;
)


(
{
    var in = LFNoise1.kr(3);
    var octave = Schmidt.kr(in, -0.15, 0.15) + 1;
    SinOsc.ar(in * 200 + 500 * octave, 0, 0.1)
}.scope;
)

// nice bass
Synth(\fm, [\freq: 500, \atk: 0, \rel: 4, \index:1,\cRatio:4.2, \mRatio:1.3, \amp: 0.3])

500.cpsmidi

(71..83)

(
p = Pbind(
	\instrument, \fm,
	\amp, 0.02,
	\cRatio, 4.2,
	\mRatio, 1.3,
	\pan, Pwhite(-1, -0.3),
	\freq, Prand([71, 73, 75, 77, 79].midicps, inf),
	\dur, 1
).play;
)


