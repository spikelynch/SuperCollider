

// Do this and reboot the server to make sure input just comes from the Scarlett

Server.default.options.inDevice_("Scarlett 2i2 USB");


{ var freq = 1000; [LFNoise0.ar(freq), Impulse.ar(freq)] }.plot





(

// audio buses

// recordb = input to bufrecorder
// granulatorb = output from granulator

~recordb = Bus.audio(s, 1);

~granulatorb = Bus.audio(s, 2);

// default control values

~buflength = 4.0;

~mintrig = 1.0;
~maxtrig = 200;

~defaulttrig = 100;
~defaultspeed = 1;
~defaultpitch = 0; // this is the control value, not synth value

~pitchrange = 3;  // this is octaves + or -


~defaultmix = 0.25;
~defaultfeedback = 0.0;
~defaultgrainamp = 0.5;
~defaultpassthrough = 0.5;
~defaultfreq = 10000;
~defaultres = 0.3;

~minlfofreq = 0.01;
~maxlfofreq = 10;

~defaultlfofreq = 0.5;
~defaultlfoamp = 0;


~frippbuffer = Buffer.alloc(s, s.sampleRate * ~buflength, 1);


// done: feedback (play some of the granulator back into the buffer) (no good)

// out isn't used for anything her

~bufrecorder = SynthDef(
	\fripp_record,
	{
		arg in = 2, fb = 4, out = 0, buffer = 0, mix = 0.25, record = 0.0, feedback = 0.0;
		var insig, fbsig;
		insig = record * In.ar(in, 1);
		fbsig = feedback * Mix.ar(In.ar(fb, 2));
		RecordBuf.ar(insig + fbsig, buffer, 0, mix, 1 - mix, loop: 1)
    }
).play(s, [\in, 2, \record, 1.0, \fb, ~granulatorb, \out, 0, \buffer, ~frippbuffer]);





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



~lfob = Bus.control(s, 1);

~lfo = SynthDef(
	\lfo,
	{
		arg out=5, freq=1, amp=0;
		Out.kr(out, SinOsc.kr(freq, 0, amp));
	}
).play(s, [\out, ~lfob, \freq, 1, \amp, 0]);



// todo - different styles of trigger

// todo - make rate hop around different powers of two

~granulator = SynthDef(
	\grainsynth,
	{
		arg out=0, modb, trate=120, rate=1, posb=5, amp=1.0, freq=10000, rq=0.3, sweep=0.25, chorus=0.0, buffer;
		var dur, blen, clk, chor, pos, pan, grains, filtfreq;
		dur = 12 / trate;
		clk = Impulse.kr(trate);
		chor = chorus * 2.pow((LFNoise0.kr(trate) + 0.5).floor) + (1 - chorus);
		blen = BufDur.kr(buffer);
		pos = In.kr(posb, 1);
		pan = WhiteNoise.kr(1 - sweep) + (2 * sweep * (pos - 1));
		filtfreq = (In.kr(modb, 1) * freq * 0.5) + freq;
		grains = TGrains.ar(2, clk, buffer, chor * rate, pos * blen, dur, pan, amp);
		Out.ar(out, RLPF.ar(grains, filtfreq, rq));
	}
).play(s, [\out, ~granulatorb, \buffer, ~frippbuffer, \posb, ~grainsawb, \modb, ~lfob]);


~mixer = SynthDef(
	\mixer_synth,
	{
		arg in = 2, gbus = 4, out = 0, amp = 1.0, passthrough = 0.0;
		//Out.ar(out, In.ar(gbus, 2));
		Out.ar(out, (amp * In.ar(gbus, 2)) + (passthrough * In.ar(2, 1) ! 2));
	}
).play(s, [\in, 2, \out, 0, \gbus, ~granulatorb, \amp, 1.0, \passthrough, 0.0], \addToTail);


)












// set up TouchOSC controls

// touchosc controls

// grains/grainxy -> grain speed, grain size
// grains/mode -> grainulator curve
// grains/pitch -> pitch bender

// buffer/length -> length of buffer
// buffer/mix -> strength of buffer feedback
// buffer/record -> toggle whether buffer is recording
// buffer/clear -> clear buffer

// fx/freq -> filter cutoff
// fx/rq -> filter resonance




