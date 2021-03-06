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
        private Tile? tile_exposed = null;
        
        public signal void freeze ();
        public signal void resume ();
        public signal void finished (Player winner, int score);
        public signal void stats_changed ();

        public Player active_player { get; set; default = Player.any (); }
        public int[] draws { get; private set; }
        public int[] pairs { get; private set; }
        public Tile[,] setup { get; set; }

        private Game () {
        }

        construct {
            draws = new int[2];
            pairs = new int[2];
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
          * Reinitializes a new setup of tiles for the current player mode and
          * resets the stats.
          */
        public void new_setup () {
            setup = shuffled_motifs (BOARD_WIDTHS[player_mode], BOARD_HEIGHTS[player_mode]);

            if (player_mode == PlayerMode.SINGLE) {
                active_player = Player.LEFT;
            } else {
                active_player = Player.any ();
            }
            
            reset_stats ();
            tile_exposed = null;

            foreach (Tile tile in setup) {
                tile.notify["exposed"].connect (() => {
                    if (tile.exposed) {
                        on_exposure (tile);
                    }
                });
            }
        }
        
        /**
          * Integrates the results of one draw.
          *
          * @param match Whether a match was found during that draw.
          */
        private void consolidate_draw (bool match) {
            draws[active_player] ++;

            if (match) {
                pairs[active_player] ++;
            } else {
                if (player_mode == PlayerMode.DUAL) {
                    active_player = active_player.other ();
                }
            }

            stats_changed ();

            if (is_game_finished ()) {
                finished (get_winner (), get_score ());
            }
        }

        /**
          * Returns true if no tiles are left on the board.
          *
          * @return true if no tiles left.
          */
        private bool is_game_finished () {
            foreach (Tile tile in setup) {
                if (tile.present_on_board) {
                    return false;
                }
            }
            return true;
        }

        private void on_exposure (Tile tile) {
            if (tile_exposed == null) {
                tile_exposed = tile;
            } else {
                freeze ();
                Timeout.add_seconds (1, () => {
                    check_pairing (tile);
                    resume ();
                    return false;
                });
            }
        }

        private void check_pairing (Tile tile_turned) {
            if (tile_exposed.motif == tile_turned.motif) {
                tile_exposed.present_on_board = false;
                tile_turned.present_on_board = false;
                consolidate_draw (true);
            } else {
                tile_exposed.exposed = false;
                tile_turned.exposed = false;
                consolidate_draw (false);
            }
            tile_exposed = null;
        }

        /**
          * Returns the winner of the current game or null if none exists yet.
          *
          * @return The winner or null.
          */
        public Player? get_winner () {
            if (! is_game_finished ()) {
                debug ("Winner inquired when game was not finished yet!");
                return null;
            }

            if (player_mode == PlayerMode.SINGLE) {
                return Player.LEFT;
            } else if (pairs[Player.LEFT] > pairs[Player.RIGHT]) {
                return Player.LEFT;
            } else if (pairs[Player.RIGHT] > pairs[Player.LEFT]) {
                return Player.RIGHT;
            } else {
                // In dual mode, odd number of tile pairs should always result in a winner.
                assert_not_reached ();
            }
        }

        /**
          * Returns the score of the winner or -1 if there is no winner.
          *
          * @return The winner's score or -1.
          */
        private int get_score () {
            if (! is_game_finished ()) {
                return -1;
            }

            if (player_mode == PlayerMode.SINGLE) {
                assert (draws[Player.LEFT] != 0);
                return pairs[Player.LEFT] * 100 / draws[Player.LEFT];
            } else if (get_winner () != null) {
                return pairs[(Player) get_winner ()] * 100 / (setup.length[0] * setup.length[1] / 2);
            } else {
                return -1;
            }
        }

        /**
          * Resets draws and pairs of players.
          */
        public void reset_stats () {
            draws[Player.LEFT] = 0;
            draws[Player.RIGHT] = 0;
            pairs[Player.LEFT] = 0;
            pairs[Player.RIGHT] = 0;

            stats_changed ();
        }

        /**
          * Returns a 2-dimensional array which holds randomly distributed
          * pairs of numbers from 0 to width * height / 2 - 1.
          */
        private Tile[,] shuffled_motifs (int width, int height) {
            int[] tile_motifs = new int[width * height / 2];
            int[] motif_taken = new int[SCHEME_SIZE];
            Tile[,] arrangement = new Tile[height, width];

            if (tile_motifs.length < SCHEME_SIZE) {
                tile_motifs = motif_subset (tile_motifs.length, SCHEME_SIZE);
            } else {
                for (int i = 0; i < tile_motifs.length; i++) {
                    tile_motifs[i] = i;
                }
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

        /**
          * Returns an array of n randomly picked, unique integers
          * between 0 and total - 1.
          *
          * @param n Number of integers to be picked.
          * @param total Number of available integers.
          * @return Array of randomly picked, unique integers.
          */
        private int[] motif_subset (int n, int total) {
            var subset = new int[n];

            for (int i = 0; i < subset.length; i++) {
                subset[i] = -1;
            }

            for (int i = 0; i < subset.length; i++) {
                int pick = -1;

                do {
                    pick = GLib.Random.int_range (0, total);
                } while (is_present_in (pick, subset));

                subset[i] = pick;
            }

            return subset;
        }

        /**
          * Returns true if the integer query is present in the collection.
          *
          * @param query The integer query.
          * @param collection The collection of integers.
          * @return true if query in collection, otherwise false.
          */
        private bool is_present_in (int query, int[] collection) {
            foreach (int element in collection) {
                if (element == query) {
                    return true;
                }
            }
            return false;
        }
    }
}
