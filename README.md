# motioneye.rpi
MotionEye Docker Container for Raspberry Pi

## Information
motionEye is a web-based frontend for `motion <https://motion-project.github.io>`_. Check out the `wiki <https://github.com/ccrisan/motioneye/wiki>`_ for more details.

## Running from command line
For taking a first look at the docker container it would be enough to simply run the following basic docker run command:
```
docker run -d --name motioneye \
    -p 8765:8765 \
    -e TZ="Europe/Berlin" \
    -v [motioneye-config]:/etc/motioneye \
    -v [motioneye-data]:/var/lib/motioneye \
    -v /etc/localtime:/etc/localtime:ro \
    -v /etc/timezone:/etc/timezone:ro \
    -e UID=1000 \
    -e GID=1000 \
    --restart=always \
    dontobi/motioneye.rpi:latest
```

## License
MIT License

Copyright (c) 2022 [Tobias 'dontobi' S.]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
