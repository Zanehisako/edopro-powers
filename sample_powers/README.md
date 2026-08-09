# Power Cards — sample expansion

Standalone test content for the Power Cards mechanic implemented in this
repository (see `../PowerCards.md`).

## What's here

| File                      | Role                                                    |
|---------------------------|---------------------------------------------------------|
| `powers_sample.cards.cdb` | SQLite card database with 3 Power Cards (`TYPE_POWER`)  |
| `script/c42000001.lua`    | Sample Power Card #1 script (activation: draw 1)        |
| `script/c42000002.lua`    | Sample Power Card #2 script (banish / draw)             |
| `script/c42000003.lua`    | Sample Power Card #3 script (chain-negation)            |
| `sample_powers_deck.ydk`  | A legal deck using the `#powers` deck section           |
| `make_cards.py`           | Reproducible generator for the `.cdb`                   |

The three cards:

* `42000001` — **Arcane Order** (`TYPE_POWER|TYPE_SPELL`)
* `42000002` — **Void Surge** (`TYPE_POWER|TYPE_SPELL`)
* `42000003` — **Temporal Shifter** (`TYPE_POWER|TYPE_SPELL`)

Power Cards are never monsters: they use the Spell flag plus the Power bit, so
the engine treats them as non-monster cards while keeping them in the Powers
deck.

## How to use it

1. Build EDOPro from this repository (it contains the Power Card mechanic).
2. Copy `powers_sample.cards.cdb` into the game's `cards/` folder (or merge with
   your `cards.cdb`).
3. Copy the two scripts `script/c42000001.lua` … `script/c42000003.lua` into the
   game's `script/` folder next to the compiled scripts.
4. Load `sample_powers_deck.ydk` in the Deck Builder. The Power Cards show up in
   the **Power deck** tab (toggle with the P key / side-deck slot).

Power cards are extra-deck-only: the engine moves them into the Extra Deck pile
at the start of the Duel, where they are playable and counted separately
("P:n" is appended to the Extra marker on the battlefield).

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