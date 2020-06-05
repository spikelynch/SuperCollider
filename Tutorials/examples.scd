

// from https://doc.sccode.org/Guides/Tour_of_UGens.html

{ FSinOsc.ar(800, 0.0, 1) * PinkNoise.ar(1) }.play


{ Crackle.ar(MouseX.kr(1,2), 0.5) }.scope(1);


{ Klank.ar(`[[200, 671, 1153, 1723], nil, [1, 1, 1, 1]], Impulse.ar(2, 0, 0.1)) }.play;


{ Klank.ar(`[[200, 671, 1153, 1723], nil, [1, 1, 1, 1]], Impulse.ar(2, 0, 0.1)) }.play;

{ Klank.ar(`[[200, 671, 1153, 1723], nil, [1, 1, 1, 1]], Dust.ar(8, 0.1)) }.play;


{ DynKlank.ar(`[[SinOsc.kr(100) * 20 + 440], nil, [1, 1, 1, 1]], PinkNoise.ar(0.007)) }.play;

Dyn

{ Klank.ar(`[ {exprand(400, 7000)}.dup(12), nil, nil ], PinkNoise.ar(0.007)) }.scope(1);

{ Klank.ar(`[ (1..13)*200, 1/(1..13), nil ], PinkNoise.ar(0.01)) }.scope(1);

{ Klank.ar(`[ (1,3..13)*200, 1/(1,3..13), nil ], PinkNoise.ar(0.01)) }.scope(1);


{ SinOsc.ar(300, 0, MouseX.kr(0.1,80,1)).distort * 0.2 }.scope(1);

{exprand(400, 7000)}.dup(12)

(
{
    var x;
    x = Klank.ar(`[[200, 671, 1153, 1723], nil, [1, 1, 1, 1]], Dust.ar(2, 0.1));
    x = Pan2.ar(x, -0.2);
    x = [x[0], DelayC.ar(x[1], 0.01, 0.01)];
    FreeVerb.ar(x, 0.75, 0.9, 0.4);
}.play;
)

(
play {
    var sig, chain;

    // The original sound source
    sig = sum({ SinOsc.ar(rrand(50,6000),0,2*Decay.ar(Dust2.ar(1),0.1)).tanh } ! 7);

    chain = sig;    // Start with the original signal
    8.do {|i|       // Loop 8 times. For each loop, connect the signal through something.

        // A simple reverb
        chain = LeakDC.ar(AllpassL.ar(LPF.ar(chain*0.9,3000), 0.2, {0.19.rand+0.01}!2, 3));
    };

    Limiter.ar(sig+chain);    // dry + wet
}
)


(
// rectangular comb filter
{
    var in, chain;
    in = PlayBuf.ar(1,c, BufRateScale.kr(c), loop:1);
    chain = FFT(b, in);
    chain = PV_RectComb(chain, 8, MouseY.kr(0,1), MouseX.kr(0,1));
    0.5 * IFFT(chain);
}.scope(1);
)
