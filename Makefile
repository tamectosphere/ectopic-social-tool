.PHONY:
services:
	docker-compose up

.PHONY:
down:
	docker-compose down -v

.PHONY:
psql:
	docker-compose -f docker-compose.yml exec postgres psql -U ectopic_social_tool_local
