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
      * specified in the given Game model.
      */
    public class Board : Gtk.Grid {
        public Models.Game game;
        private TileView? tile_exposed = null;
        private string[] tile_motif_paths = new string[32];
        private string tile_backside_path;
        public signal void tiles_insensitive ();
        public signal void tiles_sensitive ();

        public Board () {
            Object (
                margin: 6,
                column_spacing: 6,
                row_spacing: 6,
                column_homogeneous: true,
                row_homogeneous: true
            );
        }

        construct {
            game = Models.Game.get_instance ();

            // TODO: Resolve tile scheme paths on Window level, then pass the
            //       appropriate scheme paths to this.
            string[] sys_data_dirs = Environment.get_system_data_dirs ();
            //print (sys_data_dirs[2]); // 3rd one happens to be the right one
            tile_motif_paths = FileUtils.motif_img_paths (sys_data_dirs[2], "default", 32);
            tile_backside_path = Path.build_path (Path.DIR_SEPARATOR_S, sys_data_dirs[2], "/elememory/tile_schemes/default/back.png");

            populate ();

            game.freeze.connect (() => { tiles_insensitive (); });
            game.resume.connect (() => { tiles_sensitive (); });
        }

        /**
          * Populates the grid according to the model data.
          */
        private void populate () {
            for (int y = 0; y < game.setup.length[0]; y++) {
                for (int x = 0; x < game.setup.length[1]; x++) {
                    TileView tile = new TileView (game.setup[y, x], this.tile_motif_paths[game.setup[y, x].motif], this.tile_backside_path);
                    tiles_insensitive.connect (tile.desensitize);
                    tiles_sensitive.connect (tile.sensitize); 
                    tile.show ();
                    attach (tile, x, y, 1, 1);
                }
            }
        }

        /**
          * Deletes all tiles and repopulates the grid.
          */
        public void repopulate () {
            forall ((element) => element.destroy ());
            populate ();
        }
    }
}
