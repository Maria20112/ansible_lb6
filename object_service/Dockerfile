FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 8080

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src

COPY ["ApartmentRentals.sln", "./"]
COPY ["ApartmentRentals.WebAPI/ApartmentRentals.WebAPI.csproj", "ApartmentRentals.WebAPI/"]
COPY ["ApartmentRentals.Data/ApartmentRentals.Data.csproj", "ApartmentRentals.Data/"]
COPY ["ApartmentRentals.Tests/ApartmentRentals.Tests.csproj", "ApartmentRentals.Tests/"]

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
ENTRYPOINT sudo service ssh start && sudo --preserve-env=ASPNETCORE_URLS -u nonroot dotnet ApartmentRentals.WebAPI.dll