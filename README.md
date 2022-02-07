## tools.testest

Vocabulary to test Factor code on Codewars.

See [documentation](testest.md)

### Example testest setup

See [example](./example).

### Docker image

A Docker image to run Factor with tools.testest is available on [GHCR](https://github.com/codewars/testest/pkgs/container/factor).

```bash
$ docker pull ghcr.io/codewars/factor:latest
```

#### Building

The image can be built from this repository after cloning:

```bash
$ docker build -t ghcr.io/codewars/factor:latest .
```

Or using GitHub repository as a build context:
```bash
$ docker build -t ghcr.io/codewars/factor:latest https://github.com/codewars/testest.git
```

#### Usage

[`bin/run`](./bin/run) can be used to run Factor kata in the current directory with the latest image.

```bash
$ cd example
$ ../bin/run
```

### Acknowledgements

Authored by [@nomennescio](https://github.com/nomennescio).
