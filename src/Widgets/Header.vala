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
      * The header bar consisting of player mode switch, stats indicator and highscore
      * switch.
      */
    public class Header : Gtk.HeaderBar {
        public ToggleSwitch player_mode_switch;
        public ToggleSwitch highscore_switch;
        public Gtk.Stack stack;
        public StatsIndicator stats_indicator;
        private Gtk.Label highscore_title;

        public Header () {
            Object (show_close_button: true);
        }

        construct {
            player_mode_switch = new ToggleSwitch.with_tooltip_texts ("elememory-dualplayer-symbolic", "elememory-singleplayer-symbolic", 0, "Dualplayer", "Singleplayer");
            highscore_switch = new ToggleSwitch.with_tooltip_texts ("elememory-highscore-symbolic", "elememory-board-symbolic", 0, "Highscore", "Game");
            stack = new Gtk.Stack ();
            stack.set_transition_type (Gtk.StackTransitionType.SLIDE_LEFT_RIGHT);
            stats_indicator = new StatsIndicator ();
            highscore_title = new Gtk.Label ("");

            pack_start (player_mode_switch);
            pack_end (highscore_switch);
            stack.add_named (stats_indicator, "stats-indicator");
            stack.add_named (highscore_title, "highscore-title");
            custom_title = stack; 

            get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);

            stats_indicator.update_stats ();

            highscore_switch.clicked.connect (() => {
                if (highscore_switch.selected == 1) {
                    stack.set_visible_child_name ("highscore-title");
                    player_mode_switch.sensitive = false;
                } else {
                    stack.set_visible_child_name ("stats-indicator");
                    player_mode_switch.sensitive = true;
                }
            });
        }
    }
}
