/*
* Copyright (c) 2017 Heiko Müller (https://github.com/heiko-m)
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 2 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1301 USA
*
* Authored by: Heiko Müller <mue.heiko@web.de>
*/

namespace Elememory.Models {
    /**
      * Name, score tuple.
      */
    public struct HighscoreEntry {
        public string name;
        public int score;

        public HighscoreEntry (string name, int score) {
            this.name = name;
            this.score = score;
        }
    }

    /** 
      * Highscore model.
      */
    public class Highscore : Object {
        public HighscoreEntry[] ranking = new HighscoreEntry[20];
        public signal void updated ();

        public Highscore () {
        }

        construct {
            insert_entry ("A", 55);
            insert_entry ("B", 100);
            insert_entry ("C", 93);
            insert_entry ("D", 55);
            insert_entry ("E", 100);
            insert_entry ("F", 97);
            insert_entry ("G", 55);
            insert_entry ("H", 100);
            insert_entry ("I", 94);
            insert_entry ("J", 55);
            insert_entry ("K", 100);
            insert_entry ("L", 93);
            insert_entry ("M", 51);
            insert_entry ("N", 100);
            insert_entry ("O", 93);
            insert_entry ("P", 53);
            insert_entry ("Q", 100);
            insert_entry ("R", 93);
            insert_entry ("S", 55);
            insert_entry ("T", 100);
            insert_entry ("KING", 200);
            
            for (int j = 0; j < ranking.length; j++) {
                print ("%s\t%d\n", ranking[j].name, ranking[j].score);
            }
        }

        /**
          * Inserts a new entry into the ranking so that the ranking remains
          * sorted.
          */
        public void insert_entry (string name, int score) {
            bool new_entry_put = false;

            for (int i = ranking.length - 1; i >= 0; i--) {
                if (ranking[i].name == null) {
                    continue;
                } else if (ranking[i].score >= score) {
                    if (i + 1 < ranking.length) {
                        ranking[i + 1] = HighscoreEntry (name, score);
                    }
                    new_entry_put = true;
                    break;
                } else {
                    if (i + 1 < ranking.length) {
                        ranking[i + 1] = ranking[i];
                    }
                }
            }
            
            if (! new_entry_put) {
                ranking[0] = HighscoreEntry (name, score);
            }

            updated ();
        }
    }
}
