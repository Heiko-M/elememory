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

public class TileField : Gtk.Grid {
    /** This class generates a tile field of the given even size, holding all
      * the tiles.
     **/

    // TODO: Clean up this whole mess a bit (i.e. outsource all file path
    //       handling to a dedicated class and resolve tile scheme paths on
    //       Window level then pass the appropriate scheme paths to this.)
    private Tile? tile_exposed = null;
    private int pairs_found = 0;
    private string[] tile_motif_paths = new string[32];
    private string tile_backside_path;
    public signal void tiles_insensitive ();
    public signal void tiles_sensitive ();

    public TileField (int size) {
        this.column_spacing = 6;
        this.row_spacing = 6;
        this.set_column_homogeneous (true);
        this.set_row_homogeneous (true);

        // TODO: I probably need to write a function that localizes my image files by checking all the system_data_dirs returned...
        string[] sys_data_dirs = Environment.get_system_data_dirs ();
        //print (sys_data_dirs[2]); // the third one happens to be the right one
        this.tile_motif_paths = motif_img_paths (sys_data_dirs[2], "default", 32);
        this.tile_backside_path = Path.build_path (Path.DIR_SEPARATOR_S, sys_data_dirs[2], "/elememory/tile_schemes/default/back.png");

        populate (size);

        show();
    }

    private void populate (int size) {
        /** Populates the grid with newly created tiles. **/
        int[,] motif_arrangement = shuffled_motifs (size);

        for (int y = 0; y < size; y++) {
            for (int x = 0; x < size; x++) {
                Tile tile = new Tile (motif_arrangement[y, x], this.tile_motif_paths[motif_arrangement[y, x]], this.tile_backside_path);
                tile.exposed.connect ( (emitter) => { on_exposure (emitter); });
                tiles_insensitive.connect (tile.desensitize);
                tiles_sensitive.connect (tile.sensitize); 
                tile.show ();
                attach(tile, x, y, 1, 1);
            }
        }
    }

    public void repopulate (int size) {
        /** Deletes all tiles and repopulates the grid. **/
        forall ((element) => element.destroy ());
        populate (size);
    }

    private void on_exposure (Tile tile) {
        /** Checks for exposed tiles and initiates pair check if due. **/
        if (tile_exposed != null) {
            tiles_insensitive ();
            Timeout.add_seconds (1, () => {
                                           check_pair_found (tile);
                                           tiles_sensitive ();
                                           return false;
                                          });
        }
        else {
            tile_exposed = tile;
        }
    }

    private void check_pair_found (Tile tile_turned) {
        /** Checks if two pairs are exposed and consequently either dismisses
          * both or turns them face down again.
         **/
        if (tile_exposed.pairs_with (tile_turned)) {
            pairs_found += 1;
            tile_exposed.remove_from_tile_field ();
            tile_turned.remove_from_tile_field ();
        }
        else {
            tile_exposed.turn_face_down ();
            tile_turned.turn_face_down ();
        }

        tile_exposed = null;
    }

    private string[] motif_img_paths (string sys_data_dir, string motif_set, int set_size) {
        /** Returns an array of strings of file paths to the motif images. **/
        string[] paths = new string[32];

        // TODO: Shuffle images within this function (only relevant later when playing field size is adjustable.
        for (int i = 0; i < set_size; i++) {
            string img_path = Path.build_path (Path.DIR_SEPARATOR_S, sys_data_dir, "/elememory/tile_schemes/", motif_set, @"$i.png");
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
