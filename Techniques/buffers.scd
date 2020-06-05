Platform.resourceDir;


b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");

(
x = SynthDef("tutorial-PlayBuf", {
	arg out = 0, bufnum;
	Out.ar(out, PlayBuf.ar(1, bufnum))
}).play(s, [\bufnum, b])
)

x.free;

b.free;


p = Buffer.read(s, "/Users/mike/Music/Samples/Pelog.wav");


(
~ps = SynthDef("tutorial-Pelog", {
	arg out = 0, bufnum;
	Out.ar(out, PlayBuf.ar(2, bufnum))
}).play(s, [\bufnum, p])
)

~ps.free;



b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");
b.bufnum;
b.numFrames;
b.numChannels;
b.sampleRate;
b.free;

b.plot();

p.plot();

p.play


b = Buffer.alloc(s, 512, 1);
b.cheby([1,0,1,1,0,1]);
(
x = play({
    Shaper.ar(
        b,
        SinOsc.ar(300, 0, Line.kr(0,1,6)),
        0.5
    )
});
)
x.free; b.free;






b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");

~ok = Buffer.read(s, "/Users/mike/Music/Samples/Oklahoma.wav");

~ok.play;

(
{
    var trate, dur;
    trate = MouseY.kr(2,200,1);
    dur = 4 / trate;
    TGrains.ar(2, Impulse.ar(trate), ~sampleBuf, 1, MouseX.kr(0,BufDur.kr(~sampleBuf)), dur, 0, 0.1, 2);
}.scope(2, zoom: 4);
)

(
{
    var trate, dur, clk, pos, pan;
    trate = MouseY.kr(8,120,1);
    dur = 12 / trate;
    clk = Impulse.kr(trate);
    pos = MouseX.kr(0,BufDur.kr(~ok)) + TRand.kr(0, 0.01, clk);
    pan = WhiteNoise.kr(0.6);
    TGrains.ar(2, clk, ~ok, 1, pos, dur, pan, 0.1);
}.scope(2, zoom: 4);
)

