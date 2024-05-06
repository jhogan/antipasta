# Antipasta

Antipasta is a Perl-based tool designed to parse, analyze, and transform legacy
IMS/BASIC source code into a structured, object-oriented model. This
transformation facilitates easier maintenance, refactoring, and understanding
of traditional GOTO-style spaghetti code, making it more accessible for modern
programming techniques and environments.

## Features

- **Code Parsing**: Converts raw BASIC code into a structured, navigable object model.
- **Code Analysis**: Provides tools for analyzing and understanding the flow and dependencies within the codebase.
- **Refactoring Support**: Aids in the refactoring process to replace outdated patterns with more modern, maintainable constructs.
- **Legacy Integration**: Enables easier integration of legacy code with modern systems, preserving vital business logic while updating the technological stack.

## Getting Started

### Prerequisites

- Perl 5.10 or higher
- Additional Perl modules (list any specific modules needed, such as `Moose` for object-oriented programming)

## Module breakdown

* `col.pm`: Collection super class for object management.
* `Generic.pm`: Generic parsing utilities for language processing.
* `Line.pm / Lines.pm`: Manage individual and collections of BASIC source code lines.
* `Mod.pm / Mods.pm`: Abstracts BASIC modules and collections of these modules.
* `Sub.pm / Subs.pm`: Manages BASIC "gosub" subroutines and their collections.
* `Var.pm / Vars.pm`, `VarInstance.pm` / VarInstances.pm`: Handle variable declarations and instances across the BASIC program.

## Contributing

Contributions to Antipasta are welcome! Please read CONTRIBUTING.md for details
on our code of conduct, and the process for submitting pull requests to us.
License

## LICENSE
This project is licensed under the MIT License - see the LICENSE.md file for details.

## Acknowledgments

* Thank you to all the contributors who spend time to help preserve and
maintain old software systems.

* Special thanks to those dedicated to educating and documenting legacy systems
for the modern era.

This `README.md` file provides a general overview of the project, how to get
started, and how to use the program. Be sure to update any specifics like links
to repositories, more detailed instructions based on your setup, and any other
important notes that users might need to know before using or contributing to
Antipasta.
