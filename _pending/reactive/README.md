# RS_Bloom: bloom that reacts (pending)

This waits on the engine's `SetBloomOverride(spread, threshold, knee, tintR, tintG, tintB, mix, intensity = 1, fade = 0, pulse = 0, pulseRate = 0)`, `ClearBloomOverride()` and `gl_bloom_override_strength`, which are the main lane's "bloom step 1". The build script does not pack this folder.

## Files

- `zscript/rsb_reactive.zs`: the handler. It folds five signals (Flash, Breathe, Sweep, Hurt, Dark) into one override per tic.
- `zscript/rsb_override.zs`: the only file that names the engine natives. Fix it here if the final names differ.
- `stub/rsb_override.zs`: the same class with the engine calls removed. Use it only to compile-check against an older exe, and never install it.
- `cvarinfo.add`, `menudef.add`, `zscript.txt.add`, `mapinfo`: the lump changes.

## To install, once bloom step 1 is built

1. Check the main lane's final native names and argument order against `rsb_override.zs`.
2. Copy both files from `zscript/` into `RS_Bloom/zscript/`.
3. Add the lump changes:
   - Append `cvarinfo.add` to `RS_Bloom/cvarinfo`.
   - Append `zscript.txt.add` to `RS_Bloom/zscript.txt`.
   - Replace `RS_Bloom/mapinfo` with `mapinfo`.
4. Update `menudef`, following the steps in `menudef.add`:
   - Add the lint names to the two existing lint lines at the top.
   - Add the Submenu row at the end of RSBMain.
   - Add the RSBReactive menu after RSBManual.
5. Pack to scratch, compile-check with the five glow pk3s, install, commit and push.
6. Owner A/B with a grab laser and the Lance in view, in a dark room and a bright one:
   - Flash: rocket, barrel and shotgun.
   - Hurt.
   - Breathe: a GitD alarm preset.
   - Sweep: fog tint on.
   - Dark.

## Defaults

- **The master switch starts OFF.** Every reaction changes the laser and Lance glow for as long as it lasts. The owner turns it on after the A/B.
- **Flash, Breathe, Sweep and Hurt start ON** under the master, so one switch brings them in.
- **Dark starts OFF.** It moves the threshold all the time, not for a moment, so it changes the laser glow continuously until the laser exclusion exists.

## Known limits

- **Breathe sends only a depth.** The engine beats it on the glow shader's timer (`pulse`, and `pulseRate` 0 = the alarm's own rate). It stays in phase with GitD and keeps beating under a menu.
- **Until laser exclusion lands (E6, in the main lane's EMISSIVE_BLOOM_PLAN.md), anything that changes the laser bloom stays opt-in.** The page says so. When E6 lands:
  - Consider turning the master and Follow the dark on by default.
  - Update the Phase 1 preset warning in `menudef`, which currently says "Every preset changes how the grab lasers and the Lance glow".
- **Sweep reads the `rsf_tint_*` cvars.** RS_Sweeps publishes them only when RS_Fog is loaded and Sweeps' fog-tint effect is on. Otherwise Sweep does nothing.
- **Flash sees projectiles by their MISSILE flag clearing, and explosions by radius damage.** An explosion that hits nothing still flashes as an impact, at a lower weight.
