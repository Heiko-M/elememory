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
      * @deprecated   //...for now.
      */
    public class ResultsDialog : Granite.MessageDialog {
        public int score { get; construct; }
        public bool show_name_entry { get; construct; }
        public Gtk.Entry name_entry;
        public signal void winner_identified (string winner_name);

        public ResultsDialog (Gtk.Window parent, int score, bool show_name_entry) {
            Object (
                resizable: false,
                deletable: false,
                skip_taskbar_hint: true,
                modal: true,
                transient_for: parent,
                destroy_with_parent: true,
                window_position: Gtk.WindowPosition.CENTER_ON_PARENT,
                buttons: Gtk.ButtonsType.CANCEL,
                image_icon: new ThemedIcon ("dialog-information"),
                show_name_entry: show_name_entry,
                score: score
            );
        }

        construct {
            var game = Models.Game.get_instance ();
            

            if (game.player_mode == PlayerMode.SINGLE) {
                primary_text = "Well played, you made it into the highscore!";
                secondary_text = "%d pairs in %d draws, that's a score of <b>%d</b>. Enter your name to be recorded in the highscore.".printf (game.pairs[Player.LEFT], game.draws[Player.LEFT], score);
                secondary_label.use_markup = true;
            } else {
                Player? winner = game.get_winner ();
                if (winner != null) {
                    primary_text = "Congratulations! The winner reached a score of %d!".printf (score);
                    secondary_text = "He collected %d of all %d pairs!".printf (game.pairs[(Player) winner], 27);
                } else {
                    primary_text = "No winner could be determined!";
                    secondary_text = "This dialog must have been created accidentaly.";
                    debug ("ResultsDialog created although no winner (received null).");
                }
            }


            if (show_name_entry) {
                var custom_widgets_grid = new Gtk.Grid ();
                Gtk.Image winner_icon;
                if (game.player_mode == PlayerMode.DUAL) {
                    winner_icon = new Gtk.Image.from_resource (ICONS_DUALPLAYER_ACTIVE[(Player) game.get_winner ()]);
                } else {
                    winner_icon = new Gtk.Image.from_resource (ICON_SINGLEPLAYER_ACTIVE);
                }
                name_entry = new Gtk.Entry ();
                name_entry.placeholder_text = "Enter name...";
                name_entry.max_length = 20;
                name_entry.activates_default = true;

                custom_widgets_grid.attach (winner_icon, 0, 0, 1, 1);
                custom_widgets_grid.attach (name_entry, 1, 0, 1, 1);
                custom_bin.add (custom_widgets_grid);
            }

            var accept_button = add_button ("Record my name", Gtk.ResponseType.ACCEPT);
            accept_button.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);
            //set_default (close_button);
        }
    }
}
