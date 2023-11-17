FROM kodmain/builder:all AS builer

USER root:root
ENV PATH="$PATH:/root/go/bin"
RUN go install github.com/wailsapp/wails/v2/cmd/wails@latest

COPY / /home/nobody

