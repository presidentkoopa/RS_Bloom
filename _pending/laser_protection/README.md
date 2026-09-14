# RS_Bloom: laser protection rows (pending)

These rows wait for the engine's E6b, the pinned laser bloom in the main lane's `Engine docs\EMISSIVE_BLOOM_PLAN.md`. Wire them only when the main lane says E6b is done and sends the final names. Until then the rows would do nothing: E6a's `gl_bloom_pin_beams` only turns the light mask on.

The build script does not pack this folder.

## What it adds

- **"Keep legacy lasers"** (`gl_bloom_pin_beams`), a two-way switch the owner asked for:
  - On: every beam line (grab lasers, Lance, Unmaker, wheel lines, beam tracers, including their wall splash and lit fog) keeps the pinned look, while presets and SetBloomOverride change only the rest.
  - Off: the lasers bloom with everything else.
  - The engine captures the pinned look the first time the switch goes on. Flipping it after that never recaptures and never causes a hitch.
- **"Capture current bloom as the laser look"** (`gl_bloom_pin_capture`).
- **"Laser look back to the engine defaults"** (`gl_bloom_pin_reset`).
- **Warning texts:** the preset and reactive warnings become "unless Keep legacy lasers is on".

## Rules from the plan review

- The owner switches protection on by hand. RS_Bloom never turns it on.
- Presets never write `gl_bloom_pin_*`. `Base()` names every cvar it writes, so this already holds. Keep it that way.
- Capture happens only from a menu action. The engine side does it in the cvar callback, with NOINITCALL.

## To wire, once E6b is built

1. Check the final cvar and CCMD names against `menudef.add`.
2. Apply the four steps at the top of `menudef.add`.
3. Lint, pack to scratch, and announce the compile check to the main lane. Wait for its turn (after 63 and the weapons lane), then check with the glow suite and the owner's six mods.
4. Install, commit and push. Remove this folder in the same commit.
5. Owner A/B, with a grab laser and the Lance in view, in a dark room and a bright one:
   - Protection on, then pick Heavy. The lasers should look unchanged while the room changes.
   - Turn on bloom that reacts and fire a rocket. The lasers shouldn't flare.
   - Flip the switch off and on. There should be no stutter, and the captured look should be kept.
   - Use the capture row, then check the lasers take the current look.
