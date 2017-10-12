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
    private Gtk.Box tile_field_size_button_vbox;
    private Granite.Widgets.ModeButton tile_field_size_button;

    public Header (string title) {
        set_show_close_button (true);
        set_title (title);

        /*  Tile field size button  */
        tile_field_size_button_vbox = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
        tile_field_size_button = new Granite.Widgets.ModeButton ();
        var field_small_icon = new Gtk.Image.from_icon_name ("tile-field-small", Gtk.IconSize.SMALL_TOOLBAR);
        var field_medium_icon = new Gtk.Image.from_icon_name ("tile-field-medium", Gtk.IconSize.SMALL_TOOLBAR);
        var field_large_icon = new Gtk.Image.from_icon_name ("tile-field-large", Gtk.IconSize.SMALL_TOOLBAR);
        tile_field_size_button.append (field_small_icon);
        tile_field_size_button.append (field_medium_icon);
        tile_field_size_button.append (field_large_icon);
        tile_field_size_button.set_active (1);
        tile_field_size_button_vbox.pack_start (tile_field_size_button, false, false, 6);
        tile_field_size_button_vbox.set_center_widget (tile_field_size_button);
        tile_field_size_button.mode_changed.connect ( () => {
                                                             tile_field_size_changed (tile_field_size_button.selected);
                                                            }); 
        this.pack_start (tile_field_size_button_vbox);

        /*  Highscore button  */
        var highscore_icon = new Gtk.Image.from_icon_name ("elememory-highscore-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
        var highscore_button = new Gtk.ToolButton (highscore_icon, "Highscore");
        highscore_button.is_important = true;
        highscore_button.set_tooltip_text ("Highscore");
        this.pack_end (highscore_button);
    }
}
