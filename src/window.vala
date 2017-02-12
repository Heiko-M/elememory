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

    public bool on_delete_event () {
        //TODO: implement save of current game status to reload on next start.
        Gtk.main_quit ();
        return false;
    }

    public Window () {
        this.set_default_size (800, 800);
        this.set_position (Gtk.WindowPosition.CENTER);
        this.set_border_width (12);

        var header = new Header ("eleMemory");
        this.set_titlebar (header);

        var playing_field = new PlayingField (4);
        this.add (playing_field);

        this.delete_event.connect (this.on_delete_event);
        this.destroy.connect (Gtk.main_quit);

        show_all ();
        Gtk.main ();
    }
}
