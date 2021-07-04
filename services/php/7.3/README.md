### 单个项目构建方法

切换到当前目录下，然后：

```
docker build -t php:7.3.22-fpm-alpine ./
```

Options 常用参数：

- -t: 打包出镜像的名称及标签，通常写法为 name:tag
- --rm: 构建成功后，删除中间产生的容器。
- --force-rm=true: 无论是否构建成功，都删除中间产生的容器
- --no-cache: 构建镜像时不使用缓存。
- -f: 指定 DockerFile 的路径

```
docker build --force-rm --no-cache -t php:7.3.22-fpm-alpine .
```
