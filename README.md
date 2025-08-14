# shellbits

Shell scripts and reusable utility libaries.

## Overview

### Commands

The [`wat`](#wat) command acts as a memorable wrapper around the rest of the shellbits utlities:

| `wat $L` shorthand  | Full Shellbits Command     | Summary                                                                           |
|---------------------|----------------------------|-----------------------------------------------------------------------------------|
| `wat t [DIR]`       |[`twee [DIR]`](#twee)       | Improve [`tree`'s flaky `.gitignore` handling](#fixing-trees-gitignore-support).  |
| `wat m [DIR]`       |[`twee-mon [DIR]`(#twee-mon)| Run a filesystem-listening pane for [`twee`](#twee) which refreshes on changes.   |
| `wat o [DIR]`       |[`lu -o old [DIR]`](#lu)    | "Last used" files sorted with oldest at bottom                                    |
| `wat n [DIR]`       |[`lu -o new [DIR]`](#lu`)   | "Last used" files sorted with newest at bottom                                    |
| `wat w FILE`        |[`rstrip FILE`](#rstrip)    | Remove trailing whitespace from files / stdin.                                    |

### Goals

These tools are made with the following goals:

| Goal                                     | Example(s)                                                                         |
|------------------------------------------|------------------------------------------------------------------------------------|
| User convenience                         | `wat`'s ergonomics + `twee` [fixes for `tree`](#fixing-trees-gitignore-support).   |
| Target [common platforms](#requirements) | Assumes recent-ish [bash][bash-vs-sh]                                              |
| Avoid chasing "industrial scale"         | `twee` maintains legibility by forgoing caching.                                   |


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

It is meant to be an editor-agnostic accompaniment to `tmux` and `screen`.

> [!NOTE]
> This currently assumes you are on Linux with `intotify-tool` installed.

##### `lu`

"**L**ast **u**sed" listings sorted by modification time.

Use this for finer control over than `wat old` and `wat new`.

| Example                            | Action                                                          |
|------------------------------------|-----------------------------------------------------------------|
| `lu`                               | List the working directory by date from new to old.             |
| `lu --order old`                   | Same as above but with the long flag specifying the default.    |
| `lu --number 5 -o new ~/Downloads` | Show your 5 latest `~/Downloads` + dates from oldest to newest. |

Use `lu --help` to learn more.

##### `rstrip`

Remove trailing whitespace at the end of every line.

* Operates in-place on passed filenames
* Pass a single `-` to read from `stdin`

| Example                           | Action                                                           |
|-----------------------------------|------------------------------------------------------------------|
| `rstrip src/*.js`                 | Strip right-hand whitespace from `src`'s `.js` file in src.      |
| `makemess | rstrip - > clean.txt` | Pipe messy real-time output into rstrip and store it `clean.txt` |

##### `wat`

This utility acts as a memorable wrapper for the other structure and time helpers.

For each `wat [INFO_TYPE]`, the following also apply:

* `DIR` defaults to the working directory if unspecified
* All arguments from `[INFO_TYPE]` up to the penultimate one are assumed to be flags
* The last argument is hanled based on whether it starts with `-`:
  - If not, it is assumed to be a `DIR` or `FILE` positional
  - Otherwise, append it as a flag
* All flags are then passed as-is to the wrappeed command

| Example             | Action                                                                   |
|---------------------|--------------------------------------------------------------------------|
| `wat t(ree)? [DIR]` | Runp [`twee`](#twee) to translate `.gitignore` for older `tree` versions.|
| `wat n(ew)? [DIR]`  | Show items in `DIR`, sorted with newest last ([`lu -o new [DIR]`](#lu))  |
| `wat o(ld)? [DIR]`  | Show items in `DIR`, sorted with oldest last ([`lu -o old [DIR]`](#lu))  |
| `wat [rw] FILE`     | Call [`rstrip`](#rstrip) on a file.                                      |

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

**TL;DR:** Most systems have a `bash` new enough to support [array syntax][].

Some scripts *may* work with `sh`, [but it not the same as `bash`][bash-vs-sh].

[array syntax]: https://www.gnu.org/software/bash/manual/html_node/Arrays.html
[bash-vs-sh]: https://stackoverflow.com/a/5725402

##### Mac

Recent Macs ship an older version of `bash` for license reasons.

If you have issues, [`brew`][brew] may be useful for installing a later version.

[brew]: https://brew.sh/

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


## Details

### Fixing `tree`'s `.gitignore` Support

**TL;DR:** Make a `tree` flag for each broken `.gitignore` rule.

#### What's Fixed?

Trailing slash rules like `directory/` and `*.directory/`:

* Python's `__pycache__/`, `.venv*/`, `*.egg-info/` rules
* JavaScript's `node_modules/`
* IDE folders like `.idea/`

#### Am _I_ Affected?

> [!TIP]
> Feel free to relax: this is an infuriating problem but not a security concern.

At least one widely-deployed version of `tree` is affected:
 [Please file an issue][]
to report more known versions.

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
[Please file an issue]: https://github.com/pushfoo/shellbits

#### How does `wat tree` fix it?

In the simplest way possible: if there's `.gitignore` for a project folder, read each line:

1. Read either the next line or an EOF
2. If at EOF, finish scanning
3. If the line does not match a known-broken patterns, go back to step 1
4. Use the broken rule to generate and store a replacement `tree` flag
5. Go to step 1

Once done scanning, a `--gitignore` flag is passed along with the
 passed to `tree`
along with a `--gitignore` to allow any working rules to apply as normal.

#### Is it safe?

More than installing random debs or overriding system packages.

Both the `wat` command and all of shellbits follow
[the rules on how to avoid breaking Debian][DontBreakDebian]:

1. It is not a `.deb` at all
2. It does not install software globally
3. It only installs to your user directory as scripts

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
| [foxundermoon's shell-format][]       | A popular extension for Visual Studio Code |
| The JetBrains [Shell Script plugin][] | Shell support for IntelliJ, PyCharm, etc   |

The JetBrains plugin connects with [Shell Check][] and other tools under the hood. You
may want to give those utilities a look.

[foxundermoon's shell-format]: https://marketplace.visualstudio.com/items?itemName=foxundermoon.shell-format
[ShellCheck]: https://github.com/koalaman/shellcheck
[Shell Script plugin]: https://plugins.jetbrains.com/plugin/13122-shell-script

