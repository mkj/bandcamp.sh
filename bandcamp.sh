#!/bin/sh

if [ -e "$1" ]; then
    fn="$1"
else
    fn="$(mktemp ~/tmp/bc.XXXXXXXXXX.zip)"
    curl $1 > $fn || exit 1
fi

fn="$(realpath "$fn")"

z1="$(zipinfo -1 $fn | grep -v jpg|head -1)"
test -n "$z1" || exit 1
artist="$(echo $z1 | cut -d - -f 1 | sed "s/^ *//;s/ *$//;s@[;/]@-@g")"
album="$(echo $z1 | cut -d - -f 2  | sed "s/^ *//;s/ *$//;s@[;/]@-@g")"

test -n "$artist" || exit 1
test -n "$album" || exit 1

dest="/data/share/music/$artist/$album"
echo "Putting at $dest"
mkdir -p "$dest"
(cd "$dest"; unzip "$fn")
chmod -R a+rX "$dest/.."
