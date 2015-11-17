# DIY Split-Flap Display

This is a work in progress DIY [split-flap display](https://en.wikipedia.org/wiki/Split-flap_display).
Initial prototype: [video](https://www.youtube.com/watch?v=wuriphgWN40).

![animated rendering](renders/animation.gif)

The goal is to make a low-cost display that's easy to fabricate at home (e.g. custom materials can be ordered from Ponoko or similar, and other hardware is generally available).

The 3d model is built using OpenSCAD in `splitflap.scad`

### Design Highlights ###
* laser cut enclosure and mechanisms from a single material
* cheap, widely available 28byj-48 stepper motor (less expensive than NEMA-17 motors, and doesn't require an expensive high current stepper driver)
* CR80 PVC cards for flaps, cheap in bulk
* store-bought vinyl stickers for flap letters

![2d laser cut rendering](renders/raster.png)

### Cost Breakdown ###
* $5/2 units -- MDF 3.2mm P2 [on Ponoko](http://www.ponoko.com/make-and-sell/show-material/64-mdf-natural)
* $20 -- laser cutting on Ponoko (can save ~$0.70 by skipping etched label)
* $7 -- shipping from Ponoko
* ~$2 -- 28byj-48 motor
* ~$5/5 units -- 5mmx100mm rod
* $6.39/2 units -- vinyl letter stickers (minimum letter duplication per pack is 2) [on Amazon](http://www.amazon.com/Duro-Decal-Permanent-Adhesive-Letters/dp/B0027601CM)
* $12/5 units or $36/25 units -- CR80 cards (each CR80 card becomes 2 flaps, each unit requires 40 flaps) on [Amazon](http://www.amazon.com/Plastic-printers-DataCard-Evolis-Magicard/dp/B007M413BC) or [Amazon](http://www.amazon.com/White-Blank-CR80-020-Graphic-Quality/dp/B007PKD6MW)
* ? -- M4x12mm button head bolts (e.g. ISO 7380)
* ? -- M4 nuts

TBD:
* $1.05 -- QRE1113 reflectance sensor [on digikey](http://www.digikey.com/product-detail/en/QRE1113GR/QRE1113GRCT-ND/965713)
* $14/10 units -- PCB for reflectance sensor [on seeedstudio](http://www.seeedstudio.com/service/index.php?r=pcb)

Tools:
* $9.17 -- badge slot punch (for cutting notches out of cards to make flaps) [on Amazon](http://www.amazon.com/gp/product/B009YDRRB4)

## Build Your Own: Instructions ##
Coming soon! This design is still being prototyped...

## Design & Modification Guide ##

### 3D Design ###
The main design file is `splitflap.scad`

You'll need a recent version of OpenSCAD (at least 2015-03), which needs to be installed through the PPA:
`sudo add-apt-repository ppa:openscad/releases`

Note that while the design is parameterized and many values may be tweaked, there is currently no error checking for invalid parameters or combinations of parameters. Please take care to validate the design if you change any parameters. For instance, while most of the design would correctly adjust to a tweaked material `thickness` value, the `thickness` plays a role in the alignment of the gears, so changing this value may result in misaligned gears or issues with the motor shaft length.

### Rendering ###
#### Laser-cutter vector files ####
The design can be rendered to 2d for laser cutting by running `generate_2d.py`, which outputs to `build/laser_parts/combined.svg`

Internally, the design uses a `projection_renderer` module (`projection_renderer.scad`), which takes a list of child elements to render, and depending on the `render_index` renders a single child at a time. It also _adds_ material to each shape to account for the kerf that will be cut away by the laser.

The `generate_2d.py` script interacts with the `projection_renderer` module by first using it to determine the number of subcomponents to render, then runs OpenSCAD to export each component to an SVG file. It does some post-processing on the SVG output (notably adds "mm" to the document dimensions), and then combines all components into the single `combined.svg` output.

Once the `combined.svg` file is generated, you'll want to remove a couple redundant cut lines that are shared by multiple adjacent pieces, to save time/cost when cutting. In Inkscape, select the "Edit paths by nodes" tool and select an edge to delete - the endpoints should turn blue. Then click "Delete segment between two non-endpoint nodes", and repeat this for all other redundant cut lines.

#### Animated gif ####
The design can be rendered to a rotating 3d animated gif (seen above) by running `generate_gif.py`, which outputs to `build/animation/animation.gif`

The `generate_gif.py` script runs multiple OpenSCAD instances in parallel to render the design from 360 degrees to individual png frames, which are then combined into the final gif animation. As part of building the animation, `generate_gif.py` renders the design with multiple configurations (opaque enclosure, see-through enclosure, no-enclosure and no flaps) by setting the `render_enclosure` and `render_flaps` variables.

### TODO ###
* Enclosure
    * mounting holes?
    * interlocking mechanism?
* Driver
    * need some kind of home-position sensor
        * IR Reflectance sensor near spool? QRE1113?