(

~controller = NetAddr("192.168.0.66", 9000);


// set callbacks on the controls

// grain XY control




~controller.sendMsg('/grains/grainxy', [ ~defaulttrig.linlin(~mintrig, ~maxtrig, 0, 1), ~defaultspeed ]);
~currentpos.set("speed", ~defaultspeed / ~buflength);
~granulator.set("trate", ~defaulttrig);

OSCdef.new(
	\grainxy,
	{
		| msg |
		~currentspeed = msg[2].linlin(0, 1, 0, 2);
		~currentpos.set("speed", ~currentspeed / ~buflength);
		~granulator.set("trate", msg[1].linlin(0, 1, ~mintrig, ~maxtrig));
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

// set default and send to controls

~setmode.value([ '', 1.0 ], ~grainsaw, ~grainsawb);
~controller.sendMsg('/grains/mode/5/1', 1.0);



// granulator pitch control
// at the moment normalises to octaves

~controller.sendMsg('/grains/pitch', ~defaultpitch);
// default granulator rate (pitch) is already 1

OSCdef.new(
	\grainspitch,
	{
		| msg |
		var qrate = 2.pow((~pitchrange * msg[1] + 0.5).floor);
		~granulator.set("rate", qrate);
	},
	'/grains/pitch'
);


// chorus on/off

~controller.sendMsg('/grains/chorus', 0.0);

OSCdef.new(
	\grainschorus,
	{
		| msg |
		~granulator.set("chorus", msg[1]);
	},
	'/grains/chorus'
);



// set buffer length - you need to clear the buffer to apply

~controller.sendMsg('/buffer/length', ~buflength);

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

~controller.sendMsg('/buffer/mix', ~defaultmix);
~bufrecorder.set("mix", ~defaultmix);

OSCdef.new(
	\buffermix,
	{
		| msg |
		~bufrecorder.set("mix", msg[1]);
	},
	'/buffer/mix'
);

~controller.sendMsg('/buffer/feedback', ~defaultfeedback);
~bufrecorder.set("feedback", ~defaultfeedback);

OSCdef.new(
	\bufferfeedback,
	{
		| msg |
		~bufrecorder.set("feedback", msg[1]);
	},
	'/buffer/feedback'
);

~controller.sendMsg('/buffer/grains', ~defaultgrainamp);
~granulator.set("amp", ~defaultgrainamp);

OSCdef.new(
	\buffergrains,
	{
		| msg |
		~granulator.set("amp", msg[1]);
	},
	'/buffer/grains'
);


~controller.sendMsg('/buffer/passthrough', ~defaultpassthrough);
~mixer.set("passthrough", ~defaultpassthrough);

OSCdef.new(
	\bufferpassthrough,
	{
		| msg |
		~mixer.set("passthrough", msg[1]);
	},
	'/buffer/passthrough'
);


// buffer record on/off

~controller.sendMsg('/buffer/record', 1.0);
~bufrecords.set("record", 1.0);

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
		~newbuffer = Buffer.alloc(s, s.sampleRate * ~buflength, 1);
		~granulator.set("buffer", ~newbuffer);
		~bufrecorder.set("buffer", ~newbuffer);
		~frippbuffer.free;
		~frippbuffer = ~newbuffer;
		~currentpos.set("speed", ~currentspeed / ~buflength);
	},
	'/buffer/clear'
);

// filter

~controller.sendMsg('/fx/freq', ~defaultfreq);
~granulator.set("freq", ~defaultfreq);

OSCdef.new(
	\fxfreq,
	{
		| msg |
		~granulator.set("freq", msg[1]);
	},
	'/fx/freq'
);

~controller.sendMsg('/fx/rq', ~defaultres);
~granulator.set("rq", ~defaultres);

OSCdef.new(
	\fxrq,
	{
		| msg |
		~granulator.set("rq", msg[1]);
	},
	'/fx/rq'
);

~controller.sendMsg('/fx/lfofreq', ~defaultlfofreq.explin(~minlfofreq, ~maxlfofreq, 0, 1));
~lfo.set("freq", ~defaultlfofreq);

OSCdef.new(
	\fxlfofreq,
	{
		| msg |
		var freq = msg[1].linexp(0, 1, ~minlfofreq, ~maxlfofreq);
		freq.postln;
		~lfo.set("freq", freq);
	},
	'/fx/lfofreq'
);

~controller.sendMsg('/fx/lfoamp', ~defaultlfoamp);
~lfo.set("amp", ~defaultlfoamp);

OSCdef.new(
	\fxlfoamp,
	{
		| msg |
		~lfo.set("amp", msg[1]);
	},
	'/fx/lfoamp'
);




)



x = 0.2;
(x + 0.5).floor;

	x = -1;