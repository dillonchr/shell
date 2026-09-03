# Shell Scripts

A modular collection of shell utilities and aliases sourced into your shell environment (`bash`/`zsh`).

## Setup

Add the following to your `~/.zshrc` or `~/.bashrc`:

```bash
export ZSHRC_D=~/.config/shell
[[ -r "${ZSHRC_D}/bootstrap" ]] && . "${ZSHRC_D}/bootstrap"
```

## Included Utilities

* **`shortcuts.sh`**:
  * `vvv [dir]`: Activates or initializes a Python virtualenv (`.venv` or `venv`).
  * `ggg <query>`: Fast case-insensitive recursive search (uses `rg` if available, falls back to `grep`).
  * `gitroot`: Navigates to the git repository root.
  * `gitprune`: Cleans up local branches whose remotes have been deleted.
  * `cleanbranches`: Deletes local branches that are already merged.
  * `uu`: Fetches and pulls current branch + default branch.
  * `remotecommitsage`: Lists remote branch age sorted by latest commit.
  * `viewlastdiff`: Shows git diff for the commit hash currently in your clipboard.
  * `lorem [n]`: Generates *n* lines of pseudo-text.
  * `flushdns` / `cleardns`: Flushes macOS DNS cache.
  * `textbanner <msg>`: Renders formatted banners using `pppppprint`, `toilet`, `figlet`, or standard formatting.
* **`imgs.sh`**:
  * `png2webp [quality]`: Recursively converts PNGs in the current directory to WebP (supports `cwebp`, `magick`, or `convert`).
* **`ip.sh`**:
  * `ip [address]`: Look up geolocation / ISP info for an IP (or your current IP) formatted with `jq`.
* **`pkg-size.sh`**:
  * `pkgSize <pkg>` / `pkgsize <pkg>`: Check npm package publish/install size via packagephobia.
* **`scenes.sh`**:
  * `scenes <video-file> [threshold]`: Extract scene transition frames using ffmpeg with safe temp files.
* **`pdfs.sh`**:
  * `pdffields <pdf>`: Lists form field names in a PDF.
  * `diffforms <pdf1> <pdf2>`: Compares form field differences between two PDFs.
* **`crash-report.sh`**:
  * `crashreport`: Saves current clipboard contents to a timestamped file in `~/Documents`.
