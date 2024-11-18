# docker-recompose.ps1
docker compose down
docker rmi multidisciplinary_project_group4-init-setup
docker compose up --build -d