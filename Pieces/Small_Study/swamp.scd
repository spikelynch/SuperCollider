
// Synth definitions are in synths.scd

(

// busses

~lfoBus = Bus.control(s);
~filterBus = Bus.audio(s, 2);
~delayBus = Bus.audio(s, 2);

~padlfoBus = Bus.control(s);
~padFilterBus = Bus.audio(s, 2);

// tempo and scale

~tc = TempoClock(90/120);


/* TODO:

Build up the song structure recursively

A: saw                               (16)
B: then insects and pads             (16)
C: then bass , bass pattern 2        (32)
D: then snare: bass, bass pattern 2  (32)
E: then make the pads weird          (32)
F: then drop the snare and insects   (16)
G: then just pads                    (16)

*/

~lenA = 16;
~lenB = 16;
~lenC = 32;
~lenD = 32;
~lenE = 32;
~lenF = 16;
~lenG = 16;



~sawDurs =    Pseq([1/8, Rest(7/8)]);    // = 1

// ~sawDurs = Pseq([Rest(1/3), 1/3, Rest(1/3)]);

~insectDurs = Pseq([1/32, Rest(3/32)], 8); // = 1

~snareDurs  = Pseq([Rest(1/2), 1/2]);    // = 1

~padMidi =    Pseq([ [60, 67], [62, 67], [64, 69], [65, 67] ]); // = 16
              // pad durs are all 4

~bassMidiA = [  57,  55, Rest(), 48, Rest()  ];  // = 4
~bassDursA = [ 3/8, 5/8, Rest(1), 1, Rest(1) ];

~bassMidiB = [  46,  Rest(),     50, Rest(),    53, Rest() ];
~bassDursB = [ 3/8,  Rest(3/8), 3/8, Rest(7/8), 1, Rest(1) ];

~bassMidi = Pseq([Pseq([Pseq(~bassMidiA, 4), Pseq(~bassMidiB, 4)], 3), Pseq(~bassMidiA, 4)]);
~bassDurs = Pseq([Pseq([Pseq(~bassDursA, 4), Pseq(~bassDursB, 4)], 3), Pseq(~bassDursA, 4)]);


~leadDurs = Pseq([ Rest(3/8), 1/8, 4/8, 1/8, 5/8, 1/8, 4/8, Rest(13/8) ], 8);
~leadMidi = Pseq([ Rest(),    55,  55,  53,  53,  48, 48,    Rest() ],    8);
~leadIscale = Pseq([ Rest(),    12,  15,  13,  18,  16, 20,    Rest()],   8);

// filter modulation

~filtminA = 300;
~filtmaxA = 1000;


~filtminB = 300;
~filtmaxB = 1000;

~filtminC = 300;
~filtmaxC = 1500;

~filtminD = 300;
~filtmaxD = 5000;

~filtminE = 300;
~filtmaxE = 2000;

~filtminF = 300;
~filtmaxF = 400;


// bass


Pbind(
	\instrument, \fmperc,
	\out, 0,
	\dur,      Pseq([ Rest(~lenA + ~lenB), ~bassDurs]),
	\midinote, Pseq([ Rest(~lenA + ~lenB), ~bassMidi]),
	\amp, 0.2,
	\atk, 0.1,
	\rel, 1.2,
	\index, 1,
	\iScale, 7,
	\cRatio, 1,
	\mRatio, 0.25
).play(~tc);



// lead; Rest(~lenA + ~lenB + ~lenC + ~lenD)

Pbind(
	\instrument, \fmperc,
	\out, ~padFilterBus,
	\dur,      Pseq([ Rest(~lenA + ~lenB + ~lenC + ~lenD), ~leadDurs]),
	\midinote, Pseq([ Rest(~lenA + ~lenB + ~lenC + ~lenD), ~leadMidi]),
	\amp,      0.04,   // crescendo
	\index, 1,
	\iScale,   Pseq([ Rest(~lenA + ~lenB + ~lenC + ~lenD), ~leadIscale]),
	\mRatio, 3,
	\cRatio, 2,
	\atk, 0.0,
	\rel, 2,
).play(~tc);


// insect;

Pbind(
	\instrument, \insect,
	\out, 0,
	\dur, Pseq([Rest(~lenA), Pseq([~insectDurs], ~lenB + ~lenC + ~lenD + ~lenE)]),
	\rq, 0.002,
	\pan, Pseq([ -0.6, -0.2, -0.1, -0, 0.1, 0.6, 0.3], inf),
	\amp, 0.1
).play(~tc);

// snare

// op

Pbind(
	\instrument, \snare,
	\out, 0,
	\dur, Pseq([ Rest(~lenA + ~lenB + ~lenC), Pseq([~snareDurs], ~lenD + ~lenE)]),
	\amp, 0.2
).play(~tc);



// distant weird pads

// pad filter lfo

~padsweep = Synth(\lfok, [\out, ~padlfoBus, \freq, 1/10]);

~padfilter = Synth(\lfofilter, [\lfo, ~padlfoBus, \cutoff, 2000, \mod, 600, \rq, 0.23, \mul, 1.0, \in, ~padFilterBus, \out, 0]);

Pbind(
	\instrument, \fmsus,
	\out, ~padFilterBus,
	\amp, 0.009,
	\dur, Pseq([Rest(~lenA), Pseq([4],inf)]),
	\midinote, Pseq([Rest(~lenA), Pseq([~padMidi], (~lenB + ~lenC + ~lenD + ~lenE + ~lenF + ~lenG) / 16)]),
	\mRatio, 2,
	\cRatio, 3,
	// Pseq([
	// 	Rest(~lenA),
	// 	Pseq([ 3 ] , (~lenB + ~lenC + ~lenD) / 4),
	// 	Pseq([Pwhite(2.9, 3.1)], (~lenE + ~lenF) / 4),
	// 	Pseq([Pwhite(2.8, 3.2)], ~lenG / 4)
	// ]),
	\index, 1,
	\iScale, 4,
	\atk, 2,
	\rel, 2
).play(~tc);


// saw sweep

// control

~sweep = Synth(\lfok, [\out, ~lfoBus, \freq, 1.2]);


Pbind(
	\instrument, \lfosaw,
	\out, ~filterBus,
	\lfo, ~lfoBus,
	\dur, Pseq([~sawDurs], ~lenA + ~lenB + ~lenC + ~lenD + ~lenE + ~lenF),
	\freq, 440,
	\mod, 100,
	\amp, 0.1,
	\atk, 0,
	\rel, 1.2,
	\pan, Pseq([-0.5, 0.4, 0.1], inf)
).play(~tc);


~filter = Synth(\filter, [\mul, 0.5, \in, ~filterBus, \out, ~delayBus]);

// note that this Pbind has to come after the ~filter definition or the nodeID
// will be wrong

// TODO - modulate this over the course of the piece

Pbind(
	\type, \set,
	\id, ~filter.nodeID,
	\args, #[\cutoff, \rq],
	\dur, 1/6,
	\cutoff, Pseq([
		Pwhite(~filtminA, ~filtmaxA, ~lenA * 6),
		Pwhite(~filtminB, ~filtmaxB, ~lenB * 6),
		Pwhite(~filtminC, ~filtmaxC, ~lenC * 6),
		Pwhite(~filtminD, ~filtmaxD, ~lenD * 6),
		Pwhite(~filtminE, ~filtmaxE, ~lenE * 6),
		Pwhite(~filtminF, ~filtmaxF, ~lenF * 6)
	]),
	\rq, Pwhite(0.02, 0.4, inf)
).play(~tc);

// route the filter output directly to out as well as to the delay

//{ Out.ar(0, In.ar(~delayBus)) }.play;

~delay = Synth(\stereodelay, [\in, ~delayBus, \out, 0, \delay, 1/3, \decay, 4, \mix, 1], addAction:\addToTail);




)

3 + 1 + 4 + 1 + 5 + 1 + 4 + 13