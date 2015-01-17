## my blog

**building**

```console
$ docker build --rm --force-rm -t jess/blog .
```

**testing locally**

```console
$ docker run --rm -it -v /home/jessie/blog:/src -p 8000:8000 jess/blog serve
```

**deploying**

```console
$ docker run --rm -it -v /home/jessie/blog:/src jess/blog deploy
```

