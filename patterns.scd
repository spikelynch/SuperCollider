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
