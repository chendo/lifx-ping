# LIFX Ping

This script lets you 'ping' LIFX devices, even when the device in question is only accesible via the mesh.

It abuses the protocol in ways it was never intended for, so **USE AT YOUR OWN RISK**. Also it will probably break in the near future.

## Requirements

* Ruby 2.1.1
* Bundler

## Usage

```shell
$ git clone https://github.com/chendo/lifx-ping.git
$ cd lifx-ping
$ bundle
$ bundle exec ruby lifx-ping.rb
Scanning for devices...
1. d073d5xxxxxx: Foo
2. d073d5xxxxxx: Bar
3. d073d5xxxxxx: Baz
4. refresh
Select a device to ping:
1
PING d073d5xxxxxx:
Response: seq=0 time=20.934 ms
Response: seq=1 time=23.191 ms
Response: seq=2 time=22.735 ms
Response: seq=3 time=38.553 ms
Response: seq=4 time=15.276 ms
Response: seq=5 time=14.653 ms
Response: seq=6 time=12.816 ms
^C
--- d073d5xxxxxx ping statistics ---
7 messages transmitted, 0 messages received, 0.0% message loss
round trip min/avg/max/std-dev 12.816/21.165/38.553/8.715 ms
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
