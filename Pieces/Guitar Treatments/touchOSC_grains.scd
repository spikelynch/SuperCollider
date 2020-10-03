

// Do this and reboot the server to make sure input just comes from the Scarlett

Server.default.options.inDevice_("Scarlett 2i2 USB")




(
b = Buffer.alloc(s, s.sampleRate * 3.0, 1);

~bufrecorder = SynthDef(
	\fripp_record,
	{
		arg in = 2, out = 0, bufnum = 0, mix = 0.25, record = 0.0;
		RecordBuf.ar(record * In.ar(in, 1), bufnum, 0, mix, 1 - mix, loop: 1)
    }
).play(s, [\out, 0, \bufnum, b]);

// original synth

// ~granulator = {
// 	arg trate=120, speed = 1;
// 	var dur, blen, clk, pos, pan;
// 	dur = 12 / trate;
// 	clk = Impulse.kr(trate);
// 	blen = BufDur.kr(b);
// 	pos = (0.5 + SinOsc.kr(speed, 0, 0.5))  * blen;
// 	pan = WhiteNoise.kr(0.6);
// 	TGrains.ar(2, clk, b, 0.5, pos, dur, pan, 1.0);
// }.play;

// modular granulator

~grainsinb = Bus.control(s, 1);

~grainsin = SynthDef(
	\grainsin,
	{
		arg out=5, speed=1;
		Out.kr(out, 0.5 + SinOsc.kr(speed, 0, 0.5));
	}
).play(s, [\out, ~grainsinb, \speed, 1]);



~granulator = SynthDef(
	\grainsynth,
	{
		arg out=0, trate=120, posb=5, amp=1.0;
		var dur, blen, clk, pos, pan;
		dur = 12 / trate;
		clk = Impulse.kr(trate);
		blen = BufDur.kr(b);
		pos = In.kr(posb, 1) * blen;
		pan = WhiteNoise.kr(0.6);
		Out.ar(out, TGrains.ar(2, clk, b, 0.5, pos, dur, pan, amp));
	}
).play(s, [\posb, ~grainsinb]);


~passthrough = SynthDef(
	\passthrough_synth,
	{
		arg in = 2, out = 0, amp = 0.0;
		Out.ar(out, amp * In.ar(2, 1) ! 2);
	}
).play;


)


b.free;


// old passthrough		{0.4 * In.ar(2, 1) ! 2 }.play;




OSCdef.freeAll


// set up TouchOSC controls


// things to do later on -
// figure out how to send values from SuperCollider to the TouchOSC interface
// so that this code can set default values on the controls
// - see the touchOSC SC example at https://hexler.net/pub/touchosc/touchosc-simple.scd for how to do this

//

// touchosc controls

// grains/grainxy -> grain speed, grain size
// grains/mode -> grainulator curve

// buffer/length -> length of buffer
// buffer/mix -> strength of buffer feedback
// buffer/record -> toggle whether buffer is recording
// buffer/clear -> clear buffer


(

// grain XY control

OSCdef.new(
	\grainxy,
	{
		| msg |
		~grainsin.set("speed", msg[2].linlin(0, 1, 0, 2));
		~granulator.set("trate", msg[1].linlin(0, 1, 8, 120));
	},
	'/grains/grainxy'
);

// granulator mode radio-buttons

// FIXME implement me!

~setgrainmode = {
	| msg |
	msg.postln;
};

OSCdef.new( \grainmoderandom, ~setgrainmode, '/grains/mode/1/1');
OSCdef.new( \grainmodesaw,    ~setgrainmode, '/grains/mode/2/1');
OSCdef.new( \grainmodesine,   ~setgrainmode, '/grains/mode/3/1');
OSCdef.new( \grainmodeback,   ~setgrainmode, '/grains/mode/4/1');
OSCdef.new( \grainmoderamp,   ~setgrainmode, '/grains/mode/5/1');

// buffer length

OSCdef.new(
	\bufferlen,
	{
		| msg |
		~buflen = msg[1];
		~buflen.postln;
	},
	'/buffer/length'
);


// buffer recording mix

OSCdef.new(
	\buffermix,
	{
		| msg |
		~bufrecorder.set("mix", msg[1]);
	},
	'/buffer/mix'
);

OSCdef.new(
	\bufferpassthrough,
	{
		| msg |
		~passthrough.set("amp", msg[1]);
	},
	'/buffer/passthrough'
);


// buffer record on/off

OSCdef.new(
	\bufferrecord,
	{
		| msg |
		~bufrecorder.set("record", msg[1]);
	},
	'/buffer/record'
);

// clear buffer

OSCdef.new(
	\bufferclear,
	{
		| msg |
		~bufclear = msg[1];
		[ "clear", ~bufclear ].postln;
	},
	'/buffer/clear'
);
)




