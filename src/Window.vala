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

namespace Elememory {
    /**
      * The window class defines the layout of widgets and the connection of
      * signals.
      */
    public class Window : Gtk.Window {
        public Window () {
            window_position = Gtk.WindowPosition.CENTER;
            delete_event.connect (on_delete_event);
            destroy.connect (Gtk.main_quit);
            
            var game = Models.Game.get_instance ();

            // HEADER BAR
            var header = new Widgets.Header ();
            set_titlebar (header);

            // WINDOW CONTENT
            var stack = new Gtk.Stack ();
            stack.set_transition_type (Gtk.StackTransitionType.SLIDE_LEFT_RIGHT);
            var board = new Widgets.Board ();
            var highscore = new Gtk.Label ("<b>Highscore</b>\nX      100\nY      98\nZ      70");
            highscore.use_markup = true;
            
            stack.add_named (board, "board");
            stack.add_named (highscore, "highscore");
            add (stack);
            show_all ();

            // CONNECTIONS
            header.player_mode_switch.notify["selected"].connect (() => {
                if (header.player_mode_switch.selected == 0) {
                    game.player_mode = Models.PlayerMode.SINGLE;
                } else {
                    game.player_mode = Models.PlayerMode.DUAL;
                }
                board.repopulate ();
                resize (1, 1);
            });

            game.notify.connect (() => {
                header.update_stats ();
            });
            
            header.highscore_switch.clicked.connect (() => {
                if (header.highscore_switch.selected == 1) {
                    stack.set_visible_child_name ("highscore");
                } else {
                    stack.set_visible_child_name ("board");
                }
            });

            game.finished.connect (() => {
                //TODO: evaluate score and record winner in highscore.
                game.new_setup ();
                board.repopulate ();
            });

            Gtk.main ();
        }

        public bool on_delete_event () {
            //TODO: implement save of current game status to reload on next start.
            Gtk.main_quit ();
            return false;
        }
    }
}
