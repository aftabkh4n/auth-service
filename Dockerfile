FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base
WORKDIR /app
EXPOSE 8080

# Build stage
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# Copy everything and build
COPY . .

# If a .csproj exists, build it. Otherwise just verify the SDK works.
RUN find . -name "*.csproj" | head -1 | xargs -r dotnet restore
RUN find . -name "*.csproj" | head -1 | xargs -r dotnet publish -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "*.dll"]