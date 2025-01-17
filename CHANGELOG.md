# FerriteMeshParser.jl changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Added
 - 

### Changed
 - create_faceset(grid, nodeset, ::Nothing) no longer supported, use create_faceset(grid, nodeset) instead

### Fixed


## [0.1.6]
### Fixed
 - Update to new Cell parameterization to work for Ferrite#master [#20][gh20]

## [0.1.5]
No usage change, but supports `Ferrite v0.4`

## [0.1.4]
### Changed
 - For a mixed grid, the celltype is a union of all concrete cell types in the grid instead of a single non-concrete type [#15][gh15]

## [0.1.3]
*Start of changelog*

[gh20]: https://github.com/Ferrite-FEM/FerriteMeshParser.jl/pull/20
[gh15]: https://github.com/Ferrite-FEM/FerriteMeshParser.jl/pull/15

[Unreleased]: https://github.com/Ferrite-FEM/FerriteMeshParser.jl/compare/v0.1.5...HEAD
[0.1.5]: https://github.com/Ferrite-FEM/FerriteMeshParser.jl/compare/v0.1.4...v0.1.5
[0.1.4]: https://github.com/Ferrite-FEM/FerriteMeshParser.jl/compare/v0.1.3...v0.1.4
[0.1.3]: https://github.com/Ferrite-FEM/FerriteMeshParser.jl/compare/v0.1.2...v0.1.3
