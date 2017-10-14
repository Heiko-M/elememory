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

namespace Elememory.FileUtils {
    /** Provides functions to deal with filepaths. **/

        // TODO: I probably need to write a function that localizes my image files by checking all the system_data_dirs returned...
        //string[] sys_data_dirs = Environment.get_system_data_dirs ();
        //print (sys_data_dirs[2]); // the third one happens to be the right one
        //tile_backside_path = Path.build_path (Path.DIR_SEPARATOR_S, sys_data_dirs[2], "/elememory/tile_schemes/default/back.png");

    public string[] motif_img_paths (string sys_data_dir, string motif_set, int set_size) {
        /** Returns an array of strings of file paths to the motif images. **/
        string[] paths = new string[32];

        // TODO: Shuffle images within this function (only relevant later when playing field size is adjustable.
        for (int i = 0; i < set_size; i++) {
            string img_path = Path.build_path (Path.DIR_SEPARATOR_S, sys_data_dir, "/elememory/tile_schemes/", motif_set, @"$i.png");
            paths[i] = img_path;
        }

        return paths;
    }

    public string backside_img_path (string motif_set) {
        /** Returns the image path of the tile backside image. **/
        // XXX: DEPRECATED due to installation of images in subfolder of system_data_dir...
        string app_base_path = File.new_for_path(Environment.get_current_dir()).get_parent().get_path();
        string images_path = Path.build_path (Path.DIR_SEPARATOR_S, app_base_path, "images/tile_schemes", motif_set);
        string img_path = Path.build_path (Path.DIR_SEPARATOR_S, images_path, "back.png");
        return img_path;
    }

}
