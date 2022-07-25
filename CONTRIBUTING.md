# Contributing

We would ❤️ for you to contribute to Appwrite and help make it better! As a contributor, here are the guidelines we would like you to follow:

## Code of Conduct

Help us keep Appwrite open and inclusive. Please read and follow our [Code of Conduct](/CODE_OF_CONDUCT.md).

## Submit a Pull Request 🚀


Branch naming convention is as following

`TYPE-ISSUE_ID-DESCRIPTION`

example:

```
doc-548-submit-a-pull-request-section-to-contribution-guide
```

When `TYPE` can be:

- **feat** - is a new feature
- **doc** - documentation only changes
- **cicd** - changes related to CI/CD system
- **fix** - a bug fix
- **refactor** - code change that neither fixes a bug nor adds a feature

**All PRs must include a commit message with the changes description!**

For the initial start, fork the project and use git clone command to download the repository to your computer. A standard procedure for working on an issue would be to:

1. `git pull`, before creating a new branch, pull the changes from upstream. Your master needs to be up to date.

```
$ git pull
```

2. Create new branch from `master` like: `doc-548-submit-a-pull-request-section-to-contribution-guide`<br/>

```
$ git checkout -b [name_of_your_new_branch]
```

3. Work - commit - repeat ( be sure to be in your branch )

4. Before you push your changes, make sure your code follows the `Rustfmt` coding standards , which is the standard Appwrite follows currently. You can easily do this by running the formatter.

```bash
cargo fmt
```

If the `cargo fmt` command does not work then run the following to install rustfmt:

```bash
rustup component add rustfmt
```

This will give you a list of errors for you to rectify

1. Push changes to GitHub

```
$ git push origin [name_of_your_new_branch]
```

6. Submit your changes for review
   If you go to your repository on GitHub, you'll see a `Compare & pull request` button. Click on that button.
7. Start a Pull Request
   Now submit the pull request and click on `Create pull request`.
8. Get a code review approval/reject
9. After approval, merge your PR
10. GitHub will automatically delete the branch after the merge is done. (they can still be restored).


## Running Tests
Tests are run with Docker in order to test both alpine builds and GNU linux builds, Docker Compose is also required.

Bring up the testing containers using:
```bash
docker compose up -d --force-recreate --build
```

Then run the tests using
```bash
docker compose exec -T tests_gnu sh -c "cd /src/ && /src/vendor/bin/phpunit"

docker compose exec -T tests_alpine sh -c "cd /src/ && /src/vendor/bin/phpunit"
```

The first command tests GNU based machines and the second one tests alpine, both must pass before the PR is merged.