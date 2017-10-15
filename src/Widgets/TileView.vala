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
    public class TileView : Gtk.EventBox {
        /** This class represents a memory tile. **/
        private Models.Tile tile_model;
        private Gtk.Image motif = new Gtk.Image ();
        private Gtk.Image backside = new Gtk.Image ();
        private bool present_in_game;
        private ulong button_press_handler_id;
        public signal void exposed ();

        public TileView (Models.Tile tile_model, string motif_img_path, string backside_img_path) {
            this.tile_model = tile_model;
            present_in_game = true;

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
                turn_face_up ();
                return true;
            });
            show ();
        }

        private void turn_face_up () {
            /** Turns the tile motif side up and emits the exposed signal. **/
            desensitize ();  // Block from further clicking.
            remove (backside);
            add (motif); 
            exposed ();
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
            if (present_in_game) {
                SignalHandler.unblock (this, button_press_handler_id);
            }
        }

        public void remove_from_tile_field () {
            /** Removes the visible representation of this tile. **/
            // XXX: It remains in the grid so no columns or rows disappear, but
            //      it's invisible and insensitive to mouse clicks.
            remove( get_child ());
            present_in_game = false;
            disconnect (button_press_handler_id);
        }

        public bool pairs_with (TileView query_tile) {
            /** Returns true if query_tile forms pair with this tile. **/
            return tile_model.motif == query_tile.get_motif_id ();
        }

        public int get_motif_id () {
            /** Returns this tile's motif_id. **/
            return tile_model.motif;
        }
    }
}
