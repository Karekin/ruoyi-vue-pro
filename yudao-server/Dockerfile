# ========= build stage (JDK 17) =========
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /src

# 先拷 POM 命中缓存（根 POM + 所有 yudao-* 子模块的 POM，避免 go-offline 报模块缺失）
COPY pom.xml .
COPY yudao-*/pom.xml yudao-*/pom.xml
RUN mvn -q -B -DskipTests -pl yudao-server -am dependency:go-offline || true

# 再拷完整源码，仅构建 yudao-server（-am 会把依赖子模块一起编译）
COPY . .
RUN mvn -q -B -DskipTests clean package -pl yudao-server -am && \
    mkdir -p /out && \
    cp yudao-server/target/*.jar /out/app.jar

# ========= run stage (JRE 17) =========
FROM eclipse-temurin:17-jre
ENV TZ=Asia/Shanghai \
    JAVA_OPTS="-Xms512m -Xmx512m"
WORKDIR /app
COPY --from=build /out/app.jar app.jar
EXPOSE 48080
ENTRYPOINT ["sh","-c","java ${JAVA_OPTS} -Djava.security.egd=file:/dev/./urandom -jar app.jar"]
