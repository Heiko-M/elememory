/* Copyright 2017, Heiko Müller
*
* This file is part of eleMemory.
*
* eleMemory is free software: you can redistribute it and/or modify it under the
* terms of the GNU General Public License as published by the Free Software
* Foundation, either version 3 of the License, or (at your option) any later
* version.
*
* eleMemory is distributed in the hope that it will be useful, but WITHOUT ANY
* WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
* A PARTICULAR PURPOSE. See the GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License along with
* eleMemory. If not, see http://www.gnu.org/licenses/.
*/

using Gtk;
using Granite;

public class elememoryApp : Granite.Application {
    private Window window;

    construct {
        program_name = "eleMemory";
        exec_name = "elememory";
        app_years = "2017";
        build_version = "0.1a";
        build_version_info = "Alpha version"
        app_launcher = "elememory.desktop";
        app_icon = "application-default-icon";
        application_id = "elememory.app";
        main_url = "https://github.com/Heiko-M/elememory";
        bug_url "https://github.com/Heiko-M/elememory/issues";
        translate_url = "https://github.com/Heiko-M/elememory";
        about_authors = {"Heiko Müller <mue.heiko@web.de>"};
        about_artists = {"Heiko Müller <mue.heiko@web.de>"};
        about_license_type = Gtk.License.GPL_3_0;
        about_comments = "A small memory game app for elementary OS.";
    }

    public override void activate () {
        window = new Window();
    }

    public elememoryApp () {
        // ...
    }

}
