# Release and rollback

## Authoritative branches

`main` is authoritative. A release branch must contain `main`; never publish from
a divergent branch. Protect `main` and require the CI workflow before merge.

## Release procedure

1. Merge `main` into the release branch and confirm no divergence.
2. Update `pubspec.yaml`, `CHANGELOG.md`, README examples, and native metadata.
3. Run all local quality commands and wait for the complete CI platform matrix.
   Run `dart pub outdated` and query OSV for every resolved direct dependency.
4. Run `dart pub publish --dry-run` and inspect the archive contents.
5. Publish once, tag the exact commit as `vX.Y.Z`, and push the tag.
6. Verify the pub.dev page and install the published version into a clean app.

GitHub's publish workflow can use pub.dev automated publishing after the
repository and `pub.dev` environment are authorized in pub.dev package settings.

## Rollback

pub.dev releases are immutable. For a severe regression, retract the affected
version in pub.dev immediately, document the reason, restore the last known-good
code from its tag, apply the minimum fix, and publish a new patch. Never overwrite
or reuse a version number.
