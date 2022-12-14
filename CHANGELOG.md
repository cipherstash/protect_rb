# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Unreleased

## [0.3.0]

### Added

- Create and update operation using bloom filters.
- Text match querying using bloom filters.
- Rake task to generate precision and recall statistics for text match querying.

### Fixed

- Ngram tokenization to use min and max length.

## [0.2.0]

### Fixed

- Filenames and module namespacing, now that this gem is called `cipherstash-protect`.

## [0.1.0]

### Added

- Installation scripts to install custom db ore type.
- Enable CRUD operations on encrypted columns.
