FROM nginx:alpine
COPY nginx.conf /etc/nginx/nginx.conf
COPY otus.txt  /usr/share/nginx/html/otus.txt
CMD ["nginx","-g","daemon off;"]
