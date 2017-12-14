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
        public Models.Tile tile { get; construct; }
        public string scheme { get; construct; }
        public int motif { get; construct; }
        private Gtk.Image motif_side = new Gtk.Image ();
        private Gtk.Image backside = new Gtk.Image ();
        private ulong button_press_handler_id;

        public TileView (Models.Tile tile, string scheme, int motif) {
            Object (
                margin: 12,
                vexpand: false,
                hexpand: false,
                valign: Gtk.Align.CENTER,
                halign: Gtk.Align.CENTER,
                visible_window: false,
                tile: tile,
                scheme: scheme,
                motif: motif
                );
        }
        
        construct {
            motif_side.set_from_resource ("/com/github/heiko-m/elememory/tile-schemes/%s/%d.png".printf(scheme, motif));
            motif_side.show ();
            backside.set_from_resource ("/com/github/heiko-m/elememory/tile-schemes/%s/back.png".printf(scheme));
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

            tile.notify["present-on-board"].connect (() => {
                if (! tile.present_on_board) {
                    remove_from_board ();
                }
            });

            show ();
        }

        /**
          * Turns the tile motif side up.
          */
        private void turn_face_up () {
            desensitize ();
            remove (backside);
            add (motif_side); 
        }

        /**
          * Turns the tile motif side down.
          */
        private void turn_face_down () {
            remove (motif_side);
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

        /**
          * Removes the visible representation of this tile.
          */
        private void remove_from_board () {
            // It remains in the grid so no columns or rows disappear, but
            // it's invisible and insensitive to mouse clicks.
            disconnect (button_press_handler_id);
            remove(get_child ());
        }
    }
}
