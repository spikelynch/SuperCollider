(
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
)




// nice bass
Synth(\fm, [\freq: 110, \atk: 0, \rel: 1.2, \index:1, \iScale:5,\cRatio:1, \mRatio:0.25, \amp: 0.5])



(
SynthDef(\fmmouse, {
	arg freq=500, index=1, iScale=5,
	amp=0.2, atk=0.01, rel=3, pan=0;
	var car, mod, env, iEnv, mRatio, cRatio;
	mRatio = MouseX.kr(1, 20);
	cRatio = MouseY.kr(1, 20);
	env = EnvGen.kr(Env.perc(atk, rel), doneAction:2);
	iEnv = EnvGen.kr(Env.new([index, index * iScale, index], [atk, rel]));
	mod = SinOsc.ar(freq * mRatio, mul:freq * mRatio * iEnv);
	car = SinOsc.ar(freq * cRatio + mod) * env * amp;
	car = Pan2.ar(car, pan);
	Out.ar(0, car);
}).add;
)

Synth(\fmmouse, [\freq: 43.midicps, \rel: 2, \index: 2, \amp: 0.1])




(
SynthDef(\fmdrone, {
	arg freq=500, mRatio=1, cRatio=1, index=1,
	lfoFreq=1, lfoAmp=0,
	amp=0.2, gate=1,
	atk=0.01, dec=0.2, sus=0.5, rel=0.5, pan=0;
	var lfo, car, mod, env;
	env = EnvGen.kr(Env.adsr(atk, dec, sus, rel, 0.2, -4.0), gate, doneAction:2);
	lfo = SinOsc.kr(lfoFreq, mul: lfoAmp);
	mod = SinOsc.ar(freq * mRatio, mul:freq * mRatio * index);
	car = SinOsc.ar(freq * cRatio + mod * (1 + lfo)) * env * amp;
	car = Pan2.ar(car, pan);
	Out.ar(0, car);
}).add;
)

Synth(\fmdrone, [\lfoFreq: 1/10, \lfoAmp: 0.12, \mRatio: 5, \index: 2])









MIDIIn.connect;

(
var keys;
keys = Array.newClear(128);

~noteOnFunc = {arg src, chan, num, vel;
	var node;
	node = keys.at(num);
	if (node.notNil, {
		node.release;
		keys.put(num, nil);
	});
	node = Synth.head(nil, "fm", [\out: 4, \freq, num.midicps, \amp, vel/127, \atk: 0.03, \rel: 0.6, \index: 2]);
	keys.put(num, node);
	[chan,num,vel/127].postln;
};
MIDIIn.addFuncTo(\noteOn, ~noteOnFunc);

~noteOffFunc = {arg src, chan, num, vel;
	var node;
	node = keys.at(num);
	if (node.notNil, {
		node.release;
		keys.put(num, nil);
	});
};
MIDIIn.addFuncTo(\noteOff, ~noteOffFunc);

)


(
MIDIIn.removeFuncFrom(\noteOn, ~noteOnFunc);
MIDIIn.removeFuncFrom(\noteOff, ~noteOffFunc);
)

