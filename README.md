Bartlet
=======

Bartlet is an extremely simple prompt bar creator for Bash which is meant to add
a little color to your terminal prompt. It has the concept of plugins and suites
which are automatically loaded, and then enabled by your .bashrc file.

While loading, Bartlet starts off by checking if `/etc/bartlet_plugins` exists,
and if it does it loads all plugins it finds therein, after that it also checks
if your home directory has any plugins (in `~/.bartlet_plugins`) and loads
those as well. Because plugins may use the same names, we expect that any
plugins located in your home directory are desired moreso than those located in
shared user space and as such should take priority.

Why?
----

I wanted something nice and simple that wasn't bloated to add a little color to
my terminal screen so I could easily differentiate where my builds started/ended
without having to scan 100s of lines of terminal output looking for the last
prompt. This gave me that, and something to do while I was bored.

Installation
============

Add the following to your .bashrc file to enable bartlet's prompt and branch
bars:
    source /etc/Bartlet.sh
    
    bartlet_enable "Prompt"
    bartlet_enable "Branch"
    bartlet_on

Source your .bashrc, or start another terminal instance, and everything
_should_ just work (at least in theory).

Order Matters
-------------

Bartlet doesn't offer an extremely simple way to reorder enabled plugins,
instead choosing to go the easier route of drawing bars in the order you enable
them in. In the above example, Bartlet will draw the Prompt and then the Branch
plugin. If you were to later call `bartlet_enable` on another plugin it would
be drawn (and executed) after Prompt and Branch.

Standard Suite
==============

Here's a quick overview of the "Standard" plugins I have created:

`Prompt` The blue bar showing username@hostname workingdir.

`Branch` The black bar showing what branch you are on (for both git and 
    mercurial) and if the working directory is dirty or not.
    
`Time` The time since your last prompt was displayed, but only if it took more 
    than 15 seconds since last prompt.
    
`LastStatus` A small (2 character) bar that shows the last status (return code) 
    in either green or red (good or bad).

BARTLET FUNCTIONS:
==================

`bartlet_color` Takes 2 parameters, the first one is
    "isFore" that is either a 0 or 1, where 1 is a foreground color, and 0 is a
    background color. The second is a number between 0 and 255 -- the terminal 
    color code, or "standard" to get the default terminal color for foreground 
    or background. This function outputs the color code to the screen.

`bartlet_show_colors` Print each of the 256 color codes (as background) to the
    screen, and their numbers.

`bartlet_define` Define a new bar (plugin). This takes 2 parameters: the name
    (first) and the callback function (second).

`bartlet_enable` Enable a plugin by name. By default all plugins are disabled.
    This also determines the order plugins are run when creating your prompt.  
    They are run in the order they are enabled.

`bartlet_disable` Disable a plugin by name.

`bartlet_available` Display all the plugins that have been defined and their
    status (enabled or disabled).

`bartlet-status` Alias for `bartlet_available`.

`__bartlet_start` An internal function to start drawing segments to the screen
    for the prompt line.

`bartlet_segment` Returns the characters for a segment. Takes 4 parameters:
    foreground color (defaults to the previous segment foreground color), 
    background color (defaults to the previous segment background color), 
    content, and extras (extra terminal information, such as bold, italic, etc. 
    -- all of these need to be the terminal escape codes). The resulting string 
    is placed in `BARTLET_BAR_STRING`.

`__bartlet_end` End a bar and clear the color codes for standard prompt
    colors.

`__bartlet_prompt_cmd` Internal function to draw the prompt.

`bartlet_on` Enable bartlet prompt drawing.

`bartlet_off` Disable bartlet prompt drawing (and revert the prompts to what 
    they were previously).

`bartlet_restart` Calls `bartlet_off` and `bartlet_on` back-to-back.

`__bartlet_init` Internal function, automatically called. Loads all of the
    plugins in the .bash_plugins directory.  These are combined into "suites" 
    and have a directory name with a shell file inside of them that has the
    same directory name (example: Directory/Directory.sh). Each plugin suite 
    that is run is running in their path.

PROMPT OPTIONS:
===============

Bartlet
-------

`BARTLET_MAINTAIN_PROMPT_COMMAND` If true, we maintain the default prompt
    command that the terminal has, this is typically enabling VTE which keeps
    track of the current working directory every time you cd to somewhere and
    allows new terminals to open in the same directory you are currently in.
    Defaults to 1.

`BARTLET_LSEP` Specifies the character to use as a segment separator for the
    left side of segments.

`BARTLET_RSEP` Like `BARTLET_RSEP`, but for the right side.

Prompt
------

`ENABLE_STANDARD_BAR_STATUS` If true, will enable last status in the primary
    prompt background color (uses slightly different colors than LastStatus).

`PROMPT_GOOD_BG` The background color for the prompt when the previous command
    exits with good status.

`PROMPT_GOOD_FG` The foreground color for the prompt when the previous command
    exits with a good status.

`PROMPT_BAD_BG` Same as `PROMPT_GOOD_BG`, but for non-good return statuses.

`PROMPT_BAD_FG` Same as `PROMPT_GOOD_FG`, for bad return statuses.

Branch
------

`BRANCH_DIRTY_FG` The foreground color for the branch character when a branch is
    dirty.

`BRANCH_CLEAN_FG` The foreground color for the branch bar when the branch is
    clean, and the branch name when dirty.

`BRANCH_BAR_BG` The background color for the branch bar.

LastStatus
----------

`STATUS_GOOD_FG`="standard"

`STATUS_GOOD_BG`=76

`STATUS_GOOD_CONTENT` What is shown when return status is good.

`STATUS_BAD_FG`="standard"

`STATUS_BAD_BG`=196

`STATUS_BAD_CONTENT` What is shown when return status is bad.

Time
----

`TIME_FG`=250

`TIME_BG`=26

License
=======

Copyright (c) 2015 by those listed in Contributors.md.

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
