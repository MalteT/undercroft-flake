#!/usr/bin/env bash

# ARG_OPTIONAL_SINGLE([filter], [f], [Sets the scaling filter method], [nis])
# ARG_OPTIONAL_SINGLE([fps], [r], [Sets the fps limit], [60])
# ARG_OPTIONAL_BOOLEAN([hud], , [Enables the mangohud overlay])
# ARG_HELP([Script to run Undercroft on Linux])
# ARG_VERSION([echo "v0.1.0"])
# ARGBASH_GO

# [ <-- needed because of Argbash

get_hud_flag() {
	[ "${_arg_hud}" = "on" ] && echo "--mangoapp"
}

# Create writable saves directory in home if it doesn't exist
mkdir -p "$XDG_DATA_HOME/Undercroft/saves"

# Create temporary directories for union mount
MOUNT_DIR=$(mktemp -d)

# Setup unionfs
unionfs -o cow "$XDG_DATA_HOME/Undercroft=RW:@SRC@=RO" "$MOUNT_DIR"

# Run the game
pushd "$MOUNT_DIR"
export WINEPREFIX="$MOUNT_DIR/wine"
wineboot -u
# shellcheck disable=SC2046
gamescope $(get_hud_flag) \
	--filter "${_arg_filter}" \
	--adaptive-sync \
	--nested-unfocused-refresh 1 \
	-- \
	strangle "${_arg_fps}" wine Undercroft.exe
popd

# Clean up - fusermount handles unmounting for user
echo "Wait 5 seconds, before cleanup.."
sleep 5
umount "$MOUNT_DIR"
rmdir "$MOUNT_DIR"

# ] <-- needed because of Argbash
