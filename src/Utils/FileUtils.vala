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

/**
  * Provides functions for file I/O.
  */
namespace Elememory.FileUtils {

        // TODO: I probably need to write a function that localizes my image files by checking all the system_data_dirs returned...
        //string[] sys_data_dirs = Environment.get_system_data_dirs ();
        //print (sys_data_dirs[2]); // the third one happens to be the right one
        //tile_backside_path = Path.build_path (Path.DIR_SEPARATOR_S, sys_data_dirs[2], "/elememory/tile_schemes/default/back.png");

    /**
      * Returns an array of strings of file paths to the motif images.
      */
    public string[] motif_img_paths (string sys_data_dir, string motif_set, int set_size) {
        string[] paths = new string[32];

        // TODO: Shuffle images within this function.
        for (int i = 0; i < set_size; i++) {
            string img_path = Path.build_path (Path.DIR_SEPARATOR_S, sys_data_dir, "/com.github.heiko-m.elememory/tile_schemes/", motif_set, @"$i.png");
            paths[i] = img_path;
        }

        return paths;
    }

    /**
      * Fills the given array of HighscoreEntry structs with the objects found
      * in the json file filename in the users cache directory.
      *
      * @param filename Name of the json file.
      * @param entries Array of HighscoreEntry structs.
      */
    public void read_highscore_from_file (string filename, ref Models.HighscoreEntry[] entries) {
        var filepath = Environment.get_user_cache_dir () + "/com.github.heiko-m.elememory/" + filename;
        var file = File.new_for_path (filepath);
        var json_string = "";
        
        try {
            string line;
            var dis = new DataInputStream (file.read ());

            while ((line = dis.read_line (null)) != null) {
                json_string += line;
            }

            var parser = new Json.Parser ();
            parser.load_from_data (json_string);

            var root = parser.get_root ();
            var array = root.get_array ();
            int index = 0;
            foreach (var item in array.get_elements ()) {
                var node = item.get_object ();
                string name = node.get_string_member ("name");
                int score = int.parse (node.get_string_member ("score"));
                entries[index++] = Models.HighscoreEntry (name, score);
                if (index >= entries.length) {
                    break;
                }
            }
        } catch (Error e) {
            warning ("Could not read highscore from file: %s\n%s\n", filepath, e.message);
        }
    }

    /**
      * Writes all HighscoreEntries which name is not null to the given filename
      * in the users cache directory in json format.
      *
      * @param filename Name of the json file.
      * @param entries Array of HighscoreEntry structs.
      */
    public void write_highscore_to_file (string filename, Models.HighscoreEntry[] entries) {
        var app_dir = Environment.get_user_cache_dir () + "/com.github.heiko-m.elememory";
        var filepath = app_dir + "/" + filename;

        var valid_entries = new Models.HighscoreEntry[1];
        for (int i = 0; i < entries.length; i++) {
            if (entries[i].name == null) {
                if (i == 0) {
                    return;
                } else {
                    valid_entries = entries[0:i];
                    break;
                }
            }
            valid_entries = entries;
        }

        var json_string = array_to_json (valid_entries);
        var dir = File.new_for_path (app_dir);
        var file = File.new_for_path (filepath);

        try {
            if (!dir.query_exists ()) {
                dir.make_directory ();
            }

            if (file.query_exists ()) {
                file.delete ();
            }

            var file_stream = file.create (FileCreateFlags.REPLACE_DESTINATION);
            var data_stream = new DataOutputStream (file_stream);
            data_stream.put_string (json_string);
        } catch (Error e) {
            warning ("Could not save highscore to file: %s\n%s\n", filepath, e.message);
        }
    }

    /**
      * Returns the array of HighscoreEntry structs as a json string.
      *
      * @param entries Array of valid HighscoreEntry structs.
      */
    private string array_to_json (Models.HighscoreEntry[] entries) {
        string[] json_entries = new string[entries.length];
        int index = 0;

        foreach (Models.HighscoreEntry entry in entries) {
            json_entries[index++] = "{\n\t\"name\":\"%s\",\n\t\"score\":\"%d\"\n}".printf (entry.name, entry.score);
        }

        return "[%s]".printf (string.joinv (",\n", json_entries));
    }

    /**
      * @deprecated
      * Returns the image path of the tile backside image.
      */
    public string backside_img_path (string motif_set) {
        // XXX: DEPRECATED due to installation of images in subfolder of system_data_dir...
        string app_base_path = File.new_for_path (Environment.get_current_dir ()).get_parent ().get_path ();
        string images_path = Path.build_path (Path.DIR_SEPARATOR_S, app_base_path, "images/tile_schemes", motif_set);
        string img_path = Path.build_path (Path.DIR_SEPARATOR_S, images_path, "back.png");
        return img_path;
    }

}
