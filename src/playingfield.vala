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

public class PlayingField : Gtk.Grid {
    /** This class generates a playing field of the given even size, holding all
      * the tiles separated by the given spacing value. It is a subclass of
      * Gtk.Grid.
     **/

    // TODO: Clean up this whole mess a bit (i.e. outsource all file path
    //       handling to a dedicated class and resolve tile scheme paths on
    //       Window level then pass the appropriate scheme paths to this.)
    private int size;
    private Tile? tile_exposed = null;
    private int pairs_found = 0;
    private string[] tile_motif_paths = new string[32];
    private string tile_backside_path;

    public PlayingField (int size) {
        this.size = size;
        this.column_spacing = 6;
        this.row_spacing = 6;
        this.set_column_homogeneous (true);
        this.set_row_homogeneous (true);
        //this.set_orientation (Gtk.Orientation.VERTICAL);

        // TODO: I probably need to write a function that localizes my image files by checking all the system_data_dirs returned...
        string[] sys_data_dir = Environment.get_system_data_dirs ();
        print (sys_data_dir[2]);  // the third one happens to be the right one...
        this.tile_motif_paths = motif_img_paths (sys_data_dir[2], "default", 8);
        this.tile_backside_path = Path.build_path (Path.DIR_SEPARATOR_S, sys_data_dir[2], "/elememory/tile_schemes/default/back.png");

        int[,] motif_arrangement = shuffled_motifs (this.size);

        for (int y = -1; y < this.size; y++) {
            for (int x = -1; x < this.size; x++) {
                if (y == -1 || x == -1) {
                    // Place empty labels in first column and row to prevent shrinking of grid.
                    // FIXME: Prevent grid from shrinking without the X-rows and columns.
                    this.attach(new Gtk.Label("X"), x, y, 1, 1);
                }
                else {
                    var tile = new Tile (motif_arrangement[y, x], this.tile_motif_paths[motif_arrangement[y, x]], this.tile_backside_path);
                    tile.button_press_event.connect ( () => { tile_clicked (tile); return true; } );
                    tile.show ();
                    attach(tile, x, y, 1, 1);
                }
            }
        }

        show();
    }

    private void tile_clicked (Tile tile) {
        /** Reveals the tile clicked and initiates pair check if due. **/
        tile.flip ();

        if (tile_exposed != null) {
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
            tile_exposed = tile;
        }
    }

    private bool check_pair_found (Tile tile_turned) {
        /** Checks if two pairs are exposed and consequently either dismisses both
          * or turns them face down again.
         **/
        if (tile_exposed.pairs_with (tile_turned)) {
            pairs_found += 1;
            // FIXME: Find a way so that button remains in box (i.e. no rescaling of the box), maybe just display no image on tiles.
            tile_exposed.set_visible (false);
            tile_turned.set_visible (false);
        }
        else {
            tile_exposed.flip ();
            tile_turned.flip ();
        }

        tile_exposed = null;

        return false;   // False, so Timeout doesn't call it repeatedly.
    }

    private string[] motif_img_paths (string sys_data_dir, string motif_set, int set_size) {
        /** Returns an array of strings of file paths to the motif images. **/
        // TODO: Read the respective motif set file paths from XML scheme collection, maybe ...
        //string app_base_path = File.new_for_path(Environment.get_current_dir()).get_parent().get_path();
        //string images_path = Path.build_path (Path.DIR_SEPARATOR_S, app_base_path, "images/tile_schemes", motif_set);
        string[] paths = new string[32];

        // TODO: Shuffle images within this function (only relevant later when playing field size is adjustable.
        for (int i = 0; i < set_size; i++) {
            string img_path = Path.build_path (Path.DIR_SEPARATOR_S, sys_data_dir, "/elememory/tile_schemes/", motif_set, @"$i.png");
            //stdout.printf("Loading " + img_path + "\n"); // FOR DEBUGGING.
            paths[i] = img_path;
        }

        return paths;
    }

    private string backside_img_path (string motif_set) {
        /** Returns the image path of the tile backside image. **/
        // XXX: DEPRECATED due to installation of images in subfolder of system_data_dir...
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
