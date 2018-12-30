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


### Cost Breakdown ###

Requirements:
3D Printer (I picked mine up for less than $200)
Inkjet Printer capable of printing ID cards. See [here](https://brainstormidsupply.com/inkjet-id-cards/kits-cards-trays) for a list of compatible printers
Inkjet Pinter Tray - around $20
Soldering Iron, Files, cutting knife

| Item        | Quantity           | Total Price  |
| ------------- |:-------------:| -----:|
| 3D printed parts     | 12 | $30 |
| 28BYJ-48 motor [link](https://www.aliexpress.com/item/10PCS-LOT-28BYJ-48-Lead-25cm-Stepper-Motor-DC-5V-4-Phase-Step-Motor-Reduction-Newest/32602045093.html?spm=a2g0s.9042311.0.0.37e84c4dhdhRja)    | 12      |   $17 |
| ID Cards [link](https://www.amazon.co.uk/gp/product/B07C3LLKK9/ref=oh_aui_detailpage_o02_s00?ie=UTF8&psc=1) | 250      |    $53 |
| Printer ink (Optional) | 4      |    $70 | (only needed if printing white text on black background)
| PCB Printing | 1      |    $37 |
| Electronic Components |      |    ~$75 | (Could be cheaper ordering certain things from China)
| 3 pin Servo Extension | 12     |    ~$15 |
| 12v 8a power supply | 12     |    ~$19 |
| ESP8266 module | 1     |    ~$6 |
| Arduino Uno | 1     |    ~$35 |
| ID Card Punch [link](https://www.amazon.co.uk/gp/product/B01C3ZXAQ0/ref=oh_aui_detailpage_o04_s00?ie=UTF8&psc=1)| 1     |    ~$12 |
| Total | | $369 |





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
