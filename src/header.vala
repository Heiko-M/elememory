/* Copyright 2017, Heiko Müller
*
* This file is part of eleMemory.
*
* eleMemory is free software: you can redistribute it and/or modify it under the
* terms of the GNU General Public License as published by the Free Software
* Foundation, either version 3 of the License, or (at your option) any later
* version.
*
* eleMemory is distributed in the hope that it will be useful, but WITHOUT ANY
* WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
* A PARTICULAR PURPOSE. See the GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License along with
* eleMemory. If not, see http://www.gnu.org/licenses/.
*/

using Gtk;
using Granite;

public class Header : Gtk.HeaderBar {
    public signal void tile_field_size_changed (int mode);
    private Box tile_field_size_button_vbox;
    private Granite.Widgets.ModeButton tile_field_size_button;

    public Header (string title) {
        set_show_close_button (true);
        set_title (title);

        /*  Tile field size button  */
        tile_field_size_button_vbox = new Box (Gtk.Orientation.VERTICAL, 0);
        tile_field_size_button = new Granite.Widgets.ModeButton ();
        var field_small_icon = new Image.from_icon_name ("tile-field-small", IconSize.SMALL_TOOLBAR);
        var field_medium_icon = new Image.from_icon_name ("tile-field-medium", IconSize.SMALL_TOOLBAR);
        var field_large_icon = new Image.from_icon_name ("tile-field-large", IconSize.SMALL_TOOLBAR);
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

        /*  Settings button  */
        var settings_icon = new Image.from_icon_name ("document-properties", IconSize.SMALL_TOOLBAR);
        var settings_button = new ToolButton (settings_icon, "Settings");
        settings_button.is_important = true;
        settings_button.set_tooltip_text ("Settings");
        settings_button.clicked.connect (on_settings_clicked);
        this.pack_end (settings_button);
    }

    private void on_settings_clicked () {
        // TODO: Implement settings dialog
    }
}
