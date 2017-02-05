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

public class Tile : Gtk.Button {
    /** The tile class represents a single tile object of the game. **/
    private int motif_id;
    private Image motif = new Image ();
    private Image backside = new Image ();

    public Tile (int motif_id, string motif_img_path, string backside_img_path) {
        this.motif_id = motif_id;
        this.motif.set_from_file (motif_img_path);
        this.backside.set_from_file (backside_img_path);

        this.set_image (backside);
    }

    public int get_motif () {
        return this.motif_id;
    }

    public void turn_over () {
        this.set_image (motif);
    }

    public void turn_face_down () {
        this.set_image (backside);
    }

}
