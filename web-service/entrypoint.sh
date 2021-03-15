#!/bin/sh

# Replace env vars in default.conf.template file
echo "Replacing env vars in default.conf.template"
envsubst '${CATALOGUE_HOST} ${USER_HOST} ${CART_HOST} ${SHIPPING_HOST} ${PAYMENT_HOST} ${RATINGS_HOST}' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf
echo "Starting Nginx"
nginx -g 'daemon off;'