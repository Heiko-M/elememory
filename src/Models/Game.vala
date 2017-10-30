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

        public Player active_player { get; set; default = (Player) GLib.Random.int_range (1, 2); }
        public int[] draws { get; private set; }
        public int[] pairs { get; private set; }
        public Tile[,] setup { get; set; }

        private Game () {
        }

        construct {
            draws = new int[3];
            pairs = new int[3];
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
            if (player_mode == PlayerMode.SINGLE) {
                setup = shuffled_motifs (6, 4);
                active_player = Player.LEFT;
            } else {
                setup = shuffled_motifs (9, 6);
                active_player = (Player) GLib.Random.int_range (1, 2);
            }
            
            reset_stats ();

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
            if (active_player == Player.LEFT) {
                draws[Player.LEFT] ++;
                if (match) {
                    pairs[Player.LEFT] ++;
                } else {
                    if (player_mode == PlayerMode.DUAL) {
                        active_player = Player.RIGHT;
                    }
                }
            } else {
                draws[Player.RIGHT] ++;
                if (match) {
                    pairs[Player.RIGHT] ++;
                } else {
                    active_player = Player.LEFT;
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
          * Returns the winner of the current game.
          *
          * @return The winner.
          */
        //TODO: Instead of returning Player.NONE return null if no winner.
        public Player get_winner () {
            if (!is_game_finished ()) {
                return Player.NONE;
            }

            if (player_mode == PlayerMode.SINGLE) {
                return Player.LEFT;
            } else if (pairs[Player.LEFT] > pairs[Player.RIGHT]) {
                return Player.LEFT;
            } else if (pairs[Player.RIGHT] > pairs[Player.LEFT]) {
                return Player.RIGHT;
            } else {
                return Player.NONE;
            }
        }

        /**
          * Returns the score of the winner or -1 if there is no winner.
          *
          * @return The winner's score.
          */
        private int get_score () {
            if (!is_game_finished ()) {
                return -1;
            }

            if (player_mode == PlayerMode.SINGLE) {
                assert (draws[Player.LEFT] != 0);
                return pairs[Player.LEFT] * 100 / draws[Player.LEFT];
            } else if (get_winner () == Player.LEFT) {
                return pairs[Player.LEFT] * 100 / (setup.length[0] * setup.length[1] / 2);
                //TODO: eliminate redundant code here.
            } else if (get_winner () == Player.RIGHT) {
                return pairs[Player.RIGHT] * 100 / (setup.length[0] * setup.length[1] / 2);
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
