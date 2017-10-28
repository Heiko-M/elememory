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

namespace Elememory.Widgets {
    /**
      * The HighscoreView provides a list view of the highscore model.
      */
    public class HighscoreView : Gtk.Grid {
        public Models.Highscore highscore { get; construct set; }

        public HighscoreView (Models.Highscore highscore) {
            Object (
                margin: 12,
                highscore: highscore
            );

            //this.highscore = highscore;
        }

        construct {
            populate ();

            highscore.updated.connect (() => {
                repopulate ();
            });

            show ();
        }

        /**
          * Populates the highscore list according to the highscore model.
          */
        private void populate () {
            for (int i = 0; i < highscore.ranking.length; i++) {
                if (highscore.ranking[i].name == null) {
                    print ("Entry %d's name is null!\n", i);
                    break;
                } else {
                    attach (new Gtk.Label (highscore.ranking[i].name), 0, i, 1, 1);
                    attach (new Gtk.Label (highscore.ranking[i].score.to_string ()), 1, i, 1, 1);
                }
            }
        }

        /**
          * Delete and repopulate list according to the highscore model.
          */
        private void repopulate () {
            forall ((element) => element.destroy ());
            populate ();
        }
    }
}
