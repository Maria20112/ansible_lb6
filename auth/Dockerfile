FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src

COPY ["AuthService.csproj", "."]
COPY . .
RUN dotnet restore "./AuthService.csproj"

WORKDIR "/src"
RUN dotnet build "./AuthService.csproj" -c $BUILD_CONFIGURATION -o /app/build

RUN dotnet publish "./AuthService.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app

USER root

RUN apt-get update && apt-get install -y openssh-server nano sudo 
RUN mkdir -p /var/run/sshd 

RUN apt install -y python3

RUN useradd -m -s /bin/bash student && echo "student:student" | chpasswd 
RUN echo "student ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
RUN adduser --system --no-create-home --shell /bin/sh --group nonroot

COPY --from=build --chown=nonroot:nonroot /app/publish .

EXPOSE 8080
EXPOSE 22

USER student

ENTRYPOINT sudo service ssh start && sudo --preserve-env=ASPNETCORE_URLS --preserve-env=ASPNETCORE_ENVIRONMENT -u nonroot dotnet AuthService.dll
