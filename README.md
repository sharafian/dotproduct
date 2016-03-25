dotproduct
===============================

A dotfile manager that has nothing to do with the math
thing.  support for moving dotfiles, running commands, and customizing common
parts of dotfiles.

## Setup

Copy `config.example.yml` to your dotfiles directory, and configure it (as
specified in the usage section). You can either copy `dotproduct.rb` to the
directory or just run it in your dotfile directory.

## Usage

`./dotproduct.rb <config> [target]`

### config.yml

config.yml is broken into three different sections.

The first one is `vars`. In this section, you can define different variables
that can be interpolated into your files when they're moved.

The next section is `files`. This is a list of files and folders in your local
dotfiles directory, and their appropriate places in your home directory.
There are 4 fields:

* `src`: The local path to the file/folder.
* `dest`: The directory that the file/folder should be placed in.
* `delim`: delimiter for interpolating strings in this file.
* `target`: (optional) this file is only moved when the target parameter is
  equal to `target`.

The last section is scripts, which lists commands that are run when dotproduct
is run. These have 2 fields:

* `cmd`: The command to be run
* `target`: (optional) this file is only moved when the target parameter is
  equal to `target`.
