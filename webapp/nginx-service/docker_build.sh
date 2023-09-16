echo ""
echo "----- Docker build"
docker image build . -t nginx-service:latest

echo ""
echo "----- Docker tag"
docker tag nginx-service ilhemb/nginx-service:latest

echo ""
echo "----- Docker push"
docker image push ilhemb/nginx-service:latest