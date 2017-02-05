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

public class Header : Gtk.HeaderBar {
    public Header (string title) {
        this.set_show_close_button (true);
        this.set_title (title);

        /*  Settings button  */
        Image settings_icon = new Image.from_icon_name ("document-properties", IconSize.SMALL_TOOLBAR);
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
