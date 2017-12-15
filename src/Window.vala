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
            highscore_views[PlayerMode.SINGLE] = new Widgets.HighscoreView (highscores[PlayerMode.SINGLE], "Single player");
            highscore_views[PlayerMode.DUAL] = new Widgets.HighscoreView (highscores[PlayerMode.DUAL], "Dual player");
            
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

            game.stats_changed.connect (header.stats_indicator.update_stats);
            
            header.highscore_switch.notify["selected"].connect (() => {
                if (header.highscore_switch.selected == 1) {
                    stack.set_visible_child_name ("highscore-page");
                } else {
                    stack.set_visible_child_name ("board");
                }
            });

            game.finished.connect ((em, winner, score) => {
                if (highscores[game.player_mode].is_relevant_for_highscore (score)) {
                    string? winner_name = show_results_dialog_with_name_prompt (winner, score);
                    if (winner_name != null) {
                        highscores[game.player_mode].insert_entry (winner_name, score);
                    }
                } else {
                    show_results_dialog (winner, score);
                }
                game.new_setup ();
                board.repopulate ();
            });

            Gtk.main ();
        }

        /**
          * Shows dialog presenting the winner's stats and prompting him for his
          * name.
          */
        private string? show_results_dialog_with_name_prompt (Player winner, int score) {
            string? winner_name = null;
            string primary_text;
            string secondary_text;

            if (game.player_mode == PlayerMode.SINGLE) {
                primary_text = "Congratulations! Your score: %d".printf (score);
                secondary_text = "Enter your name below to be recorded in the highscore ranking.";
            } else {
                primary_text = "%s won! Score: %d".printf (winner.to_string (), score);
                secondary_text = "Enter your name below to be recorded in the highscore ranking.";
            }
            
            var results_dialog = new Granite.MessageDialog.with_image_from_icon_name (primary_text, secondary_text, "dialog-information", Gtk.ButtonsType.NONE);
            results_dialog.transient_for = this;
            results_dialog.destroy_with_parent = true;
            results_dialog.modal = true;

            var custom_widgets_grid = new Gtk.Grid ();
            Gtk.Image winner_icon;
            if (game.player_mode == PlayerMode.DUAL) {
                winner_icon = new Gtk.Image.from_resource (ICONS_DUALPLAYER_ACTIVE[winner]);
            } else {
                winner_icon = new Gtk.Image.from_resource (ICON_SINGLEPLAYER_ACTIVE);
            }
            winner_icon.margin_end = 6;
            var name_entry = new Gtk.Entry ();
            name_entry.placeholder_text = "Enter name";
            name_entry.max_length = 20;
            name_entry.activates_default = true;

            custom_widgets_grid.attach (winner_icon, 0, 0, 1, 1);
            custom_widgets_grid.attach (name_entry, 1, 0, 1, 1);
            results_dialog.custom_bin.add (custom_widgets_grid);

            results_dialog.add_button ("No, Thanks", Gtk.ResponseType.CLOSE);
            var accept_button = results_dialog.add_button ("Record My Name", Gtk.ResponseType.ACCEPT);
            accept_button.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);
            accept_button.sensitive = false;
            results_dialog.set_default (accept_button);

            results_dialog.show_all ();

            name_entry.changed.connect (() => {
                accept_button.sensitive = (name_entry.text != "");
            });

            if (results_dialog.run () == Gtk.ResponseType.ACCEPT) {
                winner_name = name_entry.text;
            }

            results_dialog.destroy ();

            return winner_name;
        }

        /**
          * Shows dialog presenting the winner's stats.
          */
        private void show_results_dialog (Player winner, int score) {
            string primary_text;
            string secondary_text;

            if (game.player_mode == PlayerMode.SINGLE) {
                primary_text = "Well played! Your score: %d".printf (score);
                secondary_text = "Try again using less draws to make it into the highscore.";
            } else {
                primary_text = "%s won! Score: %d".printf (winner.to_string (), score);
                secondary_text = "Try again collecting more of the available pairs to make it into the highscore.";
            }

            var results_dialog = new Granite.MessageDialog.with_image_from_icon_name (primary_text, secondary_text, "dialog-information", Gtk.ButtonsType.CLOSE);
            results_dialog.transient_for = this;
            results_dialog.destroy_with_parent = true;
            results_dialog.modal = true;

            results_dialog.show_all ();

            if (results_dialog.run () == Gtk.ResponseType.CLOSE) {
                results_dialog.destroy ();
            }
        }

        public bool on_delete_event () {
            Gtk.main_quit ();
            return false;
        }
    }
}
