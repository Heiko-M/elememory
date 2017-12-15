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
      * Indicator panel for single and dual player draw statistics and turn indicator.
      */
    public class StatsIndicator : Gtk.Grid {
        private Models.Game game = Models.Game.get_instance ();
        private Gtk.Label[] stats_labels;
        private Gtk.Image[] indicators;

        public StatsIndicator () {
            Object (orientation: Gtk.Orientation.HORIZONTAL,
                    margin_top: 3,
                    column_spacing: 8);
        }

        construct {
            stats_labels = new Gtk.Label[2];
            stats_labels[Player.LEFT] = new Gtk.Label (null);
            stats_labels[Player.LEFT].use_markup = true;
            stats_labels[Player.RIGHT] = new Gtk.Label (null);
            stats_labels[Player.RIGHT].use_markup = true;
            indicators = new Gtk.Image[2];
            indicators[Player.LEFT] = new Gtk.Image.from_icon_name ("elememory-dualplayer-left-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
            indicators[Player.RIGHT] = new Gtk.Image.from_icon_name ("elememory-dualplayer-right-symbolic", Gtk.IconSize.SMALL_TOOLBAR);

            update_stats ();
        }

        /**
          * Updates the draw statistics.
          */
        public void update_stats () {
            remove_row (0);

            stats_labels[Player.LEFT].label = "<b>%d pairs</b> out of <b>%d draws</b>".printf (game.pairs[Player.LEFT], game.draws[Player.LEFT]);
            stats_labels[Player.RIGHT].label = "<b>%d pairs</b> out of <b>%d draws</b>".printf (game.pairs[Player.RIGHT], game.draws[Player.RIGHT]);

            add (stats_labels[Player.LEFT]);
            if (game.player_mode == PlayerMode.DUAL) {
                add (indicators[game.active_player]);
                add (stats_labels[Player.RIGHT]);
            }
            show_all ();
        }
    }
}
