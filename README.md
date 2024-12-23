# Script to run Undercroft on Linux

You will need nix (with flakes enabled), then do:

```shell
$ nix run github:MalteT/undercroft-flake
```

```
Usage: undercroft-run [-f|--filter <arg>] [-r|--fps <arg>] [--(no-)hud] [-h|--help] [-v|--version]
	-f, --filter: Sets the scaling filter method (default: 'nis')
	-r, --fps: Sets the fps limit (default: '60')
	--hud, --no-hud: Enables the mangohud overlay (off by default)
	-h, --help: Prints help
	-v, --version: Prints version
```

Original: [Link](https://www.rakeingrass.com/games/undercroft/help.php)
