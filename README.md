After spending too much time faffing around trying to use existing tools to generate high quality console screencasts I came across this solution:

Use [`termtosvg`](https://github.com/nbedos/termtosvg).  It's the only thing I've found that compiles and still works.  [`ttystudio`](https://github.com/chjj/ttystudio/) was fantastic but no longer appears to work with any permutation of node and npm I've managed to find.  ascii "enema" renders things on their servers, yuck.  Meanwhile [`termtosvg`](https://github.com/nbedos/termtosvg) creates beautiful animated SVGs with no external dependencies.  Unfortunately it is next to impossible to easily render animated SVGs as movies. Alternatively [`termtosvg`](https://github.com/nbedos/termtosvg) can render individual SVG frames.

Rendering a collection of still SVG frames to movies or raster image stills is its own bizarre problem.  ImageMagick falls completely on its face.  Cairo can do decent job if you want to write tooling for it.  Inkscape appears to do the best job for me.  But with some fonts it seems to get the text alignment all wrong.  So, for each still frame adjust each text node to shift the baseline to the approximately correct position.  Then render everything with a high enough pixel density to create a clear, crisp movie.  And now we have a ton of still images to be rendered…

… by ffmpeg.

This is the second time in the past few years I've gotten stuck trying to solve this same exact problem.  So everything I've written here is more for my own remembrance than public consumption.  But with absolutely no warranty, implied or otherwise, hopefully this is useful for someone else.

Dependencies:

* [`termtosvg`](https://github.com/nbedos/termtosvg)
* [Inkscape](https://inkscape.org/) –  If it's not in your path and you're not using macOS set the `INKSCAPE` variable to your path.
* [`ffmpeg`](https://ffmpeg.org/)
* [Ruby](https://www.ruby-lang.org/en/) – Nokogiri is required and I'm too lazy to setup bundler.  So install it.
* [Fira Code](https://github.com/tonsky/FiraCode) – There are other monospaced fonts that should work but the baseline fudge factor will almost certainly have to be adjusted.

The following variables can be set to adjust things to your preferences:

* `INK_DPI` – default is 300.  Specifies the resolution which Inkscape will render PNGs.  Ensure you pick a value that gives you an even number of rows otherwise `ffmpeg` will not be able to produce yuv420p output.  You want yuv420p output because that's what nearly everything out there is compatible with.
* `FF_IN_FRAMERATE` – default is 8
* `FF_ENCODER` – default is libx264
* `FF_PIXFMT` - default is yuv420p, you almost certainly don't want to change this

To get a screencast run something along the lines of:

```bash
termtosvg record [NAME OF YOUR SCREEN CAST GOES HERE].asciicast -c 'bash -c "cd && exec bash -l"'
```

Now just run: `./record-to-mp4.sh [NAME OF YOUR SCREEN CAST GOES HERE]` and it will fire up a `termtosvg` session, and hopefully leave an high quality mp4 in its wake.  There's minimal error checking and sanitization in all parts of this so use with extreme caution.
