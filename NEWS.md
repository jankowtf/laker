# laker 0.0.0.9004 (2022-08-13)

link_data_lake()

- Added `link_data_lake()` as a user-friendly wrapper around `fs_create_symlink()`
- Modified `fs_create_symlink()`: added argument `is_interactive` to enable non-interative execution

----------

# laker 0.0.0.9003 (2022-03-26)

- Switched default of `subdirs` in `fs_create_symlink()`
- Took `fs_create_symlink()` out of `onAttach()`

# laker 0.0.0.9002

Env, return value, README

- Exported `env_data_catalog()`.
- Change return value of `layer_ingest()`. It now returns the actual data frame
instead of the path. I don't think it's the final solution yet but I "needed" to
do it that way in order to have `{laker}` play nicely with the dependency rules
of `{targets}`.
- Fleshed out the `README` a bit.

# laker 0.0.0.9001

GitHub dependencies

- Added GitHub dependency `rappster/valid`
- Added GitHub dependency `rappster/confx`
- Added GitHub dependency `rappster/clix`
- Added GitHub dependency `rappster/pops`

# laker 0.0.0.9000

Initial commit
