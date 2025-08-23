# shellbits

Shell scripts and reusable utility libaries.

## Overview

### Commands

The [`wat`](#wat) command acts as a memorable wrapper around the rest of the shellbits utlities:

| `wat $L` shorthand  | Full Shellbits Command        | Summary                                                                           |
|---------------------|-------------------------------|-----------------------------------------------------------------------------------|
| `wat t [DIR]`       |[`twee [DIR]`](#twee)          | Improve [`tree`'s flaky `.gitignore` handling](#fixing-trees-gitignore-support).  |
| `wat m [DIR]`       |[`twee-mon [DIR]`](#twee-mon)  | Run a filesystem-listening pane for [`twee`](#twee) which refreshes on changes.   |
| `wat o [DIR]`       |[`lu -o old [DIR]`](#lu)       | "Last used" files sorted with oldest at bottom                                    |
| `wat n [DIR]`       |[`lu -o new [DIR]`](#lu`)      | "Last used" files sorted with newest at bottom                                    |
| `wat w FILE`        |[`rstrip FILE`](#rstrip)       | Remove trailing whitespace from files / stdin.                                    |
| `wat s [any]`       |n/a (directly wraps [`du`][du] | Show the size(s) of the target(s).                                                |
| `wat v [DIR]`       |[`pyv [DIR]`][pyv]             | List Python [venvs][] in a directory (defaults to the current one)                |

[venvs]: https://docs.python.org/3/library/venv.html
[du]: https://en.wikipedia.org/wiki/Du_(Unix)

### Goals

These tools are made with the following goals:

| Goal                                     | Example(s)                                                                        |
|------------------------------------------|-----------------------------------------------------------------------------------|
| User convenience                         | `wat`'s ergonomics, `twee`'s [fixes for `tree`](#fixing-trees-gitignore-support). |
| Target [common platforms](#requirements) | Assumes recent-ish [bash][bash-vs-sh]                                             |
| Avoid chasing "industrial scale"         | `twee` maintains legibility by forgoing caching.                                  |


### Usage

**TL;DR:** `install.sh && source ~/.bashrc` to run [commands](#commands)
or [`source "$SHELLBITS\_LIB/logging.sh"`](#libraries).

> [!NOTE]
> Mac users [may need to update to a more recent version of `bash`](#requirements).

Skip to [Installing](#installing) for more guidance.


#### Commands

The following utility scripts are located in [`bin/`](./bin):

##### `twee`

This wraps the `tree` command to fix `.gitignore` handling on older versions.

It tries to auto-detect and auto-generate `tree` flags for all known-broken
`.gitignore` rules(trailing slashes, etc). See the [details section](#details)
section to learn more about how and why.

##### `twee-mon`

Wraps `twee` by re-running it each time the target directory changes.

It is a simple and editor-agnostic helper for [`tmux`][tmux],
[`screen`][screen], and similar utilities:

1. Create a pane
2. `twee-mon .`
3. It will automatically refresh

**Gotchas**

This currently assumes you are on Linux with:
- [inotify-tools][] installed
- a buggy version of `tree`

See the [requirements](#requirements) section to learn more about:
- Installing
- How to turn off `.gitignore` translation for faster refresh

[tmux]: https://github.com/tmux/tmux/wiki
[screen]: https://www.gnu.org/software/screen/manual/screen.html

##### `lu`

"**L**ast **u**sed" listings sorted by modification time.

Use this for finer control over than `wat old` and `wat new`.

| Example                            | Action                                                          |
|------------------------------------|-----------------------------------------------------------------|
| `lu`                               | List the working directory by date from new to old.             |
| `lu --order old`                   | Same as above but with the long flag specifying the default.    |
| `lu --number 5 -o new ~/Downloads` | Show your 5 latest `~/Downloads` + dates from oldest to newest. |

Use `lu --help` to learn more.

##### `pyv`

List and activate Python [virtual environments][venvs].

It counts any directory which has a `$DIR/bin/activate` file to be a likely virtual environment.

> [!IMPORTANT]
> Activating via `pyv` **requires** `source` due to how shells work.

| Action                                    | Command            |
|-------------------------------------------|--------------------|
| Activate a virtual environment.           | `source pyv`       |
| List virtual environemnts in a directory. | `pyv --list [DIR]` |

> [!NOTE]
> This tool helps people who can't use [`uv`][uv] or [`poetry`][poetry] for some reason.


[uv]: https://docs.astral.sh/uv/
[poetry]: https://python-poetry.org/

##### `rstrip`

Remove trailing whitespace at the end of every line.

* Operates in-place on passed filenames
* Pass a single `-` to read from `stdin`

| Example                           | Action                                                             |
|-----------------------------------|--------------------------------------------------------------------|
| `rstrip src/*.js`                 | Strip right-hand whitespace from `src`'s `.js` file in src.        |
| `makemess \| rstrip > clean.txt`  | Pipe messy real-time output into `rstrip` and store it `clean.txt` |

##### `wat`

This utility acts as a memorable wrapper for the other structure and time helpers.

For each `wat [INFO_TYPE]`, the following also apply:

* `DIR` defaults to the working directory if unspecified
* For all arguments from `[INFO_TYPE]` up to the penultimate one are assumed to be flags
* The last argument is handled based on whether it starts with `-`:
  - If not, it is assumed to be a `DIR` or `FILE` positional
  - Otherwise, append it as a flag

For all commands other than [`twee-mon`](#twee-mon), flags are then passed as-is
to the wrapped shellbits utility.

| Example             | Action                                                                    |
|---------------------|---------------------------------------------------------------------------|
| `wat t(ree)? [DIR]` | Run [`twee`](#twee) to translate `.gitignore` for older `tree` versions.  |
| `wat m(on)? [DIR]`  | Show an auto-refreshing [`twee-mon`](#twee-mon) view of a given `DIR`.    |
| `wat n(ew)? [DIR]`  | Show items in `DIR`, sorted with newest last ([`lu -o new [DIR]`](#lu))   |
| `wat o(ld)? [DIR]`  | Show items in `DIR`, sorted with oldest last ([`lu -o old [DIR]`](#lu))   |
| `wat [rw] FILE`     | Call [`rstrip`](#rstrip) on a file.                                       |

#### Libaries

Once [installed](#installing), load libraries from [`lib/`](./lib) as follows:

```shell
source "$SHELLBITS_LIB/logging.sh"
```

| `lib/` file                          |  Summary                                                                    |
|--------------------------------------|-----------------------------------------------------------------------------|
| [`lib/logging.sh`](./lib/logging.sh) | Base functions (`stderr`) and logging helpers (error, warning, debug, etc). |
| [`lib/paths.sh`](./lib/paths.sh)     | Path member and trim helpers.                                               |

Each `lib/\*.sh` file ends with a matching `SHELLBITS\_LIB_${NAME\_STEM}=1`
declaration. You can avoid double-import by checking whether one is either
defined or set to a non-empty value.

### Installing

#### Requirements

**TL;DR:** Your `bash` must support [array syntax][] and you'll need [inotify-tools][] for [`twee-mon`](#twee-mon) to work


The [`twee-mon`](#twee-mon) command currently requires the Linux-specific
[inotify-tools][] package for filesystem event handling. Since it's not on
Mac, that script does not yet support Mac. Otherwise, the rest of shellbits
should work fine as long as you have `bash` with array support.

> [!IMPORTANT]
> [The `sh` shell is *not* the same as `bash`][bash-vs-sh]!

[inotify-tools]: https://github.com/inotify-tools/inotify-tools
[array syntax]: https://www.gnu.org/software/bash/manual/html_node/Arrays.html
[bash-vs-sh]: https://stackoverflow.com/a/5725402

##### Platform Gotchas

**Mac**

Recent Macs ship an older version of `bash` for license reasons.

If you have issues, [`brew`][brew] may be useful for installing a later version.

[brew]: https://brew.sh/

**Arch Linux**

**TL;DR:** Install [`tree`][Arch-tree] and [`intotify-tools`][Arch-inotify] + temp-replace `twee`

1. Install the following:
   - [`tree`][Arch-tree] (`sudo pacman -S tree`?)
   - [`inotify-tools`][Arch-inotify]
2. Make sure to [check whether your `tree` version is broken](#override-twee-if-tree-works)

[Arch-tree]: https://man.archlinux.org/man/tree.1.en
[Arch-inotify]: https://archlinux.org/packages/extra/x86_64/inotify-tools/

#### Install via Script

After cloning locally:

1. [Read `./install.sh`](./install.sh) to understand what it does
2. Run `./install.sh` to add a `PATH` entry to your `.bashrc`
3. `source ~/.bashrc`

#### Install Manually

1. `cd shellbits` (or wherever you cloned it)
2. `pwd` 
3. Copy that output
4. Add the appropriate line to your `.bashrc` or other session init script:
   ```bash
   export PATH=PATH:/home/you/path/to/shellbits
   ```
5. `source .bashrc` (or other file)

#### Override `twee` If `tree` Works

The [`twee-mon`](#twee-mon) command supports replacing `twee` with
a custom command.

If your `tree` version is recent enough to have working `.gitignore`
support, this can offer the following benefits:

* faster refresh of your `twee-mon` display
* a better-looking tree display

##### Check Your `tree` Version

1. Find a local git repo which contains a `.gitignore` file which:
   - includes `dir/` rules
   - has a matching folder to test against, e.g.
     - `__pycache__/` (Python)
     - `node_modules`

2. If you are unsure what this means, please see the
   [Details section](#details)

3. Run the following command:
   ```shell
   tree --gitignore repo/with/trailing/slash/rules
   ```

If no matching folders show up, you're done!

Otherwise, proceed to the next section.

##### Modify Your Bash Config

If your `tree` version works properly, you can make `twee-mon` refresh faster.

Do so by skipping `twee`'s rule translation via one of:

| Modification                     | Example line in `.bashrc` or `.bash_profile`                      |
|----------------------------------|-------------------------------------------------------------------|
| `SHELLBITS_CUSTOM_TWEE` variable | `export SHELLBITS_CUSTOM_TWEE="tree --gitignore --exclude .git"`  |
| Alias line                       | `alias twee='tree --gitignore --exclude .git'`                    |

See Arch's [wiki page on Bash configuration][Arch-bash] to learn more.

## Details

### Fixing `tree`'s `.gitignore` Support

**TL;DR:** Make a `tree` flag for each broken `.gitignore` rule.

#### What's Fixed?

Trailing slash rules like `directory/` and `*.directory/`:

* Python's `__pycache__/`, `.venv*/`, `*.egg-info/` rules
* JavaScript's `node_modules/`
* IDE folders like `.idea/`

#### Known-Broken `tree` versions

> Feel free to relax: although it's infuriating, it's not a security concern.

[Please file an issue][file-issue] if you know of any additional buggy `tree` versions.

[file-issue]: https://github.com/pushfoo/shellbits

##### Debian Bookworm: Yes

The `tree` version for Debian bookworm [is v2.1.0][bookworm-v2.1.0].

Debian trixie:

1. Just [superceded it as the current stable release][trixie]
2. Ships [`tree` >= v2.2.1](https://packages.debian.org/trixie/tree)

Although [bookworm has LTS support until at least 2028][bookworm], bugfix
releases for non-security issues will grow slimmer with every day.

[bookworm-v2.1.0]: https://packages.debian.org/bookworm/tree
[trixie]: https://www.debian.org/News/2025/20250809
[bookworm]: https://www.debian.org/releases/bookworm/

#### Arch Linux: Unknown

[Arch's `tree` version][Arch-tree] is newer than [Debian bookworm's `tree`](#debian-bookworm-yes).

If you can confirm whether it works, [please file an issue][file-issue].

#### How does `twee` fix it?

In the simplest way possible: if there's `.gitignore` for a project folder, read each line:

1. Read either the next line or an `EOF`
2. If at `EOF`, finish scanning
3. If the line does not match a known-broken patterns, go back to step 1
4. Use the broken rule to generate and store a replacement `tree` flag
5. Go to step 1

Once done scanning, the following are passed to `tree`:
1. `--gitignore --exclude .git`
2. Any generated rule translations
3. The target `DIR`

#### Is it safe?

**TL;DR:** Safer than overriding system utilties with third-party packages.

All of shellbits follows the rules for [avoiding breaking Debian][DontBreakDebian]
by:

1. installing only to your user directory
2. never touching system folders
3. not being a `.deb`

[DontBreakDebian]: https://wiki.debian.org/DontBreakDebian

## Style

The repo currently uses a comment style heavily influenced by Python and Markdown.
We'll see where it goes from here.

### I don't like that!

I'm open to recomendations via [opening an issue](https://github.com/pushfoo/shellbits/issues).
In the meantime, these may help:

| Tool                                  | Summary                                    |
|---------------------------------------|--------------------------------------------|
| https://github.com/mvdan/sh           | Command-line shell formatter               |
| [foxundermoon's shell-format][fox]    | A popular extension for Visual Studio Code |
| The JetBrains [Shell Script plugin][] | Shell support for IntelliJ, PyCharm, etc   |

The JetBrains plugin connects with [Shell Check][] and other tools under the hood. You
may want to give those utilities a look.

[fox]: https://marketplace.visualstudio.com/items?itemName=foxundermoon.shell-format
[Shell Check]: https://github.com/koalaman/shellcheck
[Shell Script plugin]: https://plugins.jetbrains.com/plugin/13122-shell-script

