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
      * Dialog presenting stats and allowing for name input for highscore if
      * applicable.
      */
    public class ResultsDialog : Gtk.Dialog {
        public int score { get; construct; }
        public bool show_name_entry { get; construct; }
        private Gtk.Entry name_entry;
        public signal void winner_identified (string winner_name);

        public ResultsDialog (Gtk.Window parent, int score, bool show_name_entry) {
            Object (
                deletable: false,
                destroy_with_parent: true,
                resizable: false,
                title: "Game finished!",
                modal: true,
                transient_for: parent,
                window_position: Gtk.WindowPosition.CENTER_ON_PARENT,
                show_name_entry: show_name_entry,
                score: score
            );
        }

        construct {
            var game = Models.Game.get_instance ();
            
            var grid = new Gtk.Grid ();
            Gtk.Label stats_label;

            if (game.player_mode == PlayerMode.SINGLE) {
                stats_label = new Gtk.Label ("You've collected %d pairs in %d draws!".printf (game.pairs[Player.LEFT], game.draws[Player.LEFT]));

            } else {
                Player? winner = game.get_winner ();
                if (winner != null) {
                    stats_label = new Gtk.Label ("The winner collected %d of all %d pairs!".printf (game.pairs[(Player) winner], 27));
                } else {
                    stats_label = new Gtk.Label ("No winner could be determined!");
                    debug ("ResultsDialog created although no winner (received null).");
                }
            }

            var score_label = new Gtk.Label ("Score: %d".printf (score));

            grid.attach (stats_label, 0, 0, 2, 1);
            grid.attach (score_label, 0, 1, 2, 1);

            if (show_name_entry) {
                var name_label = new Gtk.Label ("Your name:");
                name_entry = new Gtk.Entry ();
                grid.attach (name_label, 0, 2, 1, 1);
                grid.attach (name_entry, 1, 2, 1, 1);
            }

            ((Gtk.Container) get_content_area ()).add (grid);

            var close_button = add_button ("Close", Gtk.ResponseType.CLOSE);
            ((Gtk.Button) close_button).clicked.connect (() => destroy ());
            response.connect (on_response);
        }

        private void on_response (Gtk.Dialog source, int response_id) {
            if (response_id == Gtk.ResponseType.CLOSE) {
                winner_identified (name_entry.text);
            }
        }
    }
}
