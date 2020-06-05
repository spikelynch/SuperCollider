(
    {
	var n = 20, h = Harmonics(n);
	SinOsc.ar(440 * h.formant(13, 3), 0, Lag.kr(LFNoise0.kr(50 * (n..1), 1/n), 0.1)  ) ! 2
}.play
)

(100..1)

a = Harmonics(32)

a.formant(16,16)



(
SynthDef(\formant,
    {
		arg out=0, freq=440, amp=1, pan=0, centre=0.5, width=0.3, stutterfreq = 50, smooth = 0.1;
		var h = Harmonics(20), sig, stutter, env;
		//stutter = Lag.kr(LFNoise0.kr(stutterfreq * (20..1), 1/20), smooth);
		sig = SinOsc.ar(freq * h.formant(20 * centre, 20 * width), mul:amp/n);
		Out.ar(out, sig ! 2);
}).add;
)


Synth(\formant, [\centre, 0.3, \width, 0.2])

(
    {
		var h = Harmonics(20), sig;
		SinOsc.ar(440 * h.formant(10, 3),mul:0.2/20) ! 2;
}.play;
)
