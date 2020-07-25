FROM alpine:3 as build
RUN apk update && apk add curl build-base ncurses-dev
RUN mkdir /usr/include/ncursesw
RUN ln -s /usr/include/ncurses.h /usr/include/ncursesw/

RUN adduser -D gtypist
RUN mkdir /gtypist
RUN chown gtypist:gtypist /gtypist
USER gtypist
WORKdir /home/gtypist

RUN curl -LO http://ftp.gnu.org/gnu/gtypist/gtypist-2.9.tar.xz
RUN tar -xf gtypist-2.9.tar.xz
WORKDIR /home/gtypist/gtypist-2.9
RUN ./configure --prefix=/gtypist
RUN make -j`nproc` install

FROM alpine:3 as run
RUN apk update && apk add ncurses
RUN rm -rf /var/cache/apk
COPY --from=build /gtypist /gtypist
RUN adduser -HD gtypist
USER gtypist
CMD /gtypist/bin/gtypist
