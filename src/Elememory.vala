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

namespace Elememory {
    /**
      * Enumeration of play modes.
      */
    public enum PlayerMode {
        SINGLE,
        DUAL
    }

    /**
      * Enumeration of players. In singleplayer mode Player.LEFT is the player.
      */
    public enum Player {
        LEFT,
        RIGHT;

        public Player other () {
            if (this == LEFT) {
                return RIGHT;
            } else {
                return LEFT;
            }
        }
    }

    /**
      * Iconnames
      */
    public const string ICONNAME_SINGLEPLAYER = "elememory-singleplayer-symbolic";
    public const string ICONNAME_DUALPLAYER = "elememory-dualplayer-symbolic";

    public const string[] ICONNAMES_DUALPLAYER_ACTIVE = {
        "elememory-dualplayer-left-symbolic",
        "elememory-dualplayer-right-symbolic"
    };
    public const string ICONNAME_SINGLEPLAYER_ACTIVE = ICONNAME_SINGLEPLAYER;
}
