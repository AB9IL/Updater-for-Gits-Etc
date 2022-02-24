# Update your Git based software, plus ad-hoc debs, zip, and tar based packages. 

Use this for Linux software you have installed which is not from your distribution's main repositories, of if you want fresher versions than available. I wrote this to simplify the time consuming tasks of checking various repos for updates, downloading, setting special compilation options, compiling, then finally installing source based packages. Of course, why not add capability to retrieve debs, zips, tar, or appimages?

This updater runs in Bash, processing packages concurrently, four jobs at once. It uses "Lastversion" (Python) and GNU Parallel. Get them with:
```
sudo apt install parallel
python3 -m pip install lastversion
```

#### Supported Apps:
| Utilities
| ---
| audioprism
| fd-find
| fetchproxies
| fzf
| fzproxy
| i3ass
| picom
| pulseaudioloopback
| rgpipe
| ripgrep
| ripgrep-all

#### Usage:
Copy the script to /usr/local/src.  Execute it there as root.
```
sudo getgits.sh
```
Note, this script will find any git repos cloned in the working directory, do a "git pull" for them, but only compile the packages for which it is configured. To add a new package, you must:

- write in a function (similar to the others) to support the software
- add the function to the list at the bottom of the script

Supported software does not need to be exclusively hosted on github; any git repo works. Also, any web resource hosting deb packages, zip, or tar archives available to wget can work. FTW, you could even set these up to use Aria2 or another download tool...
