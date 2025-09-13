# ========= build stage (JDK 17) =========
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /src

# 仅拷贝 POM 以命中依赖缓存（根 POM + yudao-server 的 POM）
COPY pom.xml .
COPY yudao-server/pom.xml yudao-server/pom.xml
RUN mvn -q -DskipTests dependency:go-offline || true

# 再拷贝完整源码，仅构建 yudao-server（-am 会把依赖子模块一起编译）
COPY . .
RUN mvn -q -DskipTests clean package -pl yudao-server -am && \
    cp yudao-server/target/*.jar /out/app.jar

# ========= run stage (JRE 17) =========
FROM eclipse-temurin:17-jre
ENV TZ=Asia/Shanghai \
    JAVA_OPTS="-Xms512m -Xmx512m"
WORKDIR /app
COPY --from=build /out/app.jar app.jar
EXPOSE 48080
ENTRYPOINT ["sh","-c","java ${JAVA_OPTS} -Djava.security.egd=file:/dev/./urandom -jar app.jar"]
