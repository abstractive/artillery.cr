# 0.0.1.14  2019-12-07 17:24 [ ECp4 ]
* Pull public directory from artillery.yml

# 0.0.1.14  2019-12-07 17:24 [ ECp4 ]
* Crystal 0.31.1 support updates

# 0.0.1.13  2019-12-07 16:25 [ ECp4 ]
* Updating to use fork of zeromq-crystal

# 0.0.1.12  2019-09-21 02:22 [ EFr7 ]
* Attempting to change handling of `body` on request.

# 0.0.1.10  2019-05-25 16:06 [ AHv6 ]
* Added --killall to bin/artillery

# 0.0.1.9   2019-05-25 16:06 [ AHv6 ]
* Disable `bin/art` executable for now
* Add `artillery.yaml` support for basic defaults

# 0.0.1.7   2019-05-10 19:51 ( 8Nf9 )
* Tweak [README.md](README.md) to point to [ZEROMQ.md](ZEROMQ.md) setup walkthrough for `ZeroMQ` in Ubuntu-like environments.

# 0.0.1.6   2019-05-10 18:15 ( 8Nf9 )
* Fix --port-zeromq= parameter.

# 0.0.1.5   2019-05-10 18:05 ( 8Nf9 )
* Overhaul bin/artillery to use --port-http= --port-zeromq= --zeromq= ( schema ) --ip= ( exposed interface )
* Now it's possible to start independent clusters, and killing one doesn't affect the others on the same machine
* Adapt defaults for most constants / environment variables to pull from exports in bin/artillery, and artillery.yml in future

# 0.0.1.1   2019-05-10 16:49 ( 8Nf9 )
* Cleaned up, and added offset capability so that Artillery doesn't need to be installed in its own shard to run; if code present, use
* Prepared for near future when bin/artillery can be added to $PATH, and is aware of where its codebase exists relative to PWD
* Working examples in examples/demo as well as the abstractive/compass application being deployed live, then adding proactive/presence

# 0.0.1.0   2019-05-10 15:51 ( 8Nf9 )
* FINALLY: Resolved the phantom issues and entanglements of Crystal vs. Bash interactions, overcoming Crystal nuances
* bin/artillery script shaping up to be good control script, and usable in PWD context
* Turned off debugging excess, trimming and cleaning
* Major version increase; still alpha

# 0.0.0.31  2019-05-10 12:46 ( 8Nf9 )
* Found the issue. There were old Launchers running on this development environment. Sigh.
* Suppress bin/artillery errors if PIDs already dead

# 0.0.0.30  2019-05-10 12:35 ( 8Nf9 )
* Fix path in require statement

# 0.0.0.29  2019-05-10 12:31 ( 8Nf9 )
* Still chasing phantom object showing up but cannot possibly exist. The HelloWorld apocalypse
* Trim out artillery/bazooka.cr and include all elements in artillery.cr; bazooka becomes only an argument

# 0.0.0.28  2019-05-10 11:52 ( 8Nf9 )
* Fighting with wierd issue where Shots are persisting for no apparent reason.
* Add redirect support

# 0.0.0.27  2019-05-10 09:32 ( 8Nf9 )
* Become ghetto fabulous about Bazooka and use bash to parallelize vs. using fibers.
* Struggling to get invoked properly in roaming PWD

# 0.0.0.26  2019-05-10 09:32 ( 8Nf9 )
* Restructure examples/demo as example of `bazooka` invokation

# 0.0.0.25  2019-05-10 09:18 ( 8Nf9 )
* Provide src/artillery/bazooka and bin/bazooka
* Update bin/artillery to launch PWD as bazooka instance

# 0.0.0.24  2019-05-10 09:08 ( 8Nf9 )
* Fix permissions of bin/ commands

# 0.0.0.23  2019-05-10 09:06 ( 8Nf9 )
* Previous issue was that `Crystal` needs shards tagged with "v" prepended to version
* Fixed .gitignore that was removing `art` commands and `artillery`

# 0.0.0.22  2019-05-10 07:39 ( 8Nf9 )
* Show three sample installations in README.md before making the options actually work
* Add `artillery` CLI placeholder

# 0.0.0.21  2019-05-10 03:31 ( 7Mf8 )
* Clean up examples

# 0.0.0.20  2019-05-10 02:52 ( 7Mf8 )
* Massive dive into Crystal internals and returned alive
* Completed #19 and #20, essentially making this usable to start writing programs with
* Closes #10 by searching with Radix::Tree for what Shot to call

# 0.0.0.15  2019-05-09 20:00 ( 7Mf8 )
* Refactor Projectile to Shot per #14
* Rename src/run/ to src/processes/
* Attempt to fix #18 with discovery of port issue, but likely not a fix
* Yeah, it didn't work
* Added scripts/remake.sh to build bin/ processes

# 0.0.0.14  2019-05-09 19:30 ( 7Mf8 )
* Giving up on #18 for now

# 0.0.0.13  2019-05-09 18:40 ( 7Mf8 )
* Never Forget 5/9 // Mr. Robot
* Fixed versions for previous two entries
* Added Dockerfile.* and docker-compose.yml per #18
* Added first scripts per #18 also, need to test further
* Still debugging ZeroMQ issues for Docker containers
* Containers seem to build now, testing run

# 0.0.0.11  2019-05-07 14:08 ( 5Kf6 )
* Renamed `mount` to `mointpoint` for clarity, and lack of conflict with system binary.
* Clean up some expensive `puts` activity
* Prepare basic Dockerfile start points

# 0.0.0.10  2019-05-07 14:08 ( 5Kf6 )
* Added minimal benchmarking.

# 0.0.0.9   2019-05-07 13:31 ( 5Kf6 )
* Catch failure of socket and reset for `Launcher` and `Mountpoint` per #9
* Refactor `Projectile` toward storing routes differently in `Launcher`
* Beginning of `Projectile.vectors` leading to radix tree next
* Logger extends self

# 0.0.0.7   2019-05-07 11:24 ( 5Kf6 )
* Put in, wrestled with, and then ripped out msgpack.
* Tidied up, no tests at this early stage though as I figure out what even works.

# 0.0.0.4   2019-05-07 02:25 ( 4Jf5 )
* Anticipate `nginx` setup process
* Add failing tests for `Mountpoint`, `Launcher`, and `Projectile`
* Add `Logger` module skeleton

# 0.0.0.3   2019-05-07 00:47 ( 4Jf5 )
* Routing of HTTP from `mountpoint` through ZeroMQ to `launchers`

# 0.0.0.2   2019-05-07 00:24 ( 4Jf5 )
* Examples minimally testing ZeroMQ
* Instructions to setup ZeroMQ

# 0.0.0.1   2019-05-06 23:47 ( 4Jf5 )
* Initial releases of empty shard