# Contributing

Create changes from `main`; use `dev` only for an explicitly coordinated release
candidate. Every change requires a focused test and must pass the commands in
the README development section.

Platform-channel changes must update Dart, Linux, macOS, and Windows together.
Document unsupported platforms explicitly instead of allowing a method to fall
through silently. Pull requests that alter public behavior must update the
README and changelog.

Do not commit generated build directories, local signing identities, secrets,
or unversioned native binaries.
