



ServerOptions.inDevices;


{ In.ar(0, 2) }.scope

{ In.ar(2, 1) }.scope

(
SynthDef(\reverb,
	{
		arg in=2, out=0, mix=1.0, room=0.7, damp=0.2;
		var sig;
		sig = In.ar(in, 2);
		Out.ar(out, FreeVerb2.ar(sig[0], sig[1], mix, room, damp));
	}
).add;

)

(
SynthDef(\delay,
	{
		arg in=2, out=0, maxdel=0.2, curdel=0.2, decay=3, left, right;
		left = CombC.ar(In.ar(in, 1), maxdel, curdel, decay);
		right = CombC.ar(In.ar(in, 1), maxdel + 0.01, curdel + 0.01, decay);
		Out.ar(out, [ left, right])
	}
).add;
)

{ In.ar(2).distort }.play

{ CombN.ar(In.ar(2), 0.2, 0.2, 3) }.scope(1, zoom:4);

d = Synth(\delay, [\decay, 4, \out, 4])

r = Synth(\reverb, [\in, 4, \mix: 0.5, \room: 0.3], addAction:\addToTail)

r.free

Server.default.options.inDevice_("Scarlett 2i2 USB")
