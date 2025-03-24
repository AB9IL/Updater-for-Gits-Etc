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

export ARCH="amd64"
export ARCH2="x86_64"
export OBSIDIAN_VER="1.8.9"
export MeshChatVersion="v1.21.0"
export VPNGateVersion="0.3.1"
export LF_VER="34"
export LAZYGIT_VER="0.48.0"
export CYAN_VER="1.2.4"
export STARSH_VER="1.22.1"

# define working directory
export working_dir="/usr/local/src"

# get the latest release from git repos
download_last(){
    wget -P "$3/" "$(lastversion --pre $1 --format assets --filter $2)"
}
export -f download_last

try_pull(){
    for d in $(fd '.git$' --type d -utd); do
        pushd "$d/.." > /dev/null || return
        echo -e "\n${HIGHLIGHT}Updating `pwd`${NORMAL}"
        git pull 2>&1
        popd > /dev/null || return
    done
}

update_bluetabs() {
printf "\n\n...bluetabs..."
cd "$working_dir" || return
[[ -d "$working_dir/bluetabs" ]] && cd "$working_dir/bluetabs" || return
git pull
chmod +x bluetabs
}
export -f update_bluetabs

update_catbird_linux_scripts() {
printf "\n\n...catbird linux scripts..."
cd "$working_dir" || return
[[ -d "$working_dir/Catbird-Linux-Scripts" ]] && cd "$working_dir/Catbird-Linux-Scripts" || return
git pull
find . -type f ! -name system.rasi ! -name 'README.md' ! -name 'LICENSE' -exec chmod +x {} \;
}
export -f update_catbird_linux_scripts

update_circumventionist_scripts() {
printf "\n\n...circumventionist scripts..."
cd "$working_dir" || return
[[ -d "$working_dir/circumventionist-scripts" ]] && cd "$working_dir/circumventionist-scripts" || return
git pull
find . -type f ! -name 'README.md' ! -name 'LICENSE' -exec chmod +x {} \;
}
export -f update_circumventionist_scripts

