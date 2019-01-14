FROM  golang:1.11.4-alpine3.8

MAINTAINER Loc Nguyen <locnguyen.it@gmail.com>

ARG VIPS_VERSION=8.7.3
RUN wget -O- https://github.com/libvips/libvips/releases/download/v${VIPS_VERSION}/vips-${VIPS_VERSION}.tar.gz | tar xzC /tmp \
    && apk update \
    && apk upgrade \
    && apk add \
    git curl zlib libxml2 glib gobject-introspection \
    libjpeg-turbo libexif lcms2 fftw giflib libpng \
    libwebp orc tiff poppler-glib librsvg libgsf openexr \
    && apk add --virtual vips-dependencies build-base \
    zlib-dev libxml2-dev glib-dev gobject-introspection-dev \
    libjpeg-turbo-dev libexif-dev lcms2-dev fftw-dev giflib-dev libpng-dev \
    libwebp-dev orc-dev tiff-dev poppler-dev librsvg-dev libgsf-dev openexr-dev \
    py-gobject3-dev \
    && cd /tmp/vips-${VIPS_VERSION} \
    && ./configure --prefix=/usr \
                   --disable-static \
                   --disable-dependency-tracking \
                   --enable-silent-rules \
                   --enable-pyvips8 \
    && make -s install-strip \
    && cd $OLDPWD \
    && rm -rf /tmp/vips-${VIPS_VERSION} \
    && apk del --purge vips-dependencies \
    && rm -rf /var/cache/apk/*

    ENV GOPATH /go
    RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
    WORKDIR $GOPATH

    # Fetch the latest version of the package
    RUN go get -u golang.org/x/net/context
    RUN go get -u github.com/golang/dep/cmd/dep
    RUN go get -u github.com/locskeleton/bimg

    # Copy bimg sources
    COPY . $GOPATH/src/github.com/locskeleton/bimg

