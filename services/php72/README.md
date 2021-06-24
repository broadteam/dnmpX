### 开发版 vs 正式版 区别

`开发版`：占用空间比较大！用于在基础镜像上编译安装扩展等，编译好后会把扩展复制到当前目录下的`extension`文件夹下。

`正式版`：占用空间小！用于日常镜像。

### 构建方法

切换到当前目录下，然后：


```
docker build -t php72-fpm:latest ./
```


##### 构建开发版：

```
docker build -f ./build.Dockerfile -t php72-fpm:develop ./
```

##### 开发版构建好后复制扩展文件：

```
docker cp e80e6362b20e:/usr/local/lib/php/extensions/no-debug-non-zts-20170718/pack.tar.gz ./extension/
```
