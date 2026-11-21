FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 8080

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src

COPY ["ApartmentRentals.sln", "./"]
COPY ["ApartmentRentals.WebAPI/ApartmentRentals.WebAPI.csproj", "ApartmentRentals.WebAPI/"]
COPY ["ApartmentRentals.Data/UserService.Data.csproj", "ApartmentRentals.Data/"]

COPY . .

RUN dotnet restore "ApartmentRentals.sln"

WORKDIR "/src/ApartmentRentals.WebAPI"
RUN dotnet publish "ApartmentRentals.WebAPI.csproj" \
    -c $BUILD_CONFIGURATION \
    -o /app/publish \
    /p:UseAppHost=false

FROM base AS final
WORKDIR /app

USER root

RUN apt-get update && apt-get install -y openssh-server nano sudo \
    && mkdir -p /var/run/sshd \
    && apt install -y python3 \
    && useradd -m -s /bin/bash student && echo "student:student" | chpasswd \
    && echo "student ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
    && adduser --system --no-create-home --shell /bin/sh --group nonroot

COPY --from=build --chown=nonroot:nonroot /app/publish .

EXPOSE 8080
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh
USER student

ENTRYPOINT ["/entrypoint.sh"]

#ENTRYPOINT sudo service ssh start && sudo --preserve-env=ASPNETCORE_URLS -u nonroot dotnet ApartmentRentals.WebAPI.dll