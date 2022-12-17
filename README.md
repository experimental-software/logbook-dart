# Logbook

[![Stability: Experimental](https://masterminds.github.io/stability/experimental.svg)](https://masterminds.github.io/stability/experimental.html)

The Logbook project provides a desktop and command-line application for chronological note taking.

## Setup

### Desktop app

**Linux**

To install the Logbook as desktop app, [Snapd](https://snapcraft.io/docs/installing-snapd) needs to be installed, first.
Then one can download the `snap` file from the [latest release on GitHub](https://github.com/experimental-software/logbook/releases/latest) and install in dev mode.

```sh
cd ~/Downloads
sudo snap install --devmode logbook_*_amd64.snap
```

### Command-line interface

To use the command-line interface of the Logbook app, the [Dart SDK](https://dart.dev/get-dart) needs to be installed, first.
Then one can clone the Git repository and globally activate the Logbook package.

⚠️ At the moment, only **Linux** and **macOS** are supported. Windows and other operating systems will not work.

```sh
git clone git@github.com:experimental-software/logbook.git

cd logbook/packages/logbook_cli
dart pub get
dart pub global activate --source path .
```

### Configuration

In the `~/.config/logbook/config.yaml` file it can be configured what directories are used for reading and writing log entries.

The following snippet shows the configuration options with their default values:

```yaml
# The directory where new log entries are added.
logDirectory: ~/Logs
# The directory where log entries are moved when they are archived.
archiveDirectory: ~/Archive
```

## Usage

TBD

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

## Alternative projects

- [Engineering Notebook](https://www.youtube.com/watch?v=xaFqpd7lNM4)
- [QOwnNote](https://www.qownnotes.org)
- [Emacs OrgMode](https://orgmode.org)
- [Evernote](https://evernote.com)
- [Roam Research](https://roamresearch.com)
- [Quiver](https://yliansoft.com/)
- [Notion](https://www.notion.so/product)
