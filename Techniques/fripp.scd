

// Do this and reboot the server to make sure input just comes from the Scarlett

Server.default.options.inDevice_("Scarlett 2i2 USB")


// Frippertronics

(
b = Buffer.alloc(s, s.sampleRate * 4.0, 1);
)

// record on a loop
(
SynthDef(\fripp_record, { arg in = 2, out = 0, bufnum = 0;
	RecordBuf.ar(In.ar(in, 1), bufnum, 0, 0.25, 0.75, loop: 1)
}).play(s,[\out, 0, \bufnum, b]);
)

// play it back
(
SynthDef(\fripp_playback, { arg out = 0, bufnum = 0;
    var playbuf;
	playbuf = PlayBuf.ar(1, bufnum, loop: 1);
    Out.ar(out, playbuf ! 2);
}).play(s, [\out, 0, \bufnum, b]);
)




b.free


