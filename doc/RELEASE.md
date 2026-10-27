# Release and rollback

## Authoritative branches

`main` is authoritative. A release branch must contain `main`; never publish from
a divergent branch. Protect `main` and require the CI workflow before merge.

## Release procedure

1. Merge the release changes to `main` and confirm no divergence.
2. Update `pubspec.yaml`, `CHANGELOG.md`, README examples, and native metadata.
3. Run all local quality commands and wait for the complete CI platform matrix
   to pass on the exact release commit.
   Run `dart pub outdated` and query OSV for every resolved direct dependency.
4. Run `dart pub publish --dry-run` and inspect the archive contents.
5. Tag the verified commit as `vX.Y.Z` and push the tag. The publish workflow
   rejects tags that do not match `pubspec.yaml`, lack a dated changelog entry,
   have no successful CI run for the exact commit, or fail the OSV scan.
6. Approve the protected `pub.dev` environment deployment. The workflow repeats
   analysis, tests, coverage, and package validation before publishing.
7. Verify the pub.dev page and install the published version into a clean app.

The repository and protected `pub.dev` environment must be authorized in the
pub.dev automated-publishing settings.

## Rollback

pub.dev releases are immutable. For a severe regression, retract the affected
version in pub.dev immediately, document the reason, restore the last known-good
code from its tag, apply the minimum fix, and publish a new patch. Never overwrite
or reuse a version number.
