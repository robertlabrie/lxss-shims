# lxss-shims #

TLDR: Run Windows userland apps from Ubuntu bash with Linux --> Windows path
correction

Microsoft ships the Linux Subsytem for Windows, which is an Ubuntu userland
running native ELF binaries. It's not a VM, it's not Cygwin, the processes
are legitimate Windows processes running through a compatibility layer.

You can also run native Windows apps from the shell. Yes, it's ok to run
`/mnt/c/Windows/System32/notepad.exe` and it works! Ok, so what's the catch? Say
you want to open a file with notepad like this
`/mnt/c/Windows/System32/nodepad.exe /mnt/c/users/rob/Documents/goodstuff.txt`.
In Windows userland, `/mnt/c/....` doesn't mean anything. That is what these
shims are for. Using Powershell for Linux, we convert the Linux virtual path for
a file to the actual Windows path. This way
`notepad ./goodstuff.txt` becomes `notepad C:\Users\Rob\Docu,ents\goodstuff.txt`
