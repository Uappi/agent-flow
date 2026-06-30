# Contributing

Thank you for your interest in contributing to the Agent Starter Kit! This guide will help you understand how to effectively contribute to this repository.

## Getting Started

Before submitting any changes, please discuss your proposed modifications with the repository maintainers by opening an issue. This step is crucial to ensure that your contributions align with the project's goals and to avoid duplicating efforts.

The Agent Starter Kit is a **foundation** — a minimal, unopinionated scaffold that any developer can clone and extend for their own project. Contributions should reinforce this philosophy:

- **Keep it general.** Skills, rules, and personas must serve the workflow of an average developer. Domain-specific or highly opinionated additions belong in your own fork, not here.
- **Keep it minimal.** Every file added is context every user pays for. If a contribution doesn't clearly benefit the common case, it doesn't belong in the starter kit.

We value meaningful contributions that substantively improve the project. Please focus on quality over quantity — contributions should address real needs or enhancement opportunities rather than superficial changes. **Proposals that appear primarily aimed at gaining contributor status without adding significant value will be declined.**

## Code of Conduct

Our community values respectful and inclusive collaboration. We strive to make participation a positive experience for everyone, regardless of background, identity, or experience level.

As a contributor, we ask that you:

- Treat others with respect and kindness;
- Show empathy in your interactions;
- Be receptive to constructive feedback;
- Take responsibility for mistakes and use them as learning opportunities.

Unacceptable behaviors may include, but are not limited to:

- Harassment, bullying, or intimidation;
- Discriminatory or offensive comments;
- Unwelcome attention or remarks;
- Sharing private information without permission.

If you witness or experience inappropriate behavior, please contact the maintainers at legal _at_ goinfinite.net. All reports will be reviewed and addressed appropriately.

Enforcement actions from correction to permanent bans will be taken depending on the severity of the violation.

## Licensing

This project is released under the MIT License. By contributing, you agree that your submissions will be governed by this license.

## What We Don't Accept

- **Provider list updates.** The models in `skills/dispatch.md` are examples, not a registry. All personas default to `host` — the provider list only matters when a user customizes away from it. We intentionally keep one entry per CLI to minimize maintenance. If you want a different model, edit your fork's `skills/dispatch.md` — no PR needed.
- **Adding new providers or models.** We will not accept issues or PRs that add new model entries to the Providers block. The starter kit is a foundation — customize it in your own fork.

## Pull Request Guidelines

When submitting pull requests, please follow these steps:

- Open an issue first to discuss the change — unsolicited PRs without prior discussion may be declined;
- One logical change per PR. Do not bundle unrelated modifications;
- Follow the existing file schemas — every directory has a `README.md` that defines the expected frontmatter and sections for its files;
- Update the `CHANGELOG.md` with a concise entry describing your change;
- Increment the `version` and `lastUpdated` fields in the frontmatter of every file you modify;
- Follow the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) specification for every commit message;
- Ensure your changes do not break the boot sequence — test by running the framework in a sample project;
- Obtain approval from two reviewers before merging. If you lack merge permissions, the second reviewer can complete the merge for you.

By following these guidelines, you help maintain project quality and consistency while making contributions valuable to the community.
