SHELL = /bin/sh

CONTAINER_ID := `docker ps -f "name=job_san_nginx" -q`

maintenance-start:
	@echo "CONTAINER_ID: $(CONTAINER_ID)"
	docker exec ${CONTAINER_ID} /bin/sh -c "./change_maintenance_mode.sh start"

maintenance-stop:
	@echo "CONTAINER_ID: $(CONTAINER_ID)"
	docker exec ${CONTAINER_ID} /bin/sh -c "./change_maintenance_mode.sh stop"
