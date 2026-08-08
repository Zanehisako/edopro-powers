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
```