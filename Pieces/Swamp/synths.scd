(
SynthDef(\fmperc, {
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

SynthDef(\fmsus, {
	arg out=0, amp=0.2, gate=1, freq=500, mRatio=1, cRatio=1, index=1, iScale=5, atk=0.01, dec=0.1, sus=0.8, rel=1, pan=0;
	var car, mod, env, iEnv;
	env = EnvGen.kr(Env.adsr(atk, dec, sus, rel), gate,doneAction:2);
	iEnv = EnvGen.kr(Env.new([index, index * iScale, index], [atk, rel]));
	mod = SinOsc.ar(freq * mRatio, mul:freq * mRatio * iEnv);
	car = SinOsc.ar(freq * cRatio + mod) * env * amp;
	car = Pan2.ar(car, pan);
	Out.ar(out, car);
}).add;

SynthDef(\lfosaw, {
	arg out=0, lfo=9, amp=0.2, gate=1, freq=440, mod=40, atk=0.01, dec=0.1, sus=0.8, rel=1, pan=0;
	var sig, env;
	sig = Saw.ar((In.kr(lfo, 1)) * mod + freq, amp);
	env = EnvGen.kr(Env.adsr(atk, dec, sus, rel), gate,doneAction:2);
	Out.ar(out, Pan2.ar(sig * env, pan));
}).add;

SynthDef(\lfok,
	{
		arg out=9,freq=0.5;
		Out.kr(out, SinOsc.kr(freq))
	}
).add;

SynthDef(\filter, {
	arg in=6, out=0, mul=1.0, cutoff=1000, rq=1.0;
	Out.ar(out, RLPF.ar(In.ar(in, 2),cutoff,rq,mul));
}).add;

SynthDef(\stereodelay, {
	arg in=6, out=0, maxdelay=0.2, delay=0.2, decay=3;
	var left, right;
	left = CombC.ar(In.ar(in, 1), maxdelay, delay, decay);
	right = CombC.ar(In.ar(in + 1, 1), maxdelay, delay, decay);
	Out.ar(out, [ left, right ]);
}).add;


SynthDef(\stereodelay2, {
	arg in=6, out=0, mix=0.5, maxdelay=0.2, delay=0.2, decay=3;
	var inl=In.ar(in, 1), inr=In.ar(in + 1, 1), left, right;
	left = CombC.ar(inl, maxdelay, delay, decay);
	right = CombC.ar(inr, maxdelay, delay, decay);
	Out.ar(out, [ (inl * (1 - mix)) + (left * mix), (inr * (1 - mix)) + (right * mix) ]);
}).add;

SynthDef(\lfofilter, {
	arg in=6, out=0, lfo=12, mul=1.0, cutoff=1000, mod=500, rq=1.0;
	Out.ar(out, RLPF.ar(In.ar(in, 2),In.kr(lfo) * mod + cutoff,rq,mul));
}).add;


SynthDef(\insect, {
	arg out=0, pan=0, cutoff=10000, pulse=50, amp=0.2, rq=0.002, atk=0.01, rel=0.2;
	var env, sig;
	env = EnvGen.kr(Env.perc(atk, rel), doneAction:Done.freeSelf);
	sig = RHPF.ar(PinkNoise.ar(amp) * Saw.kr(pulse, 0.5, 0.5), cutoff, rq);
	Out.ar(out, Pan2.ar(sig * env, pan));
}).add;



SynthDef(\snare, {
	arg out=0, pan=0, filter=1000,amp=0.1,atk=0.01,rel=0.5;
	var env, sig, snap;
	env = EnvGen.kr(Env.perc(atk, rel), doneAction:Done.freeSelf);
	snap = BrownNoise.ar(XLine.kr(amp * 3, 0, rel));
	sig = 4 * Clip.ar(BPF.ar(Crackle.ar(1.95, 0.6), filter, 0.2), -0.5, 0.5);
	Out.ar(out, Pan2.ar(sig * env + snap, pan));
}).add;
)




