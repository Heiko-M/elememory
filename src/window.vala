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
        this.set_border_width (12);
        this.delete_event.connect (this.on_delete_event);
        this.destroy.connect (Gtk.main_quit);

        var header = new Header ("eleMemory");
        this.set_titlebar (header);

        var tile_field = new TileField (6);
        this.add (tile_field);

        header.tile_field_size_changed.connect( (emitter, mode) => {
                                                                    tile_field.repopulate (4 + mode * 2);
                                                                   });

        show_all ();
        Gtk.main ();
    }

    public bool on_delete_event () {
        //TODO: implement save of current game status to reload on next start.
        Gtk.main_quit ();
        return false;
    }
}
