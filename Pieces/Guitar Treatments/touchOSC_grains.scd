

// Do this and reboot the server to make sure input just comes from the Scarlett

Server.default.options.inDevice_("Scarlett 2i2 USB");






(

~buflength = 4.0;


~frippbuffer = Buffer.alloc(s, s.sampleRate * ~buflength, 1);


// todo: feedback (play some of the granulator back into the buffer)


~bufrecorder = SynthDef(
	\fripp_record,
	{
		arg in = 2, out = 0, buffer = 0, mix = 0.25, record = 0.0;
		RecordBuf.ar(record * In.ar(in, 1), buffer, 0, mix, 1 - mix, loop: 1)
    }
).play(s, [\out, 0, \buffer, ~frippbuffer]);





// modular granulator

// more ideas for modules: scramble - do a permutation of ABCDEFGH slots


~grainsinb = Bus.control(s, 1);

~grainsin = SynthDef(
	\grainsin,
	{
		arg out=5, speed=1;
		Out.kr(out, 0.5 + SinOsc.kr(speed, 0, 0.5));
	}
).play(s, [\out, ~grainsinb, \speed, 1]);



~grainsawb = Bus.control(s, 1);

~grainsaw = SynthDef(
	\grainsaw,
	{
		arg out=5, speed=1;
		Out.kr(out, 0.5 + LFSaw.kr(speed, 0, 0.5));
	}
).play(s, [\out, ~grainsawb, \speed, 1]);

~grainreverseb = Bus.control(s, 1);

~grainreverse = SynthDef(
	\grainreverse,
	{
		arg out=5, speed=1;
		Out.kr(out, 0.5 - LFSaw.kr(speed, 0, 0.5));
	}
).play(s, [\out, ~grainreverseb, \speed, 1]);


~graintrib = Bus.control(s, 1);

~graintri = SynthDef(
	\graintri,
	{
		arg out=5, speed=1;
		Out.kr(out, 0.5 + LFTri.kr(speed, 0, 0.5));
	}
).play(s, [\out, ~graintrib, \speed, 1]);


~grainrandb = Bus.control(s, 1);

~grainrand = SynthDef(
	\grainsin,
	{
		arg out=5, speed=1;
		Out.kr(out, 0.5 + WhiteNoise.kr(0.5));
	}
).play(s, [\out, ~grainrandb, \speed, 1]);




// todo - different styles of trigger

~grainout = Bus.audio(s, 2);


~granulator = SynthDef(
	\grainsynth,
	{
		arg out=0, trate=120, rate=1, posb=5, amp=1.0, freq=10000, rq=0.3, buffer;
		var dur, blen, clk, pos, pan;
		dur = 12 / trate;
		clk = Impulse.kr(trate);
		blen = BufDur.kr(buffer);
		pos = In.kr(posb, 1) * blen;
		pan = WhiteNoise.kr(0.6);
		Out.ar(out, RLPF.ar(TGrains.ar(2, clk, buffer, rate, pos, dur, pan, amp), freq,rq));
	}
).play(s, [\out, 0, \buffer, ~frippbuffer, \posb, ~grainsawb]);

~filter = SynthDef(
	\outputfilt,
	{
		arg in=2, out=0, mix=0.0, freq=400, rq=0.5, amp=0.5;
		//Out.ar(out, RLPF.ar(In.ar(in, 2), freq, rq, amp));
		Out.ar(out, In.ar(in, 2));
}).play(s, [\in, ~grainout, \out, 0]);

~passthrough = SynthDef(
	\passthrough_synth,
	{
		arg in = 2, out = 0, amp = 0.0;
		Out.ar(out, amp * In.ar(2, 1) ! 2);
	}
).play;


)

~frippbuffer.plot;
~grainout.plot;


~granulator.set("rate",0.4)

~filter.set("freq", 10000)
~filter.set("amp", 1)


~fripbuffer.free;






OSCdef.freeAll;


// set up TouchOSC controls


// things to do later on -
// figure out how to send values from SuperCollider to the TouchOSC interface
// so that this code can set default values on the controls
// - see the touchOSC SC example at https://hexler.net/pub/touchosc/touchosc-simple.scd for how to do this

//

// touchosc controls

// grains/grainxy -> grain speed, grain size
// grains/mode -> grainulator curve
// grains/rate -> [TODO] gra

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
		~currentspeed = msg[2].linlin(0, 1, 0, 1);
		~currentpos.set("speed", ~currentspeed);
		~granulator.set("trate", msg[1].linlin(0, 1, 1, 200));
	},
	'/grains/grainxy'
);

// granulator mode radio-buttons





~setmode = {
	| msg, ctrlsynth, ctrlbus |
	if(msg[1] > 0.0, {
		~granulator.set("posb", ctrlbus);
		~currentpos = ctrlsynth;
		~currentpos.set("speed", ~currentspeed);
		[ "grain mode set to", ctrlbus ].postln;
	}, {});
};



OSCdef.new(\grainmodesaw,      { |msg| ~setmode.value(msg, ~grainsaw, ~grainsawb) }, '/grains/mode/5/1');
OSCdef.new(\grainmodereverse,  { |msg| ~setmode.value(msg, ~grainreverse, ~grainreverseb) }, '/grains/mode/4/1');
OSCdef.new(\grainmodesine,     { |msg| ~setmode.value(msg, ~grainsin, ~grainsinb) }, '/grains/mode/3/1');
OSCdef.new(\grainmodetri,      { |msg| ~setmode.value(msg, ~graintri, ~graintrib) }, '/grains/mode/2/1');
OSCdef.new(\grainmoderand,     { |msg| ~setmode.value(msg, ~grainrand, ~grainrandb) }, '/grains/mode/1/1');


// set buffer length - you need to clear the buffer to apply

OSCdef.new(
	\bufferlen,
	{
		| msg |
		~buflength = msg[1];
		~buflength.postln;
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
		[ "clearing buffer", ~bufclear ].postln;
		[ "old buffer = ", ~frippbuffer ].postln;
		~newbuffer = Buffer.alloc(s, s.sampleRate * ~buflength, 1);
		[ "new buffer = ", ~newbuffer ].postln;
		~granulator.set("buffer", ~newbuffer);
		~bufrecorder.set("buffer", ~newbuffer);
		~frippbuffer.free;
		~frippbuffer = ~newbuffer;
		[ "~frippbuffer = ", ~frippbuffer ].postln;

	},
	'/buffer/clear'
);

// filter

OSCdef.new(
	\fxfreq,
	{
		| msg |
		~granulator.set("freq", msg[1]);
	},
	'/fx/freq'
);

OSCdef.new(
	\fxrq,
	{
		| msg |
		~granulator.set("rq", msg[1]);
	},
	'/fx/rq'
);


)


~adrs = NetAddr("192.168.0.85", 9000)

~adrs.sendMsg("/grains/mode/1/1", 1.0)

