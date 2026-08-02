# Jamfantwo (Jfw)

A medieval fantasy world-building project. It is completely AI generated.

## Quick Start

```bash
bundle install
./scripts/serve.sh
```

The server is available on the local network at `http://<this-machine-ip>:4000`.
To choose the address used in generated links explicitly:

```bash
JEKYLL_PUBLIC_URL=http://192.168.1.10:4000 ./scripts/serve.sh
```

## Validation

A custom content validator checks source files for basic compliance:

```bash
ruby scripts/validate_content.rb
```

Runs against source files only; does not require a Jekyll build.

## License

This project is dedicated to the public domain under the [Unlicense](https://unlicense.org/).
