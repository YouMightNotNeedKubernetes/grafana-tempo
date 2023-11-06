deploy:
	docker stack deploy -c docker-compose.yml grafana-tempo

destroy:
	docker stack rm grafana-tempo
