# Power Cards — implementation (EDOPro fork)

A Yu‑Gi‑Oh!‑style add‑on: a fourth, extra‑deck‑only card pool called **Power
Cards** with its own chain rules.

## Functional overview

* **`TYPE_POWER` (0x8000000)** marks a card as a Power Card.
* **`LOCATION_POWERS (0x2000)`** is the client-side virtual zone used to
  communicate power-deck content.
* Power Cards are **extra‑deck‑only** — the ocgcore forces them into the Extra
  Deck pile; the deck builder only allows them in the new `powers` deck zone;
  the network protocol carries the power‑deck block; and on the battlefield
  they live in the (extra‑deck) pile, counted with a `P:n` marker.
* A Power Card can be **declared** when a given chain segment opens; a declared
  Power Card closes the chain with `CHAIN_POWER`, which cannot be responded to
  by the opponent.

## Phase status (all committed & pushed to `Zanehisako/edopro-powers`)

| Phase | Scope | Where | Status |
|-------|-------|-------|--------|
| 0 | constants & gating | `gframe/ocgapi_constants.h`, `ocgcore/` | ✅ |
| 1 | ocgcore engine | `ocgcore/*` (`is_power_card`, extra-pile redirect, `CHAIN_POWER`) | ✅ |
| 2 | network & server | `gframe/network.h`, `deck_manager.*`, `generic_duel.cpp`, `duelclient.cpp` (deck protocol, `MSG_START` powers count, `OCG_DuelNewCard(LOCATION_POWERS)`) | ✅ |
| 3 | client deck builder | `deck_con.*`, `drawing.cpp` (power deck tab, `#powers` ydk section) | ✅ |
| 4 | field zone UI | `materials.*`, `client_field.cpp`, `event_handler.cpp`, `drawing.cpp` (`getPowers()`, pile viewer, `P:` counter) | ✅ |
| 5 | client modes & config | `single_mode.cpp` (hand‑test loads power deck, `DUEL_ENABLE_POWERS`), online deck‑size defaults | ✅ |
| 6 | sample cards & verification | `sample_powers/` (see below) | ✅ |
| 7 | script runtime & protocol fixes | `ocgcore/libduel.cpp` (`Duel.GetReasonEffect` shim), `gframe/generic_duel.cpp` (`MSG_START` per‑player ordering), `script/constant.lua` + `script/utility.lua` shipped locally | ✅ |
| 8 | power pip meter | `ocgcore` (pip counter, costs, `MSG_POWER_UPDATE`), `gframe` (meter UI, handler) | ✅ |

## Phase 8 — power pip meter

Power Cards are gated by a shared resource, **Power Pips**, enforced by the
engine so it works online, in single-player and in replays.

* Each player has a pip counter (`player_info.power_pips`). Player 1 starts with
  **0**, Player 2 with **1** (going-second bonus). At the start of each new round
  (the first player's next turn after both have taken one) both players gain
  **+1**, up to a maximum of **5**.
* A Power Card declares its cost in its script with
  `Effect:SetPowerCost(n)` (default 1; the sample cards use 1/2/3).
* The engine refuses any Power Card activation whose cost exceeds the activating
  player's current pips (`effect::is_activateable` also reports such cards as
  not activatable, so they are not offered to the player or the AI).
* On activation (`AddChain`) the cost is deducted immediately and never refunded
  (like any cost, even if the chain is later negated).
* A new protocol message **`MSG_POWER_UPDATE` (191)** carries `(pips0, pips1)`
  and is sent at each round start and after every activation; the client shows
  the current pips as 5 visual pips (filled = current, hollow = remaining)
  beside each player's Powers pile
  (`Game::DrawPowerPips`, filled color from `DUELFIELD_POWER_PIPS`,
  hollow from `DUELFIELD_POWER_PIPS_EMPTY`).
* Power Cards live in the Powers pile (engine-side `LOCATION_EXTRA`), outside the
  activation range of a normal ACTIVATE effect, so `card::add_effect` /
  `apply_field_effect` / `cancel_field_effect` treat `TYPE_POWER` handlers as
  always in range, indexing their effects into the free-chain activation list.
  On activation a Power Card stays in the Powers pile (no `move_to_field`, no
  `MSG_SELECT_PLACE`), and `effect::get_speed()` reports 2 so it is chainable at
  free-chain timing like a Quick-Play/Trap.

## Phase 7 — script runtime & protocol fixes

