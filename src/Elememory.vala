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
            switch (this) {
                case LEFT:
                    return RIGHT;
                case RIGHT:
                    return LEFT;
                default:
                    assert_not_reached ();
            }
        }

        public string to_string () {
            switch (this) {
                case LEFT:
                    return "Player to the left";
                case RIGHT:
                    return "Player to the right";
                default:
                    assert_not_reached ();
            }
        }
    }

    /**
      * Board sizes
      */
    public const int[] BOARD_WIDTH = {6, 9};
    public const int[] BOARD_HEIGHT = {4, 6};

    /**
      * Resource names of icons
      */
    public const string RESOURCE_BASE = "/com/github/heiko-m/elememory";
    public const string RESOURCE_ICONS = RESOURCE_BASE + "/icons";

    public const string ICON_SINGLEPLAYER = RESOURCE_ICONS + "/singleplayer-symbolic";
    public const string ICON_DUALPLAYER = RESOURCE_ICONS + "/dualplayer-symbolic";

    public const string[] ICONS_DUALPLAYER_ACTIVE = {
        RESOURCE_ICONS + "/dualplayer-left-symbolic",
        RESOURCE_ICONS + "/dualplayer-right-symbolic"
    };
    public const string ICON_SINGLEPLAYER_ACTIVE = ICON_SINGLEPLAYER;

    public const string ICON_HIGHSCORE = RESOURCE_ICONS + "/highscore-symbolic";
    public const string ICON_BOARD = RESOURCE_ICONS + "/board-symbolic";
}
