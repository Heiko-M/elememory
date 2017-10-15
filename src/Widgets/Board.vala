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
      * The Board provides a visual representation of the setup of tiles
      * specified in the given model of the game.
      */
    public class Board : Gtk.Grid {
        public Models.Game game_model;
        private TileView? tile_exposed = null;
        private string[] tile_motif_paths = new string[32];
        private string tile_backside_path;
        public signal void tiles_insensitive ();
        public signal void tiles_sensitive ();

        public Board () {
            game_model = Models.Game.get_instance ();

            margin = 6;
            column_spacing = 6;
            row_spacing = 6;
            set_column_homogeneous (true);
            set_row_homogeneous (true);

            // TODO: Resolve tile scheme paths on Window level, then pass the
            //       appropriate scheme paths to this.
            string[] sys_data_dirs = Environment.get_system_data_dirs ();
            //print (sys_data_dirs[2]); // 3rd one happens to be the right one
            tile_motif_paths = FileUtils.motif_img_paths (sys_data_dirs[2], "default", 32);
            tile_backside_path = Path.build_path (Path.DIR_SEPARATOR_S, sys_data_dirs[2], "/elememory/tile_schemes/default/back.png");

            populate ();

            show();
        }

        private void populate () {
            /** Populates the grid according to the model data. **/
            for (int y = 0; y < game_model.setup.length[0]; y++) {
                for (int x = 0; x < game_model.setup.length[1]; x++) {
                    TileView tile = new TileView (game_model.setup[y, x], this.tile_motif_paths[game_model.setup[y, x].motif], this.tile_backside_path);
                    tile.exposed.connect ( (emitter) => { on_exposure (emitter); });
                    tiles_insensitive.connect (tile.desensitize);
                    tiles_sensitive.connect (tile.sensitize); 
                    tile.show ();
                    attach(tile, x, y, 1, 1);
                }
            }
        }

        public void repopulate () {
            /** Deletes all tiles and repopulates the grid. **/
            forall ((element) => element.destroy ());
            populate ();
        }

        private void on_exposure (TileView tile) {
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

        /**
          * Checks if two pairs are exposed and consequently either dismisses
          * both or turns them face down again.
         **/
        private void check_pair_found (TileView tile_turned) {
            if (tile_exposed.pairs_with (tile_turned)) {
                tile_exposed.remove_from_tile_field ();
                tile_turned.remove_from_tile_field ();
                game_model.integrate_draw_results (true);
            }
            else {
                tile_exposed.turn_face_down ();
                tile_turned.turn_face_down ();
                game_model.integrate_draw_results (false);
            }

            tile_exposed = null;
        }
    }
}
