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
        public int active_player { get; set; default = GLib.Random.int_range (1, 2); }
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

        /**
          * Returns the instance of the game model. If none exists, a new
          * instance is generated.
          *
          * @return Instance of the game model.
          */
        public static Game get_instance () {
            if (instance == null) {
                instance = new Game ();
            }
            return instance;
        }
        
        /**
          * Computes the results of one draw.
          *
          * @param match Whether a match was found.
          */
        public void draw_results (bool match) {
            if (active_player == 1) {
                p1_draws ++;
                if (match) {
                    p1_matches ++;
                } else {
                    if (player_mode == PlayerMode.DUAL) {
                        active_player = 2;
                    }
                }
            } else {
                p2_draws ++;
                if (match) {
                    p2_matches ++;
                } else {
                    active_player = 1;
                }
            }
        }

        private void new_setup () {
            if (player_mode == PlayerMode.SINGLE) {
                setup = shuffled_motifs (6, 4);
                active_player = 1;
            } else {
                setup = shuffled_motifs (9, 6);
                active_player = GLib.Random.int_range (1, 2);
            }
            p1_draws = 0;
            p1_matches = 0;
            p2_draws = 0;
            p2_matches = 0;
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
