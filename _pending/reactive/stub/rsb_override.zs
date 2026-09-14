// COMPILE-CHECK STUB ONLY. Never installed, never run (the check is -norun).
//
// Same class and signatures as zscript/rsb_override.zs, for an exe that does not
// have SetBloomOverride yet. Each body calls an EXISTING clearscope LevelLocals
// native the same way the real file calls the new one, so the check still
// proves Level is reachable from these clearscope static functions.

class RSB_Override
{
	clearscope static void Set(double spread, double threshold, double knee,
		double tintR, double tintG, double tintB, double mixAmount,
		double intensity, double fade, double pulse, double pulseRate)
	{
		Level.ClearFogGradientOverride();
	}

	clearscope static void Clear()
	{
		Level.ClearFogGradientOverride();
	}
}
