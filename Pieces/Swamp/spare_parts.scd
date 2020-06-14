
//spare parts



Pbind(
	\instrument, \fmsus,
	\out, 6,
	\dur, Pseq([1/8], inf),
	\midinote, Pseq([48, Rest(), 50, Rest(), 50, Rest(), 53, Rest()], inf),
	\amp, 0.1,
	\mRatio, 2,
	\pan, Pwhite(-0.3,0.3, inf)
).play(~tc);
