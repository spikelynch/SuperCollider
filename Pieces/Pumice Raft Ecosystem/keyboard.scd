



(



MIDIIn.connect;

~keys = Array.newClear(25);
~pads = Array.newClear(16);


~kharmonic = 3/2;
~kpartials = 0.75;
~krelease = 0.8;
~kcutoff = 4000;

~pharmonic = 3/2;
~ppartials = 0.75;
~prelease = 0.8;
~pcutoff = 4000;



// MIDI controls

MIDIFunc.cc({ | value | ~kharmonic = value / 31.75 + 1},   21);
MIDIFunc.cc({ | value | ~kpartials = value / 127 },     22);
MIDIFunc.cc({ | value | ~krelease = value / 32 },       23);
MIDIFunc.cc({ | value | ~kcutoff = value * 100 + 100 }, 24);

MIDIFunc.cc({ | value | ~pharmonic = value / 31.75 + 1},  25);
MIDIFunc.cc({ | value | ~ppartials = value / 127 },    26);
MIDIFunc.cc({ | value | ~prelease = value / 32 },       27);
MIDIFunc.cc({ | value | ~pcutoff = value * 100 + 100 }, 28);

~padmap = [ 0, 1, 2, 3, 8, 9, 10, 11, 4, 5, 6, 7, 12, 13, 14, 15 ];

// note - this won't work if you shift the octave with the LaunchKey controls

MIDIFunc.noteOn({
	| vel, note |
	var i = note - 60, node;
	node = ~keys.at(i);
	if( node.notNil, { ~keys.put(i, nil); });
	node = Synth.head(nil, \clinker_dust, [
		\out, 0,
		\dust, 2000,
		\freq, note.midicps,
		\amp, vel/127,
		\harmonic, ~kharmonic,
		\partials, ~kpartials,
		\rel, ~krelease,
		\cutoff, ~kcutoff,
		\atk, 0.01,
		\pan, (i - 13) / 30
	]);
},	(60..84));

MIDIFunc.noteOn({
	| vel, pad |
	var i = ~padmap.at(pad - 36), note = i + 36, node;
	node = ~pads.at(i);
	if( node.notNil, { ~pads.put(i, nil); });
	node = Synth.head(nil, \clinker_dust, [
		\out, 0,
		\dust, 2000,
		\freq, note.midicps,
		\amp, vel/127,

		\harmonic, ~pharmonic,
		\partials, ~ppartials,
		\rel, ~prelease,
		\cutoff, ~pcutoff,

		\atk, 0.01,
		\pan, (i - 8) / 16
	]);
},	(36..51));


)

[ ~kharmonic, ~kpartials, ~krelease, ~kcutoff ]



[ ~pharmonic, ~ppartials, ~prelease, ~pcutoff ]


127 / 4

(
Synth(\clinker_ii, [\out, ~keyboardbus, \pan, 0, \freq, 220, \amp, 0.2])
)

~keyboardbus.numChannels

~send

~padmap = [ 0, 1, 2, 3, 8, 9, 10, 11, 4, 5, 6, 7, 12, 13, 14, 15 ];
~padmap.at(8)