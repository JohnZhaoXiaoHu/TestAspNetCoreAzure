FROM microsoft/dotnet:2.2-aspnetcore-runtime AS base
RUN apt-get update && \
    apt-get install -y wget && \
    apt-get install -y gnupg2 && \
    wget -qO- https://deb.nodesource.com/setup_10.x | bash - && \
    apt-get install -y build-essential nodejs
WORKDIR /app
EXPOSE 80

FROM microsoft/dotnet:2.2-sdk AS build
WORKDIR /src
COPY ["AspNetCoreVueStarter.csproj", ""]
RUN dotnet restore "/AspNetCoreVueStarter.csproj"
COPY . .
WORKDIR "/src/"
RUN dotnet build "AspNetCoreVueStarter.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "AspNetCoreVueStarter.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "AspNetCoreVueStarter.dll"]