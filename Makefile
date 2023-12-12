.PHONY:
services:
	docker-compose -f docker-compose.yml up -d

.PHONY:
down:
	docker-compose down -v

.PHONY:
psql:
	docker-compose -f docker-compose.yml exec postgres psql -U ectopic_social_tool_local

.PHONY: 
dev: services
	mix phx.server