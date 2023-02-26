# Logbook

[![Stability: Experimental](https://masterminds.github.io/stability/experimental.svg)](https://masterminds.github.io/stability/experimental.html)

The Logbook project provides a desktop and command-line application for chronological note taking.

## Setup

### Desktop app

**Linux**

The Logbook desktop app is distributed as compressed [tar](https://en.wikipedia.org/wiki/Tar_(computing)) file (`*.tgz`) containing the release output of the `flutter build linux` command.

It can be installed by downloading the `tgz` file from the [latest GitHub release](https://github.com/experimental-software/logbook/releases/latest), unpacking it, moving it into a custom installation directory, and creating a [Desktop file](./packages/logbook_app/tool/resources/logbookapp.desktop).

Those steps may be done automatically by executing the [install_linux.sh](./packages/logbook_app/tool/install_linux.sh) script:

```bash
./packages/logbook_app/tool/install_linux.sh -h
```

⚠️ Currently the Linux release gets only tested with **Ubuntu 22.04**.

### Command-line interface

To use the command-line interface of the Logbook app, the [Dart SDK](https://dart.dev/get-dart) needs to be installed, first.
Then one can clone the Git repository and globally activate the Logbook package.

```sh
git clone git@github.com:experimental-software/logbook.git

cd logbook/packages/logbook_cli
dart pub get
dart pub global activate --source path .
```

⚠️ Currently only **Linux** and **macOS** are supported.

### Configuration

In the `~/.config/logbook/config.yaml` file it can be configured what directories are used for reading and writing log entries.

The following snippet shows the configuration options with their default values:

```yaml
# The directory where new log entries are added.
logDirectory: ~/Logs
# The directory where log entries are moved when they are archived.
archiveDirectory: ~/Archive
# The path of a text editor (needs to start with "/usr/", e.g. "/usr/local/bin/code")
textEditor:
```

## Usage

**Add log entry**

A new log entry can be added with the `add` command an the log title as positional parameter.

```
$ logbook add "Hello, World!"
/Users/jdoe/Logs/2022/12/19/10.38_hello-world
```

The program will print out the directory that got created for the log entry.

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
NEW_VERSION= # e.g. 0.2.0

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
- [Obsidian](https://obsidian.md/)
- [Joplin](https://joplinapp.org/)
