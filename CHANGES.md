# v201912102339-1Gg7 0.0.1.20
* Fix --clear behavior

# v201912101938-1Gg7 0.0.1.19
* Change method of overriding shots/ so that Artillery can still filter its paths properly

# v201912101825-1Gg7 0.0.1.18
* Allow override of shots location and base require ( allows for `Stellar` control of `Artillery` )

# v201912080930-UDp5 0.0.1.17
* --clear option to reset Crystal environment under `eval` handling

# v201912080912-UDp5 0.0.1.16
* Fix linefeeds on bin/* files, and do not send a default public/ directory from bin/artillery script

# v201912071857-ECp4 0.0.1.15
* Pull public directory from artillery.yml

# v201912071724-ECp4 0.0.1.14
* Crystal 0.31.1 support updates

# v201912071625-ECp4 0.0.1.13
* Updating to use fork of zeromq-crystal

# v201909210222-EFr7 0.0.1.12
* Attempting to change handling of `body` on request.

# v201905251606-AHv6 0.0.1.10
* Added --killall to bin/artillery

# v201905251606-AHv6 0.0.1.9
* Disable `bin/art` executable for now
* Add `artillery.yaml` support for basic defaults

# v201905101951-8Nf9 0.0.1.7
* Tweak [README.md](README.md) to point to [ZEROMQ.md](ZEROMQ.md) setup walkthrough for `ZeroMQ` in Ubuntu-like environments.

# v201905101815-8Nf9 0.0.1.6
* Fix --port-zeromq= parameter.

# v201905101805-8Nf9 0.0.1.5
* Overhaul bin/artillery to use --port-http= --port-zeromq= --zeromq= ( schema ) --ip= ( exposed interface )
* Now it's possible to start independent clusters, and killing one doesn't affect the others on the same machine
* Adapt defaults for most constants / environment variables to pull from exports in bin/artillery, and artillery.yml in future

# v201905101649-8Nf9 0.0.1.1
* Cleaned up, and added offset capability so that Artillery doesn't need to be installed in its own shard to run; if code present, use
* Prepared for near future when bin/artillery can be added to $PATH, and is aware of where its codebase exists relative to PWD
* Working examples in examples/demo as well as the abstractive/compass application being deployed live, then adding proactive/presence

# v201905101551-8Nf9 0.0.1.0
* FINALLY: Resolved the phantom issues and entanglements of Crystal vs. Bash interactions, overcoming Crystal nuances
* bin/artillery script shaping up to be good control script, and usable in PWD context
* Turned off debugging excess, trimming and cleaning
* Major version increase; still alpha

# v201905101246-8Nf9 0.0.0.31
* Found the issue. There were old Launchers running on this development environment. Sigh.
* Suppress bin/artillery errors if PIDs already dead

# v201905101235-8Nf9 0.0.0.30
* Fix path in require statement

# v201905101231-8Nf9 0.0.0.29
* Still chasing phantom object showing up but cannot possibly exist. The HelloWorld apocalypse
* Trim out artillery/bazooka.cr and include all elements in artillery.cr; bazooka becomes only an argument

# v201905101152-8Nf9 0.0.0.28
* Fighting with wierd issue where Shots are persisting for no apparent reason.
* Add redirect support

# v201905100932-8Nf9 0.0.0.27
* Become ghetto fabulous about Bazooka and use bash to parallelize vs. using fibers.
* Struggling to get invoked properly in roaming PWD

# v201905100932-8Nf9 0.0.0.26
* Restructure examples/demo as example of `bazooka` invokation

# v201905100918-8Nf9 0.0.0.25
* Provide src/artillery/bazooka and bin/bazooka
* Update bin/artillery to launch PWD as bazooka instance

# v201905100908-8Nf9 0.0.0.24
* Fix permissions of bin/ commands

# v201905100906-8Nf9 0.0.0.23
* Previous issue was that `Crystal` needs shards tagged with "v" prepended to version
* Fixed .gitignore that was removing `art` commands and `artillery`

# v201905100739-8Nf9 0.0.0.22
* Show three sample installations in README.md before making the options actually work
* Add `artillery` CLI placeholder

# v201905100331-7Mf8 0.0.0.21
* Clean up examples

# v201905100252-7Mf8 0.0.0.20
* Massive dive into Crystal internals and returned alive
* Completed #19 and #20, essentially making this usable to start writing programs with
* Closes #10 by searching with Radix::Tree for what Shot to call

# v201905092000-7Mf8 0.0.0.15
* Refactor Projectile to Shot per #14
* Rename src/run/ to src/processes/
* Attempt to fix #18 with discovery of port issue, but likely not a fix
* Yeah, it didn't work
* Added scripts/remake.sh to build bin/ processes

# v201905091930-7Mf8 0.0.0.14
* Giving up on #18 for now

# v201905091840-7Mf8 0.0.0.13
* Never Forget 5/9 // Mr. Robot
* Fixed versions for previous two entries
* Added Dockerfile.* and docker-compose.yml per #18
* Added first scripts per #18 also, need to test further
* Still debugging ZeroMQ issues for Docker containers
* Containers seem to build now, testing run

# v201905071408-5Kf6 0.0.0.11
* Renamed `mount` to `mointpoint` for clarity, and lack of conflict with system binary.
* Clean up some expensive `puts` activity
* Prepare basic Dockerfile start points

# v201905071408-5Kf6 0.0.0.10
* Added minimal benchmarking.

# v201905071331-5Kf6 0.0.0.9
* Catch failure of socket and reset for `Launcher` and `Mountpoint` per #9
* Refactor `Projectile` toward storing routes differently in `Launcher`
* Beginning of `Projectile.vectors` leading to radix tree next
* Logger extends self

# v201905071124-5Kf6 0.0.0.7
* Put in, wrestled with, and then ripped out msgpack.
* Tidied up, no tests at this early stage though as I figure out what even works.

# v201905070225-4Jf5 0.0.0.4
* Anticipate `nginx` setup process
* Add failing tests for `Mountpoint`, `Launcher`, and `Projectile`
* Add `Logger` module skeleton

# v201905070047-4Jf5 0.0.0.3
* Routing of HTTP from `mountpoint` through ZeroMQ to `launchers`

# v201905070024-4Jf5 0.0.0.2
* Examples minimally testing ZeroMQ
* Instructions to setup ZeroMQ

# v201905062347-4Jf5 0.0.0.1
* Initial releases of empty shard