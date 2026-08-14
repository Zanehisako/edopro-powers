# Power Cards — sample expansion

Standalone test content for the Power Cards mechanic implemented in this
repository (see `../PowerCards.md`).

## What's here

| File                      | Role                                                      |
|---------------------------|-----------------------------------------------------------|
| `powers_sample.cards.cdb` | SQLite card database with 20 Power Cards (`TYPE_POWER`)   |
| `script/c42000001.lua` … `c42000020.lua` | Power Card scripts (costs 1 to 5)          |
| `sample_powers_deck.ydk`  | A legal deck using the `#powers` deck section             |
| `make_cards.py`           | Reproducible generator for the `.cdb`                     |
| `generate_card_art.py`    | Card art generator (421x614 JPGs in `pics/`)              |

## Power Cards Catalog

| ID | Name | Power Cost | Category | Effect Summary |
|----|------|------------|----------|----------------|
| `42000001` | **Arcane Order** | 1 Pip | Draw | Draw 1 card. |
| `42000002` | **Void Surge** | 2 Pips | Draw | Draw 2 cards. |
| `42000003` | **Temporal Shifter** | 3 Pips | Recover | Gain 4000 LP. |
| `42000004` | **Solar Flare** | 4 Pips | Destroy | Destroy all monsters your opponent controls. |
| `42000005` | **Mystic Tempest** | 2 Pips | Destroy | Destroy all Spell and Trap Cards your opponent controls. |
| `42000006` | **Astral Rebirth** | 3 Pips | Special Summon | Target 1 monster in either player's GY; Special Summon it to your field. |
| `42000007` | **Aegis Barrier** | 1 Pip | Defense | Until end of turn, you take no damage, also monsters you control cannot be destroyed by battle. |
| `42000008` | **Titan's Might** | 1 Pip | ATK Change | Target 1 face-up monster on the field; it gains 1500 ATK until the end of this turn. |
| `42000009` | **Chrono Freeze** | 2 Pips | Disable / ATK | Target 1 face-up monster your opponent controls; until end of turn, negate its effects, and its ATK becomes 0. |
| `42000010` | **Omega Cataclysm** | 5 Pips | Destroy / Damage | Destroy all cards on the field, and if you do, inflict 1000 damage to your opponent. |
| `42000011` | **Dimensional Banish** | 3 Pips | Remove | Target 1 card on the field; banish it. |
| `42000012` | **Mind Shatter** | 4 Pips | Hand Destruction | Discard 2 random cards from your opponent's hand. |
| `42000013` | **Summoner's Surge** | 1 Pip | Extra Summon | You can conduct 2 Normal Summons/Sets this turn, not just 1. |
| `42000014` | **Domain of Silence** | 2 Pips | Field Negate | Negate the effects of all face-up monsters your opponent currently controls until end of turn. |
| `42000015` | **Vanguard Assault** | 1 Pip | Special Summon | If opponent controls a monster and you control none: Special Summon 1 Level 4 or lower monster from your hand or GY. |
| `42000016` | **Equilibrium Burst** | 3 Pips | Destroy / Draw | If opponent controls more cards than you: Target 2 cards opponent controls; destroy them, then draw 1 card. |
| `42000017` | **Tactical Mulligan** | 1 Pip | Deck / Draw | Shuffle up to 3 cards from your hand into the Deck, then draw that same number + 1. |
| `42000018` | **Gravity Singularity** | 2 Pips | Send to GY / Burn | Send 1 monster your opponent controls to the GY (non-targeting), and inflict damage equal to half its original ATK. |
| `42000019` | **Absolute Lockdown** | 3 Pips | Position | Change all face-up monsters opponent controls to face-down DEF; battle positions cannot be changed this turn. |
| `42000020` | **Second Wind** | 1 Pip | Add to Hand | Target up to 2 cards in your GY; add them to your hand. |

Power Cards are never monsters: they use the Spell flag plus the Power bit (`TYPE_POWER | TYPE_SPELL = 0x8000002`), so the engine treats them as non-monster cards while keeping them in the Powers deck.

## How to use it

1. Build EDOPro from this repository (it contains the Power Card mechanic).
2. Copy `powers_sample.cards.cdb` into the game's `cards/` and `expansions/` folder.
3. Copy scripts `script/c42000001.lua` … `script/c42000020.lua` into the game's `script/` folder.
4. Load `sample_powers_deck.ydk` in the Deck Builder. The Power Cards show up in the **Power deck** tab (toggle with the P key / side-deck slot).

Power cards are extra-deck-only: the engine moves them into the Extra Deck pile at the start of the Duel, where they are playable and counted separately ("P:n" is appended to the Extra marker on the battlefield).

Activating a Power Card costs **Power Pips**. Player 1 starts with 0 pips and Player 2 with 1 (going-second bonus); each round (both players' turns) both players gain +1 pip up to a maximum of 5. Each Power Card declares its cost with `Effect:SetPowerCost(n)`. The engine refuses and hides activations you cannot afford and deducts the pips when you activate a card; the current pips are shown as "n / 5" beside each Powers pile on the battlefield.

## Verifying the database

```sh
python3 -c "
import sqlite3
con = sqlite3.connect('powers_sample.cards.cdb')
for row in con.execute('''SELECT d.id, d.type, t.name
                          FROM datas d, texts t WHERE t.id = d.id'''):
    print(row)
"
```

Every row must carry `type & 0x8000000` (TYPE_POWER).