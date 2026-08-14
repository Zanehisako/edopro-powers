#!/usr/bin/env python3
"""Generates the sample Power Cards expansion (.cdb) for EDOPro.
Card text (name/desc) lives in the `texts` table; card data lives in `datas`.
Place the generated powers_sample.cards and script/ into a working EDOPro
installation to try the mechanic (see README.md).
"""
import os
import shutil
import sqlite3

TYPE_MONSTER = 0x1
TYPE_SPELL = 0x2
TYPE_EFFECT = 0x20
TYPE_POWER = 0x8000000

# Power Categories
CATEGORY_DESTROY = 0x1
CATEGORY_REMOVE = 0x4
CATEGORY_TOHAND = 0x8
CATEGORY_TODECK = 0x10
CATEGORY_TOGRAVE = 0x20
CATEGORY_HANDES = 0x80
CATEGORY_SPECIAL_SUMMON = 0x200
CATEGORY_POSITION = 0x1000
CATEGORY_DISABLE = 0x4000
CATEGORY_DRAW = 0x10000
CATEGORY_DAMAGE = 0x80000
CATEGORY_RECOVER = 0x100000
CATEGORY_ATKCHANGE = 0x200000

# Power Cards are never monsters; they use the Spell flag so the engine treats
# them as non-monster cards while the Power bit keeps them in the Powers deck.
SPELL = TYPE_POWER | TYPE_SPELL

CARDS = [
    # id, ot, alias, setcode, type, atk, def, level, race, attribute, category, name, desc
    (42000001, 0, 0, 0, SPELL, 0, 0, 0, 0, 0, CATEGORY_DRAW,
     "Arcane Order",
     "Power Card. Power Cost 1. Draw 1 card."),
    (42000002, 0, 0, 0, SPELL, 0, 0, 0, 0, 0, CATEGORY_DRAW,
     "Void Surge",
     "Power Card. Power Cost 2. Draw 2 cards."),
    (42000003, 0, 0, 0, SPELL, 0, 0, 0, 0, 0, CATEGORY_RECOVER,
     "Temporal Shifter",
     "Power Card. Power Cost 3. Gain 4000 LP."),
    (42000004, 0, 0, 0, SPELL, 0, 0, 0, 0, 0, CATEGORY_DESTROY,
     "Solar Flare",
     "Power Card. Power Cost 4. Destroy all monsters your opponent controls."),
    (42000005, 0, 0, 0, SPELL, 0, 0, 0, 0, 0, CATEGORY_DESTROY,
     "Mystic Tempest",
     "Power Card. Power Cost 2. Destroy all Spell and Trap Cards your opponent controls."),
    (42000006, 0, 0, 0, SPELL, 0, 0, 0, 0, 0, CATEGORY_SPECIAL_SUMMON,
     "Astral Rebirth",
     "Power Card. Power Cost 3. Target 1 monster in either player's GY; Special Summon it to your field."),
    (42000007, 0, 0, 0, SPELL, 0, 0, 0, 0, 0, 0,
     "Aegis Barrier",
     "Power Card. Power Cost 1. Until the end of this turn, you take no damage, also monsters you control cannot be destroyed by battle."),
    (42000008, 0, 0, 0, SPELL, 0, 0, 0, 0, 0, CATEGORY_ATKCHANGE,
     "Titan's Might",
     "Power Card. Power Cost 1. Target 1 face-up monster on the field; it gains 1500 ATK until the end of this turn."),
    (42000009, 0, 0, 0, SPELL, 0, 0, 0, 0, 0, CATEGORY_DISABLE | CATEGORY_ATKCHANGE,
     "Chrono Freeze",
     "Power Card. Power Cost 2. Target 1 face-up monster your opponent controls; until the end of this turn, negate its effects, also its ATK becomes 0."),
    (42000010, 0, 0, 0, SPELL, 0, 0, 0, 0, 0, CATEGORY_DESTROY | CATEGORY_DAMAGE,
     "Omega Cataclysm",
     "Power Card. Power Cost 5. Destroy all cards on the field, and if you do, inflict 1000 damage to your opponent."),
    (42000011, 0, 0, 0, SPELL, 0, 0, 0, 0, 0, CATEGORY_REMOVE,
     "Dimensional Banish",
     "Power Card. Power Cost 3. Target 1 card on the field; banish it."),
    (42000012, 0, 0, 0, SPELL, 0, 0, 0, 0, 0, CATEGORY_HANDES,
     "Mind Shatter",
     "Power Card. Power Cost 4. Discard 2 random cards from your opponent's hand."),
    (42000013, 0, 0, 0, SPELL, 0, 0, 0, 0, 0, 0,
     "Summoner's Surge",
     "Power Card. Power Cost 1. You can conduct 2 Normal Summons/Sets this turn, not just 1."),
    (42000014, 0, 0, 0, SPELL, 0, 0, 0, 0, 0, CATEGORY_DISABLE,
     "Domain of Silence",
     "Power Card. Power Cost 2. Negate the effects of all face-up monsters your opponent currently controls until the end of this turn."),
    (42000015, 0, 0, 0, SPELL, 0, 0, 0, 0, 0, CATEGORY_SPECIAL_SUMMON,
     "Vanguard Assault",
     "Power Card. Power Cost 1. If your opponent controls a monster and you control no monsters: Special Summon 1 Level 4 or lower monster from your hand or GY."),
    (42000016, 0, 0, 0, SPELL, 0, 0, 0, 0, 0, CATEGORY_DESTROY | CATEGORY_DRAW,
     "Equilibrium Burst",
     "Power Card. Power Cost 3. If your opponent controls more cards than you do: Target 2 cards your opponent controls; destroy them, then draw 1 card."),
    (42000017, 0, 0, 0, SPELL, 0, 0, 0, 0, 0, CATEGORY_TODECK | CATEGORY_DRAW,
     "Tactical Mulligan",
     "Power Card. Power Cost 1. Shuffle up to 3 cards from your hand into the Deck, then draw that same number of cards + 1."),
    (42000018, 0, 0, 0, SPELL, 0, 0, 0, 0, 0, CATEGORY_TOGRAVE | CATEGORY_DAMAGE,
     "Gravity Singularity",
     "Power Card. Power Cost 2. Send 1 monster your opponent controls to the GY, and if you do, inflict damage to your opponent equal to half its original ATK."),
    (42000019, 0, 0, 0, SPELL, 0, 0, 0, 0, 0, CATEGORY_POSITION,
     "Absolute Lockdown",
     "Power Card. Power Cost 3. Change all face-up monsters your opponent controls to face-down Defense Position, also their battle positions cannot be changed this turn."),
    (42000020, 0, 0, 0, SPELL, 0, 0, 0, 0, 0, CATEGORY_TOHAND,
     "Second Wind",
     "Power Card. Power Cost 1. Target up to 2 cards in your GY; add them to your hand."),
]

