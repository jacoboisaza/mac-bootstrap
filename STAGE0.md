# Stage 0 — clean Apple Silicon Mac

Stage 0 uses only macOS's built-in `curl` and `/bin/bash`. It launches Apple's
Command Line Tools installer when needed, clones the latest default branch as a
real Git checkout, and hands control to `setup`.

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/jacoboisaza/mac-bootstrap/main/stage0)"
```

The script displays its actions and asks for confirmation. If Apple's graphical
installer opens, complete it and then press Return in Terminal. `setup` handles
Homebrew and the complete workstation configuration afterward.

To inspect Stage 0 before running it:

```bash
curl -fsSL https://raw.githubusercontent.com/jacoboisaza/mac-bootstrap/main/stage0
```

Stage 0 refuses to overwrite an existing `~/mac-bootstrap` directory.