The sample power scripts previously failed to load in a real duel
(`error.log` showed `Parameter 2 should be "Int" but is "nil"` at `e1:SetType(...)`
because `EFFECT_TYPE_*` constants were `nil` — no `constant.lua` was present before
the repos were cloned, and the fork's v11 core could not run the current
Project Ignis base scripts).

Fixes (verified headless against the built core):
- `ocgcore/libduel.cpp`: added `Duel.GetReasonEffect()` — required by the
  current `chain.lua` (`chain.lua:575`) which otherwise aborts loading the
  `proc_*.lua` helper scripts.
- `gframe/generic_duel.cpp`: `MSG_START` now writes per-player
  `(deck, extra, powers)` groups instead of `(deck, extra) x2, powers x2`,
  matching the client's reader (`duelclient.cpp` reads deck/extra/powers per
  player). Previously both players' counts were misread.
- `script/constant.lua` + `script/utility.lua`: copied from the pinned
  `delta-bagooska` repo so hand-testing works even before/without cloning repos.
- Verification: a headless harness driving `OCG_CreateDuel` + `constant.lua` +
  `utility.lua` + `OCG_StartDuel` + `OCG_DuelNewCard(LOCATION_POWERS)` for
  `42000001/2/3` now loads `c42000001-3.lua` and processes the duel with **zero**
  script errors (`initial_effect` runs, effects register).

## Phases detail

### Phase 0 — constants & gating
`TYPE_POWER`, `LOCATION_POWERS`, `DUEL_ENABLE_POWERS` (0x2000000000),
`CHAIN_POWER` added to the ocgcore and to the client mirror
(`ocgapi_constants.h`).

### Phase 1 — engine
- `card::is_power_card()` helper.
- Cards with `TYPE_POWER` never stay in main; `card.cpp`/`field.cpp` route them
  to the Extra Deck pile, and resets are redirected in `OCG_DuelNewCard` via
  `LOCATION_POWERS → LOCATION_EXTRA`.
- `CHAIN_POWER` chain flag: an open chain whose top link is a Power Card can no
  longer be responded to (`chain_solving` skips response windows).

### Phase 2 — protocol & server
- `DeckSizes` gains `powers{min,max}`; `DeckError::POWERCOUNT` added.
- `CTOS_UPDATE_DECK` carries `(mainc, powersc, sidec)`; room creation reads
  `powers_min/powers_max`.
- `LoadDeckFromBuffer` / `LoadSide` / `LoadDeckFromFile` / `SaveDeck` handle the
  powers zone; `CheckDeckContent` allows `TYPE_POWER` only in the powers zone;
  `CheckDeckSize` enforces the limits.
- `MSG_START` writes `home_powers`/`opp_powers`; `ClientField::Initial` builds
  the `powers[2]` placeholder zone; `generic_duel.cpp` uploads the power deck via
  `OCG_DuelNewCard(… LOCATION_POWERS)`.

### Phase 3 — deck builder
- `DeckType::POWERS`; `push_powers/pop_powers` (power-only container).
- Power deck shown in the builder via a toggle (hotkey P), reusing the side-deck
  region; drag/drop, right/middle click and text‑drop target the powers deck.
- `TYPE_POWER` is rejected in main/extra/side inside the builder.

### Phase 4 — field zone UI
- `Materials::getPowers()` exposes the powers-zone vertices.
- `GetCardPos`/`GetCardLocation` resolve `LOCATION_POWERS` to the zone.
- `ShowPileDisplayCards(LOCATION_POWERS, player)` shows the power deck.
- The Extra-deck stack indicator appends ` P:<count>` when powers are present.

### Phase 5 — modes & rules
- Single/hand-test mode sets `DUEL_ENABLE_POWERS` and feeds the power deck into
  the Duel (as extra-deck-only cards), including into the replay stream.
- Online deck-size defaults for the powers zone are sent by the host.

### Phase 6 — samples & verification
- `sample_powers/` ships a regenerable `.cdb` (verified rows carry `TYPE_POWER`),
  three sample scripts, a legal `#powers` .ydk deck, and this readme.

## Repository layout of the fork

All work lives on top of vanilla `edo9300/edopro@master`.
See the git log for per-phase commits:

```
e2b68645  Phase 0
6a1441b9  Phase 1
dbb09f2f  Phase 2
5a72808e  Phase 3
8f0042d2  Phase 4
1a369a21  Phase 5
<latest>  Phase 6
<latest>  Phase 7
b65b3f2d  Phase 8 (ocgcore)
1369dab5  Phase 8 (gframe)
93fba85f  Phase 8 (samples)
```