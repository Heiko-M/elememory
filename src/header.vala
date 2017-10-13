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

public class Header : Gtk.HeaderBar {
    public signal void tile_field_size_changed (int mode);

    public Header (string title) {
        set_show_close_button (true);
        set_title (title);

        /*  Player mode toggle switch  */
        var player_mode_switch = new Elememory.Widgets.ToggleSwitch ("elememory-dualplayer-symbolic", "elememory-singleplayer-symbolic", 0);
        this.pack_start (player_mode_switch);

        /*  Highscore - board toggle switch  */
        var highscore_switch = new Elememory.Widgets.ToggleSwitch ("elememory-highscore-symbolic", "elememory-board-symbolic", 0);
        highscore_switch.set_tooltip_text ("Highscore");  // TODO: toggle tooltip text as well.
        this.pack_end (highscore_switch);
    }
}
