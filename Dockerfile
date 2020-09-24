FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
WORKDIR /src
COPY src/Hecate.csproj Hecate/
RUN dotnet restore "Hecate/Hecate.csproj"
WORKDIR /src/Hecate
COPY . .
RUN dotnet build "Hecate.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Hecate.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Hecate.dll"]