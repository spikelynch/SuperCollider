


(
{
loop({
    play({
        var nPartials = 12, nChans = 5, n = nPartials * nChans;
        Splay.ar(Klang.ar(`[ { { rrand(200.0, 2000.0) } ! nPartials } ! nChans, nil, nil ], 1, 0))
             * EnvGen.kr(Env.sine(4), 1, 0.02, doneAction: Done.freeSelf);
    });
    2.wait;
})
}.fork;
)

{ Klang.ar(`[ [440, 660, 550], [) }.play

	play({ Klang.ar(`[ [800, 1000, 1200], [0.3, 0.3, 0.3], [pi, pi, pi]], 1, 0) * 0.4});


(
{
loop({
    play({
        Pan2.ar(Klang.ar(`[ Array.rand(12, 200.0, 2000.0), nil, nil ], 1, 0), 1.0.rand)
             * EnvGen.kr(Env.sine(4), 1, 0.02, doneAction: Done.freeSelf);
    });
    2.wait;
})
}.fork;
)