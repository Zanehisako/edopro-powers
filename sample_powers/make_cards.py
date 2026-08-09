#!/usr/bin/env python3
"""Generates the sample Power Cards expansion (.cdb) for EDOPro.
Card text (name/desc) lives in the `texts` table; card data lives in `datas`.
Place the generated powers_sample.cards and script/ into a working EDOPro
installation to try the mechanic (see README.md).
"""
import sqlite3

TYPE_MONSTER = 0x1
TYPE_SPELL = 0x2
TYPE_EFFECT = 0x20
TYPE_POWER = 0x8000000

# Power Cards are never monsters; they use the Spell flag so the engine treats
# them as non-monster cards while the Power bit keeps them in the Powers deck.
SPELL = TYPE_POWER | TYPE_SPELL

CARDS = [
    # id, ot, alias, setcode, type, atk, def, level, race, attribute, category, name, desc
    (42000001, 0, 0, 0, SPELL, 0, 0, 0, 0, 0, 0,
     "Arcane Order",
     "Power Card. During your Main Phase: reveal this card from your Power Deck "
     "to target 1 Set Spell/Trap you control; that target can be activated this "
     "turn as if your opponent had attacked it. You can only activate 1 Power "
     "Card per turn."),
    (42000002, 0, 0, 0, SPELL, 0, 0, 0, 0, 0, 0,
     "Void Surge",
     "Power Card. Banish 1 card from each player's Graveyard; if you banished a "
     "Monster, draw 1 card. You can only activate 1 Power Card per turn."),
    (42000003, 0, 0, 0, SPELL, 0, 0, 0, 0, 0, 0,
     "Temporal Shifter",
     "Power Card. You can chain this card to any Normal Spell/Trap activation; "
     "negate that card's effect, then place it on top of its owner's Deck. "
     "You can only activate 1 Power Card per turn."),
]

def main():
    con = sqlite3.connect("powers_sample.cards.cdb")
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

if __name__ == "__main__":
    main()