# Stage 1: Build the application
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /source

# Copy csproj from the subfolder and restore
COPY jubilant-broccoliii/*.csproj ./jubilant-broccoliii/
RUN dotnet restore jubilant-broccoliii/jubilant-broccoliii.csproj

# Copy everything else
COPY . .
WORKDIR /source/jubilant-broccoliii
RUN dotnet publish -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build /app/publish .
ENV ASPNETCORE_URLS=http://+:${PORT}
ENTRYPOINT ["dotnet", "jubilant-broccoliii.dll"]