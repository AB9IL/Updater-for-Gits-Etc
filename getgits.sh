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

# define working directory
export working_dir="/usr/local/src"

# get the latest release from git repos
download_last(){
    wget -P "$3/" "$(lastversion --pre $1 --format assets --filter $2)"
}
export -f download_last

update_arc-theme() {
printf "\n\n...arc-theme..."
cd "$working_dir"
[[ -d "$working_dir/arc-theme" ]] \
    || git clone "https://github.com/horst3180/arc-theme" --depth 1
cd "$working_dir/arc-theme"
./autogen.sh --prefix=/usr --with-gnome=3.22
make install
}

update_audioprism() {
printf "\n\n...audioprism..."
cd "$working_dir"
apt -o DPkg::Lock::Timeout=-1 install -y libpulse-dev libfftw3-dev \
    libsdl2-dev libsdl2-ttf-dev libsndfile1-dev libgraphicsmagick++1-dev
[[ -d "$working_dir/audioprism" ]] \
    || git clone "https://github.com/vsergeev/audioprism" --depth 1
cd "$working_dir/audioprism"
make -j4
make install
}

update_fd() {
printf "\n\n...fd..."
cd "$working_dir"
git_repo="sharkdp/fd"
target_file="fd_.*_amd64.deb"
dl_dir="$working_dir/fd"
[[ -d "$dl_dir" ]] || mkdir -p $dl_dir
cd "$dl_dir"
download_last $git_repo $target_file $dl_dir
deb_file="$(find . -maxdepth 1 -name "$(echo "$target_file" | sed 's|\.||')")"
dpkg -i $deb_file
# clean up
rm ./*.deb
}

update_fetchproxies() {
printf "\n\n...fetch-some-proxies..."
cd "$working_dir"
[[ -d "$working_dir/fetch-some-proxies" ]] \
    || git clone "https://github.com/stamparm/fetch-some-proxies" --depth 1
    # nothing more to do
}

update_fzf() {
printf "\n\n...fzf..."
cd "$working_dir"
git_repo="junegunn/fzf"
target_file="fzf-.*-linux_amd64.tar.gz"
dl_dir="$working_dir/fzf"
[[ -d "$dl_dir" ]] || mkdir -p $dl_dir
cd "$dl_dir"
download_last $git_repo $target_file $dl_dir
gz_file="$(find . -maxdepth 1 -name "$(echo "$target_file" | sed 's|\.||')")"
tar -xvzf "$gz_file"
chown -R root:root "$dl_dir"
# uncomment the symlinker below if needed
#ln -sf "$dl_dir/fzf" "/usr/local/bin/fzf"
#
# clean up
rm "$gz_file"
}

update_fzproxy() {
printf "\n\n...fzproxy..."
cd "$working_dir"
[[ -d "$working_dir/fzproxy" ]] \
    || git clone "https://git.teknik.io/matf/fzproxy" --depth 1
# uncomment the symlinker below if needed
#ln -sf "$working_dir/fzproxy/fzproxy" "/usr/local/sbin/fzproxy"
}

update_glow() {
printf "\n\n...glow..."
cd "$working_dir"
git_repo="charmbracelet/glow"
target_file="glow_.*linux_x86_64.tar.gz"
dl_dir="$working_dir"
download_last $git_repo $target_file $dl_dir
gz_file="$(find . -maxdepth 1 -name "$(echo "$target_file" | sed 's|\.||')")"
mkdir glow_linux_x86_64 || rm -rf glow_linux_x86_64/*
tar -xvzf $gz_file --directory "$working_dir/glow_linux_x86_64"
chown -R root:root glow_linux_x86_64
chmod +x glow_linux_x86_64/glow
# uncomment the symlinker below if needed
#ln -sf "$dl_dir/glow_linux_x86_64/glow" "/usr/local/bin/glow"
# clean up
rm "$gz_file"
}

update_i3ass() {
printf "\n\n...i3ass..."
cd "$working_dir"
[[ -d "$working_dir/i3ass" ]] \
    || git clone "https://github.com/budlabs/i3ass" --depth 1
make -j4
# uncomment the symlinker below if needed
#scripts="i3flip i3fyra i3get i3gw i3king i3Kornhe \
# i3list i3menu i3run i3var i3viswiz i3zen"
#for item in $scripts; do
#ln -sf "$working_dir/i3ass/src/$item/$item" "/usr/bin/$item"
#done
}

update_lf() {
printf "\n\n...lf..."
cd "$working_dir"
git_repo="gokcehan/lf"
target_file="lf-linux-amd64.tar.gz"
dl_dir="$working_dir"
download_last $git_repo $target_file $dl_dir
gz_file="$(find . -maxdepth 1 -name "$target_file")"
mkdir lf_linux_amd64 || rm -rf lf_linux_amd64/*
tar -xvzf $gz_file --directory "$working_dir/lf_linux_amd64"
chown -R root:root lf_linux_amd64
chmod +x lf_linux_amd64/lf
# uncomment the symlinker below if needed
#ln -sf "$dl_dir/lf_linux_amd64/lf" "/usr/local/bin/lf"
# clean up
rm "$gz_file"
}

update_lowdown() {
printf "\n\n...lowdown..."
cd "$working_dir"
[[ -d "$working_dir/lowdown" ]] \
    || git clone "https://github.com/kristapsdz/lowdown" --depth 1
cd "$working_dir/lowdown"
./configure
make -j4
# uncomment the symlinker below if needed
#ln -sf "$working_dir/lowdown/lowdown" "/usr/local/bin/lowdown"
}

update_outline_client() {
printf "\n\n...Outline-Client..."
cd "$working_dir"
git_repo="Jigsaw-Code/outline-client"
target_file="Outline-Client.AppImage"
app_dir="/opt/outline"
dl_dir="$working_dir"
[[ -d "$app_dir" ]] || mkdir -p $app_dir
download_last $git_repo $target_file $dl_dir
app_img_file="$(find . -maxdepth 1 -name "$target_file")"
chmod +x "$app_img_file"
mv "$app_img_file" "$app_dir/$app_img_file"
}

update_picom() {
printf "\n\n...picom..."
cd "$working_dir"
dl_dir="$working_dir/picom"
[[ -d "$dl_dir" ]] \
    || git clone "https://github.com/yshui/picom" --depth 1
# uncomment the symlinker below if needed
#ln -sf "/usr/local/bin/meson" "/usr/bin/meson"
cd "$dl_dir"
git submodule update --init --recursive
meson --buildtype=release . build
ninja -C build
# uncomment the symlinker below if needed
#ln -sf "$working_dir/picom/build/src/picom" "/usr/local/bin/picom"
}

update_powerline() {
printf "\n\n...Powerline-go..."
cd "$working_dir"
git_repo="justjanne/powerline-go"
target_file="powerline-go-linux-amd64"
dl_dir="$working_dir/powerline"
[[ -d "$dl_dir" ]] || mkdir -p $dl_dir
download_last $git_repo $target_file $dl_dir
# overwrite the old executable
# if new file successfully downloaded
[[ -f "${dl_dir}/${target_file}.1" ]] && mv "${dl_dir}/${target_file}.1" "${dl_dir}/${target_file}"
chown -R root:root "${dl_dir}/${target_file}"
chmod +x "${dl_dir}/${target_file}"
# uncomment the symlinker below if needed
ln -sf "${dl_dir}/${target_file}" "/usr/local/bin/powerline-go"
}

update_pulseaudioloopback() {
printf "\n\n...Python-Pulseaudio-Loopback-Tool..."
cd "$working_dir"
[[ -d "$working_dir/Python-Pulseaudio-Loopback-Tool" ]] \
    || git clone "https://github.com/alentoghostflame/Python-Pulseaudio-Loopback-Tool" --depth 1
# nothing more to do
}

update_rgpipe() {
printf "\n\n...rgpipe..."
cd "$working_dir"
[[ -d "$working_dir/rgpipe" ]] \
    || git clone "https://github.com/ColonelBuendia/rgpipe" --depth 1
chmod +x "$working_dir/rgpipe/rgpipe"
# uncomment the symlinker below if needed
#ln -sf "$working_dir/rgpipe/rgpipe" "/usr/local/sbin/rgpipe"
}

update_ripgrep() {
printf "\n\n...ripgrep..."
cd "$working_dir"
git_repo="BurntSushi/ripgrep"
target_file="ripgrep_.*_amd64.deb"
dl_dir="$working_dir/ripgrep"
[[ -d "$dl_dir" ]] || mkdir -p $dl_dir
cd "$dl_dir"
download_last $git_repo $target_file $dl_dir
deb_file="$(find . -maxdepth 1 -name "$(echo "$target_file" | sed 's|\.||')")"
dpkg -i $deb_file
# clean up
rm $deb_file
}

update_ripgrep_all() {
printf "\n\n...ripgrep_all..."
cd "$working_dir"
git_repo="phiresky/ripgrep-all"
target_file="ripgrep_all-.*-linux-musl.tar.gz"
dl_dir="$working_dir"
download_last $git_repo $target_file $dl_dir
gz_file="$(find . -maxdepth 1 -name "$(echo "$target_file" | sed 's|\.||')")"
tar -xvzf $gz_file && rm -rf ripgrep-all && mv ripgrep_all*/ ripgrep-all
chown -R root:root ripgrep-all
chmod +x ripgrep-all/rga
chmod +x ripgrep-all/rga-preproc
# uncomment the symlinker below if needed
#ln -sf "$dl_dir/ripgrep-all/rga" "/usr/local/bin/rga"
#ln -sf "$dl_dir/ripgrep-all/rga-preproc" "/usr/local/bin/rga-preproc"
# clean up
rm "$gz_file"
}

# update apt repo data
apt -o DPkg::Lock::Timeout=-1 update

# use find (unless you already have fd)
find -type d -name '.git' | xargs -n1 -P4 -I {} \
    bash -c 'pushd "${0%/*}" \
    && ( git pull origin master --depth 1; \
    git tag -d $(git tag -l); \
    git reflog expire --expire=all --all;
    git gc --prune=all ) \
    && popd' {} \;

# use fd if you have it
#fd -HIFt d '.git' | xargs -n1 -P4 -I {} \
#    bash -c 'pushd "$0" \
#    && ( git pull origin master --depth 1; \
#    git tag -d $(git tag -l); \
#    git reflog expire --expire=all --all; \
#    git gc --prune=all ) \
#    && popd' {}

# compile decoders and tools as separate processes
list="update_audioprism \
update_fd \
update_fetchproxies \
update_fzf \
update_fzproxy \
update_glow \
update_i3ass \
update_lowdown \
update_lf \
update_outline_client \
update_picom \
update_powerline \
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
