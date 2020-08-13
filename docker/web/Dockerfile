FROM nginx:1.17.10
RUN rm -f /etc/nginx/conf.d/*
COPY ./docker/web/habit_app.conf /etc/nginx/conf.d/habit_app.conf
CMD ["/usr/sbin/nginx", "-g", "daemon off;", "-c", "/etc/nginx/nginx.conf"]
