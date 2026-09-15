# Glow lane agenda: RS_Bloom and the glow suite

Written 2026-09-15 at the owner's close of day. In order:

1. **Preset tuning, after the owner's headset checks.**
   - Retune Emissive, Neon, Fog glow, VR clean and the rest from what the owner reports.
   - The check: each preset with a grab laser and the Lance in view, in a dark room and a bright one.
   - The rules stay: presets only change values, never write `gl_bloom_pin_*`, and "None" stays the default.
2. **Reactive default flip, after the owner's headset laser A/B passes.**
   - The owner decided this on 2026-09-15.
   - Change: `rsb_reactive` and `rsb_rx_dark` default to true.
   - Changing a cvar default doesn't reach a saved ini, so add a one-press "Recommended: reacting bloom on" row on the Reactive page that sets both.
   - Update the gold warning texts to match "Keep legacy lasers".
   - Compile-check, install, commit and push.
3. **The suite hub.** The six glow mods (Fog, Darkness, GlowInTheDark, Sweeps, Flashlight, Bloom) get treated as one suite: a shared hub page, named looks and a test map.
   - Write the plan first and bring it to the owner.
   - Additive only: nothing the owner uses daily gets moved, hidden or renamed.
4. **E4b's Bloom rows, when the main lane builds emissive-only bloom** (EMISSIVE_BLOOM_PLAN.md).
   - An "Emissive-only bloom" row (`gl_bloom_emissive`), with an air sub-row (`gl_bloom_emissive_air`).
   - The Arcade preset, and `Base()` resets `gl_bloom_emissive` to false.
   - All rows LINT-LIVE-OK. Use the final names the main lane sends.
