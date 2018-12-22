# Tacticians Online - Client
This is the code for the front-end of Tacticians Online, an online
multiplayer turn-based strategy game.

## Getting Started

### Prerequisites
* Elm 0.19
* GNU make
* Sass
* Tacticians Online - Data
* m4

### Installing
1. Go into the directory in which this repository was cloned.
2. Set the DATA\_DIR variable in `./Makefile` to match the "Tacticians Online -
   Data" directory.
3. Copy `./conf/constants.conf.example` to `./conf/constants.conf`, edit the new
   file to your preference.
4. Run `$ make`. Some Elm libraries will require confirmation before download.
5. With a web browser, open the `./www/index.html` page. You're done.

## Screenshot
![Screenshot of a battle](https://noot-noot.org/to-2018-09-07.png)

## License
Apache License 2.0 (see `./LICENSE`)
