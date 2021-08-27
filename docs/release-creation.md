# Making new releases

We are using Github Releases to mark new releases and provide pre-built bottles for users. You can track releases for LIGO itself here: https://gitlab.com/ligolang/ligo/-/releases.

To make a release after updating the formula:
1. Build a bottle for each macOS version you need.

   For macOS Catalina there is a Github Actions workflow that builds it on Github-hosted runners and exports it as an artifact.

   For any other version you should checkout the repository and run `./scripts/build-bottle.sh` script yourself. If you already have `ligo` formula installed with the same version, you may have to uninstall it first with `brew uninstall ligo`.
2. Add SHA256 hashes for bottles to the formula.
3. Make a release in Github, specifying LIGO version as a tag and attaching the bottles.
