{RLPF.ar(Dust.ar([12, 13]), LFNoise1.ar([0.3,0.2]).range(400, 3000), 0.012)}.play;


LFNoise1.ar(0.3, 0.2).poll


(5 + 2 * 2).postln

100.do({"Print this line over and over...".scramble.postln});

a = "Hello world"

b = [ 0, 1, 2, 3, 4, 5]

c = Pbind(\note, Pwhite(0, 10), \dur, 0.1);

a.postln
b + 100

c.play

d = b * 5

d

Pbind(\degree, Pseries(0, 1, 30), \dur, 0.05).play;

Pbind(\degree, 0).play

(
p = Pbind(
	\degree, Pseq([0, -1, 2, -3, 4, -3, 7, 11, 4, 2, 0, -3], 5),
	\dur, Pseq([0.2, 0.1, 0.1], inf),
	\amp, Pseq([0.7, 0.5, 0.3, 0.2], inf),
	\legato, 1
);
)

~myPlayer = p.play;



~myPlayer.stop

~myPlayer.resume







a = [ 2, 2, 3, 5, 8, 13, 21, 34 ]
303
a.reverse

a.size

a.at(3)

a[5]

a.wrapAt(1000)

a.add(44)

a.insert(4, [\am, \foo])

a.put(2, "ho")
a

a.powerset


a + 10

30 ! 4


~myFreqs = Array.fill(10, {rrand(440, 6880)})

~myFreqs.do({arg item; { SinOsc.ar(item, 0, 0.1)}.play})