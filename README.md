# LIFX Ping

This script lets you 'ping' LIFX devices, even when the device in question is only accesible via the mesh.

It abuses the protocol in ways it was never intended for, so **USE AT YOUR OWN RISK**. Also it will probably break in the near future.

## Requirements

* Ruby 2.1.1
* Bundler

## Usage

```shell
git clone https://github.com/chendo/lifx-ping.git
cd lifx-ping
bundle
bundle exec ruby lifx-ping.rb
```

## License

MIT.

The MIT License (MIT)

Copyright (c) 2014 Jack "chendo" Chen

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
