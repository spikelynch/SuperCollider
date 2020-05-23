

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


// granular synth
(
{
    var trate, dur, blen, clk, pos, pan;
    trate = MouseY.kr(8,120,1);
    dur = 12 / trate;
    clk = Impulse.kr(trate);
	blen = BufDur.kr(b);
	pos = (SinOsc.kr(MouseX.kr(0, .3), 0, 0.5) + 0.5)  * blen;
    pan = WhiteNoise.kr(0.6);
    TGrains.ar(2, clk, b, 1, pos, dur, pan, 1.0);
}.play;
)

// passthrough

(
{ 0.4 * In.ar(2, 1) ! 2 }.play
)


b.free


