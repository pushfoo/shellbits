# shellbits

Shell scripts and a few utility functions.

These are tools:

* are textmode conveniences
* do not aim to provide industrial-strength efficiency

## Usage

**TL;DR:** `install.sh && source ~/bashrc` to run [commands](#commands)
or [`source "$SHELLBITS_LIB/logging.sh"`](#libraries).

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

> [!NOTE]
> Some scripts may require a `bash`-compatible shell rather than `sh`.

#### Libaries

The [`lib/logging.sh`](bin/logging.sh) file contains some helpers
for commong logging tasks. Use it in scripts as follows:

```sh
source "$SHELLBITS_LIB/logging.sh"
```

### Installing

#### Easy mode

1. [Read `./install.sh`](./install.sh) to understand what it does
2. Run `./install.sh` to add a `PATH` entry to your `.bashrc`
3. `source ~/.bashrc`

#### Manually

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

