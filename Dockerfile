FROM mcr.microsoft.com/dotnet/sdk:6.0 as Base

RUN curl -fsSL https://deb.nodesource.com/setup_19.x | bash - &&\
apt-get install -y nodejs

COPY DotnetTemplate.Web DotnetTemplate.Web
COPY DotnetTemplate.Web.Tests DotnetTemplate.Web.Tests

WORKDIR /DotnetTemplate.Web

RUN dotnet build

RUN npm install
RUN npm run build

FROM base as test
WORKDIR /DotnetTemplate.Web.Tests
RUN dotnet test
WORKDIR /DotnetTemplate.Web
RUN npm t
RUN npm run lint

FROM base as production
WORKDIR /DotnetTemplate.Web
ENTRYPOINT dotnet run