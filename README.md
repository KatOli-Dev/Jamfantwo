# Jamfantwo (Jfw)

A medieval fantasy world-building project. It is completely AI generated.

## Quick Start

```bash
bundle install
./scripts/serve.sh
```

The server binds to port 4000 on every network interface, so it's reachable at
`http://localhost:4000` and at this machine's address on the local network.
Generated links are root-relative, so they work no matter which address you use to reach it.

To bake in an absolute URL instead (e.g. for a tunnel/reverse-proxy address, or to test the
production-style feed/sitemap output):

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
