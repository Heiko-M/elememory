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
    public class App : Granite.Application {
        private Window window;

        construct {
            program_name = "eleMemory";
            exec_name = "elememory";
            app_years = "2017";
            build_version = "0.1a";
            build_version_info = "Alpha version";
            app_launcher = "elememory.desktop";
            app_icon = "application-default-icon";
            application_id = "elememory.app";
            main_url = "https://github.com/Heiko-M/elememory";
            bug_url = "https://github.com/Heiko-M/elememory/issues";
            translate_url = "https://github.com/Heiko-M/elememory";
            about_authors = {"Heiko Müller <mue.heiko@web.de>"};
            about_artists = {"Heiko Müller <mue.heiko@web.de>"};
            about_license_type = Gtk.License.GPL_3_0;
            about_comments = "A small memory game app for elementary OS.";
        }

        public override void activate () {
            window = new Window();
        }

        public App () {
            //TODO: GObject-style construction á la Daniel Foré's Harvey 
        }

    }
}
