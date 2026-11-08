# Homebrew repository for krunkit (deprecated)

> [!WARNING]
> **This tap is deprecated and no longer updated** (it is stuck at krunkit 1.1.1, which does
> not work with Podman 6). krunkit and its dependencies are now published in
> [`slp/krun`](https://github.com/slp/homebrew-krun).
>
> To migrate, remove everything installed from this tap, then install from the new one:
>
> ```
> brew list --full-name | grep "^slp/krunkit/" | xargs brew uninstall
> brew untap slp/krunkit
> brew tap slp/krun
> brew install krunkit
> ```

This was the Homebrew repository for [krunkit](https://github.com/libkrun/krunkit/) and its dependencies.

## Supported platforms

The formulae and bottles on this repository only support Apple Silicon-based devices (M1 family).

## How do I install krunkit?

Use the maintained tap — see the notice above or the
[krunkit installation docs](https://github.com/libkrun/krunkit#installation).