update_cyan() {
printf "\n\n...cyan..."
cd "$working_dir" || return
aria2c -x5 -s5 \
    https://github.com/rodlie/cyan/releases/download/"$CYAN_VER"/Cyan-"$CYAN_VER"-Linux-"$ARCH2".tgz
tar -xvzf --overwrite Cyan*.tgz
mv Cyan*/* cyan/
rm -r Cyan*
chmod +x cyan/Cyan
ln -sf /usr/local/src/cyan/Cyan \
    /usr/local/bin/Cyan
}
export -f update_cyan

update_Dotfiles() {
printf "\n\n...Dotfiles..."
cd "$working_dir" || return
[[ -d "$working_dir/Dotfiles" ]] && cd "$working_dir/Dotfiles" || return
    update() {
        DIRS=".bashrc.d .ssh .w3m"
        for DIR in $DIRS; do
            cp -r "$DIR" /home/"$(logname)"/
        done
        FILES=".bashrc .fzf.bash .inputrc .nanorc .profile \
            .tmux.conf .vimrc .wgetrc .xinitrc"
        for FILE in $FILES; do
            cp "$FILE" /home/"$(logname)"/
        done

        FOLDERS="alacritty castero newsboat picom rofi sxhkd zathura"
        for FOLDER in $FOLDERS;do
            cp -r "$FOLDER"  /home/"$(logname)"/.config/"$FOLDER"
        done
    }
    git pull && update
}
export -f update_Dotfiles

update_dyatlov() {
printf "\n\n...Dyatlov Map Maker..."
cd "$working_dir" || return
[[ -d "$working_dir/dyatlov" ]] && cd "$working_dir/dyatlov" || return
    git pull
    chown -R "$(logname)":"$(logname)" .
    chmod +x dyatlov/kiwisdr_com-parse
    chmod +x dyatlov/kiwisdr_com-update
}
export -f update_dyatlov

update_fd() {
printf "\n\n...fd..."
cd "$working_dir" || return
git_repo="sharkdp/fd"
target_file="fd_.*_amd64.deb"
dl_dir="$working_dir/fd"
[[ -d "$dl_dir" ]] || mkdir -p $dl_dir
cd "$dl_dir" || return
download_last $git_repo $target_file $dl_dir
deb_file="$(find . -maxdepth 1 -name "$(echo "$target_file" | sed 's|\.||')")"
for package in *.deb; do dpkg -i $package; done
# clean up
rm ./*.deb
}
export -f update_fd

update_fetchproxies() {
printf "\n\n...fetch-some-proxies..."
cd "$working_dir" || return
[[ -d "$working_dir/fetch-some-proxies" ]] && cd "$working_dir/fetch-some-proxies" || return
git pull
# nothing more to do
}
export -f update_fetchproxies

update_fzf() {
printf "\n\n...fzf..."
cd "$working_dir" || return
git_repo="junegunn/fzf"
target_file="fzf-.*-linux_amd64.tar.gz"
dl_dir="$working_dir/fzf"
[[ -d "$dl_dir" ]] || mkdir -p $dl_dir
cd "$dl_dir" || return
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
export -f update_fzf

update_fzproxy() {
printf "\n\n...fzproxy..."
cd "$working_dir" || return
[[ -d "$working_dir/fzproxy" ]] && cd "$working_dir/fzproxy" || return
git pull
chmod +x fzproxy
# uncomment the symlinker below if needed
#ln -sf "$working_dir/fzproxy/fzproxy" "/usr/local/bin/fzproxy"
}
export -f update_fzproxy

update_glow() {
printf "\n\n...glow..."
cd "$working_dir" || return
git_repo="charmbracelet/glow"
target_file="glow_Linux_x86_64.tar.gz"
dl_dir="$working_dir"
download_last $git_repo $target_file $dl_dir
gz_file="$(find . -maxdepth 1 -name "$(echo "$target_file" | sed 's|\.||')")"
[[ -f "$gz_file" ]] && mkdir glow_linux_x86_64 || rm -rf glow_linux_x86_64/*
tar -xvzf $gz_file --directory "$working_dir/glow_linux_x86_64"
chown -R root:root glow_linux_x86_64
chmod +x glow_linux_x86_64/glow
# uncomment the symlinker below if needed
#ln -sf "$dl_dir/glow_linux_x86_64/glow" "/usr/local/bin/glow"
# clean up
rm "$gz_file"
}
export -f update_glow

update_lazygit() {
printf "\n\n...lazygit..."
cd "$working_dir" || return
    aria2c -x5 -s5 \
        https://github.com/jesseduffield/lazygit/releases/download/v"$LAZYGIT_VER"/lazygit_"$LAZYGIT_VER"_Linux_"$ARCH2".tar.gz
    tar -xvzf --overwrite lazygit_* -C lazygit/
    rm lazygit_*.tar.gz
    chmod +x lazygit/lazygit
#    ln -sf /usr/local/src/lazygit/lazygit \
#        /usr/local/bin/lazygit
}
export -f update_lazygit

update_lf() {
printf "\n\n...lf..."
cd "$working_dir" || return
git_repo="gokcehan/lf"
target_file="lf-linux-amd64.tar.gz"
dl_dir="$working_dir"
download_last $git_repo $target_file $dl_dir
gz_file="$(find . -maxdepth 1 -name "$target_file")"
[[ -f "$gz_file" ]] && mkdir lf_linux_amd64 || rm -rf lf_linux_amd64/*
tar -xvzf $gz_file --directory "$working_dir/lf_linux_amd64"
chown -R root:root lf_linux_amd64
chmod +x lf_linux_amd64/lf
# uncomment the symlinker below if needed
#ln -sf "$dl_dir/lf_linux_amd64/lf" "/usr/local/bin/lf"
# clean up
rm "$gz_file"
}
export -f update_lf

update_meshchat() {
printf "\n\n...reticulum meshchat..."
cd /opt/reticulum || exit
aria2c -x5 -s5 \
    https://github.com/liamcottle/reticulum-meshchat/releases/download/"$MeshChatVersion"/ReticulumMeshChat-"$MeshChatVersion"-linux.AppImage
    chmod +x ReticulumMeshChat*
cd "$working_dir" || return
}
export -f update_meshchat

update_nvim() {
printf "\n\n...neovim..."
cd "$working_dir" || return
git_repo="neovim/neovim-releases"
target_file="nvim-linux-$ARCH2.tar.gz"
dl_dir="$working_dir/nvim-linux64"
[[ -d "$dl_dir" ]] || mkdir -p $dl_dir
cd "$dl_dir" || return
download_last $git_repo $target_file $dl_dir
gz_file="$(find . -maxdepth 1 -name "$target_file")"
[[ -f "$gz_file" ]] && mkdir nvim-linux64 || rm -rf nvim-linux64/*
tar -xvzf $gz_file --directory "$working_dir/nvim-linux64"
chown -R root:root nvim-linux64
cd nvim-linux64 || return
chmod +x bin/nvim
cp -f bin/* /usr/bin/
cp -r share/{applications,icons,locale,man} /usr/share/
rsync -avhc --delete --inplace --mkpath lib/nvim/ /usr/lib/nvim/
rsync -avhc --delete --inplace --mkpath share/nvim/ /usr/share/nvim/
rsync -avhc --delete --inplace --mkpath lib/nvim/ /usr/lib/nvim/
npm install -g neovim
curl -L https://cpanmin.us | perl - App::cpanminus
cpanm Neovim::Ext
cd ../../
# clean up
rm -rf nvim-linux64/*
}
export -f update_nvim

update_pistol() {
cd "$working_dir" || return
aria2c -x5 -s5 \
    https://github.com/doronbehar/pistol/releases/download/v0.5.2/pistol-static-linux-x86_64
mkdir pistol
mv pistol-* pistol/pistol
chmod +x pistol/pistol
#    ln -sf "$working_dir"/pistol/pistol \
#        /usr/local/bin/pistol
}
export -f update_pistol

update_python_tgpt() {
source /opt/python-tgpt/bin/activate
uv pip install -U python-tgpt
uv clean
deactivate
}
export -f update_python_tgpt

update_ripgrep() {
printf "\n\n...ripgrep..."
cd "$working_dir" || return
git_repo="BurntSushi/ripgrep"
target_file="ripgrep_.*_amd64.deb"
dl_dir="$working_dir/ripgrep"
[[ -d "$dl_dir" ]] || mkdir -p $dl_dir
cd "$dl_dir" || return
download_last $git_repo $target_file $dl_dir
deb_file="$(find . -maxdepth 1 -name "$(echo "$target_file" | sed 's|\.||')")"
for package in *.deb; do dpkg -i $package; done
# clean up
rm $deb_file
}
export -f update_ripgrep

update_ripgrep_all() {
printf "\n\n...ripgrep_all..."
cd "$working_dir" || return
git_repo="phiresky/ripgrep-all"
target_file="ripgrep_all-.*-linux-musl.tar.gz"
dl_dir="$working_dir"
download_last $git_repo $target_file $dl_dir
gz_file="$(find . -maxdepth 1 -name "$(echo "$target_file" | sed 's|\.||')")"
[[ -f "$gz_file" ]] && tar -xvzf $gz_file && rm -rf ripgrep-all && mv ripgrep_all*/ ripgrep-all
chown -R root:root ripgrep-all
chmod +x ripgrep-all/rga
chmod +x ripgrep-all/rga-preproc
# uncomment the symlinker below if needed
#ln -sf "$dl_dir/ripgrep-all/rga" "/usr/local/bin/rga"
#ln -sf "$dl_dir/ripgrep-all/rga-preproc" "/usr/local/bin/rga-preproc"
# clean up
rm "$gz_file"
}
export -f update_ripgrep_all

