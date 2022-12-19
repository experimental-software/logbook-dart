# Logbook

[![Stability: Experimental](https://masterminds.github.io/stability/experimental.svg)](https://masterminds.github.io/stability/experimental.html)

The Logbook project provides a desktop and command-line application for chronological note taking.

## Setup

### Desktop app

**Linux**

To use the Logbook desktop app, [Snapd](https://snapcraft.io/docs/installing-snapd) needs to be installed, first.
Then download the `snap` file from the [latest release on GitHub](https://github.com/experimental-software/logbook/releases/latest) and install it in dev mode.

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

⚠️ On Linux, due to the Snap security restrictings, the log and archive directories need to be under the `/home` directory.

## Usage

**Add log entry**

A new log entry can be added with the `add` command an the log title as positional parameter.

```
$ logbook add "Hello, World!"
/Users/jdoe/Logs/2022/12/19/10.38_hello-world
```

**Search log entries**

With the help of the `search` command, the logs can be found. If no search term gets provided, all available log entries are listed.

```
$ logbook search
+------------------+----------------+-----------------------------------------------+
| Time             | Title          | Path                                          |
+------------------+----------------+-----------------------------------------------+
| 2022-12-19 10:38 | Hello, World!  | /Users/jdoe/Logs/2022/12/19/10.38_hello-world |
+------------------+----------------+-----------------------------------------------+
```

**Details**

For an overview over all the options, call the `logbook` program and/or the respective sub-command with the `--help` flag.

```
$ logbook -h
$ logbook add -h
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
NEW_VERSION= # e.g. 0.1.4

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
