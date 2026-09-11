// RS_Bloom -- presets.
//
// These write the engine's own gl_bloom_* cvars. There is no mod-side state and
// no second copy of anything: bloom is one global pass shared by every mod, and
// a private duplicate would only be a second thing to keep in step.
//
// WHAT THE CONTROLS ACTUALLY DO, since the names are not obvious:
//
//   threshold  how bright a pixel must be before it blooms at all. The engine
//              default is 1.0, meaning ONLY pixels that already blew past full
//              white. That is right for a muzzle flash and wrong for anything
//              trying to read as emissive at a sane brightness -- which is most
//              of what this family draws.
//
//   knee       how sharply it crosses that line. 0 is a hard cutoff, and a hard
//              cutoff makes things POP in and out of blooming as they cross it,
//              which is constant and obvious when a glow is pulsing or a band is
//              sweeping. Higher rolls the transition over a range.
//
//   amount     blur radius. How far the glow spreads from what made it.
//
//   anamorphic blur wider horizontally than vertically, so bright things streak
//              sideways the way they do through an anamorphic lens. Free -- the
//              blur is already two passes and this only gives them different
//              amounts.
//
//   tint       colours the bloom independently of what produced it. A cold tint
//              over warm lights is most of what makes a scene look graded.
//
//   chromatic  offsets the colour channels radially, so bright edges break up
//              toward the screen edges the way light through glass does.

class RSB_Presets
{
	const COUNT = 9;

	static void F(String n, double v) { let c = CVar.FindCVar(n); if (c) c.SetFloat(v); }
	static void B(String n, bool v)   { let c = CVar.FindCVar(n); if (c) c.SetBool(v); }

	// on, amount, threshold, knee
	static void Core(bool on, double amount, double threshold, double knee)
	{
		B("gl_bloom", on);
		F("gl_bloom_amount", amount);
		F("gl_bloom_threshold", threshold);
		F("gl_bloom_knee", knee);
	}

	static void Lens(bool anamorphic, double ratio, double chromatic)
	{
		B("gl_bloom_anamorphic", anamorphic);
		F("gl_bloom_anamorphic_ratio", ratio);
		F("gl_bloom_chromatic", chromatic);
	}

	static void Tint(double r, double g, double b)
	{
		F("gl_bloom_tint_r", r);
		F("gl_bloom_tint_g", g);
		F("gl_bloom_tint_b", b);
	}

	// Every term, neutral, before a preset runs -- so a preset states only what
	// it cares about and can never wear the leftovers of the one before it.
	static void Base()
	{
		Core(true, 1.4, 1.0, 0.5);
		Lens(false, 3.0, 0.0);
		Tint(1.0, 1.0, 1.0);
	}

	static void Apply(int idx)
	{
		Base();
		switch (idx)
		{
		default:
		case 0: Off();        break;
		case 1: Vanilla();    break;
		case 2: Emissive();   break;
		case 3: Subtle();     break;
		case 4: Heavy();      break;
		case 5: Anamorphic(); break;
		case 6: Cold();       break;
		case 7: Furnace();    break;
		case 8: Lens70();     break;
		}
	}

	// No bloom at all. Worth having as a preset rather than only a switch,
	// because it is the honest comparison for everything below.
	static void Off()
	{
		Core(false, 1.4, 1.0, 0.5);
	}

	// The engine's own defaults, untouched. Only pixels past full white bloom,
	// with a mild knee.
	static void Vanilla()
	{
		Core(true, 1.4, 1.0, 0.5);
	}

	// THE ONE THIS FAMILY WANTS, and the default.
	//
	// Threshold down to 0.62 so a glow lane, a surface stamp or a neon core
	// blooms at the brightness it is actually drawn at rather than needing to be
	// driven absurdly high first. A generous knee, because everything here
	// pulses -- a hard cutoff on a breathing glow flickers as it crosses.
	static void Emissive()
	{
		Core(true, 1.6, 0.62, 1.6);
	}

	// Present but restrained. For playing rather than for looking at.
	static void Subtle()
	{
		Core(true, 1.0, 0.85, 0.9);
	}

	// Everything blooms and it spreads a long way. Hazy and soft.
	static void Heavy()
	{
		Core(true, 3.2, 0.45, 2.4);
	}

	// Sideways streaks off every bright thing. The most obviously cinematic of
	// the set and the one that most changes how a corridor of lights reads.
	static void Anamorphic()
	{
		Core(true, 2.0, 0.6, 1.4);
		Lens(true, 5.0, 0.015);
	}

	// A cold blue cast on the bloom over whatever colour made it, which is most
	// of what makes a scene look graded rather than lit.
	static void Cold()
	{
		Core(true, 1.8, 0.6, 1.4);
		Tint(0.72, 0.86, 1.25);
	}

	// The opposite: everything blooms warm, so fires and lava dominate and cold
	// lights are pulled toward them.
	static void Furnace()
	{
		Core(true, 2.0, 0.55, 1.5);
		Tint(1.30, 0.88, 0.66);
	}

	// Dirty optics. Wide anamorphic streaks plus heavy chromatic fringing, so
	// bright edges break up toward the corners of the screen.
	static void Lens70()
	{
		Core(true, 2.6, 0.5, 1.8);
		Lens(true, 6.5, 0.06);
		Tint(1.06, 0.98, 1.10);
	}
}
