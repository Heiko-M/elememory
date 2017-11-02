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
        private Models.Highscore[] highscores = new Models.Highscore[2];
        private Gtk.Grid highscore_page;
        private Widgets.HighscoreView[] highscore_views = new Widgets.HighscoreView[2];

        public Window () {
            window_position = Gtk.WindowPosition.CENTER;
            
            highscores[PlayerMode.SINGLE] = new Models.Highscore ("single_highscore.json");
            highscores[PlayerMode.DUAL] = new Models.Highscore ("dual_highscore.json");
            game = Models.Game.get_instance ();

            // HEADER BAR
            header = new Widgets.Header ();
            set_titlebar (header);

            // WINDOW CONTENT
            stack = new Gtk.Stack ();
            stack.set_transition_type (Gtk.StackTransitionType.SLIDE_LEFT_RIGHT);
            board = new Widgets.Board ();
            highscore_page = new Gtk.Grid ();
            highscore_page.column_homogeneous = true;
            highscore_views[PlayerMode.SINGLE] = new Widgets.HighscoreView (highscores[PlayerMode.SINGLE], "Single player mode");
            highscore_views[PlayerMode.DUAL] = new Widgets.HighscoreView (highscores[PlayerMode.DUAL], "Dual player mode");
            
            highscore_page.add (highscore_views[PlayerMode.SINGLE]);
            highscore_page.add (highscore_views[PlayerMode.DUAL]);
            stack.add_named (board, "board");
            stack.add_named (highscore_page, "highscore-page");
            add (stack);
            show_all ();

            // CONNECTIONS
            delete_event.connect (on_delete_event);
            destroy.connect (Gtk.main_quit);

            header.player_mode_switch.notify["selected"].connect (() => {
                if (header.player_mode_switch.selected == 0) {
                    game.player_mode = PlayerMode.SINGLE;
                } else {
                    game.player_mode = PlayerMode.DUAL;
                }
                board.repopulate ();
                resize (1, 1);
            });

            game.stats_changed.connect (() => {
                header.update_stats ();
            });
            
            header.highscore_switch.clicked.connect (() => {
                if (header.highscore_switch.selected == 1) {
                    stack.set_visible_child_name ("highscore-page");
                } else {
                    stack.set_visible_child_name ("board");
                }
            });

            game.finished.connect ((em, winner, score) => {
                var results_dialog = new Widgets.ResultsDialog (this, score, highscores[game.player_mode].is_relevant_for_highscore (score));
                results_dialog.show_all ();
                results_dialog.winner_identified.connect ((em, winner_name) => {
                    highscores[game.player_mode].insert_entry (winner_name, score);
                });
                results_dialog.run ();
                game.new_setup ();
                board.repopulate ();
            });

            Gtk.main ();
        }

        public bool on_delete_event () {
            Gtk.main_quit ();
            return false;
        }
    }
}
