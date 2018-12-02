# DIY Split-Flap Display

This project has been forked from [https://github.com/scottbez1/splitflap](https://github.com/scottbez1/splitflap). Most of the design work, electronics and software was designed by ScottBez1 so he deserves a lot of thanks.

I've modified the project to be 3D printable (the original used laser cut MDF), and simplified the readme and wiki somewhat.

My intention is to get build a 12 module panel that is controlled over wifi via a simple iOS app and integrated with Home Assistant.

### Design Highlights ###
* 3D Printed in three simple parts
* Cheap, widely available 28byj-48 stepper motor (less expensive than NEMA-17 motors, and doesn't require an expensive high current stepper driver)
* Inject printable PVC ID cards for flaps, cheap in bulk
* Control up to 12 modules from a single Arduino

Most of the documentation has now been moved to the [Wiki](https://github.com/NilSkilz/splitflap/wiki)


![animated rendering](https://github.com/NilSkilz/splitflap/blob/master/docs/animation.gif)



## Design & Modification Guide ##

### Driver Electronics ###
The driver board is designed to plug into an Arduino like a shield, and can control 4 stepper motors.
Up to 3 driver boards can be chained together, for up to 12 modules controlled by a single Arduino.
The designs for the controller can be found under `electronics/splitflap.pro` (KiCad project).
Nearly everything is a through-hole component rather than SMD, so it's very easy to hand-solder.

The driver uses 2 MIC5842 low-side shift-register drivers, with built-in transient-suppression diodes, to control the motors, and a 74HC165 shift register to read from 4 hall-effect magnetic home position sensors.
There are optional WS2812B RGB LEDs which can be used to indicate the status of each of the 4 channels.

<a href="https://s3.amazonaws.com/splitflap-travis/branches/master/schematic.pdf">
<img height="320" src="https://s3.amazonaws.com/splitflap-travis/branches/master/schematic.png"/>
</a>

The PCB layout is 10cm x 5cm which makes it fairly cheap to produce using a low-cost PCB manufacturer (e.g. Seeed Studio).

<a href="https://s3.amazonaws.com/splitflap-travis/branches/master/pcb_raster.png">
<img width="640" src="https://s3.amazonaws.com/splitflap-travis/branches/master/pcb_raster.png"/>
</a>

Each module also needs a hall-effect sensor board, with an AH3391Q (or similar) sensor and connector.
These boards are small (about 16mm x 16 mm) and are available on a second PCB design that's panelized.
The panelization is configurable (see [generate_panelize_config.py](https://github.com/scottbez1/splitflap/blob/master/electronics/generate_panelize_config.py))
and is optimized for production at SeeedStudio.

<a href="https://s3.amazonaws.com/splitflap-travis/branches/master/sensor_pcb_raster.png">
<img width="640" src="https://s3.amazonaws.com/splitflap-travis/branches/master/sensor_pcb_raster.png"/>
</a>

##### Latest PCB Renderings #####
These are automatically updated on every commit with the latest rendering from the `master` branch.
See this blog post for more details on how that works: [Automated KiCad, OpenSCAD rendering using Travis CI](http://scottbezek.blogspot.com/2016/04/automated-kicad-openscad-rendering.html).

For Stable PCB designs, make sure to check out the [Releases](https://github.com/scottbez1/splitflap/releases) instead of using these experimental files.

Latest (experimental!) Controller PCB Gerbers: [zip](https://s3.amazonaws.com/splitflap-travis/branches/master/pcb_gerber.zip)

Latest (experimental!) Controller PCB Packet: [pdf](https://s3.amazonaws.com/splitflap-travis/branches/master/pcb_packet.pdf)

Latest (experimental!) Sensor PCB Gerbers: [zip](https://s3.amazonaws.com/splitflap-travis/branches/master/sensor_pcb_gerber.zip)

Latest (experimental!) Sensor PCB Packet: [pdf](https://s3.amazonaws.com/splitflap-travis/branches/master/sensor_pcb_packet.pdf)

Latest (experimental!) rough bill of materials: [csv](https://s3.amazonaws.com/splitflap-travis/branches/master/bom.csv)

#### Rendering ####
The PCB layout can be rendered to an svg or png (seen above) by running `electronics/generate_svg.py file.kicad_pcb`.
This uses KiCad's [python scripting API](https://github.com/blairbonnett-mirrors/kicad/blob/master/demos/python_scripts_examples/plot_board.py)
to render several layers to individual svg files, manipulates them to apply color and opacity settings, and then merges them to a single svg.
For additional details, see this blog post: [Scripting KiCad Pcbnew exports](http://scottbezek.blogspot.com/2016/04/scripting-kicad-pcbnew-exports.html).

For reviewing the design, a pdf packet with copper, silkscreen, and drill info can be produced by running `electronics/generate_pdf.py file.kicad_pcb`.

Gerber files for fabrication can be exported by running `electronics/generate_gerber.py file.kicad_pcb`.
This generates gerber files and an Excellon drill file with Seeed Studio's [naming conventions](http://support.seeedstudio.com/knowledgebase/articles/422482-fusion-pcb-order-submission-guidelines) and produces a `.zip` which can be sent for fabrication.

EESchema isn't easily scriptable, so to export the schematic and bill of materials `electronics/scripts/export_schematic.py` and `export_bom.py` start an X Virtual Frame Buffer (Xvfb) and open the `eeschema` GUI within that virtual display, and then send a series of hardcoded key presses via `xdotool` to interact with the GUI and click through the dialogs. This is very fragile but seems to work ok for now. For additional details, see this blog post: [Using UI automation to export KiCad schematics](http://scottbezek.blogspot.com/2016/04/automated-kicad-schematic-export.html).

### Driver Firmware ###
The driver firmware is written using Arduino and is available at `arduino/splitflap/splitflap.ino`.

The firmware currently runs a basic closed-loop controller that accepts letters over USB serial and drives the stepper motors using a precomputed acceleration ramp for smooth control. The firmware automatically calibrates the spool position at startup, using the hall-effect magnetic sensor, and will automatically recalibrate itself if it ever detects that the spool position has gotten out of sync. If a commanded rotation is expected to bring the spool past the "home" position, it will confirm that the sensor is triggered neither too early nor too late; otherwise it will search for the "home" position to get in sync before continuing to the desired letter.

### Computer Control Software ###
The display can be controlled by a computer connected to the Arduino over USB serial. A basic python library for interfacing with the Arduino and a demo application that displays random words can be found in the [software](https://github.com/scottbez1/splitflap/tree/master/software) directory.

Commands to the display are sent in a basic plain-text format, and messages _from_ the display are single-line JSON objects, always with a `type` entry describing which type of message it is.

When the Arduino starts up, it sends an initialization message that looks like:
```
{"type":"init", "num_modules":4}
```

The display will automatically calibrate all modules, and when complete it will send a status update message:
```
{
    "type":"status",
    "modules":[
        {"state":"normal", "flap":" ", "count_missed_home":0, "count_unexpected_home":0},
        {"state":"sensor_error", "flap":"e", "count_missed_home":0, "count_unexpected_home":0},
        {"state":"sensor_error", "flap":"e", "count_missed_home":0, "count_unexpected_home":0},
        {"state":"sensor_error", "flap":"e", "count_missed_home":0, "count_unexpected_home":0}
    ]
}
```
(Note: this is sent as a single line, but has been reformatted for readability above)

In this case the Arduino was programmed to support 4 modules, but only 1 module is connected, so the other 3 end up in `"sensor_error"` state. More on status updates below.

At this point you can command the display to show some letters. To do this, send a message to the Arduino that looks like this:
```
=hiya\n
```
The `=` indicates a movement command, followed by any number of letters, followed by a newline. You don't have to send the exact number of modules - if you send fewer letters than modules, only the first N modules will be updated and the remainder won't move. For instance, you could send `=a\n` as shorthand to only set the first module (even if there are 12 modules connected). Any letters that can't be displayed are considered a no-op for that module.

Whenever ALL modules come to a stop, the Arduino will send a status update message (just like the one following initialization, shown above). Here's what the fields mean in each module's status entry:
- **state** - `normal` indicates it's working as intended, `sensor_error` indicates the module can't find the home position and has given up trying (it will no longer respond to movement commands until told to recalibrate - see below). `panic` indicates the firmware detected a programming bug and has gone into failsafe mode (it will no longer respond to movement commands and requires a full reset of the Arduino to recover - should never happen).
- **flap** - which letter is shown by this module
- **count\_missed\_home** - number of times the module expected to pass the home position but failed to detect it. If this is non-zero, it indicates either a flaky sensor or that the motor may have jammed up. The module automatically attempts to recalibrate whenever it misses the home position, so if this number is non-zero and the module is still in the `normal` state, it means the module successfully recovered from the issue(s). However, if this number keeps going up over continued use, it may indicate a recurrent transient issue that warrants investigation.
- **count\_unexpected\_home** - number of times the module detected the home position when it wasn't supposed to. This is rare, but would indicate a flaky/broken sensor that is tripping at the wrong time. Just like with missed home errors, unexpected home errors will cause the module to attempt to recalibrate itself.

If you want to make all modules recalibrate their home position, send a single @ symbol (no newline follows):
```
@
```
This recalibrates all modules, including any that were in the `sensor_error` state; if recalibration succeeds they will return to the `normal` state and start responding to movement commands again.


## License ##
I'd love to hear your thoughts and questions about this project, and happy to incorporate any feedback you might have into these designs! Please feel free (and encouraged) to [open GitHub issues](https://github.com/scottbez1/splitflap/issues/new), email me directly, reach out [on Twitter](https://twitter.com/scottbez1), and [get involved](https://github.com/scottbez1/splitflap/pulls) in the open source development and let's keep chatting and building together!

The vast majority of this project is licensed under Apache v2 (see [LICENSE.txt](LICENSE.txt) for full details).

    Copyright 2015-2018 Scott Bezek and the splitflap contributors

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
