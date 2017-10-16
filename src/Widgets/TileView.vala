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
      * The TileView constitutes a graphical and interactive representation of a
      * Tile model.
      */
    public class TileView : Gtk.EventBox {
        private Models.Tile tile;
        private Gtk.Image motif = new Gtk.Image ();
        private Gtk.Image backside = new Gtk.Image ();
        private ulong button_press_handler_id;

        public TileView (Models.Tile tile, string motif_img_path, string backside_img_path) {
            this.tile = tile;

            margin = 12;
            vexpand = false;
            valign = Gtk.Align.CENTER;
            hexpand = false;
            halign = Gtk.Align.CENTER;
            set_visible_window (false);

            motif.set_from_file (motif_img_path);
            motif.show ();
            backside.set_from_file (backside_img_path);
            backside.show ();
            add (backside);

            button_press_handler_id = button_press_event.connect (() => {
                tile.exposed = true;
                return true;
            });

            tile.notify["exposed"].connect (() => {
                if (tile.exposed) {
                    turn_face_up ();
                } else {
                    turn_face_down ();
                }
            });

            tile.notify["present_on_board"].connect (() => {
                if (! tile.present_on_board) {
                    remove_from_board ();
                }
            });

            show ();
        }

        private void turn_face_up () {
            /** Turns the tile motif side up. **/
            desensitize ();  // Block from further clicking.
            remove (backside);
            add (motif); 
        }

        public void turn_face_down () {
            /** Turns the tile motif side down. **/
            remove (motif);
            add (backside);
            sensitize ();
        }

        public void desensitize () {
            SignalHandler.block (this, button_press_handler_id);
        }

        public void sensitize () {
            if (tile.present_on_board) {
                SignalHandler.unblock (this, button_press_handler_id);
            }
        }

        public void remove_from_board () {
            /** Removes the visible representation of this tile. **/
            // XXX: It remains in the grid so no columns or rows disappear, but
            //      it's invisible and insensitive to mouse clicks.
            remove(get_child ());
            disconnect (button_press_handler_id);
        }
    }
}
