FROM mcr.microsoft.com/dotnet/core/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 5003

ENV ASPNETCORE_URLS=http://*:5003

# Creates a non-root user with an explicit UID and adds permission to access the /app folder
# For more info, please refer to https://aka.ms/vscode-docker-dotnet-configure-containers
RUN adduser -u 5678 --disabled-password --gecos "" appuser && chown -R appuser /app
USER appuser

FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /src
COPY ["src/AWS.EKS.Bookstore.Clients-API.csproj", "clients-api/"]
RUN dotnet restore "clients-api/AWS.EKS.Bookstore.Clients-API.csproj"
COPY /src ./clients-api
WORKDIR "/src/clients-api"
RUN dotnet build "AWS.EKS.Bookstore.Clients-API.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "AWS.EKS.Bookstore.Clients-API.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "AWS.EKS.Bookstore.Clients-API.dll"]
