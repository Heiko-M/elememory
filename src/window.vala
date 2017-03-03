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

public class Window : Gtk.Window {
    public Window () {
        this.set_default_size (812, 937);
        this.set_position (Gtk.WindowPosition.CENTER);
        this.set_border_width (0);
        this.delete_event.connect (this.on_delete_event);
        this.destroy.connect (Gtk.main_quit);

        // HEADER BAR
        var header = new Header ("eleMemory");
        this.set_titlebar (header);

        // WINDOW CONTENT
        var vlayout = new Box (Gtk.Orientation.VERTICAL, 0);

        var tile_field_box = new Box (Gtk.Orientation.HORIZONTAL, 0);
        var tile_field = new TileField (6);
        tile_field_box.pack_start (tile_field, true, true, 12);
        tile_field_box.set_center_widget (tile_field);
        vlayout.pack_start (tile_field_box, true, true, 12);

        header.tile_field_size_changed.connect( (emitter, mode) => {
                                                                    tile_field.repopulate (4 + mode * 2);
                                                                   });

        var indicator_bar = new IndicatorBar ();
        vlayout.pack_end (indicator_bar, false, false, 0);

        add (vlayout);

        show_all ();
        Gtk.main ();
    }

    public bool on_delete_event () {
        //TODO: implement save of current game status to reload on next start.
        Gtk.main_quit ();
        return false;
    }
}
