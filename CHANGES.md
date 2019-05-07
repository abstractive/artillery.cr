# 0.0.0.9 2019-05-07 13:31 ( 5Kf6 )

- Catch failure of socket and reset for `Launcher` and `Mount` per #9
- Refactor `Projectile` toward storing routes differently in `Launcher`
- Beginning of `Projectile.vectors` leading to radix tree next
- Logger extends self

# 0.0.0.7 2019-05-07 11:24 ( 5Kf6 )

- Put in, wrestled with, and then ripped out msgpack.
- Tidied up, no tests at this early stage though as I figure out what even works.

# 0.0.0.4 2019-05-07 02:25 ( 4Jf5 )

- Anticipate `nginx` setup process
- Add failing tests for `Mount`, `Launcher`, and `Projectile`
- Add `Logger` module skeleton

# 0.0.0.3 2019-05-07 00:47 ( 4Jf5 )

- Routing of HTTP from `mount` through 0MQ to `launchers`

# 0.0.0.2 2019-05-07 00:24 ( 4Jf5 )

- Examples minimally testing 0MQ
- Instructions to setup 0MQ

# 0.0.0.1 2019-05-06 23:47 ( 4Jf5 )

- Initial releases of empty shard