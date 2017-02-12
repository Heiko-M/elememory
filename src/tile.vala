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

public class Tile : Gtk.EventBox {
    /** This class represents a memory tile. **/
    private int motif_id;
    private Image motif = new Image ();
    private Image backside = new Image ();

    public Tile (int motif_id, string motif_img_path, string backside_img_path) {
        this.motif_id = motif_id;

        motif.set_from_file (motif_img_path);
        motif.show ();
        backside.set_from_file (backside_img_path);
        backside.show ();
        add (backside);

        set_vexpand (false);
        set_valign (Gtk.Align.CENTER);
        set_hexpand (false);
        set_halign (Gtk.Align.CENTER);

        show ();
    }

    public void flip () {
        /** Flips this tile from backside to motif or vice versa **/
        if (get_child () == backside) {
            remove (backside);
            add (motif);
            set_sensitive (false);       // An exposed tile should not react to further clicking.
        }
        else {
            remove (motif);
            add (backside);
            set_sensitive (true);
        }
    }

    public bool pairs_with (Tile query_tile) {
        /** Returns true if query_tile forms pair with this tile. **/
        return motif_id == query_tile.get_motif_id ();
    }

    public int get_motif_id () {
        /** Returns this tile's motif_id. **/
        return motif_id;
    }

}
