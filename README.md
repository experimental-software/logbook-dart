# Logbook

The logbook project provides a desktop and command-line application for chronological note taking.

🚧 This project is not generally usable, yet. E.g. it assumes the availabilty of certain user directories and installed binaries. 🚧

## Introduction

### Unique value proposition

- The simplicity of the tool enables to focus on subject to be worked on.
- It has been built to support work which requires intensive learning on the job.

### Alternative projects

- [Engineering Notebook](https://www.youtube.com/watch?v=xaFqpd7lNM4)
- [QOwnNote](https://www.qownnotes.org)
- [Emacs OrgMode](https://orgmode.org)
- [Evernote](https://evernote.com)
- [Roam Research](https://roamresearch.com)
- [Quiver](https://yliansoft.com/)

## Setup

```
./install.sh
```

## Development

### Check test coverage

Given `lcov` has been install via Homebrew or Apt, the test coverage report can be generated like this:

```
./tool/create_test_coverage_report.sh
```

## Maintenance

### Create release

```
NEW_VERSION= # e.g. v0.0.9

git tag $NEW_VERSION
git push origin --tag $NEW_VERSION
```
