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

namespace Elememory {
    public class Window : Gtk.Window {
        /**
          * The window class defines the layout of widgets and the connection of
          * signals.
          */
        public Window () {
            this.set_position (Gtk.WindowPosition.CENTER);
            this.delete_event.connect (this.on_delete_event);
            this.destroy.connect (Gtk.main_quit);
            
            var game_model = Models.Game.get_instance ();

            // HEADER BAR
            var header = new Widgets.Header ("eleMemory");
            this.set_titlebar (header);

            // WINDOW CONTENT
            var stack = new Gtk.Stack ();
            stack.set_transition_type (Gtk.StackTransitionType.SLIDE_LEFT_RIGHT);

            var board = new Widgets.Board (6);
            stack.add_named (board, "board");

            header.tile_field_size_changed.connect ((mode) => {
                board.repopulate (4 + mode * 2);
            });

            add (stack);

            show_all ();
            Gtk.main ();
        }

        public bool on_delete_event () {
            //TODO: implement save of current game status to reload on next start.
            Gtk.main_quit ();
            return false;
        }
    }
}