update_starship() {
printf "\n\n...starship prompt..."
cd "$working_dir" || return
    mkdir starship
    aria2c -x5 -s5 \
        https://github.com/starship/starship/releases/download/v"$STARSH_VER"/starship-"$ARCH2"-unknown-linux-gnu.tar.gz
    tar -xvzf --overwrite starship-*.gz -C starship/
    chmod +x starship/starship
#    ln -sf /usr/local/src/starship/starship \
#        /usr/local/bin/starship
    cp Dotfiles/starship.toml /home/"$(logname)"/.config/
    rm starship-*.gz
}

update_supersdr_wrapper() {
printf "\n\n...supersdr-wrapper..."
cd "$working_dir" || return
[[ -d "$working_dir/supersdr-wrapper" ]] && cd "$working_dir/supersdr-wrapper" || return
git pull
chown -R "$(logname)":"$(logname)" kiwidata
chmod +x stripper
chmod +x supersdr-wrapper
}
export -f update_supersdr_wrapper

update_vpngate() {
cd "$working_dir" || return
[[ -d "$working_dir/vpngate" ]] && cd "$working_dir/vpngate" || return
aria2c -x5 -s5 \
    https://github.com/davegallant/vpngate/releases/download/v"$VPNGateVersion"/vpngate_"$VPNGateVersion"_linux_"$ARCH".tar.gz
tar -xvzf --overwrite vpn*.gz
cd "$working_dir" || exit
chmod +x vpngate/vpngate
rm vpngate/vpn*.gz
ln -sf /usr/local/src/vpngate/vpngate \
    /usr/local/bin/vpngate

# make executable and symlink
chmod +x circumventionist-scripts/dl_vpngate
ln -sf /usr/local/src/circumventionist-scripts/dl_vpngate \
    /usr/local/bin/dl_vpngate

# make executable and symlink
chmod +x circumventionist-scripts/menu-vpngate
ln -sf /usr/local/src/circumventionist-scripts/menu-vpngate \
    /usr/local/bin/menu-vpngate
}

# nala update if available
nala update

# download updates from git repos
try_pull

# compile decoders and tools as separate processes
list="update_bluetabs \
update_catbird_linux_scripts \
update_circumventionist_scripts \
update_cyan \
update_dyatlov \
update_fd \
update_fetchproxies \
update_fzf \
update_fzproxy \
update_glow \
update_lazygit \
update_lf \
update_meshchat \
update_nvim \
update_pistol \
update_python_tgpt \
update_ripgrep \
update_ripgrep_all \
update_starship \
update_supersdr_wrapper \
update_vpngate"

for job in $list;do
    echo -e "\n\n Job:  $job\n\n"
    sem -j 2 "$job"
done

printf "\n\nWorking... Please stand by.\n\n"
printf "\n\nPlease be patient... Downloading and compiling may be slow.\n\n"
sem --wait

# update the links for shared libraries
ldconfig

printf "\n\nEnd of script.  Good luck / have fun.\n"
