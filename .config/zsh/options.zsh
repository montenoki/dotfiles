#!/usr/bin/env bash

# If a command is issued that can’t be executed as a normal command, and the
# command is the name of a directory, perform the cd command to that directory.
setopt AUTO_CD

# Treat  the ‘#’, ‘~’ and ‘^’ characters as part of patterns for filename
# generation, etc.  (An initial unquoted ‘~’ always produces named directory
# expansion.)
setopt EXTENDED_GLOB

# If a pattern for filename generation has no matches, print an error, instead
# of leaving it unchanged in the argument  list. This also applies to file
# expansion of an initial ‘~’ or ‘=’.
setopt NOMATCH

# no Beep on error in ZLE.
setopt NO_BEEP

# Remove any right prompt from display when accepting a command line. This may
# be useful with terminals with other cut/paste methods.
setopt TRANSIENT_RPROMPT

# If unset, the cursor is set to the end of the word if completion is started.
# Otherwise it stays there and completion is done from both ends.
setopt COMPLETE_IN_WORD

# Make cd push the old directory onto the directory stack.
setopt AUTO_PUSHD

# Don’t push multiple copies of the same directory onto the directory stack.
setopt PUSHD_IGNORE_DUPS

# DON NOT Allow ‘>’ redirection to truncate existing files, and ‘>>’ to create
# files. Otherwise ‘>!’ or ‘>|’ must be used to truncate  a file, and ‘>>!’ or
# ‘>>|’ to create a file.
setopt NO_CLOBBER

# History ignore command that start with a space
setopt HIST_IGNORE_SPACE
setopt HIST_IGNORE_DUPS
