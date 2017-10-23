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
        private Models.Game game;
        private Widgets.Header header;
        private Gtk.Stack stack;
        private Widgets.Board board;
        private Models.Highscore single_highscore;
        private Models.Highscore dual_highscore;
        private Gtk.Grid highscore_page;
        private Widgets.HighscoreView single_highscore_view;
        private Widgets.HighscoreView dual_highscore_view;

        public Window () {
            window_position = Gtk.WindowPosition.CENTER;
            
            single_highscore = new Models.Highscore ();
            dual_highscore = new Models.Highscore ();
            game = Models.Game.get_instance ();

            // HEADER BAR
            header = new Widgets.Header ();
            set_titlebar (header);

            // WINDOW CONTENT
            stack = new Gtk.Stack ();
            stack.set_transition_type (Gtk.StackTransitionType.SLIDE_LEFT_RIGHT);
            board = new Widgets.Board ();
            highscore_page = new Gtk.Grid ();
            single_highscore_view = new Widgets.HighscoreView (single_highscore);
            dual_highscore_view = new Widgets.HighscoreView (dual_highscore);
            //var highscore = new Gtk.Label ("<b>Highscore</b>\nX      100\nY      98\nZ      70");
            //highscore.use_markup = true;
            
            highscore_page.add (single_highscore_view);
            highscore_page.add (dual_highscore_view);
            stack.add_named (board, "board");
            stack.add_named (highscore_page, "highscore-page");
            add (stack);
            show_all ();

            // CONNECTIONS
            delete_event.connect (on_delete_event);
            destroy.connect (Gtk.main_quit);

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
                    stack.set_visible_child_name ("highscore-page");
                } else {
                    stack.set_visible_child_name ("board");
                }
                // XXX: Move this section where it belongs
                var results_dialog = new Widgets.ResultsDialog (this);
                results_dialog.show_all ();
                results_dialog.run ();
            });

            game.finished.connect (() => {
                // XXX: Move ResultsDialog sectoin here.
                //TODO: evaluate score and record winner in highscore.
                game.new_setup ();
                board.repopulate ();
            });

            Gtk.main ();
        }

        public bool on_delete_event () {
            //TODO: implement save of highscore.
            Gtk.main_quit ();
            return false;
        }
    }
}
