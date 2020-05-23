// Working through the Pattern Guide

// https://doc.sccode.org/Tutorials/A-Practical-Guide/PG_01_Introduction.html

(
a = Routine {
	var i = 0;
	loop {
		i.yield;
		i = i + 1;
	};
};
)

a.nextN(10);


(
a = Routine {
	(0..).do { |i|
		i.yield;
	};
};
)

a.nextN(10);



a = Pseries().asStream;

a.nextN(10);

q = Pseries(120, 2).asStream;
q = q.asStream;
q.nextN(10);

l = Pseq([ 1, 2, 3, 5 ], 20).asStream;

w = Pwhite().asStream;
w.nextN(10);

b = Pbrown().asStream;

b.nextN(100);


r = Pwalk(Array.series(100)).asStream;
r.nextN(20);


(
p = Pbind(
    \degree, Pseq(#[0, 0, 4, 4, 5, 5, 4], 1),
    \dur, Pseq(#[0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 1], 1)
).play;
)

(
p = Pbind(
    \degree, Pslide((-6, -4 .. 12), 8, 3, 1, 0),
    \dur, Pseq(#[0.1, 0.1, 0.2], inf),
    \sustain, 0.15
).play;
)

(
p = Pbind(
    \degree, Pseries(-7, 1, 15),
    \dur, Pgeom(0.5, 0.89140193218427, 15)
).play;
)

(
p = Pbind(
	\degree, Pseq([Pshuf([1, 2, 3, 5]), [ Rest(1) ]], inf),
	\dur, Pseq([Pwhite(0.2, 0.3, 4), Rest(rrand(3, 7))], inf)
).play;
)

p.next(Event.new);