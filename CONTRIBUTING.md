# Contributing to the Jentic API AI-Readiness Framework

We welcome contributions from the community. Whether you're reporting bugs, suggesting improvements, or submitting changes, your input helps strengthen this framework for everyone.

## How to Contribute

### Reporting Issues

Found a problem or have a suggestion? Open an issue on GitHub:

- **Bug reports**: Describe the issue, expected behaviour, and steps to reproduce
- **Feature requests**: Explain the use case and why it would benefit the framework
- **Documentation improvements**: Point out gaps, errors, or areas needing clarification

Before opening a new issue, search existing issues to avoid duplicates.

### Contributing Code

We accept pull requests for bug fixes, documentation improvements, and new features. For substantial changes, open an issue first to discuss your approach before investing significant time.

**Types of contributions:**

- **Documentation**: Clarifications, corrections, and examples are always welcome
- **Bug fixes**: If the fix is straightforward, submit a PR directly. For complex issues, discuss in an issue first
- **New features**: Must be discussed in an issue before PR submission to ensure alignment with framework goals

### Pull Request Process

1. **Create an issue** describing the problem or feature (unless it's a trivial fix)
2. **Fork the repository** and create a branch from `main`
3. **Make your changes** with clear, focused commits
4. **Test your changes** to ensure they work as intended
5. **Submit a pull request** referencing the related issue
6. **Respond to feedback** during the review process

Keep PRs small and focused. Large changes should be broken into multiple PRs when possible.

## Coding Guidelines

### Branch Naming

Use descriptive branch names with prefixes:

- `feature/` for new features
- `fix/` for bug fixes

Optionally include the issue number: `fix/123-typo-in-spec`

### Commit Messages

Write clear, atomic commits that represent logical units of change:

- Use present tense, imperative mood: "Add scoring algorithm" not "Added" or "Adds"
- Keep subject lines under 69 characters
- Reference issues using `Refs #<issue-number>` in the commit body
- Follow [Conventional Commits](https://www.conventionalcommits.org/) format when possible

**Examples:**

```text
docs: fix typo in specification section 4.2

Refs #42
```

```text
feat: add usability scoring dimension

Implements new scoring logic for agent usability metrics.

Refs #127
```

### Merging

Maintainers will typically use "Squash and merge" to keep the commit history clean. The squashed commit will follow Conventional Commits format.

## Code of Conduct

All contributors must follow our [Code of Conduct](CODE_OF_CONDUCT.md). We're committed to providing a welcoming, safe, and respectful environment for everyone.

## Questions?

- Open a [GitHub Discussion](../../discussions) for general questions
- Comment on existing issues for specific topics
- Reach out to maintainers listed in [MAINTAINERS.md](MAINTAINERS.md)

## Recognition

Contributors are recognized in the project history through commit attribution and acknowledgment in release notes.

Thank you for contributing to the Jentic API AI-Readiness Framework!
