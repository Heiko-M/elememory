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

        public App () {
            Object (application_id: "com.github.heiko-m.elememory",
                    flags: ApplicationFlags.FLAGS_NONE);
        }

        public override void activate () {
            window = new Window();
        }

        public static int main (string[] args) {
            Gtk.init (ref args);
            var app = new Elememory.App ();
            return app.run (args);
        }
    }
}
