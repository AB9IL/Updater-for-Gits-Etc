#!/bin/bash

# Copyright (c) 2022 by Philip Collier, radio AB9IL <webmaster@ab9il.net>
# This is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version. There is NO warranty; not even for
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

# update software from git repositories
# To disable a specific updater, comment its reference in
# the function list near the bottom of this script.

# get the latest release from git repos
download_last(){
    cd $3
    wget "$(lastversion --pre $1 --format assets --filter $2)"
}
export -f download_last

update_audioprism() {
printf "\n\n...audioprism..."
apt install libpulse-dev libfftw3-dev libsdl2-dev libsdl2-ttf-dev \
    libsndfile1-dev libgraphicsmagick++1-dev
[[ -f "/usr/local/src/audioprism" ]] \
    || git clone https://github.com/vsergeev/audioprism
cd /usr/local/src/audioprism
make
make install
}

update_fd() {
printf "\n\n...fd..."
git_repo="sharkdp/fd"
target_file="fd_.*_amd64.deb"
dl_dir="/usr/local/src/fd"
[[ -f "$dl_dir" ]] || mkdir -p $dl_dir
cd "$dl_dir"
download_last $git_repo $target_file $dl_dir
deb_file="$(ls | grep "$target_file")"
dpkg -i $deb_file
# clean up
rm ./*.deb
}

update_fetchproxies() {
printf "\n\n...fetch-some-proxies..."
cd /usr/local/src
[[ -f "/usr/local/src/fetch-some-proxies" ]] \
    || git clone https://github.com/stamparm/fetch-some-proxies
    # nothing more to do
}

update_fzf() {
printf "\n\n...fzf..."
git_repo="junegunn/fzf"
target_file="fzf-.*-linux_amd64.tar.gz"
dl_dir="/usr/local/src/fzf"
[[ -f "$dl_dir" ]] || mkdir -p $dl_dir
cd "$dl_dir"
download_last $git_repo $target_file $dl_dir
gz_file="$(ls | grep "$target_file")"
tar -xf $gz_file
chown root:root fzf
# uncomment the symlinker below if needed
#[[ -f "$dl_dir/fzf" ]] \
#    && rm "/usr/local/bin/fzf" \
#    && ln -s "$dl_dir/fzf" "/usr/local/bin/fzf"

# clean up
rm ./*.gz
}

update_fzproxy() {
printf "\n\n...fzproxy..."
/usr/local/src
[[ -f "/usr/local/src/fzproxy" ]] \
    || git clone https://git.teknik.io/matf/fzproxy
# uncomment the symlinker below if needed
#[[ -f "/usr/local/src/fzproxy/fzproxy" ]] \
#    && rm "/usr/local/sbin/fzproxy" \
#    && ln -s "/usr/local/src/fzproxy/fzproxy" "/usr/local/sbin/fzproxy"
}

update_i3ass() {
printf "\n\n...fzproxy..."
/usr/local/src
[[ -f "/usr/local/src/i3ass" ]] \
    || git clone https://github.com/budlabs/i3ass
# uncomment the symlinker below if needed
#scripts="i3flip i3fyra i3get i3gw i3king i3Kornhe \
# i3list i3menu i3run i3var i3viswiz i3zen"
#for item in $scripts; do
#    rm "/usr/bin/$item"
#    ln -s "/usr/local/src/i3ass/src/$item/$item" "/usr/bin/$item"
#done
}

update_picom() {
printf "\n\n...Python-Pulseaudio-Loopback-Tool..."
/usr/local/src
[[ -f "/usr/local/src/Python-Pulseaudio-Loopback-Tool" ]] \
    || git clone https://github.com/yshui/picom
cd /usr/local/src/picom
git submodule update --init --recursive
[[ -f "/usr/bin/meson" ]] || \
    ln -s "/usr/local/bin/meson" "/usr/bin/meson"
meson --buildtype=release . build
ninja -C build
# uncomment the symlinker below if needed
#[[ -f "/usr/local/src/picom/build/src/picom" ]] \
#    && rm "/usr/local/bin/picom" \
#    && ln -s "/usr/local/src/picom/build/src/picom" "/usr/local/bin/picom"
}

update_pulseaudioloopback() {
printf "\n\n...Python-Pulseaudio-Loopback-Tool..."
[[ -f "/usr/local/src/Python-Pulseaudio-Loopback-Tool" ]] \
    || git clone https://github.com/alentoghostflame/Python-Pulseaudio-Loopback-Tool
# nothing more to do
}

update_rgpipe() {
printf "\n\n...rgpipe..."
[[ -f "/usr/local/src/rgpipe" ]] \
    || git clone https://github.com/ColonelBuendia/rgpipe
chmod +x /usr/local/src/rgpipe/rgpipe
# uncomment the symlinker below if needed
#[[ -f "/usr/local/src/rgpipe/rgpipe" ]] \
#    && rm "/usr/local/sbin/rgpipe" \
#    && ln -s "/usr/local/src/rgpipe/rgpipe" "/usr/local/sbin/rgpipe"
}

update_ripgrep() {
printf "\n\n...ripgrep..."
git_repo="BurntSushi/ripgrep"
target_file="ripgrep_.*_amd64.deb"
dl_dir="/usr/local/src/ripgrep"
[[ -f "$dl_dir" ]] || mkdir -p $dl_dir
cd "$dl_dir"
download_last $git_repo $target_file $dl_dir
deb_file="$(ls | grep "$target_file")"
dpkg -i $deb_file
# clean up
rm ./*.deb
}

update_ripgrep_all() {
printf "\n\n...ripgrep_all..."
git_repo="phiresky/ripgrep-all"
target_file="ripgrep_all-.*-linux-musl.tar.gz"
dl_dir="/usr/local/src"
download_last $git_repo $target_file $dl_dir
gz_file="$(ls | grep "$target_file")"
tar -xf $gz_file && mv ripgrep_all*/ ripgrep-all
chown -R root:root $dl_dir/ripgrep-all
chmod +x $dl_dir/ripgrep-all/rga
chmod +x $dl_dir/ripgrep-all/rga-preproc
# uncomment the symlinker below if needed
#[[ -f "$dl_dir/ripgrep-all/rga" ]] && rm "/usr/local/bin/rga"
#[[ -f "$dl_dir/ripgrep-all/rga-preproc" ]] && rm "/usr/local/bin/rga-preproc"
#ln -s "$dl_dir/ripgrep-all/rga" "/usr/local/bin/rga"
#ln -s "$dl_dir/ripgrep-all/rga-preproc" "/usr/local/bin/rga-preproc"
# clean up
rm $dl_dir/ripgrep_all*.gz
}

# update apt repo data
apt update

# check git repos for updates
find . -name .git -type d \
| xargs -n1 -P4 -I% git --git-dir=% --work-tree=%/.. pull origin master

# compile decoders and tools as separate processes
list="\
update_audioprism \
update_fd \
update_fetchproxies \
update_fzf \
update_fzproxy \
update_i3ass \
update_picom \
update_pulseaudioloopback \
update_rgpipe \
update_ripgrep \
update_ripgrep_all"

for job in $list;do
    export -f "$job"
    sem -j+0 "$job"
done

printf "\n\nWorking... Please stand by.\n\n"
printf "\n\nPlease be patient... Downloading and compiling may be slow.\n\n"
sem --wait

# update the links for shared libraries
ldconfig

printf "\n\nEnd of script.  Good luck / have fun.\n"
