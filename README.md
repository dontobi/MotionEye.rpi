[![Source](https://img.shields.io/badge/source-github-blue)](https://github.com/dontobi/MotionEye.rpi)
[![Github Issues](https://img.shields.io/github/issues/dontobi/MotionEye.rpi)](https://github.com/dontobi/MotionEye.rpi/issues)
[![Docker Image Size (tag)](https://img.shields.io/docker/image-size/dontobi/motioneye.rpi/latest)](https://hub.docker.com/repository/docker/dontobi/motioneye.rpi)
[![Docker Pulls](https://img.shields.io/docker/pulls/dontobi/motioneye.rpi)](https://hub.docker.com/repository/docker/dontobi/motioneye.rpi)
[![License](https://img.shields.io/github/license/dontobi/motioneye.rpi)](https://github.com/dontobi/motioneye.rpi/blob/main/LICENSE.md)

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
This project is licensed under the MIT License — see [LICENSE](LICENSE) for details.

Copyright (c) 2021-2026 Tobias 'dontobi' Schug
