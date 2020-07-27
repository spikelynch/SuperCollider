

// sequences



(
~subbass.stop;
~bell.stop;
~woodblock.stop;
~shaker.stop;
)


~kharmonic.postln



// TODO: better sequences!

(

~tc = TempoClock(100/120);

// ~shaker = Pbind(
// 	\instrument, \clinker_ii,
// 	\out, ~keyboardbus,
// 	\dur, Pseq([0.5, 0.5, Rest(1)], inf),
// 	\midinote, Pseq([100], inf),
// 	\amp, 0.1,
// 	\harmonics, 3.9291338582677,
// 	\partials, Pwhite(0.1, 0.4, inf),//  0.10236220472441,
// 	\rel, 1.125,
// 	\cutoff, 9300
// ).play(~tc);

// how to route the controls to this?

~woodblock = Pbind(
 	\instrument, \clinker_ii,
	\out, ~keyboardbus,
	\dur,      Pseq([1/4, Rest(1/4), 1/4, 1/4, 1/4, 1/4], inf),
	\midinote, Pseq([60, Rest(), 65, 63, 67, 70], inf),
	\amp, 0.45,
	\harmonic, Pfunc( { ~kharmonic} ),
	\partials, Pfunc( { ~kpartials} ),
	\rel, Pfunc( { ~krelease }),
	\cutoff, Pfunc( { ~kcutoff }),


	// \harmonics, 3.0787401574803,
	// \partials, 0.59842519685039,
	// \rel, 0.8125,
	// \cutoff, 800,
	\pan, Pseq([-0.3, -0.2, -0.1, 0, 0.1, 0.2, 0.3, 0.4], inf)
).play(~tc);

)

(
~subbass = Pbind(
	\instrument, \clinker_ii,
	\out, ~keyboardbus,
	\dur, Pseq([1, Rest(7)], inf),
	\midinote, Pseq([40, Rest()], inf),
	\amp, 0.45,
	\harmonics, 5.0,
	\partials, 0.75590551181102,
	\rel, 1.125,
	\cutoff, 100
).play(~tc);


~bell = Pbind(
	\instrument, \clinker_ii,
	\out, ~keyboardbus,
	\dur, 1,
	\degree, Pseq([0, 1, 2], inf),
	\amp, 0.45,
	\harmonics, 5.0,
	\partials, 1.0,
	\rel, 0.8125,
	\cutoff, 10200
).play(~tc);





)







// parking these here because I want to drive them
// with the keyboard

(

~lead = Pbind(
	\instrument, \clinker_ii,
	\out, ~keyboardbus,
	\dur, 1,
	\degree, Pseq([0, 1, 2], inf),
	\amp, 0.45,
	\harmonics, 3.1102362204724,
	\partials, 0.18897637795276,
	\rel, 3.03125,
	\cutoff, 3700
).play(~tc);


~volcano = Pbind(
	\instrument, \clinker_ii,
	\out, ~keyboardbus,
	\dur, 1,
	\degree, Pseq([-18, Rest(), -40], inf),
	\amp, 0.45,
	\harmonics, 1.3464566929134,
	\partials, 0.50393700787402,
	\rel, 3.625,
	\cutoff, 3300
).play(~tc)
)

(
~lead.stop;
~volcano.stop;
)