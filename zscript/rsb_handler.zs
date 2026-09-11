// RS_Bloom -- the handler.
//
// Almost nothing to do. The menu binds straight to the engine's gl_bloom_*
// cvars, so dragging a slider already changes bloom on the next frame without
// anything here running at all -- there is no per-tic push and no render state
// to keep in step.
//
// All this does is notice the preset changed and stamp the cvars once.

class RSB_Handler : EventHandler
{
	override void WorldLoaded(WorldEvent e)
	{
		SyncPreset();
	}

	override void WorldTick()
	{
		SyncPreset();
	}

	// Also from the menu tick, so picking a preset changes the picture while
	// you are still looking at the list rather than after you back out.
	override void UiTick()
	{
		SyncPreset();
	}

	clearscope void SyncPreset()
	{
		if (!Get("rsb_enabled", true))
		{
			// Switched off means the engine's own bloom setting is left exactly
			// as the player had it -- this mod does not own gl_bloom, it only
			// offers to set it. Turning the mod off should hand it back rather
			// than force it dark.
			return;
		}

		int want = GetI("rsb_preset", 2);
		if (want < 0 || want >= RSB_Presets.COUNT) want = 2;
		if (want == GetI("rsb_preset_applied", -1)) return;
		RSB_Presets.Apply(want);
		SetI("rsb_preset_applied", want);
	}

	clearscope static bool Get(String n, bool def)
	{
		let c = CVar.FindCVar(n); return c ? c.GetBool() : def;
	}
	clearscope static int GetI(String n, int def)
	{
		let c = CVar.FindCVar(n); return c ? c.GetInt() : def;
	}
	clearscope static void SetI(String n, int v)
	{
		let c = CVar.FindCVar(n); if (c) c.SetInt(v);
	}
}
