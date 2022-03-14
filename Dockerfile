# 指定基础镜像，必须为第一个命令
FROM golang:alpine AS builder

# 工作目录，类似于cd命令
# 通过WORKDIR设置工作目录后，Dockerfile中其后的命令RUN、CMD、ENTRYPOINT、ADD、COPY等命令都会在该目录下执行
WORKDIR /build

ADD go.mod .
# 将本地文件添加到容器中，tar类型文件会自动解压(网络压缩资源不会被解压)，可以访问网络资源，类似wget
# 功能类似ADD，但是是不会自动解压文件，也不能访问网络资源
COPY . .

# 构建镜像时执行的命令, docker build
RUN go build -o main main.go

FROM alpine

WORKDIR /build
COPY --from=builder /build/main /build/main

# 构建容器后调用，也就是在容器启动时才进行调用
CMD ["./main"]
