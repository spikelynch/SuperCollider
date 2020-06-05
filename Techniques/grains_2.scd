b = Buffer.readChannel(s, "/Users/mike/Music/SuperCollider/guitar.wav", channels: [0]);



b.play
b.free


(
{
    var trate, dur, blen, clk, pos, pan;
    trate = MouseY.kr(8,120,1);
    dur = 12 / trate;
    clk = Impulse.kr(trate);
	blen = BufDur.kr(b);
	pos = (SinOsc.kr(MouseX.kr(0, 3), 0, 0.5) + 0.5)  * blen;
    pan = WhiteNoise.kr(0.6);
    TGrains.ar(2, clk, b, 1, pos, dur, pan, 1.0);
}.play;
)

b.play

(
{
    var trate, dur, rate;
    trate = MouseY.kr(2,200,1);
    dur = 4 / trate;
    rate = Dseq([10, 1, 1, 0.5, 0.5, 0.2, 0.1], inf);
    TGrains.ar(2, Impulse.ar(trate), b, rate, MouseX.kr(0,BufDur.kr(b)), dur, Dseq([-1, 1], inf), 0.1, 2);
}.scope(zoom: 4);
)

(
{
    var trate, dur, clk, pos, pan, spread;
    trate = 120;
    dur = 2 / trate;
	spread = MouseY.kr(0, 1.0);
    clk = Impulse.kr(trate);
    pos = MouseX.kr(0,BufDur.kr(b));
    pan = WhiteNoise.kr(0.6);
	TGrains.ar(2, clk, b, WhiteNoise.kr(spread) + 1.0, pos, dur, pan, 0.5);
}.scope(zoom: 4);
)



(
{
	var 