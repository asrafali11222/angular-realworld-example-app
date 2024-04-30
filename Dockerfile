
FROM node:14-alpine as builder


# set the working dir for container
WORKDIR /usr/local/app


# copy the json file first
COPY package*.json /usr/local/app/


# install npm dependencies
RUN npm install


# copy other project files
COPY . .


# build the folder
RUN npm run build -- --configuration="production"


# Handle Nginx
FROM nginx:stable-alpine


COPY --from=builder /usr/local/app/dist/angular-conduit /usr/share/nginx/html


# Changing the ownership
RUN chown -R nginx:nginx /usr/share/nginx/html && chown -R nginx:nginx /var/cache/nginx && \
       chown -R nginx:nginx /var/log/nginx && \
       chown -R nginx:nginx /etc/nginx/conf.d && chown -R nginx:nginx /var/run
RUN touch /var/run/nginx.pid && \
       chown -R nginx:nginx /var/run/nginx.pid


USER nginx


EXPOSE 80
