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

namespace Elememory.Models {
    public enum PlayerMode {
        SINGLE,
        DUAL
    }

    /** 
      * Game model singleton.
      */
    public class Game : Object {
        private static Game? instance = null;
        public PlayerMode player_mode {
            public get {
                return _player_mode;
            }
            public set {
                _player_mode = value;
                new_setup ();
            }
            default = PlayerMode.SINGLE;
        }
        private PlayerMode _player_mode;
        public int p1_draws { get; set; default = 0; }
        public int p1_matches { get; set; default = 0; }
        public int p2_draws { get; set; default = 0; }
        public int p2_matches { get; set; default = 0; }
        public Tile[,] setup { get; set; }

        private Game () {
        }

        construct {
            new_setup ();
        }

        public static Game get_instance () {
            if (instance == null) {
                instance = new Game ();
            }
            return instance;
        }
        
        private void new_setup () {
            if (player_mode == PlayerMode.SINGLE) {
                setup = shuffled_motifs (6, 4);
            } else {
                setup = shuffled_motifs (9, 6);
            }
        }

        /**
          * Returns a 2-dimensional array which holds randomly distributed
          * pairs of numbers from 0 to width * height / 2 - 1.
          */
        private Tile[,] shuffled_motifs (int width, int height) {
            int[] tile_motifs = new int[width * height / 2];
            int[] motif_taken = new int[width * height / 2];
            Tile[,] arrangement = new Tile[height, width];

            for (int i = 0; i < tile_motifs.length; i++) {
                tile_motifs[i] = i;
                motif_taken[i] = 0;
            }

            for (int y = 0; y < height; y++) {
                for (int x = 0; x < width; x++) {
                    int motif = tile_motifs[GLib.Random.int_range (0, tile_motifs.length)];

                    while (motif_taken[motif] >= 2) {
                        motif = tile_motifs[GLib.Random.int_range (0, tile_motifs.length)];
                    }

                    arrangement[y, x] = new Tile (motif);
                    motif_taken[motif] += 1;
                }
            }

            return arrangement;
        }
    }
}
