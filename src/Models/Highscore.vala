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
        public string save_file { get; construct; }
        public HighscoreEntry[] ranking = new HighscoreEntry[12];
        public signal void updated ();

        public Highscore (string save_file) {
            Object (
                save_file: save_file
            );
        }

        construct {
            FileUtils.read_highscore_from_file (save_file, ref ranking);
        }

        /**
          * Inserts a new entry into the ranking so that the ranking remains
          * sorted and emitts the updated signal. Entries which thereby loose
          * their top 12 spot are lost.
          *
          * @param name Player's name.
          * @param score Player's score.
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

            FileUtils.write_highscore_to_file (save_file, ranking);
            updated ();
        }

        /**
          * Returns true if the given score would make it into the top 12.
          *
          * @param score Score to check.
          * @return True if relevant for highscore.
          */
        public bool is_relevant_for_highscore (int score) {
            return score > ranking[ranking.length - 1].score;
        }
    }
}
