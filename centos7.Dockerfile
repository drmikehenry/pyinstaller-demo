FROM centos:7

ARG UV_VERSION="0.7.2"
ARG UV_PYTHON_VERSION="3.13"
ARG UV_PACKAGE="uv-x86_64-unknown-linux-musl.tar.gz"
ARG UV_RELEASES="https://github.com/astral-sh/uv/releases"
ARG UV_URL="$UV_RELEASES/download/$UV_VERSION/$UV_PACKAGE"

WORKDIR /work

RUN rm /etc/yum.repos.d/*
COPY files/centos.repo /etc/yum.repos.d

RUN yum install -y \
      binutils \
      curl \
  && yum -y clean all \
  && rm -rf /var/cache

RUN curl -L "$UV_URL" -o "/tmp/$UV_PACKAGE" \
  && tar -C /tmp -xf "/tmp/$UV_PACKAGE" \
  && cp /tmp/uv-*/uv* /usr/local/bin \
  && rm -rf /tmp/uv*

RUN uv python install "$UV_PYTHON_VERSION"

COPY pyproject.toml noxfile.py uv.lock ./
RUN uv sync --locked --no-install-project

COPY README.md pyinstaller-demo-wrapper.py src ./

RUN uv run nox -s build

COPY dist/pyinstaller-demo /usr/local/bin

ENTRYPOINT ["pyinstaller-demo"]
