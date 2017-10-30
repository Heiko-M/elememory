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
    public class Header : Gtk.HeaderBar {
        public ToggleSwitch player_mode_switch;
        public ToggleSwitch highscore_switch;
        private Models.Game game_model = Models.Game.get_instance ();

        public Header () {
            Object (show_close_button: true);
        }

        construct {
            update_stats ();

            player_mode_switch = new ToggleSwitch.with_tooltip_texts ("elememory-dualplayer-symbolic", "elememory-singleplayer-symbolic", 0, "Dualplayer", "Singleplayer");
            highscore_switch = new ToggleSwitch.with_tooltip_texts ("elememory-highscore-symbolic", "elememory-board-symbolic", 0, "Highscore", "Game");

            this.pack_start (player_mode_switch);
            this.pack_end (highscore_switch);
        }

        /**
          * Updates the draw statistics.
          */
        public void update_stats () {
            if (game_model.player_mode == PlayerMode.SINGLE) {
                set_title ("%d pairs out of %d draws".printf (game_model.pairs[Player.LEFT], game_model.draws[Player.LEFT]));
            } else if (game_model.player_mode == PlayerMode.DUAL) {
                set_title ("%d pairs out of %d draws | %d pairs out of %d draws".printf (game_model.pairs[Player.LEFT], game_model.draws[Player.LEFT], game_model.pairs[Player.RIGHT], game_model.draws[Player.RIGHT]));
            }
        }
    }
}
