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

public class PlayingField : Gtk.Box {  // XXX: Maybe use Grid instead of box...
    /** This class generates a playing field of the given even size, holding all the
     * tiles separated by the given spacing value. It is a subclass of Gtk.Box.
     **/

    // TODO: Clean up this whole mess a bit...
    private int size;
    private Tile? tile_exposed = null;
    private int pairs_found = 0;
    private string[] tile_motif_paths = new string[32];
    private string tile_backside_path;

    public PlayingField (int size, int spacing) {
        this.size = size;
        this.set_spacing (spacing);
        this.set_orientation (Gtk.Orientation.VERTICAL);

        this.tile_motif_paths = motif_img_paths ("default", 8);
        this.tile_backside_path = backside_img_path ("default");
        int[,] motif_arrangement = shuffled_motifs (this.size);

        for (int y = 0; y < this.size; y++) {
            var box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, spacing);
            this.pack_start (box, true, true, 0);

            for (int x = 0; x < this.size; x++) {
                var tile = new Tile (motif_arrangement[y, x], this.tile_motif_paths[motif_arrangement[y, x]], this.tile_backside_path);
                tile.clicked.connect ( () => { this.tile_clicked (tile); } );
                tile.show ();
                box.pack_start (tile, true, true, 0);
            }
        }

        this.show();
    }

    private void tile_clicked (Tile tile) {
        tile.turn_over ();
        tile.set_sensitive (false);

        if (this.tile_exposed != null) {
            // TODO: While timeout all tiles should be insensitive.
            Timeout.add_seconds (1, () => {
                                try {
                                     check_pair_found (tile);
                                } catch (Error e) {
                                     stderr.printf ("%s\n", e.message);
                                }
                                return false;
            });
        }
        else {
            this.tile_exposed = tile;
        }
    }

    private bool check_pair_found (Tile tile_turned) {
        if (this.tile_exposed.get_motif () == tile_turned.get_motif ()) {
            this.pairs_found += 1;
            // FIXME: Find a way so that button remains in box (i.e. no rescaling of the box)
            this.tile_exposed.set_visible (false);
            tile_turned.set_visible (false);
        }
        else {
            this.tile_exposed.turn_face_down ();
            tile_turned.turn_face_down ();
        }

        this.tile_exposed.set_sensitive (true);
        tile_turned.set_sensitive (true);
        this.tile_exposed = null;

        return false;   // False, so Timeout doesn't call it repeatedly.
    }

    private string[] motif_img_paths (string motif_set, int set_size) {
        /** Returns an array of strings of file paths to the motif images. **/
        // TODO: Read the respective motif set file paths from XML scheme collection
        string app_base_path = File.new_for_path(Environment.get_current_dir()).get_parent().get_path();
        string images_path = Path.build_path (Path.DIR_SEPARATOR_S, app_base_path, "images/tile_schemes", motif_set);
        string[] paths = new string[32];

        // TODO: Shuffle images within this function (only relevant later when playing field size is adjustable.
        for (int i = 0; i < set_size; i++) {
            string img_path = Path.build_path (Path.DIR_SEPARATOR_S, images_path, @"$i.png");
            //stdout.printf("Loading " + img_path + "\n"); // FOR DEBUGGING.
            paths[i] = img_path;
        }

        return paths;
    }

    private string backside_img_path (string motif_set) {
        string app_base_path = File.new_for_path(Environment.get_current_dir()).get_parent().get_path();
        string images_path = Path.build_path (Path.DIR_SEPARATOR_S, app_base_path, "images/tile_schemes", motif_set);
        string img_path = Path.build_path (Path.DIR_SEPARATOR_S, images_path, "back.png");
        return img_path;
    }

    private static int[,] shuffled_motifs (int dimension) {
        /** Returns a 2-dimensional array which holds randomly distributed pairs
         * of numbers from 0 to dimension^2 / 2 - 1.
         **/
        int[] tile_motifs = new int[dimension * dimension / 2];
        int[] motif_taken = new int[dimension * dimension / 2];
        int[,] arrangement = new int[dimension, dimension];

        for (int i = 0; i < tile_motifs.length; i++) {
            tile_motifs[i] = i;
            motif_taken[i] = 0;
        }

        for (int y = 0; y < dimension; y++) {
            for (int x = 0; x < dimension; x++) {
                int motif = tile_motifs[GLib.Random.int_range (0, tile_motifs.length)];

                while (motif_taken[motif] >= 2) {
                    motif = tile_motifs[GLib.Random.int_range (0, tile_motifs.length)];
                }

                arrangement[y, x] = motif;
                motif_taken[motif] += 1;
            }
        }

        return arrangement;
    }
}
