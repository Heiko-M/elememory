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

            populate ();
        }

        /**
          * Populates the grid according to the model data.
          */
        private void populate () {
            for (int y = 0; y < game.setup.length[0]; y++) {
                for (int x = 0; x < game.setup.length[1]; x++) {
                    TileView tile = new TileView (game.setup[y, x], "default", game.setup[y, x].motif);
                    game.freeze.connect (tile.desensitize);
                    game.resume.connect (tile.sensitize); 
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
