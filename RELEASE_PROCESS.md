# Release Process

This is the process to follow to make a new release.
Similar to Semantic Version. The project refers to the respective components of this triple as `<major>.<minor>.<patch>`.

Steps:

1. Check the issue tracker milestone.
1. [Write release notes](#Write release notes)
1. [Change the hardcoded version in code **Mannaly**](#Change the hardcoded version in code **Mannaly**)
1. [Tag Version](#Tag Version)

## Write release notes

All release notes are always written on the `main` branch, and
copied into release branches in a later step.

Commit it with the message: "Update Release Note version XXX"

## Change the hardcoded version in code **Mannaly**

The code is at:

* README.md
* charts/Chart.yml

Commit it with the message: "Dump version vXXX"

## Tag Version

* Add a tag through git tag -s ${VERSION}.
* Push the tag to GitHub through git push origin tags/$VERSION.
  * The image and helm charts would release automanly
  * Merge the generated "Update index.yaml" PR **Mannaly**

### Brag about new release

Tweet, post to G+, slack, IRC, whatever. Make some noise, if it's
worth making noise about!
