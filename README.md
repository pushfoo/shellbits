# shellbits

Shell scripts and reusable utility libaries.

These tools:

* focus on user convenience
* assume [common environments](#requirements)
* do not target "industrial scale"

## Usage

**TL;DR:** `install.sh && source ~/.bashrc` to run [commands](#commands)
or [`source "$SHELLBITS_LIB/logging.sh"`](#libraries).

> [!NOTE]
> Mac users [may need to update to a more recent version of `bash`](#requirements).

### Overview

#### Commands

The following utility scripts are located in [`bin/`](./bin):

| Command    | Summary                                        |
|------------|------------------------------------------------|
| `lu`       | "Last used" ls wrapper to sort by old/new.     |
| `rstrip`   | Remove trailing whitespace from files / stdin. |
| `wat new`  | Show the newest items in `cwd` last            |
| `wat old`  | Show theo ldest items in `cwd` last            |
| `wat tree` | Filtered tree view of project structure.       |


#### Libaries

Helpers for logging are loated in [`lib/logging.sh`](bin/logging.sh).

Use it in your scripts as follows:

```sh
source "$SHELLBITS_LIB/logging.sh"
```

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

## Style

[`bin/lu`](./bin/lu) currently uses a comment style heavily influenced by Python and Markdown.
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

