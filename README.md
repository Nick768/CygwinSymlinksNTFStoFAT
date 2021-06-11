# CygwinSymlinksNTFStoFAT
Converts Cygwin symlinks from NTFS-symlinks to FAT-symlinks

## What it is?
* Converts Cygwin symlinks from NTFS symlink format to FAT symlink format
* Just place this script in your Cygwin root folder, double click it and wait
* After that you can convert your partition from NTFS to FAT32 (usually if you use [Cygwin Portable](https://github.com/vegardit/cygwin-portable-installer) on an usb stick)

## When to use?
This script should only be used if you converted an NTFS partition to FAT32 and Cygwin doesn't find its symlinked files.

## How it works?
* Search for \*.lnk files in the current workingdir and read the shortcut description
* Create a new file with the same name as the \*.lnk, but without file extension
* Add this magic hex header to the file: `0x21 0x3c 0x73 0x79 0x6d 0x6c 0x69 0x6e 0x6b 0x3e 0xff 0xfe`
* Write the shortcut description (taken from \*.lnk file) to the new file (and insert null bytes every second character)
* if everything succeeds, delete the \*.lnk file, else collect a report of the problem and report it to the user when everything finished.
