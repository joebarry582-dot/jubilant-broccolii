# Stage 1: Build the application
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS builder
WORKDIR /source

# Copy the project file and restore dependencies
COPY *.csproj .
RUN dotnet restore

# Copy the rest of the source code
COPY . .

# Publish the application to a folder
RUN dotnet publish -c Release -o /app/publish

# Stage 2: Create the final runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=builder /app/publish .

# Expose the port your app listens on (Render uses PORT env variable)
EXPOSE 8080

# Set the entry point to run your application
ENTRYPOINT ["dotnet", "myapp.dll"]