def main():
    script_dir = os.path.dirname(os.path.abspath(__file__))
    root_dir = os.path.abspath(os.path.join(script_dir, ".."))
    db_path = os.path.join(script_dir, "powers_sample.cards.cdb")

    if os.path.exists(db_path):
        os.remove(db_path)
    con = sqlite3.connect(db_path)
    cur = con.cursor()
    cur.execute("DROP TABLE IF EXISTS datas")
    cur.execute("DROP TABLE IF EXISTS texts")
    cur.execute("CREATE TABLE datas (id INTEGER PRIMARY KEY,ot INTEGER NOT NULL,alias INTEGER NOT NULL,setcode INTEGER NOT NULL,type INTEGER NOT NULL,atk INTEGER NOT NULL,def INTEGER NOT NULL,level INTEGER NOT NULL,race INTEGER NOT NULL,attribute INTEGER NOT NULL,category INTEGER NOT NULL)")
    cur.execute("CREATE TABLE texts (id INTEGER PRIMARY KEY,name TEXT NOT NULL,desc NOT NULL,str1 TEXT NULL,str2 TEXT NULL,str3 TEXT NULL,str4 TEXT NULL,str5 TEXT NULL,str6 TEXT NULL,str7 TEXT NULL,str8 TEXT NULL,str9 TEXT NULL,str10 TEXT NULL,str11 TEXT NULL,str12 TEXT NULL,str13 TEXT NULL,str14 TEXT NULL,str15 TEXT NULL,str16 TEXT NULL)")
    for (cid, ot, alias, setcode, ctype, atk, ddef, level, race, attribute, category, cname, condesc) in CARDS:
        cur.execute("INSERT INTO datas VALUES (?,?,?,?,?,?,?,?,?,?,?)",
                    (cid, ot, alias, setcode, ctype, atk, ddef, level, race, attribute, category))
        cur.execute("INSERT INTO texts (id,name,desc) VALUES (?,?,?)", (cid, cname, condesc))
    con.commit()
    con.close()
    print(f"Generated {db_path} with {len(CARDS)} power cards.")

    # Copy to cards/ and expansions/ if they exist
    cards_db = os.path.join(root_dir, "cards", "powers_sample.cards.cdb")
    expansions_db = os.path.join(root_dir, "expansions", "powers_sample.cards.cdb")
    if os.path.exists(os.path.dirname(cards_db)):
        shutil.copy2(db_path, cards_db)
        print(f"Copied to {cards_db}")
    if os.path.exists(os.path.dirname(expansions_db)):
        shutil.copy2(db_path, expansions_db)
        print(f"Copied to {expansions_db}")

if __name__ == "__main__":
    main()