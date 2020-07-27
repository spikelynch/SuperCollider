

~buffer.free

(
//~recordbus = Bus.audio(s, 1);

~keyboardbus = Bus.audio(s, 2);

~granulatorbus = Bus.audio(s, 2);

~buffer = Buffer.alloc(s, s.sampleRate * 4.0, 1);



// this now takes a stereo bus and mixes it down to one channel
// for the buffer

SynthDef(\recorder, {
	arg in = 0, bufnum = 0, mix = 0.25;
	RecordBuf.ar(Mix.ar(In.ar(in, 2)), bufnum, 0, mix, 1 - mix, loop: 1)
}).add;


SynthDef(\recorder_filt, {
	arg in = 0, bufnum = 0, mix = 0.25, cutoff = 4000;
	RecordBuf.ar(RLPF.ar(Mix.ar(In.ar(in, 2)), cutoff), bufnum, 0, mix, 1 - mix, loop: 1)
}).add;


SynthDef(\recorder_filt_channels, {
	arg in = 0, feedback = 2, fbamp = 0.2, bufnum = 0, mix = 0.25, cutoff = 4000;
	var fback = Mix.ar(In.ar(feedback, 2)) * fbamp;
	RecordBuf.ar(RLPF.ar(Mix.ar(In.ar(in, 2)) + fback, cutoff), bufnum, 0, mix, 1 - mix, loop: 1)
}).add;


// mix its inputs
// SynthDef(\mixer, {
// 	arg in = 2, out = 0 amp = 1.0;
// 	Out.ar(out, Mix.ar(in) * amp);
// }).add;


SynthDef(\playback, {
	arg out = 0, bufnum = 0;
	var playbuf = PlayBuf.ar(1, bufnum);
	FreeSelfWhenDone.kr(playbuf);
	Out.ar(out, playbuf);
}).add;




SynthDef(\passthrough, {
	arg out=0, in=6, pan=0, amp=0.8;
	Out.ar(out, Pan2.ar(In.ar(in, 2) * amp, pan));
}).add;


SynthDef(\passthrough_stereo, {
	arg out=0, in=6, amp=0.8;
	Out.ar(out, In.ar(in, 2));
}).add;



SynthDef(\granulator_mouse, {
    arg out = 0, bufnum = 0, amp = 0.5;
	var trate, dur, blen, clk, pos, pan;
    trate = MouseY.kr(8,120,1);
    dur = 12 / trate;
    clk = Impulse.kr(trate);
	blen = BufDur.kr(bufnum);
	pos = (SinOsc.kr(MouseX.kr(0,0.3), 0, 0.5) + 0.5)  * blen;
    pan = WhiteNoise.kr(0.6);
	Out.ar(out, TGrains.ar(2, clk, bufnum, 1, pos, dur, pan, amp));
}).add;

SynthDef(\granulator_mouse_static, {
    arg out = 0, bufnum = 0, amp = 0.5;
	var trate, dur, blen, clk, pos, pan;
    trate = MouseY.kr(8,120,1);
    dur = 12 / trate;
    clk = Impulse.kr(trate);
	blen = BufDur.kr(bufnum);
	pos = MouseX.kr(0, blen);
    pan = MouseX.kr(-1, 1);
	Out.ar(out, TGrains.ar(2, clk, bufnum, 1, pos, dur, pan, amp));
}).add;

// used for Knuckles take one, i think

SynthDef(\granulator_bounce, {
    arg out = 0, bufnum = 0, amp = 0.5, freq = 1;
	var dur, blen, clk, pos, pan;
    var trate = freq * 16;
    dur = 20 / trate;
    clk = Impulse.kr(trate);
	blen = BufDur.kr(bufnum);
	pos =  (SinOsc.kr(freq, 0, 0.5) + 0.5)  * blen;
    pan = SinOsc.kr(freq);
	Out.ar(out, TGrains.ar(2, clk, bufnum, 1, pos, dur, pan, amp));
}).add;

// used for PRE second demo

SynthDef(\granulator_sweep, {
    arg out = 0, bufnum = 0, amp = 0.5, freq = 1;
	var dur, blen, clk, pos, pan;
    var trate = freq * 16;
    dur = 20 / trate;
    clk = Impulse.kr(trate);
	blen = BufDur.kr(bufnum);
	pos =  (LFSaw.kr(freq, 0.5) + 0.5)  * blen;
    pan = LFSaw.kr(freq);
	Out.ar(out, TGrains.ar(2, clk, bufnum, 1, pos, dur, pan, amp));
}).add;


/* ktrl should be a unipolar control bus (0 - 1.0) which
   is used to control the position in the buffer
   panb is a bipolar control bus (-1.0 - 1.0) which controls
  the pan

*/

SynthDef(\granulator_modular, {
    arg out = 0, ktrl = 5, panb = 6, bufnum = 0, amp = 0.5, trate = 48, dur = 0.02;
	var blen, clk, pos, pan;
    clk = Impulse.kr(trate);
	blen = BufDur.kr(bufnum);
	pos = In.kr(ktrl, 1) * blen;
	pan = In.kr(panb, 1);
	Out.ar(out, TGrains.ar(2, clk, bufnum, 1, pos, dur, pan, amp));
}).add;



SynthDef(\clinker_ii,
	{
		arg out=0, freq=440, cutoff=8000, amp=0.1, harmonic=1, fade=1.0, partials=0.6, atk=0.01, rel=2, pan=0;
		var e = EnvGen.kr(Env.perc(atk, rel, 1), doneAction: Done.freeSelf);
		var noiseamp = 0.35;
		var i = e * RLPF.ar(WhiteNoise.ar(amp * noiseamp), cutoff, 0.6);
		var nharms = 40;
		var harmonics = freq * Array.series(nharms, 1, harmonic);
		var amplitudes = Array.geom(nharms, 1 / nharms, fade);
		var rings = Array.geom(nharms, 1, partials);
		var bank = `[ harmonics, amplitudes, rings ];
		var sig = RLPF.ar(Klank.ar(bank, i), cutoff, 0.2);
		//var sig = Klank.ar(bank, i);
		Out.ar(out, Pan2.ar(e * sig, pan));
	}
).add;


SynthDef(\clinker_impulse,
	{
		arg out=0, freq=440, cutoff=8000, amp=0.1, harmonic=1, fade=1.0, partials=0.6, atk=0.01, rel=2, pan=0;
		var noiseamp = 0.65;
		var e = EnvGen.kr(Env.perc(atk, rel, 1), doneAction: Done.freeSelf);
		var i = Impulse.ar(0, 0, amp * noiseamp);
		var nharms = 40;
		var harmonics = freq * Array.series(nharms, 1, harmonic);
		var amplitudes = Array.geom(nharms, 1 / nharms, fade);
		var rings = Array.geom(nharms, 1, partials);
		var bank = `[ harmonics, amplitudes, rings ];
		var sig = RLPF.ar(Klank.ar(bank, i), cutoff, 0.2);
		//var sig = Klank.ar(bank, i);
		Out.ar(out, Pan2.ar(e * sig, pan));
	}
).add;

SynthDef(\clinker_dust,
	{
		arg out=0, freq=440, dust=100, cutoff=8000, amp=0.1, harmonic=1, fade=1.0, partials=0.6, atk=0.01, rel=2, pan=0;
		var dustamp = 0.25;
		var e = EnvGen.kr(Env.perc(atk, rel, 1), doneAction: Done.freeSelf);
		var i = e * Dust.ar(dust, amp * dustamp);
		var nharms = 40;
		var harmonics = freq * Array.series(nharms, 1, harmonic);
		var amplitudes = Array.geom(nharms, 1 / nharms, fade);
		var rings = Array.geom(nharms, 1, partials);
		var bank = `[ harmonics, amplitudes, rings ];
		var sig = RLPF.ar(Klank.ar(bank, i), cutoff, 0.2);
		//var sig = Klank.ar(bank, i);
		Out.ar(out, Pan2.ar(e * sig, pan));
	}
).add;


)




(

~recsynth = Synth(\recorder_filt, [
	\in, ~keyboardbus,
	\bufnum, ~buffer,
	\mix, 0.35,
	\cutoff, 3000,
], addAction:'addToTail');


Synth(\passthrough_stereo, [\out, 0, \in, ~keyboardbus, \amp, 0.1]);

~granposbus = Bus.control(s, 1);

~granpanbus = Bus.control(s, 1);

// { Out.kr(~granposbus, SinOsc.kr(0.25, 0, 0.5, 0.5)) }.play;
// { Out.kr(~granpanbus, SinOsc.kr(0.25, pi)) }.play;

// { Out.kr(~granposbus, LFSaw.kr(0.25, 0.5, 0.5)) }.play;
// { Out.kr(~granpanbus, LFSaw.kr(0.25)) }.play;

// {
// 	Out.kr(~granposbus, SinOsc.kr(SinOsc.kr(0.2) * 10 + 10.1, 0, 0.5, 0.5))
// }.play;

{ Out.kr(~granposbus, SinOsc.kr(MouseX.kr(0, 0.5), 0, 0.5, 0.5)) }.play;

{
	Out.kr(~granpanbus, WhiteNoise.kr(0.6))
}.play;


)



(

~granulatorsynth = Synth(\granulator_modular, [
	\out, 0,
	\bufnum, ~buffer,
	\ktrl, ~granposbus,
	\panb, ~granpanbus,
	\amp, 0.7,
	\trate, 10,
	\dur, 0.4,
	\freq, 0.25
]);





)


(
// change freqs and ringtimes with mouse
{    var freqs, ringtimes;
    freqs = [800, 1071, 1153, 1723] * MouseX.kr(0.5, 2, 1);
    ringtimes = [1, 1, 1, 1] * MouseY.kr(0.1, 10, 1);
    DynKlank.ar(`[freqs, nil, ringtimes ], Impulse.ar(2, 0, 0.1))
}.play;
)


pi
~granulatorsynth.free