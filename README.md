# shellbits
Bits of shell script I want to keep around. Maybe it'll become a more "proper" library one day?

## Library Usage

First, `git clone` this repo onto your system.

You can either source directly from the repo, or by adding shellbits to
your PATH.

### Yes, Add it to Path!

1. `cd shellbits`
2. `pwd` 
3. Copy that path
2. Add it to your `.bash_rc` to enable sourcing from anywhere:
    ```bash
    export PATH=PATH:/home/you/path/to/shellbits
    ```

## Style

[foxundermoon's shell-format]: https://marketplace.visualstudio.com/items?itemName=foxundermoon.shell-format
[ShellCheck]: https://github.com/koalaman/shellcheck
[Shell Script plugin]: https://plugins.jetbrains.com/plugin/13122-shell-script

This currently uses a comment style heavily influenced by Python and Markdown.

### I don't like that!

I'm open to recomendations via [the repo's GitHub issues](https://github.com/pushfoo/shellbits/issues). In the meantime, these may help:

| Tool                                  | Summary                                    |
|---------------------------------------|--------------------------------------------|
| https://github.com/mvdan/sh           | Command-line shell formatter               |
| [foxundermoon's shell-format][]       | A popular extension for Visual Studio Code |
| The JetBrains [Shell Script plugin][] | Shell support for IntelliJ, PyCharm, etc   |

The JetBrains plugin connects with [Shell Check][] and other tools under the hood. You
may want to give them a look too.
