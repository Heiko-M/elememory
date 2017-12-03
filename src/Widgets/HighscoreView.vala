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
        public Models.Highscore highscore { get; construct; }
        public string title { get; construct; }

        public HighscoreView (Models.Highscore highscore, string title) {
            Object (
                margin: 60,
                row_spacing: 12,
                halign: Gtk.Align.CENTER,
                highscore: highscore,
                title: title
            );
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
            var title_label = new Gtk.Label (title);
            title_label.get_style_context ().add_class ("h2");
            title_label.margin_bottom = 12;

            attach (title_label, 0, 0, 3, 1);

            for (int i = 0; i < highscore.ranking.length; i++) {
                if (highscore.ranking[i].name == null) {
                    break;
                } else {
                    var rank_label = new Gtk.Label ("%d.".printf (i + 1));
                    rank_label.margin_end = 12;
                    rank_label.halign = Gtk.Align.END;
                    var name_label = new Gtk.Label ("%s".printf (highscore.ranking[i].name));
                    name_label.margin_end = 12;
                    name_label.halign = Gtk.Align.START;
                    var score_label = new Gtk.Label ("%d".printf (highscore.ranking[i].score));
                    score_label.margin_end = 8;
                    score_label.halign = Gtk.Align.END;

                    attach (rank_label, 0, i + 1, 1, 1);
                    attach (name_label, 1, i + 1, 1, 1);
                    attach (score_label, 2, i + 1, 1, 1);
                }
            }
            show_all ();
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
