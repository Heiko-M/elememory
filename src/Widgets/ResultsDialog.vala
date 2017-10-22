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

        public ResultsDialog (Gtk.Window parent) {
            Object (
                deletable: false,
                destroy_with_parent: true,
                resizable: false,
                title: "Congrats!",
                transient_for: parent,
                window_position: Gtk.WindowPosition.CENTER_ON_PARENT
            );
        }

        construct {
            var game = Models.Game.get_instance ();

            if (game.player_mode == Models.PlayerMode.SINGLE) {
                var stats_label = new Gtk.Label ("You've collected %d pairs in %d draws!".printf (game.p1_matches, game.p1_draws));
                var name_label = new Gtk.Label ("Your name:");
                var name_entry = new Gtk.Entry ();
                var close_button = add_button ("Close", Gtk.ResponseType.CLOSE);

                var grid = new Gtk.Grid ();
                grid.attach (stats_label, 0, 0, 2, 1);
                grid.attach (name_label, 0, 1, 1, 1);
                grid.attach (name_entry, 1, 1, 1, 1);
                ((Gtk.Container) get_content_area ()).add (grid);

                ((Gtk.Button) close_button).clicked.connect (() => destroy ());
            } else {
            }
        }
    }
}
