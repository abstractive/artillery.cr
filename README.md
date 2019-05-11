# artillery.cr

[![GitHub release](https://img.shields.io/github/release/abstractive/artillery.cr.svg)](https://github.com/abstractive/artillery.cr/releases)

## Work In Progress

This implementation of [`Artillery`](https://github.com/abstractive/artillery) is the reference implementation for the other languages at present, until another language or language platform can out-perform `Crystal` in the wild. `Crystal` feels perfect as the language to start from because it's almost _designed_ for writing microservices.


## Ignore Documentation

All information about this exists in [Issues](https://github.com/abstractive/artillery.cr/issues) and code itself primarily, by way of implication; as well as in [delimiter chambers](https://github.com/delimiterchambers) discussions. Reach out if you have questions or want to contribute.

---

## Preparation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     artillery:
       github: abstractive/artillery.cr
   ```

2. Run `shards install`


## Invokation

`Artillery` can be invoked several ways; here are three:

### Local environment, using the nimble but effective `Bazooka` style [ Working ]

From within a clone of a projectile repository you want to activate run this commands:

```
$ bin/artillery --bazooka
```

### Cloud deployment of a `Mountpoint` and several `Launcher` instances [ Pending* ]

In `artillery.yml`, include the following:

```yaml
projectile:
  environment:
    production:
      domains:
        - artillery.cloud
      launchers: 3
    development:
      launchers: 3
```

Then, run the following in the root of the repository, wherever it is checked out:

```
$ sudo artillery
```

### Local deployment of a `Mountpoint` and several `Launcher` instances [ Pending* ]

In `artillery.yml`, include the following:

```yaml
projectile:
  environment:
    development:
      launchers: 3
```

Then, run the following in the root directory of your local environment:

```
$ sudo artillery development
```

### Other configurations:

Details coming.

### Pending Invokations:

> Right now the `Docker` cluster configurations are broken, but it is mostly there. Once resolved, the remaining invokation styles will be available quickly thereafter, and will provide reduncancy, load-balancing, etc. The `Bazooka` demonstrates the concept, then down the line it will remain as the primary means of doing local development using the exact infrastructure `Shot` instances are deployed to in public.

---

Currently and foreseeably MIT licensed, because if you want code without people, and you want to run off with the benefit of community work, good riddance anyway. Otherwise, do what you're going to do, and if you've got too much going on to contribute, you're probably making a contribution to the world some other way. But don't be a stranger. This code is intended to bring people together.

---

**Developed by [digitalextremist //](https://github.com/digitalextremist)** in partnership with [abstractive labs](https://github.com/abstractive), facilitated by [delimiter chambers](http://github.com/delimiterchambers).
